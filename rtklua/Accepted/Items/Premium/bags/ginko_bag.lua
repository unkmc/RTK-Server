ginko_bags = {
	-- this not actually an item, is a function that all bags can use

	addToBag = function(player, amberType)
		local item = Item(amberType)
		local bag = player:getInventoryItem(player.invSlot)

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local amount = 0
		local invAmount = 0

		local invItem
		for i = 0, 52 do
			invItem = player:getInventoryItem(i)
			if invItem ~= nil then
				if invItem.yname == item.yname then
					invAmount = invItem.amount
					break
				end
			end
		end

		if invAmount == 0 then
			player:dialogSeq(
				{
					t,
					"You have no " .. Item(amberType).name .. " to add to the bag."
				},
				0
			)
			return
		end

		amount = player:inputNumberCheck(player:input("How many " .. Item(amberType).name .. " would you like to add to the bag?"))

		if amount > invAmount then
			amount = invAmount
		end

		if bag.dura == bag.maxDura then
			player:dialogSeq(
				{t, "Your bag is full of " .. Item(amberType).name .. "."},
				0
			)
			return
		end

		if amount + bag.dura > bag.maxDura then
			amount = bag.maxDura - bag.dura
		end

		if player:hasItem(amberType, amount) ~= true then
			return
		end

		bag.dura = bag.dura + amount
		player:removeItem(amberType, amount)
		player:updateInv()
	end,

	removeFromBag = function(player, amberType)
		local bag = player:getInventoryItem(player.invSlot)
		local amount = 0

		if bag.dura > 1 then
			amount = player:inputNumberCheck(player:input("How many " .. Item(amberType).name .. "s would you like to remove from your bag?"))
			if amount > bag.dura then
				amount = bag.dura
			end
		elseif bag.dura == 1 then
			amount = 1
		end

		local invAmount = 0
		local diff = 0

		for i = 0, 52 do
			local invItem = player:getInventoryItem(i)

			if invItem ~= nil then
				if invItem.yname == amberType then
					invAmount = invItem.amount
					break
				end
			end
		end

		if invAmount + amount > Item(amberType).stackAmount then
			-- the ambers would be larger than stack
			amount = Item(amberType).stackAmount - invAmount
		end

		if amount == 0 then
			-- stack is 100% full
			player:dialogSeq(
				{
					t,
					"You cannot have more " .. Item(amberType).name .. " until you remove some from your inventory."
				},
				0
			)
			return
		end

		if not player:hasSpace(amberType, amount) then
			player:sendMinitext("Your bag is full.")
			return
		end

		if bag.dura - amount <= 0 then
			if player:hasItem(bag.yname, 1, amount) ~= true then
				return
			end
			player:addItem("empty_ginko_bag", 1)
			player:removeItemSlot(player.invSlot, 1)
		else
			bag.dura = bag.dura - amount
			player:updateInv()
		end

		player:addItem(Item(amberType).yname, amount)
	end,

	presentOptions = function(player)
		local bag = player:getInventoryItem(player.invSlot)
		local amberType = "ginko_wood"

		local t = {graphic = bag.icon, color = bag.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local choices = {}
		if bag.dura ~= bag.maxDura then
			table.insert(choices, "Add ginko wood to bag.")
		end
		if bag.dura ~= 0 then
			table.insert(choices, "Remove ginko wood from bag.")
		end

		local choice = player:menuString("What would you like to do?", choices)

		if choice == "Add ginko wood to bag." then
			ginko_bags.addToBag(player, amberType)
		elseif choice == "Remove ginko wood from bag." then
			ginko_bags.removeFromBag(player, amberType)
		end
	end
}

empty_ginko_bag = {
	use = async(function(player)
		local t = {graphic = convertGraphic(2232, "item"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local amount = 0
		local invAmount = 0

		for i = 0, 52 do
			local item = player:getInventoryItem(i)
			if item ~= nil then
				if item.yname == "ginko_wood" then
					invAmount = item.amount
					break
				end
			end
		end

		if invAmount == 0 then
			player:dialogSeq(
				{
					t,
					"You must have some Ginko wood in your inventory to be able to add to the bag."
				},
				0
			)
			return
		end

		local amount = player:inputNumberCheck(player:input("How many Ginko wood would you like to add to your ginko bag?"))

		if amount > invAmount then
			amount = invAmount
		end

		if player:hasItem("ginko_wood", amount) ~= true then
			return
		end

		-- this is fail safe incase someone tries swapping slots
		if player:hasItem("empty_ginko_bag", 1) ~= true then
			return
		end

		if not player:hasSpace("ginko_bag", 1) then
			player:sendMinitext("Your inventory is full.")
			return
		end

		player:removeItem("empty_ginko_bag", 1)
		player:removeItem("ginko_wood", amount)
		player:addItem("ginko_bag", 1, amount)
	end)
}

ginko_bag = {
	use = async(function(player)
		ginko_bags.presentOptions(player)
	end)
}
