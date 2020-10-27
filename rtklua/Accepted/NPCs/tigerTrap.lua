TigerSpawnNpc = {
	-- @TODO: Not sure this function ever gets invoked; maybe delete it?
	action = function(npc)
		for map = 100, 110 do
			TigerSpawnNpc.spawnTigerTrap(npc, map)
			TigerSpawnNpc.spawnTigerTrap(npc, map + 3000)
			TigerSpawnNpc.spawnTigerTrap(npc, map + 4000)
		end
	end,

	-- @TODO: Not sure this function ever gets invoked; maybe delete it?
	spawnTigerTrap = function(npc, map)
		local trapCount = npc:getObjectsInMap(map, BL_NPC)
		local tigerTrapCount = 0
		if (#trapCount > 0) then
			for k = 1, #trapCount do
				if (trapCount[k].yname == "MobSpawnNpc") then
					tigerTrapCount = tigerTrapCount + 1
				end
			end
		end

		local mobCount = npc:getObjectsInMap(map, BL_MOB)
		if (#mobCount < 50 and tigerTrapCount < 20) then
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
					tigerTrapCount = tigerTrapCount + 1
				end
				fail = fail + 1
			until tigerTrapCount >= 20 or fail >= 5000
		end
	end,

	spawnTigerMob1 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 294
		mobs[1][2] = 294
		mobs[1][3] = 294
		mobs[2] = {}
		mobs[2][1] = 295
		mobs[2][2] = 295
		mobs[2][3] = 295
		mobs[2][4] = 295
		mobs[3] = {}
		mobs[3][1] = 296
		mobs[3][2] = 296
		mobs[3][3] = 297
		mobs[3][4] = 295
		mobs[4] = {}
		mobs[4][1] = 296
		mobs[4][2] = 296
		mobs[4][3] = 294
		mobs[4][4] = 295
		mobs[5] = {}
		mobs[5][1] = 296
		mobs[5][2] = 296
		mobs[5][3] = 294
		mobs[5][4] = 295
		mobs[6] = {}
		mobs[6][1] = 297
		mobs[6][2] = 297

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

	spawnTigerBigMob1 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 294
		mobs[1][2] = 294
		mobs[1][3] = 294
		mobs[1][4] = 296
		mobs[1][5] = 296
		mobs[1][6] = 296
		mobs[1][7] = 297
		mobs[1][8] = 297
		mobs[1][9] = 295
		mobs[1][10] = 295

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
			elseif (z == 5) then
				local passCheck = getPass(block.m, block.x + 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 2,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 2,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 2, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 6) then
				local passCheck = getPass(block.m, block.x - 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 2,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 2,
					block.y
				)) then
					block:spawn(mob, block.x - 2, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 7) then
				local passCheck = getPass(block.m, block.x, block.y - 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 2
				)) then
					block:spawn(mob, block.x, block.y - 2, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 8) then
				local passCheck = getPass(block.m, block.x, block.y + 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 2
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 2, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnTigerMob2 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 342
		mobs[1][2] = 342
		mobs[1][3] = 342
		mobs[2] = {}
		mobs[2][1] = 343
		mobs[2][2] = 343
		mobs[2][3] = 343
		mobs[2][4] = 343
		mobs[3] = {}
		mobs[3][1] = 344
		mobs[3][2] = 344
		mobs[3][3] = 344
		mobs[3][4] = 343
		mobs[4] = {}
		mobs[4][1] = 344
		mobs[4][2] = 344
		mobs[4][3] = 342
		mobs[4][4] = 343
		mobs[5] = {}
		mobs[5][1] = 344
		mobs[5][2] = 344
		mobs[5][3] = 342
		mobs[5][4] = 343
		mobs[6] = {}
		mobs[6][1] = 344
		mobs[6][2] = 344

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

	spawnTigerBigMob2 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 342
		mobs[1][2] = 342
		mobs[1][3] = 342
		mobs[1][4] = 342
		mobs[1][5] = 343
		mobs[1][6] = 343
		mobs[1][7] = 343
		mobs[1][8] = 343
		mobs[1][9] = 344
		mobs[1][10] = 344

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
			elseif (z == 5) then
				local passCheck = getPass(block.m, block.x + 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 2,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 2,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 2, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 6) then
				local passCheck = getPass(block.m, block.x - 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 2,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 2,
					block.y
				)) then
					block:spawn(mob, block.x - 2, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 7) then
				local passCheck = getPass(block.m, block.x, block.y - 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 2
				)) then
					block:spawn(mob, block.x, block.y - 2, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 8) then
				local passCheck = getPass(block.m, block.x, block.y + 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 2
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 2, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnTigerMob3 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 347
		mobs[1][2] = 347
		mobs[1][3] = 347
		mobs[2] = {}
		mobs[2][1] = 348
		mobs[2][2] = 348
		mobs[2][3] = 348
		mobs[2][4] = 348
		mobs[3] = {}
		mobs[3][1] = 349
		mobs[3][2] = 349
		mobs[3][3] = 349
		mobs[3][4] = 348
		mobs[4] = {}
		mobs[4][1] = 349
		mobs[4][2] = 349
		mobs[4][3] = 347
		mobs[4][4] = 348
		mobs[5] = {}
		mobs[5][1] = 349
		mobs[5][2] = 349
		mobs[5][3] = 347
		mobs[5][4] = 348
		mobs[6] = {}
		mobs[6][1] = 349
		mobs[6][2] = 349

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

	spawnTigerBigMob3 = function(npc, block, map)
		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = 347
		mobs[1][2] = 347
		mobs[1][3] = 347
		mobs[1][4] = 347
		mobs[1][5] = 349
		mobs[1][6] = 349
		mobs[1][7] = 349
		mobs[1][8] = 349
		mobs[1][9] = 348
		mobs[1][10] = 348

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
			elseif (z == 5) then
				local passCheck = getPass(block.m, block.x + 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x + 2,
					block.y,
					BL_ALL
				)
				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x + 2,
					block.y
				)) then
					if block.x + 1 <= getMapXMax(block.m) then
						block:spawn(mob, block.x + 2, block.y, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 6) then
				local passCheck = getPass(block.m, block.x - 2, block.y)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x - 2,
					block.y,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x - 2,
					block.y
				)) then
					block:spawn(mob, block.x - 2, block.y, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 7) then
				local passCheck = getPass(block.m, block.x, block.y - 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y - 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y - 2
				)) then
					block:spawn(mob, block.x, block.y - 2, 1)
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			elseif (z == 8) then
				local passCheck = getPass(block.m, block.x, block.y + 2)
				local blockCheck = block:getObjectsInCell(
					block.m,
					block.x,
					block.y + 2,
					BL_ALL
				)

				if (passCheck == 0 and #blockCheck == 0 and not getWarp(
					block.m,
					block.x,
					block.y + 2
				)) then
					if block.y + 1 <= getMapYMax(block.m) then
						block:spawn(mob, block.x, block.y + 2, 1)
					end
				else
					block:spawn(mob, block.x, block.y, 1)
				end
			else
				block:spawn(mob, block.x, block.y, 1)
			end
		end
	end,

	spawnTigerSentries = function(npc, block, map, mobId)
		if (mobId < 804 or mobId > 806) then
			return
		end

		local mobs = {}
		mobs[1] = {}
		mobs[1][1] = mobId
		mobs[1][2] = mobId
		mobs[1][3] = mobId
		mobs[1][4] = mobId
		mobs[1][5] = mobId

		-- MobId 804 --> Tiger sentry
		-- MobId 805 --> Tiger guardian
		-- MobId 806 --> Tiger defender

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
