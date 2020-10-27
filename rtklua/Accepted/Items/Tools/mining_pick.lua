mining_pick2 = {
	on_hit = function(player, target)
		if target.blType == BL_MOB then
			local correctNode = false
			local nodes = {
				"ore_poor",
				"ore_med",
				"ore_high",
				"ore_very_high",
				"quartz",
				"silver_ore",
				"gold_ore"
			}

			for i = 1, #nodes do
				if target.yname == nodes[i] then
					correctNode = true
				end
			end

			if not correctNode then
				return
			end

			local chanceTable = {
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				2,
				2,
				2,
				2,
				2,
				2,
				2,
				3,
				3,
				3,
				4,
				5,
				6,
				6,
				7
			}

			local select = chanceTable[math.random(1, #chanceTable)]

			local chosenOre = nodes[select]

			if math.random(1, 10) < 3 then
				-- success
				player:addItem(chosenOre, 1)

				if not crafting.checkSkillLevel(player, "mining", "novice") then
					-- no points in skill
					crafting.addPoints(player, NPC("Chul"), "mining", 1)

					-- adds initial legend mark
				else
					crafting.skillChanceIncrease(player, NPC("Chul"), "mining")
				end
			end

			--[[local items = {"ore_poor","ore_med","ore_high","ore_very_high","quartz","gold_ore","silver_ore"}
		local itemChances = {75, 50, 25, 10, 2, 2}
		local itemAmounts = {2,3,2,2,3,2}
		local start = 0

		for i = 1, #items do
			if target.yname == items[i] then start = i break end
		end
		if start == 0 then return end

		local miningskill = crafting.getSkillValue(player,"mining") + 1
		if miningskill < start then player:sendMinitext("You need higher mining skill.") return end
		local fail = math.random(1,miningskill)
		if fail <= start then return end

		for i = start, #items do
			local chance = math.random(1,100)
			local given = math.random(1,itemAmounts[i])
			if chance < itemChances[i] then
				if player:hasItem(items[i],(Item(items[i]).stackAmount - given) + 1) ~= true then
					player:addItem(items[i],given)

					if not crafting.checkSkillLevel(player,"mining","novice") then -- no points in skill
						crafting.addPoints(player,NPC("Chul"),"mining",1) -- adds initial legend mark
					else
						crafting.skillChanceIncrease(player,NPC("Chul"),"mining")
					end

				else
					if math.random(1,8) == 1 then
						player:sendMinitext("You can't carry any more "..Item(items[i]).name..".")
					end
				end
				return
			end
		end]]
			--
		end
	end
}
