fish_bags = {
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
					"You have no " .. Item(amberType).name .. "es to add to the bag."
				},
				0
			)
			return
		end

		amount = player:inputNumberCheck(player:input("How many " .. Item(amberType).name .. "es would you like to add to the bag?"))

		if amount > invAmount then
			amount = invAmount
		end

		if bag.dura == bag.maxDura then
			player:dialogSeq(
				{t, "Your bag is full of " .. Item(amberType).name .. "es."},
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
			amount = player:inputNumberCheck(player:input("How many " .. Item(amberType).name .. "es would you like to remove from your bag?"))
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
					"You cannot have more " .. Item(amberType).name .. "es until you remove some from your inventory."
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
			player:addItem("empty_fish_bag", 1)
			player:removeItemSlot(player.invSlot, 1)
		else
			bag.dura = bag.dura - amount
			player:updateInv()
		end

		player:addItem(Item(amberType).yname, amount)
	end,

	presentOptions = function(player)
		local bag = player:getInventoryItem(player.invSlot)

		local amberType = string.gsub(bag.yname, "_bag", "")

		local t = {graphic = bag.icon, color = bag.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local choices = {}
		if bag.dura ~= bag.maxDura then
			table.insert(choices, "Add fish to bag.")
		end
		if bag.dura ~= 0 then
			table.insert(choices, "Remove fish from bag.")
		end

		local choice = player:menuString("What would you like to do?", choices)

		if choice == "Add fish to bag." then
			fish_bags.addToBag(player, amberType)
		elseif choice == "Remove fish from bag." then
			fish_bags.removeFromBag(player, amberType)
		end
	end
}

empty_fish_bag = {
	use = async(function(player)
		local t = {graphic = convertGraphic(2232, "item"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local fishtypes = {
			"scrawny_fish",
			"tiny_fish",
			"small_fish",
			"large_fish",
			"tasty_fish",
			"delicious_fish"
		}

		local foundFish = {}
		local amounts = {}

		for i = 0, 52 do
			local item = player:getInventoryItem(i)
			if item ~= nil then
				for j = 1, #fishtypes do
					if item.yname == fishtypes[j] then
						table.insert(foundFish, item.yname)
						table.insert(amounts, item.amount)
					end
				end
			end
		end

		if #foundFish == 0 then
			player:dialogSeq(
				{
					t,
					"You must have some fish in your inventory to be able to add to the bag."
				},
				0
			)
			return
		end

		local choiceid = player:buy(
			"What type of fish do you want to add?",
			foundFish,
			amounts,
			{},
			{},
			{},
			{},
			{}
		)

		local invItem

		for i = 0, 52 do
			invItem = player:getInventoryItem(i)
			if invItem ~= nil then
				if invItem.name == choiceid then
					break
				end
			end
		end

		local amount = 0

		if invItem ~= nil then
			-- finally at the point we have a valid object from what the player chose
			if invItem.amount > 1 then
				amount = player:inputNumberCheck(player:input("How many " .. invItem.name .. "s would you like to add to your fish bag?"))

				if amount > invItem.amount then
					amount = invItem.amount
				end
			else
				amount = 1
			end
		end

		if player:hasItem(invItem.yname, amount) ~= true then
			return
		end

		-- this is fail safe incase someone tries swapping slots
		if player:hasItem("empty_fish_bag", 1) ~= true then
			return
		end

		local newBag = invItem.yname

		if not player:hasSpace(newBag .. "_bag", 1) then
			player:sendMinitext("Your inventory is full.")
			return
		end

		player:removeItem("empty_fish_bag", 1)
		player:removeItem(invItem.yname, amount)
		player:addItem(newBag .. "_bag", 1, amount)
	end)
}

scrawny_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
tiny_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
small_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
large_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
tasty_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
delicious_fish_bag = {
	use = async(function(player)
		fish_bags.presentOptions(player)
	end)
}
