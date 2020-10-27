AuctioneerNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Help", "List Item for Auction", "Bid/Buyout an Item"}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Help" then
		elseif menu == "List Item for Auction" then
			AuctioneerNpc.list(player, npc)
		elseif menu == "Bid/Buyout an Item" then
			AuctioneerNpc.bid(player, npc)
		end
	end),

	list = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local itemlist = {}
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
							if not nItem.droppable then
								table.insert(itemlist, nItem.id)
							end
						end
					else
						if not nItem.droppable then
							table.insert(itemlist, nItem.id)
						end
					end
				end
			end
		end

		local choice = player:sell(
			"What would you like to list for auction?",
			itemlist
		)
		local item = player:getInventoryItem(choice - 1)

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

		if amount > item.amount then
			amount = item.amount
		end

		if player:hasItem(
			item.name,
			amount,
			item.dura,
			item.owner,
			item.realName,
			item.customLook,
			item.customLookColor,
			item.customIcon,
			item.customIconColor
		) ~= true then
			return
		end

		local price = player:inputNumberCheck(player:input("How much gold would you like to list it for?"))

		if price == 0 then
			player:dialog("You cannot list items for free.")
			return
		end

		local name = ""

		if item.realName ~= "" then
			name = item.realName .. "(" .. item.name .. ")"
		else
			name = item.name
		end

		local confirm = player:menuSeq(
			"Are you sure you would like to list " .. name .. " for " .. Tools.formatNumber(price) .. " gold?",
			{"Yes, list it.", "Nevermind."},
			{}
		)

		if confirm == 1 then
			if player:hasItem(
				item.name,
				amount,
				item.dura,
				item.owner,
				item.realName,
				item.customLook,
				item.customLookColor,
				item.customIcon,
				item.customIconColor
			) ~= true then
				return
			end

			if listAuction(
				player.ID,
				item.id,
				amount,
				item.dura,
				price,
				item.realName,
				item.timer,
				item.customIcon,
				item.customIconColor,
				item.customLook,
				item.customLookColor,
				item.protected,
				0
			) == 0 then
				player:dialog(
					"Error listing auction. Please contact support.",
					{}
				)
				return
			else
				player:removeItem(
					item.name,
					amount,
					9,
					item.owner,
					item.realName
				)
				player:dialog(
					"You have successfully listed your item for auction.",
					{}
				)
			end
		end
	end,

	bid = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local auctions = getAuctions()

		if #auctions == 0 then
			player:dialogSeq(
				{t, "Sorry but there are currently no auctions"},
				0
			)
			return
		end

		local auctionIds = {}
		local auctionChaIds = {}
		local auctionItmIds = {}
		local auctionItmAmounts = {}
		local auctionItmDurability = {}
		local auctionItmEngrave = {}
		local auctionItmTimer = {}
		local auctionItmCustomIcon = {}
		local auctionItmCustomIconColor = {}
		local auctionItmCustomLook = {}
		local auctionItmCustomLookColor = {}
		local auctionItmProtected = {}
		local auctionPrices = {}
		local auctionBidding = {}
		local auctionItmType = {}
		local auctionItmText = {}

		local x = 1

		for i = 1, #auctions do
			table.insert(auctionIds, auctions[x])
			table.insert(auctionChaIds, auctions[x + 1])
			table.insert(auctionItmIds, auctions[x + 2])
			table.insert(auctionItmAmounts, auctions[x + 3])
			table.insert(auctionItmDurability, auctions[x + 4])
			table.insert(auctionPrices, auctions[x + 5])
			table.insert(auctionItmEngrave, auctions[x + 6])
			table.insert(auctionItmTimer, auctions[x + 7])
			table.insert(auctionItmCustomIcon, auctions[x + 8])
			table.insert(auctionItmCustomIconColor, auctions[x + 9])
			table.insert(auctionItmCustomLook, auctions[x + 10])
			table.insert(auctionItmCustomLookColor, auctions[x + 11])
			table.insert(auctionItmProtected, auctions[x + 12])
			table.insert(auctionBidding, auctions[x + 13])
			x = x + 14
		end

		for i = 1, #auctionItmIds do
			table.insert(auctionItmType, Item(auctionItmIds[i]).type)
		end

		local choice = player:menuString(
			"What type of item would you like to buy?",
			{"Weapons", "Armors", "Helms/Helmets", "Rings", "Foods", "Other"},
			{}
		)
		local type = 0

		if choice == "Weapons" then
			type = 3
		elseif choice == "Armor" then
			type = 4
		elseif choice == "Helms/Helmets" then
			type = 6
		elseif choice == "Rings" then
			type = 7
		elseif choice == "Food" then
			type = 2
		elseif choice == "Other" then
			type = 18
		end

		i = 1
		while i <= #auctionItmType do
			if auctionItmType[i] ~= type then
				table.remove(auctionIds, i)
				table.remove(auctionChaIds, i)
				table.remove(auctionItmIds, i)
				table.remove(auctionItmAmounts, i)
				table.remove(auctionItmDurability, i)
				table.remove(auctionItmEngrave, i)
				table.remove(auctionItmTimer, i)
				table.remove(auctionItmCustomIcon, i)
				table.remove(auctionItmCustomIconColor, i)
				table.remove(auctionItmCustomLook, i)
				table.remove(auctionItmCustomLookColor, i)
				table.remove(auctionItmProtected, i)
				table.remove(auctionPrices, i)
				table.remove(auctionBidding, i)
				table.remove(auctionItmType, i)
				i = i - 1
			end
			i = i + 1
		end

		--if #auctionIds == 0 then player:dialogSeq({t,"Sorry but there are currently no "..choice.." for auction"},0) return end

		for i = 1, #auctionIds do
			text = "Amt: " .. auctionItmAmounts[i]

			if Item(auctionItmIds[i]).maxDura == 0 then
				text = text .. " | Prot: " .. auctionItmProtected[i]
			else
				text = text .. " (" .. ((auctionItmDurability[i] / Item(auctionItmIds[i]).maxDura) * 100) .. ")% | Prot: " .. auctionItmProtected[
					i
				]
			end

			text = text .. " | by: " .. getOfflineID(auctionChaIds[i])

			table.insert(auctionItmText, text)
		end

		local buyChoice = player:auctionBuyExtend(
			"I think I can accomodate some of the things you need. What would you like?",
			auctionIds,
			auctionChaIds,
			auctionItmIds,
			auctionItmAmounts,
			auctionPrices,
			auctionItmText,
			auctionItmEngrave,
			auctionItmDurability,
			auctionItmProtected,
			auctionItmCustomIcon,
			auctionItmCustomIconColor,
			auctionItmCustomLook,
			auctionItmCustomLookColor
		)

		if buyChoice ~= nil then
			-- worked
			local auctid = buyChoice[1]
			local auctchaid = buyChoice[2]
			local itmid = buyChoice[3]
			local amount = buyChoice[4]
			local price = buyChoice[5]
			local engrave = buyChoice[6]
			local purchaser = buyChoice[7]

			removeAuction(auctid)

			if engrave == "" then
				-- no engrave
				player:msg(
					0,
					"You have just won the auction for (" .. amount .. ") " .. Item(itmid).name .. " for " .. Tools.formatNumber(price) .. " gold.",
					player.ID
				)
			elseif engrave ~= "" then
				player:msg(
					0,
					"You have just won the auction for (" .. amount .. ") " .. engrave .. " for " .. Tools.formatNumber(price) .. " gold.",
					player.ID
				)
			end

			player:msg(0, "Please visit a messenger to claim.", player.ID)

			--- send nmail and parcel to the person who listed the auction
			local mail = "Below are the transaction details for your listed auction\n\n"
			mail = mail .. (os.date("%A, %m %B %Y, %I:%M:%S %p")) .. "\n\n"

			mail = mail .. "Person who bought from you: " .. getOfflineID(purchaser) .. "\n"

			local name = ""
			if engrave ~= "" then
				name = engrave .. " (" .. Item(itmid).name .. ")"
			else
				name = Item(itmid).name
			end

			mail = mail .. "What was bought: " .. name .. "\n"
			mail = mail .. "Amount: " .. amount .. "\n"
			mail = mail .. "Price: " .. Tools.formatNumber(price) .. " gold.\n\n"
			mail = mail .. "The proceeds from this auction have been sent to you via parcel."

			player:sendMail(
				getOfflineID(auctchaid),
				getOfflineID(purchaser) .. " has bought an item from you",
				mail
			)
			player:sendParcel(auctchaid, 190, 0, price, 0, 0, 1)

			--Player(2):talk(0,"auctid: "..auctid.." itmid: "..itmid.." amount: "..amount)
		end
	end
}

function Player.auctionBuyExtend(player, dialog, auctionids, chaids, items, amounts, prices, buytext, engraves, durability, protecteds, customIcons, customIconColors, customLooks, customLookColors)
	if (items == nil) then
		items = {}
	end
	if (prices == nil) then
		prices = {}
	end
	if (amounts == nil) then
		amounts = {}
	end
	if (buytext == nil) then
		buytext = {}
	end
	if (engraves == nil) then
		engraves = {}
	end
	if (durability == nil) then
		durability = {}
	end
	if (protecteds == nil) then
		protecteds = {}
	end
	if (customIcons == nil) then
		customIcons = {}
	end
	if (customIconColors == nil) then
		customIconColors = {}
	end
	if (customLooks == nil) then
		customLooks = {}
	end
	if (customLookColors == nil) then
		customLookColors = {}
	end
	local x = 0
	local amount = 1
	local t = {graphics = player.npcGraphic, color = player.npcColor}

	if #prices == 0 then
		for i = 1, #items do
			table.insert(prices, Item(items[i]).price)
		end
	end
	if #amounts == 0 then
		for i = 1, #items do
			table.insert(amounts, 0)
		end
	end
	if #durability == 0 then
		for i = 1, #items do
			table.insert(durability, Item(items[i]).maxDura)
		end
	end
	if #buytext == 0 then
		for i = 1, #items do
			table.insert(buytext, "")
		end
	end
	if #engraves == 0 then
		for i = 1, #items do
			table.insert(engraves, "")
		end
	end
	if #protecteds == 0 then
		for i = 1, #items do
			table.insert(protecteds, 0)
		end
	end
	if #customIcons == 0 then
		for i = 1, #items do
			table.insert(customIcons, 0)
		end
	end
	if #customIconColors == 0 then
		for i = 1, #items do
			table.insert(customIconColors, 0)
		end
	end
	if #customLooks == 0 then
		for i = 1, #items do
			table.insert(customLooks, 0)
		end
	end
	if #customLookColors == 0 then
		for i = 1, #items do
			table.insert(customLookColors, 0)
		end
	end

	local choice = player:buyCustom(
		dialog,
		items,
		prices,
		buytext,
		customIcons,
		customIconColors
	)

	for i = 1, #items do
		if items[i] == choice then
			x = i
			break
		end
	end
	if (x == 0) then
		return nil
	end

	local id = items[x]
	local price = prices[x]
	local amount = amounts[x]
	local dura = durability[x]
	local engrave = engraves[x]
	local customIcon = customIcons[x]
	local customIconColor = customIconColors[x]
	local customLook = customLooks[x]
	local customLookColor = customLookColors[x]
	local protected = protecteds[x]
	local auctionid = auctionids[x]
	local chaid = chaids[x]

	if (player.money < price) then
		player:dialog("You do not have enough money.", {})
		return nil
	end

	local name = ""
	if engrave ~= "" then
		name = engrave .. " (" .. Item(choice).name .. ")"
	else
		name = Item(choice).name
	end

	local newChoice = player:menuString(
		"You are bidding on (" .. amount .. ") " .. name .. " for " .. Tools.formatNumber(price) .. " gold.\n\nAuction posted by: " .. getOfflineID(chaid) .. "\n\nDeal?",
		{"Yes", "No"}
	)
	if (newChoice == "Yes") then
		if player.money >= price then
			local buytable = {
				auctionid,
				chaid,
				Item(choice).id,
				amount,
				price,
				engrave,
				player.ID
			}
			player:sendParcel(
				player.ID,
				190,
				id,
				amount,
				0,
				engrave,
				1,
				customLook,
				customLookColor,
				customIcon,
				customIconColor,
				protected,
				dura
			)
			player:removeGold(price)
			return buytable
		else
			player:dialogSeq(
				{t, "You don't have enough money to purchase that."},
				0
			)
		end
	end
end
