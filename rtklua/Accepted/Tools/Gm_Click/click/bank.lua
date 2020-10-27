bank = {
	show_main_menu = function(player, npc)
		local opts = {}

		if (player.registry["joint_bank_request"] > 0) then
			table.insert(opts, "Review Joint Account Request")
		end

		local availableAccounts = bank.get_available_accounts(player)

		if (#availableAccounts > 0) then
			table.insert(opts, player.name)

			for i = 1, #availableAccounts do
				table.insert(opts, availableAccounts[i])
			end
		else
			bank.lock_bank(player, player)

			table.insert(opts, "Deposit Item")
			table.insert(opts, "Withdraw Item")

			if player.money > 0 then
				table.insert(opts, "Deposit Money")
			end

			if player.bankMoney > 0 then
				table.insert(opts, "Withdraw Money")
			end
		end
	
		table.insert(opts, "Open Joint Account")

		if (#availableAccounts > 0) then
			table.insert(opts, "Close Joint Account")
		end

		local selection = player:menuString("Please select from the following options:", opts)
		bank.process_menu_selection(player, npc, selection)
	end,

	show_sub_menu = function(player, npc, bankOwnerName)
		local bankOwner = bank.get_bankOwner(player, bankOwnerName)

		if (bankOwner == nil) then
			return
		end

		bank.lock_bank(player, bankOwner)

		local opts = {}
		local playerIsBankOwner = bankOwnerName == player.name

		if (playerIsBankOwner and player.registry["joint_bank_request"] > 0) then
			table.insert(opts, "Review Joint Account Request")
		end

		table.insert(opts, "Deposit Item")
		table.insert(opts, "Withdraw Item")

		if player.money > 0 then
			table.insert(opts, "Deposit Money")
		end

		if bankOwner.bankMoney > 0 then
			table.insert(opts, "Withdraw Money")
		end

		if (playerIsBankOwner) then
			table.insert(opts, "Open Joint Account")

			local availableAccounts = bank.get_available_accounts(bankOwner)

			if (#availableAccounts > 0) then
				table.insert(opts, "Close Joint Account")
			end
		end

		local selection = player:menuString("Please select from the following options:", opts)
		bank.process_menu_selection(player, npc, selection, bankOwnerName)
	end,

	process_menu_selection = function(player, npc, selection, bankOwnerName)
		if (bankOwnerName == nil) then
			bankOwnerName = player.name
		end
		
		local bankOwner = bank.get_bankOwner(player, bankOwnerName)

		if (bankOwner == nil) then
			return
		end

		if (selection == "Review Joint Account Request") then
			bank.open_joint_account(player)
			return
		end

		if (selection == "Open Joint Account") then
			bank.request_joint_account(player)
			return
		end

		if (selection == "Close Joint Account") then
			bank.close_joint_account(player)
			return
		end

		if (selection == "Deposit Item") then
			player:showBankDeposit(npc, bankOwnerName)
			return
		end

		if (selection == "Withdraw Item") then
			player:showBankWithdraw(npc, bankOwnerName)
			return
		end

		if (selection == "Deposit Money") then
			player:bankAddMoney(npc, bankOwnerName)
			return
		end

		if (selection == "Withdraw Money") then
			player:bankWithdrawMoney(npc, bankOwnerName)
			return
		end

		-- If we get to this point, we know the player is on the main menu and selected a player's
		-- name. We also know that we did not receive a bankOwnerName in this scenario, so we assumed
		-- at the beginning of this method that bankOwner = player. However, that will not actually
		-- be true in this scenario unless the player selected his/her own name. But since the value
		-- of the selection contains the correct bankOwnerName, we can ditch our initial assumption
		-- that bankOwner = player and use selection to overwrite bankOwner with the correct entity.
		
		bankOwner = Player(selection)

		if (bankOwner ~= nil) then
			bank.show_sub_menu(player, npc, bankOwner.name)
		end
	end,

	get_available_accounts = function(player)
		local availableAccountIds = {}

		for i = 1, player.registry["joint_banks_count"] do
			local bankId = "joint_bank_" .. i
			local bankOwner = Player(player.registry[bankId])

			if (bankOwner ~= nil) then
				table.insert(availableAccountIds, bankId)
			end
		end

		local availableAccountNames = {}

		if (#availableAccountIds > 0) then
			for i = 1, #availableAccountIds do
				local bankOwner = Player(player.registry[availableAccountIds[i]])
	
				if (bankOwner ~= nil) then
					table.insert(availableAccountNames, bankOwner.name)
				end
			end
		end

		table.sort(availableAccountNames, function(a, b) return a:lower() < b:lower() end)

		return availableAccountNames
	end,

	get_bankOwner = function(player, bankOwnerName)
		local bankOwner = Player(bankOwnerName)
		
		if (bankOwner == nil) then
			player:dialogSeq({"Transaction canceled. " .. bankOwnerName .. " has left the kingdom. Please try again later."})
		end

		return bankOwner
	end,

	lock_bank = function(player, bankOwner)
		bankOwner.registry["bank_lock"] = player.ID
		bankOwner:forceSave()
	end,

	is_bank_locked = function(player, bankOwner)
		return bankOwner.registry["bank_lock"] ~= player.ID
	end,

	show_bank_locked = function(player)
		player:dialogSeq({"Transaction canceled. The account is locked because another person started a transaction on the account before you completed yours. Please try again later."})
	end,
	
	request_joint_account = function(player)
		bank.show_joint_account_warnings(player)

		local recipientName = player:input("If you understand and accept the risks, please enter the name of the person with whom would you like to open a joint account.")

		if (recipientName:lower() == player.name:lower()) then
			player:dialogSeq({"You can't open a joint account with yourself."})
			return
		end

		local availableAccounts = bank.get_available_accounts(player)

		for i = 1, #availableAccounts do
			if (recipientName:lower() == availableAccounts[i]:lower()) then
				player:dialogSeq({"You already share a joint account with that person."})
				return
			end
		end

		local recipient = Player(recipientName)

		if (tonumber(recipientName) ~= nil or recipient == nil) then
			player:dialogSeq({"Hmm, I don't see that person anywhere. You must both be present in the kingdom to proceed with the request."})
			return
		end

		local playerExistingRequest = player.registry["joint_bank_request"]

		if (playerExistingRequest == recipient.ID) then
			player:dialogSeq({recipient.name .. " has already requested a joint account with you. You just need to approve it."})
			return
		end

		local recipientExistingRequest = recipient.registry["joint_bank_request"]

		if (recipientExistingRequest == player.ID) then
			player:dialogSeq({"You already have a pending request awaiting approval from " .. recipient.name .. "."})
			return
		end

		if (recipientExistingRequest > 0) then
			player:dialogSeq({"Hmm, I don't see that person anywhere. You must both be present in the kingdom to proceed with the request."})
			return
		end

		recipient.registry["joint_bank_request"] = player.ID
		recipient:forceSave()

		player:dialogSeq({"I have submitted your request. Please ask " .. recipient.name .. " to come see me about approval."})
	end,

	open_joint_account = function(player)
		local requestorId = player.registry["joint_bank_request"]
		local requestor = Player(requestorId)

		if (requestor == nil) then
			player:dialogSeq({"Hmm, I don't see the requestor anywhere. You must both be present in the kingdom to proceed with the request."})
			return
		end

		bank.show_joint_account_warnings(player)

		local choice = player:menuSeq(
			requestor.name .. " has requested to open a joint account with you. Do you accept?",
			{"Yes, I understand and accept the risks.", "Maybe not..."},
			{}
		)
		
		requestor = Player(requestorId)

		if (requestor == nil) then
			player:dialogSeq({"Transaction canceled. The requestor has left the kingdom. Please try again later."})
			return
		end

		if (choice == 1) then
			bank.add_joint_owner(requestor, player)
			bank.add_joint_owner(player, requestor)
			
			player:sendMinitext("You opened a joint bank account with " .. requestor.name .. ".")
			requestor:sendMinitext("You opened a joint bank account with " .. player.name .. ".")
			requestor:forceSave()
		else
			player:sendMinitext("You have denied " .. requestor.name .. "'s joint bank account request.")
			requestor:sendMinitext(player.name .. " has denied your joint bank account request.")
		end

		player.registry["joint_bank_request"] = 0
		player:forceSave()
	end,

	show_joint_account_warnings = function(player)
		player:dialogSeq({"A joint bank account grants two individuals unrestricted authority to make deposits and withdrawals on each other's accounts whenever both are present in the kingdom."}, 1)
		player:dialogSeq({"You can have multiple joint accounts. Opening joint accounts with multiple other people does not automatically create joint accounts between those other individuals."}, 1)
		player:dialogSeq({"In setting up a joint account, you waive the right to any legal recourse against transactions conducted by a joint owner."}, 1)
	end,

	add_joint_owner = function(owner, jointOwner)
		local jointAccountIndex = owner.registry["joint_banks_count"] + 1
		owner.registry["joint_banks_count"] = jointAccountIndex
		owner.registry["joint_bank_" .. jointAccountIndex] = jointOwner.ID
	end,

	close_joint_account = function(player)
		local availableAccounts = bank.get_available_accounts(player)

		if (#availableAccounts < 1) then
			player:dialogSeq({"None of your joint accounts are currently available. Please try again when the joint owner of the account that you want to close is present in the kingdom."}, 1)
			return
		end

		player:dialogSeq({"Closing a joint bank account removes the ability for two people to make deposits and withdrawals on each other's accounts whenever both individuals are present in the kingdom."}, 1)

		local selection = player:menuString("With whom would you like to sever joint ownership?", availableAccounts)
		local jointOwner = Player(selection)

		if (jointOwner == nil) then
			player:dialogSeq({"Transaction canceled. " .. selection .. " has left the kingdom. Please try again later."})
			return
		end

		bank.remove_joint_owner(player, jointOwner)
		bank.remove_joint_owner(jointOwner, player)

		player:forceSave()
		jointOwner:forceSave()

		player:sendMinitext("You closed your joint bank account with " .. jointOwner.name .. ".")
		jointOwner:sendMinitext(player.name .. " has closed your joint bank account.")
	end,

	remove_joint_owner = function(owner, jointOwner)
		local jointAccountIndex = 0
		local jointAccountCount = owner.registry["joint_banks_count"]

		if (jointAccountCount < 1) then
			return
		end

		for i = 1, jointAccountCount do
			local jointOwnerId = owner.registry["joint_bank_" .. i]

			if (jointOwnerId == jointOwner.ID) then
				jointAccountIndex = i
			end
		end
		
		for i = jointAccountIndex, jointAccountCount do
			owner.registry["joint_bank_" .. i] = owner.registry["joint_bank_" .. i + 1]
		end
		
		owner.registry["joint_banks_count"] = owner.registry["joint_banks_count"] - 1
	end,
	
	gm_click = function(player, target, npc)
		local name = "<b>[" .. target.name .. "'s Bank]\n\n"

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		choice = player:menuString(name .. "What to do with target's bank?", {
			"Show Bank",
			"Add item to bank",
			"<< Back"
		})

		if choice == "Show Bank" then
			bank.show(player, target, npc)
		elseif choice == "Add item to bank" then
			bank.add(player, target, npc)
		elseif choice == "<< Back" then
			player:freeAsync()
			click.menu(player, target, npc)
		end
	end,

	add = function(player, target, npc)
		local npc = NPC("Rotah")
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local input = player:input("What would you like to add to their bank?")
		local item = Item(input)
		local owner = 0
		local engrave = ""

		if item == nil then
			player:dialog("Bad item.")
			return
		end

		local amount = 1

		if (item.stackAmount > 1) then
			amount = player:inputNumberCheck(player:input("How many would you like?"))
		end
		if (amount < 1) then
			return
		end

		if item.type >= 3 and item.type <= 17 then
			-- equipment
			local ownerCheck = player:menuSeq(
				"Add them as owner?",
				{"Yes", "No"},
				{}
			)
			if ownerCheck == 1 then
				owner = target.ID
			end

			local engraveCheck = player:menuSeq(
				"Add an engrave?",
				{"Yes", "No"},
				{}
			)
			if engraveCheck == 1 then
				engrave = player:input("Enter an engrave")
			end
		end

		target:bankDeposit(item.id, amount, owner, 0, engrave)

		player:dialog(
			item.name .. " (" .. amount .. ") added to " .. target.name .. "'s bank.",
			{}
		)
	end,

	show = function(player, target, npc)
		local npc = NPC("Rotah")
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable, bankItemTableNames = target:bankItemsList(0)

		local found = 0
		local next = next

		for i = 1, #bankItemTable do
			if (Item(bankItemTable[i]).name == "") then
				player:talkSelf(0, "bad item: " .. bankItemTable[i])
			end
		end

		if next(bankItemTable) == 0 then
			player:dialogSeq({name .. "Target's bank is currently empty!"})
			return
		else
			local take = player:buy(
				target.name .. " Total items : " .. #bankItemTable .. "\nWhat to do with target's bank item?",
				bankItemTable,
				bankCountTable,
				bankEngraveTable,
				bankOwnerTable,
				{},
				{},
				{}
			)

			for i = 1, 255 do
				if bankItemTable[i] ~= nil then
					if (bankItemTableNames[i] == take) then
						found = i
						break
					end
				end
			end

			if found == 0 then
				return nil
			else
				local icon = {
					graphic = Item(bankItemTable[found]).icon,
					color = Item(bankItemTable[found]).iconC
				}
				player.npcGraphic = icon.graphic
				player.npcColor = icon.color
				player.dialogType = 0
				text = "Item : " .. Item(bankItemTable[found]).name .. "\n"
				text = text .. "Qty  : " .. bankCountTable[found] .. " pcs\n"

				local opts = {"Take", "Delete", "<< Back"}
				choice = player:menuSeq(
					text .. "\nWhat to do with this item?",
					opts,
					{}
				)

				if choice == 3 then
					bank.show(player, target, npc)
				elseif choice == 2 then
				elseif choice == 1 then
					local amount = 0

					if Item(bankItemTable[found]).maxAmount > 1 then
						amount = math.abs(tonumber(math.ceil(player:input("" .. text .. "\nHow many shall you withdraw?"))))
						if amount > bankCountTable[found] then
							amount = bankCountTable[found]
						end
					else
						amount = 1
					end
					if amount <= 0 then
						return false
					else
						if player:hasSpace(
							bankItemTable[found],
							amount,
							bankOwnerTable[found],
							bankEngraveTable[found]
						) ~= true then
							player:dialogSeq(
								{
									"You don't have enough space in your inventory for that!"
								},
								1
							)
							bank.show(player, target, npc)
							return
						else
							local worked = player:addItem(
								bankItemTable[found],
								amount,
								0,
								bankOwnerTable[found],
								bankEngraveTable[found]
							)

							if (worked == true) then
								target:bankWithdraw(
									bankItemTable[found],
									amount,
									bankOwnerTable[found],
									bankTimerTable[found],
									bankEngraveTable[found]
								)

							else
								player:dialogSeq(
									{
										"Cannot take " .. amount .. " " .. Item(bankItemTable[found]).name .. " from target!"
									},
									1
								)
								bank.show(player, target, npc)
							end
						end
					end
				end
			end
		end
	end
}
