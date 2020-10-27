local _getWaypointId = function(player, npc)
	local waypointIdByMap = {
		[3802] = "kamings_encampment"
	}

	local waypointId = waypointIdByMap[npc.m]

	if (not waypointId) then
		return "kugnae"
	end

	return waypointId
end

MessengerNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {}

		local parcel = player:getParcel()
		if parcel then
			table.insert(opts, "Mailbox")
		end

		table.insert(opts, "Buy")
		table.insert(opts, "Sell")
		table.insert(opts, "Send Parcel")
		table.insert(opts, "Checks")

		local waypointId = _getWaypointId(player, npc)

		if (not Waypoint.isEnabled(player, waypointId)) then
			table.insert(opts, "Waypoint")
		end

		--table.insert(opts,"Wrap gift")

		local buyopts = MessengerNpc.buyItems(npc)
		local sellopts = MessengerNpc.sellItems(npc)

		local menu = player:menuString(
			"Hello " .. player.name .. ", What would you like to do today?",
			opts
		)

		if menu == "Mailbox" then
			local txt = ""
			local item = player:getParcel()
			local optsPO = {"Send Parcel"}
			if item ~= false then
				txt = "What would you like to do?\n\nYou have a new parcel!"
				table.insert(optsPO, "Receive Parcel")
			else
				txt = "What would you like to do?\n\nYou have no new parcels"
			end
			choice = player:menuString(txt .. "", optsPO)
			if choice == "Send Parcel" then
				player:sendParcelTo(npc)
			elseif choice == "Receive Parcel" then
				player:receiveParcelFrom(npc)
			end
		elseif menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyopts
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellopts)
		elseif menu == "Checks" then
			general_npc_funcs.checks(player, npc)
		elseif menu == "Send Parcel" then
			player:sendParcelTo(npc)
		elseif menu == "Wrap gift" then
			MessengerNpc.wrapGift(player, npc)
		elseif menu == "Waypoint" then
			Waypoint.add(player, npc, waypointId)
		end
	end),

	onSayClick = async(function(player, npc)
		local speech = player.speech:lower()
		local waypointId = _getWaypointId(player, npc)

		if (speech == "waypoint" and not Waypoint.isEnabled(player, waypointId)) then
			Waypoint.add(player, npc, waypointId)
			return
		end
	end),

	wrapGift = function(player, npc)
		Tools.configureDialog(player, npc)

		player:dialogSeq(
			{
				"A gift for a special someone? How sweet.",
				"You may add up to 3 items to your gift box. The items must be non-bonded and fully repaired.",
				"You'll need some ribbon and gift paper to make a nice present."
			},
			1
		)

		local choice = player:menuSeq(
			"Are you ready to continue?",
			{"Yes", "No"},
			{}
		)

		if choice == 1 then
			if player:hasItem("ribbon", 1) ~= true then
				player:dialogSeq({"You need to bring some ribbon to wrap the present with!"}, 0)
				return
			end

			if player:hasItem("brown_gift_paper", 1) ~= true then
				player:dialogSeq({"You need to bring some gift paper to wrap the present with!"}, 0)
				return
			end

			local found = 0
			local itemTable = {}
			local items = {}
			local itemAmounts = {}
			local itemEngraves = {}

			for i = 0, player.maxInv do
				local nItem = player:getInventoryItem(i)

				if (nItem ~= nil and nItem.id > 0) then
					if (#itemTable > 0) then
						found = 0

						for j = 1, #itemTable do
							if (itemTable[j] == nItem.id) then
								found = 1
								break
							end
						end

						if (found == 0) then
							if nItem.id ~= Item("ribbon").id and nItem.id ~= Item("brown_gift_paper").id and nItem.id ~= Item("brown_present").id then
								table.insert(itemTable, nItem.id)
							end
						end
					else
						if nItem.id ~= Item("ribbon").id and nItem.id ~= Item("brown_gift_paper").id and nItem.id ~= Item("brown_present").id then
							table.insert(itemTable, nItem.id)
						end
					end
				end
			end

			local buffer = "a"

			while buffer == "a" do
				local choice = player:sell(
					"What would you like add to the gift box?",
					itemTable
				)
				local dItem = player:getInventoryItem(choice - 1)
				if (dItem == nil) then
					return
				end

				if (dItem.depositable) then
					player:sendMinitext("You cannot deposit that item.")
					return false
				end

				if (dItem.dura ~= dItem.maxDura) then
					player:sendMinitext("You cannot gift damaged items.")
					return false
				end

				if (dItem.owner ~= 0) then
					player:sendMinitext("You may only gift non-bonded items.")
					return false
				end

				if (dItem.stackAmount > 1 and dItem.amount > 1) then
					amount = math.abs(tonumber(math.floor(player:input("How many would you like to send?"))))

					if (player:hasItem(dItem.id, amount) ~= true) then
						amountCheck = player:hasItem(dItem.id, amount)
						amount = amountCheck
					end
				else
					amount = 1
				end

				table.insert(items, dItem.yname)
				table.insert(itemAmounts, amount)
				table.insert(itemEngraves, dItem.realName)

				if #itemTable ~= nil then
					for j = 1, #itemTable do
						if (itemTable[j] == dItem.id) then
							table.remove(itemTable, j)
						end
					end
				end

				if #items >= 3 then
					break
				end

				local addMore = player:menuSeq(
					"Would you like to add any more items?",
					{"Yes", "No"},
					{}
				)

				if addMore == 2 then
					buffer = "b"
				end
			end

			local text = ""

			if items == nil then
				return
			end

			for i = 1, #items do
				if itemEngraves[i] ~= "" then
					text = text .. ItemEngraves[i] .. "\n"
				else
					text = text .. "(" .. itemAmounts[i] .. ") " .. Item(items[i]).name .. "\n"
				end
			end

			player:dialogSeq({"Your gift box's contents are below.\n\n" .. text}, 1)

			local confirm = player:menuSeq(
				"Are these the correct items?",
				{"Yes", "No"},
				{}
			)

			if confirm == 1 then
				--yes

				local giftid = player:addGift(items, itemAmounts, itemEngraves)

				if giftid ~= nil then
					for i = 1, #items do
						if player:hasItem(items[i], itemAmounts[i]) ~= true then
							player:dialogSeq({"You no longer have " .. itemAmounts[i] .. " " .. items[i] .. " in your posession."}, 0)
							return
						end
					end

					for i = 1, #items do
						player:removeItem(items[i], itemAmounts[i], 9)
					end

					player:removeItem("ribbon", 1, 9)
					player:removeItem("brown_gift_paper", 1, 9)

					player:addItem("brown_present", 1, 0, 0, 0, "", 0, 0, 0, 0, 0, "", giftid)

					-- giftid from gifts table
					player:dialogSeq({"There you go, I hope whoever gets the gift enjoys it!"}, 0)
				else
					player:dialogSeq({"There was an error wrapping your gift. Please contact support."}, 0)
					return
				end
			end
		elseif choice == 2 then
			player:dialogSeq({"Come back when you are ready."}, 0)
			return
		end
	end,

	buyItems = function(npc)
		local buyItems = {
			"scroll",
			"book",
			"ink",
			"smelting_agreement",
			"white_paper",
			"ribbon",
			"brown_gift_paper"
		}

		if npc.mapTitle == "Sying's Shop" then
			table.insert(buyItems, "sonhi_pipe")
		end

		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = MessengerNpc.buyItems(npc)

		if npc.mapTitle == "Sying's Shop" then
			table.insert(sellItems, "ogre_cider")
			table.insert(sellItems, "ogre_drought")
		end

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "scribes_pen")
			table.insert(sellItems, "scribes_book")
		end

		return sellItems
	end
}
