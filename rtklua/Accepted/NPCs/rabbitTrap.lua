RabbitSpawnNpc = {
	action = function(npc)
		for map = 201, 207 do
			RabbitSpawnNpc.spawnRabbitTrap(npc, map)
			RabbitSpawnNpc.spawnRabbitTrap(npc, map + 3000)
			RabbitSpawnNpc.spawnRabbitTrap(npc, map + 4000)
		end
		RabbitSpawnNpc.spawnRabbitTrap208upper(npc, 4208)
		RabbitSpawnNpc.spawnRabbitTrap208lower(npc, 4208)
		RabbitSpawnNpc.spawnRabbitTrap208upper(npc, 3208)
		RabbitSpawnNpc.spawnRabbitTrap208lower(npc, 3208)
		RabbitSpawnNpc.spawnRabbitTrap208upper(npc, 208)
		RabbitSpawnNpc.spawnRabbitTrap208lower(npc, 208)
	end,

	spawnRabbitTrap = function(npc, map)
		local trapCount = npc:getObjectsInMap(map, BL_NPC)
		local rabbitTrapCount = 0
		if (#trapCount > 0) then
			for k = 1, #trapCount do
				if (trapCount[k].yname == "MobSpawnNpc") then
					rabbitTrapCount = rabbitTrapCount + 1
				end
			end
		end

		local mobCount = npc:getObjectsInMap(map, BL_MOB)
		if (#mobCount < 64 and rabbitTrapCount < 20) then
			local fail = 0
			repeat
				local spawnX = math.random(1, getMapXMax(map))
				local spawnY = math.random(1, getMapYMax(map))
				local passCheck = getPass(map, spawnX, spawnY)
				local blockCheck = npc:getObjectsInCell(
					map,
					spawnX,
					spawnY,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(map, spawnX, spawnY)) then
					npc:addNPC("MobSpawnNpc", map, spawnX, spawnY, 2)
					rabbitTrapCount = rabbitTrapCount + 1
				end
				fail = fail + 1
			until rabbitTrapCount >= 20 or fail >= 5000
		end
	end,

	spawnRabbitTrap208upper = function(npc, map)
		local trapCount = npc:getObjectsInMap(map, BL_NPC)
		local rabbitTrapCount = 0
		if (#trapCount > 0) then
			for k = 1, #trapCount do
				if (trapCount[k].yname == "MobSpawnNpc") then
					if (trapCount[k].y <= 20) then
						rabbitTrapCount = rabbitTrapCount + 1
					end
				end
			end
		end

		local mobCount = npc:getObjectsInMap(map, BL_MOB)
		local themobcount = 0
		for z = 1, #mobCount do
			if (mobCount[z].y <= 20) then
				themobcount = themobcount + 1
			end
		end
		local totalcount = (rabbitTrapCount * 5) + themobcount
		if (totalcount < 60) then
			local fail = 0
			repeat
				local spawnX = math.random(1, getMapXMax(map))
				local spawnY = math.random(1, 19)
				local passCheck = getPass(map, spawnX, spawnY)
				local blockCheck = npc:getObjectsInCell(
					map,
					spawnX,
					spawnY,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(map, spawnX, spawnY)) then
					npc:addNPC("MobSpawnNpc", map, spawnX, spawnY, 2)
					totalcount = totalcount + 5
				end
				fail = fail + 1
			until totalcount >= 50 or fail >= 5000
		end
	end,

	spawnRabbitTrap208lower = function(npc, map)
		local trapCount = npc:getObjectsInMap(map, BL_NPC)
		local rabbitTrapCount = 0
		if (#trapCount > 0) then
			for k = 1, #trapCount do
				if (trapCount[k].yname == "MobSpawnNpc") then
					if (trapCount[k].y > 20) then
						rabbitTrapCount = rabbitTrapCount + 1
					end
				end
			end
		end

		local mobCount = npc:getObjectsInMap(map, BL_MOB)
		local themobcount = 0
		for z = 1, #mobCount do
			if (mobCount[z].y > 20) then
				themobcount = themobcount + 1
			end
		end
		local totalcount = (rabbitTrapCount * 5) + themobcount
		if (totalcount < 50) then
			local fail = 0
			repeat
				local spawnX = math.random(1, getMapXMax(map))
				local spawnY = math.random(25, getMapYMax(map))
				local passCheck = getPass(map, spawnX, spawnY)
				local blockCheck = npc:getObjectsInCell(
					map,
					spawnX,
					spawnY,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(map, spawnX, spawnY)) then
					npc:addNPC("MobSpawnNpc", map, spawnX, spawnY, 2)
					totalcount = totalcount + 5
				end
				fail = fail + 1
			until totalcount >= 50 or fail >= 5000
		end
	end,

	spawnRabbitMob1 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 518
		mobs[1][2] = 518
		mobs[1][3] = 518
		mobs[1][4] = 518
		mobs[2] = {}
		mobs[2][1] = 519
		mobs[2][2] = 519
		mobs[2][3] = 519
		mobs[2][4] = 519
		mobs[3] = {}
		mobs[3][1] = 520
		mobs[3][2] = 520
		mobs[3][3] = 520
		mobs[3][4] = 520

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnRabbitSentsMob1 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 521
		mobs[1][2] = 521
		mobs[1][3] = 521
		mobs[1][4] = 521
		mobs[1][5] = 521

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnRabbitMob2 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 599
		mobs[1][2] = 599
		mobs[1][3] = 599
		mobs[1][4] = 599
		mobs[2] = {}
		mobs[2][1] = 524
		mobs[2][2] = 524
		mobs[2][3] = 524
		mobs[2][4] = 524
		mobs[3] = {}
		mobs[3][1] = 525
		mobs[3][2] = 525
		mobs[3][3] = 525
		mobs[3][4] = 525

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnRabbitSentsMob2 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 526
		mobs[1][2] = 526
		mobs[1][3] = 526
		mobs[1][4] = 526
		mobs[1][5] = 526

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnRabbitMob3 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1] = {}
		mobs[1][1] = 529
		mobs[1][2] = 530
		mobs[1][3] = 529
		mobs[1][4] = 530
		mobs[2] = {}
		mobs[2][1] = 529
		mobs[2][2] = 530
		mobs[2][3] = 529
		mobs[2][4] = 530
		mobs[3] = {}
		mobs[3][1] = 531
		mobs[3][2] = 531
		mobs[3][3] = 531
		mobs[3][4] = 531

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnRabbitSentsMob3 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 532
		mobs[1][2] = 532
		mobs[1][3] = 532
		mobs[1][4] = 532
		mobs[1][5] = 532

		local trapType = math.random(1, #mobs)
		for z = 1, #mobs[trapType] do
			local mob = mobs[trapType][z]

			if (z == 1) then
				local passCheck = getPass(block.m, block.x + 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 1,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 1,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 1, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 2) then
				local passCheck = getPass(block.m, block.x - 1, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 1,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 1,
					block.y
				)) then
					block:spawn(mob, block.x - 1, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 3) then
				local passCheck = getPass(block.m, block.x, block.y - 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 1
				)) then
					block:spawn(mob, block.x, block.y - 1, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 4) then
				local passCheck = getPass(block.m, block.x, block.y + 1)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 1,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 1
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 1, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end
}
