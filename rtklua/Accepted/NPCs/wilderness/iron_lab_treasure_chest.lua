IronLabTreasureChestNpc = {
	on_spawn = function(npc)
		npc.subType = 0
		npc.look = 154
		npc.lookColor = 3
		npc.side = 2
		npc:sendSide()
	end,

	action = function(npc)
		npc.side = 2
		npc:sendSide()
	end,

	open = function(player, npc)
		npc.side = 1
		npc:sendSide()

		local roll = math.random(1, 100000)

		local foundItem = false

		local items = {
			"ore_poor",
			"ore_med",
			"metal",
			"ore_high",
			"fine_metal",
			"ore_very_high",
			"gold_ore",
			"silver_ore"
		}
		local amounts = {3, 3, 2, 2, 1, 1, 1, 1}
		local chance = {55000, 30000, 40000, 25000, 15000, 10000, 5000, 7500}

		for i = 1, #chance do
			roll = math.random(1, 100000)
			if foundItem == true and roll <= chance[i] then
				player:addItem(items[i], math.random(1, amounts[i]))
				break
			elseif roll <= chance[i] then
				player:addItem(items[i], math.random(1, amounts[i]))
				foundItem = true
			end
		end

		if foundItem then
			player:sendMinitext("You manage to open the treasure box!")
		end
		if not foundItem then
			player:sendMinitext("The chest was empty.")
		end
	end
}
