function Player.sendParcelTo(player, npc)
	local itemlist = {}
	local found = 0

	local fchoice = player:menuSeq(
		"What would you like to send?",
		{"Gold", "Item"},
		{}
	)

	if fchoice == 1 then
		-- gold
		local amount = player:inputNumberCheck(player:input("How much gold would you like to send?"))

		if player.money < amount then
			player:dialog("You don't have that much gold.", {})
			return
		end

		local receiver = player:inputLetterCheck(player:input("Who do you want to send this " .. Tools.formatNumber(amount) .. " gold to?"))
		receiver = getOfflineID(receiver)

		if not receiver then
			player:dialog("Character does not exist.")
			return
		end

		if player.money < amount then
			return
		end

		if player:sendParcel(receiver, player.ID, 0, amount, 0, 0, 0) == true then
			player:removeGold(amount)
			player:sendMinitext("Your " .. Tools.formatNumber(amount) .. " gold has been sent in a parcel to " .. getOfflineID(receiver))

			if Player(receiver) ~= nil then
				player:msg(
					12,
					"[PARCEL]: You got a parcel from " .. player.name .. "!",
					Player(receiver).ID
				)
			end
		end

		return
	end

	for i = 0, player.maxInv - 1 do
		nItem = player:getInventoryItem(i)
		if nItem ~= nil then
			if nItem.id > 0 then
				if #itemlist > 0 then
					found = 0
					for j = 1, #itemlist do
						if itemlist[j] == nItem.id then
							found = 1
						end
					end
					if found == 0 then
						if not nItem.droppable or player.gmLevel > 0 then
							table.insert(itemlist, nItem.id)
						end
					end
				else
					if not nItem.droppable or player.gmLevel > 0 then
						table.insert(itemlist, nItem.id)
					end
				end
			end
		end
	end

	local choice = player:sell("What would you like to send?", itemlist)
	local item = player:getInventoryItem(choice - 1)
	local amount = 1
	local cost = 0

	if item.type == 0 then
		player:menu(
			"Food would rot, and I would end up with rats everywhere! I'm not willing to send it for you.",
			{},
			{}
		)
		return
	end

	if item.amount > 1 then
		amount = player:inputNumberCheck(player:input("How many " .. item.name .. " do you want to send?"))
	else
		amount = 1
	end

	if player:hasItem(item.name, amount) ~= true then
		return
	end

	--local receiver = player:input("Who do you want to send this "..amount.." "..item.name.." to?")
	local receiver = player:inputLetterCheck(player:input("Who do you want to send this " .. amount .. " " .. item.name .. " to?"))

	receiver = getOfflineID(receiver)

	-- weapons 120c, 140c smoked items, no food can be sent, 101c for misc

	-- I need 102 for a seal; 102 you understand. You could use the Black Box on the Communing Stone.

	if receiver ~= false then
		if item.exchangeable then
			player:dialogSeq({"You can not send a non-exchangeable item"})
			return
		end

		if item.droppable and player.gmLevel == 0 then
			player:dialogSeq({"You can not send a non-droppable item"})
			return
		end

		if item.dura ~= item.maxDura then
			player:dialogSeq({"Item must be in perfect condition to send. Go and repair it first!"})
			return
		end

		if player:hasItem(item.id, amount) ~= true then
			player:dialogSeq({"You only have " .. player:hasItem(item.id, amount) .. " " .. item.name "."})
			return
		elseif (player:hasItemDura(item.id, amount) ~= true) then
			player:dialogSeq({"Item must be in perfect condition to send. Go and repair it first!"})
			return
		else
			cost = cost + math.ceil((item.price *.05) * amount)
			if player.money < cost then
				player:menu(
					"I need " .. Tools.formatNumber(cost) .. " for a seal; " .. Tools.formatNumber(cost) .. " you understand. You could use the Black Box on the Communing Stone.",
					{}
				)
				return
			end

			if player.money < cost then
				return
			end

			if player:sendParcel(
				receiver,
				player.ID,
				item.id,
				amount,
				item.owner,
				item.realName,
				0,
				item.customLook,
				item.customLookColor,
				item.customIcon,
				item.customIconColor,
				item.protected,
				item.dura
			) == true then
				player:removeGold(cost)
				if amount > item.stackAmount then
					player:removeItem(item.id, amount, 2)
				else
					player:removeItemSlot(choice - 1, amount, 2)
				end
				player:sendMinitext("Your parcel has been sent.")
				if Player(receiver) ~= nil then
					player:msg(
						12,
						"[PARCEL]: You got a parcel from " .. player.name .. "!",
						Player(receiver).ID
					)
				end
			end
		end
	else
		player:sendMinitext("User not found!")
	end
end

function Player.receiveParcelFrom(player, npc)
	local item = player:getParcel()

	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	if item.id >= 0 and item.id <= 3 then
		-- gold

		player:addGold(item.amount)
		player:removeParcel(
			item.sender,
			item.id,
			item.amount,
			item.pos,
			item.owner,
			item.realName,
			item.npcflag
		)

		if item.npcFlag > 0 then
			local sender = NPC(item.sender)
			player:msg(
				12,
				"[PARCEL]: You got a parcel from " .. sender.name .. "!",
				player.ID
			)
		else
			local sender = getOfflineID(item.sender)
			if sender ~= false then
				player:sendMinitext("You receive " .. Tools.formatNumber(item.amount) .. " gold from " .. sender)
			else
				player:sendMinitext("No senders!")
			end
		end
		return
	end

	if player:hasSpace(item.id, item.amount, item.owner, item.realName) then
		player:addItem(
			item.id,
			item.amount,
			item.dura,
			item.owner,
			item.time,
			item.realName,
			item.customLook,
			item.customLookColor,
			item.customIcon,
			item.customIconColor,
			item.protected
		)
		player:removeParcel(
			item.sender,
			item.id,
			item.amount,
			item.pos,
			item.owner,
			item.realName,
			item.npcflag
		)

		if item.npcFlag > 0 then
			local sender = NPC(item.sender)
			player:msg(
				12,
				"[PARCEL]: You got a parcel from " .. sender.name .. "!",
				player.ID
			)
		else
			local sender = getOfflineID(item.sender)
			if sender ~= false then
				player:sendMinitext("You receive a parcel from " .. sender)
			else
				player:sendMinitext("No senders!")
			end
		end
	else
		local choice = player:menuSeq(
			"You don't have enough space in your inventory for " .. Tools.formatNumber(item.amount) .. " " .. item.name .. ", bank instead?",
			{"Yes, deposit in my bank.", "Nevermind."},
			{}
		)

		if choice == 1 then
			player:bankDeposit(
				item.id,
				item.amount,
				item.owner,
				item.time,
				item.realName
			)
			player:removeParcel(
				item.sender,
				item.id,
				item.amount,
				item.pos,
				item.owner,
				item.realName,
				item.npcflag
			)

			if item.npcFlag > 0 then
				local sender = NPC(item.sender)
				player:msg(
					12,
					"[PARCEL]: You got a parcel from " .. sender.name .. "!",
					player.ID
				)
			else
				local sender = getOfflineID(item.sender)
				if sender ~= false then
					player:sendMinitext("You receive a parcel from " .. sender)
				else
					player:sendMinitext("No senders!")
				end
			end

			player:msg(
				12,
				"[PARCEL]: " .. Tools.formatNumber(item.amount) .. " " .. item.name .. " deposited into your bank",
				player.ID
			)
		end

		return
	end
	player:sendStatus()
end

function Player.receiveParcelFromList(player, npc)
	local parcellist = player:getParcelList()
	local idlist = {}
	local amountlist = {}
	local namelist = {}
	for x = 1, #parcellist do
		table.insert(idlist, parcellist[x].id)
		table.insert(amountlist, parcellist[x].amount)
		if (string.len(parcellist[x].realName) > 0) then
			table.insert(namelist, parcellist[x].realName)
		else
			table.insert(namelist, parcellist[x].name)
		end
	end
	local choice = player:sell(
		"Testing Parcel List.",
		idlist,
		amountlist,
		namelist
	)
	if (player:hasSpace(
		parcellist[choice].id,
		parcellist[choice].amount,
		parcellist[choice].owner,
		parcellist[choice].realName
	) == true) then
		player:addItem(
			parcellist[choice].id,
			parcellist[choice].amount,
			parcellist[choice].owner,
			parcellist[choice].realName
		)
		player:removeParcel(
			parcellist[choice].sender,
			parcellist[choice].id,
			parcellist[choice].amount,
			parcellist[choice].pos,
			parcellist[choice].owner,
			parcellist[choice].realName,
			parcellist[choice].npcflag
		)
	end
end
