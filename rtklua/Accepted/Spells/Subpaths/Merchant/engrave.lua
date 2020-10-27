engrave = {
	cast = async(function(player, target)
		local t = {graphic = convertGraphic(71, "item"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if os.time() < player.registry["engrave_timer"] then
			player:dialogSeq({t, "You have engraved too recently."}, 0)
			return
		end

		local cost = player:inputNumberCheck(player:inputSeq(
			"How much gold will you be asking for offering your services?",
			"I will be asking for",
			"gold",
			{},
			{}
		))

		target:freeAsync()
		engrave.presentOffer(target, player, cost)
	end),

	presentOffer = async(function(engravee, engraver, cost)
		local t = {graphic = convertGraphic(71, "item"), color = 0}
		engravee.npcGraphic = t.graphic
		engravee.npcColor = t.color
		engravee.dialogType = 0

		local choice = engravee:menuSeq(
			engraver.name .. " is offering you their engraving services for " .. Tools.formatValue(cost) .. " gold. Are you willing to pay this amount?",
			{"Yes", "No"},
			{}
		)

		if choice == 1 then
			if engravee.money < cost then
				engraver:popUp(engravee.name .. " is unable to afford your services.")
				return
			end
		end

		if choice == 2 then
			engraver:popUp(engravee.name .. " has not accepted your offer.")
			return
		end

		local proposedName = ""

		local inventoryItems = {}
		local inventoryItemIds = {}
		local inventoryItemCounts = {}
		local inventoryItemEngraves = {}
		local inventoryItemOwners = {}

		local found = 0

		for i = 0, 51 do
			table.insert(inventoryItems, engravee:getInventoryItem(i))
		end

		for i = 1, #inventoryItems do
			if inventoryItems[i].type >= 3 and inventoryItems[i].type <= 17 then
				table.insert(inventoryItemIds, inventoryItems[i].id)
				table.insert(inventoryItemCounts, inventoryItems[i].amount)
				table.insert(inventoryItemEngraves, inventoryItems[i].realName)
				table.insert(inventoryItemOwners, inventoryItems[i].owner)
			end
		end

		local temp = engravee:buy(
			"What item would you like to engrave?",
			inventoryItemIds,
			inventoryItemCounts,
			inventoryItemEngraves,
			inventoryItemOwners
		)

		local selectedItem = {}

		for i = 0, 52 do
			-- this block returns the slot id of the item they chose
			selectedItem = engravee:getInventoryItem(i)

			if selectedItem ~= nil then
				if (selectedItem.id == temp) then
					break
				end
			end
		end

		if selectedItem == nil then
			return
		end

		local t = {graphic = selectedItem.icon, selectedItem.iconC}
		engravee.npcGraphic = t.graphic
		engravee.npcColor = t.color
		engravee.dialogType = 0
		engravee.lastClick = engravee.ID

		if selectedItem.realName == "" then
			-- has no engrave
			proposedName = engravee:inputSeq(
				"Please type in some text that you would like the item to be known as.\n\n(You do not need to enter the asterisks (*))",
				"",
				"",
				{},
				{}
			)
		else
			proposedName = engravee:inputSeq(
				"Current Engrave: " .. selectedItem.realName .. "\n\n(You do not need to enter the asterisks (*))",
				"Type in a new engrave below.",
				"",
				{},
				{}
			)
		end

		if (proposedName:match("[^%a%s%']")) then
			engravee:dialog("You can only enter letters and spaces.", {})
			return
		end

		if string.len(proposedName) > 18 then
			engravee:dialogSeq(
				{t, "The proposed name is too long. Maximum of 18 characters."},
				1
			)
			return
		end

		engraver:freeAsync()
		engrave.confirmEngrave(
			engraver,
			engravee,
			selectedItem,
			proposedName,
			cost
		)
	end),

	confirmEngrave = async(function(engraver, engravee, selectedItem, proposedName, cost)
		local t = {graphic = selectedItem.icon, selectedItem.iconC}
		engraver.npcGraphic = t.graphic
		engraver.npcColor = t.color
		engraver.dialogType = 0
		engraver.lastClick = engravee.ID

		local choice = engraver:menuSeq(
			engravee.name .. " has accepted your offer.\n\nProposed name: ** " .. proposedName .. " **\n\nDoes this name meet the Acceptable naming policy set forth in the Terms of Service?",
			{"Yes", "No"},
			{}
		)

		if choice == 2 then
			-- reject
			engravee:popUp("Your proposed engrave name does not meet the standards set forth in the Terms of Service.")
			return
		end

		local confirm = engraver:menuSeq(
			"Are you sure you want to engrave the item?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if Player(engravee.name) == nil then
				engraver:dialogSeq(
					{t, "That character is no longer online."},
					0
				)
				return
			end

			if engravee.money < cost then
				engraver:dialogSeq(
					{
						t,
						"That character no longer has enough gold to cover your cost."
					},
					0
				)
				return
			end

			engravee:removeGold(cost)
			engraver:addGold(cost)

			engraver.registry["engrave_timer"] = os.time() + 86400

			selectedItem.realName = "** " .. proposedName .. " **"
			engravee:refreshInventory()

			engraver:popUp("The item has been engraved.")
			engravee:popUp("The item has been engraved.")
		end
	end)
}
