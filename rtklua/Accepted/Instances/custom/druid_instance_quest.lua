druid_instance_quest = {
	quest = function(maps, owner)
		local player = Player(owner)
		local guitext = ""

		local stage1_total = 20

		if player.registry["druid_quest"] == 0 then
			player.registry["druid_quest"] = 1
			local minX = 0
			local maxX = getMapXMax(map)
			local minY = 0
			local maxY = getMapYMax(map)

			if (spawnMinX ~= nil and spawnMaxX ~= nil and spawnMinY ~= nil and spawnMaxY ~= nil) then
				minX = spawnMinX
				maxX = spawnMaxX
				minY = spawnMinY
				maxY = spawnMaxY

				if maxX > getMapXMax(map) then
					maxX = getMapXMax(map)
				end
				if maxY > getMapYMax(map) then
					maxY = getMapYMax(map)
				end
			end

			for z = 1, 1000 do
				local spawnX = math.random(minX, maxX)
				local spawnY = math.random(minY, maxY)

				local passCheck = getPass(player.m, spawnX, spawnY)
				local objCheck = getObject(player.m, spawnX, spawnY)
				local pcCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_PC
				)
				local mobCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_MOB
				)
				local npcCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_NPC
				)

				if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and #npcCheck == 0 and not getWarp(
					player.m,
					spawnX,
					spawnY
				)) then
					player:addNPC(
						"DruidQuestFireNpc",
						player.m,
						spawnX,
						spawnY,
						2,
						1000,
						3500000,
						player.ID
					)
				end
			end

			for z = 1, 500 do
				local spawnX = math.random(minX, maxX)
				local spawnY = math.random(minY, maxY)

				local passCheck = getPass(player.m, spawnX, spawnY)
				local objCheck = getObject(player.m, spawnX, spawnY)
				local pcCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_PC
				)
				local mobCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_MOB
				)
				local npcCheck = player:getObjectsInCell(
					player.m,
					spawnX,
					spawnY,
					BL_NPC
				)

				if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and #npcCheck == 0 and not getWarp(
					player.m,
					spawnX,
					spawnY
				)) then
					player:spawn(715, spawnX, spawnY, 1)
				end
			end

			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				192,
				114,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				193,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				194,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				195,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				196,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				197,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				198,
				115,
				2,
				1000,
				3500000,
				player.ID
			)
			player:addNPC(
				"DruidQuestFireNpc",
				player.m,
				199,
				114,
				2,
				1000,
				3500000,
				player.ID
			)
			player:spawn(718, 196, 114, 1)

			player:msg(
				0,
				"Hariette(Druid): Wow! What is going on here?!",
				player.ID
			)
			setMapAttribute(maps[1], "light", 15)
			setMapAttribute(maps[1], "indoor", 1)
			player:refresh()
			player:updateState()
			player.registry["druid_quest_stage1_amount"] = 0
		end

		if player.registry["druid_quest"] == 1 then
			if player.registry["druid_quest_stage1_amount"] == stage1_total then
				player:msg(
					0,
					"Hariette(Druid): Good job! Now go find the tree of reflections and make sure it is ok!",
					player.ID
				)
				player.registry["druid_quest"] = 2
				player.registry["druid_quest_time"] = os.time()
			end

			guitext = ""
			guitext = guitext .. "Stage 1 - The Beginning" .. "\n"
			guitext = guitext .. "Fires put out " .. player.registry[
				"druid_quest_stage1_amount"
			] .. "/" .. stage1_total
		end

		if player.registry["druid_quest"] == 2 then
			if (os.time() > player.registry["druid_quest_time"] + 5) then
				if player.x > 186 and player.y > 101 and player.y < 121 then
					player:msg(
						0,
						"Hariette(Druid): You made it! What is going on here? It looks like they are going to burn it down.",
						player.ID
					)
					player.registry["druid_quest"] = 3
					player.registry["druid_quest_time"] = os.time()
				end

				guitext = ""
				guitext = guitext .. "Stage 2 - What is going on?" .. "\n"
				guitext = guitext .. "Travel to the tree of reflections"
			end
		end

		if player.registry["druid_quest"] == 3 then
			if (os.time() > player.registry["druid_quest_time"] + 3) then
				player:msg(
					0,
					"Hariette(Druid): Quickly, heal the tree back and put out the fires.",
					player.ID
				)
				player.registry["druid_quest"] = 4
				player.registry["druid_quest_time"] = os.time()
			end
		end

		if player.registry["druid_quest"] == 4 then
			local tree = player:getObjectsInCell(player.m, 196, 114, BL_MOB)

			if #tree > 0 then
				local percent = math.floor(tree[1].health / tree[1].maxHealth * 100)

				guitext = ""
				guitext = guitext .. "Stage 3 - Restoration" .. "\n"
				guitext = guitext .. "Tree Health: " .. percent .. "%"

				if tree[1].health >= tree[1].maxHealth then
					player.registry["druid_quest"] = 5
					player.registry["druid_quest_time"] = os.time()
				end
			end
		end

		if player.registry["druid_quest"] == 5 then
			if (os.time() > player.registry["druid_quest_time"] + 2) then
				player:msg(
					0,
					"Hariette(Druid): Great job, you restored the tree.",
					player.ID
				)
				player.registry["druid_quest"] = 6
				player.registry["druid_quest_time"] = os.time()
			end
		end

		if player.registry["druid_quest"] == 6 then
			if (os.time() > player.registry["druid_quest_time"] + 2) then
				player:msg(
					0,
					"Hariette(Druid): Come back to me, you have completed this trial.",
					player.ID
				)
				player.registry["druid_quest"] = 7
				player.registry["druid_quest_time"] = os.time()
			end
		end

		if player.registry["druid_quest"] == 7 then
			if (os.time() > player.registry["druid_quest_time"] + 5) then
				player.registry["druid_quest"] = 8
				player:warp(3632, 27, 16)
			end
		end

		player:guitext(guitext)
	end,
}
