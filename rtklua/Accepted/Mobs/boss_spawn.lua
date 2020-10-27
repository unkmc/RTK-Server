boss_spawn = {
	spawn = function()
		if (realMinute() % 10 == 0) then
			boss_spawn.nine_tailed_fox_buya()
		end

		if (realSecond() % 10 == 0) then
			boss_spawn.nine_tailed_fox_kugnae()
		end
	end,

	nine_tailed_fox_kugnae = function()
		local maxSpawns = 2
		local spawns = 0

		local spawnMapIds = {73, 75, 76, 77, 78}

		for i = 1, #spawnMapIds do
			local mob = core:getObjectsInMap(spawnMapIds[i], BL_MOB)

			if mob ~= nil then
				for j = 1, #mob do
					if mob[j].yname == "nine_tailed_fox" then
						spawns = spawns + 1
					end
				end
			end

			if spawns >= maxSpawns then
				return
			end
		end

		local spawned = false
		local maxRuns = 5
		local increment = 0
		local randX
		local randY
		local mobsSpawnedOnMap = {}

		while spawned == false do
			local rand = math.random(1, #spawnMapIds)
			local randomMap = spawnMapIds[rand]
			randX = math.random(1, getMapXMax(randomMap))
			randY = math.random(1, getMapYMax(randomMap))

			mobsSpawnedOnMap = core:getObjectsInMap(randomMap, BL_MOB)

			if mobsSpawnedOnMap ~= nil then
				for a = 1, #mobsSpawnedOnMap do
					if mobsSpawnedOnMap[a].yname == "nine_tailed_fox" then
						return
					end
				end
			end

			local pass = getPass(randomMap, randX, randY)
			local obj = getObject(randomMap, randX, randY)
			local warp = getWarp(randomMap, randX, randY)
			local blockCheck = core:getObjectsInCell(
				randomMap,
				randX,
				randY,
				BL_ALL
			)

			if pass == 0 and obj == 0 and not warp and #blockCheck == 0 then
				core:spawn("nine_tailed_fox", randX, randY, 1, randomMap)
				spawned = true
			end

			increment = increment + 1
			if increment >= maxRuns then
				-- failsafe break while loop
				return
			end
		end
	end,

	nine_tailed_fox_buya = function()
		local maxSpawns = 3
		local spawns = 0

		local spawnMapIds = {393, 394, 395, 396, 397, 398, 399}

		for i = 1, #spawnMapIds do
			local mob = core:getObjectsInMap(spawnMapIds[i], BL_MOB)

			if #mob > 0 then
				for j = 1, #mob do
					if mob[j].yname == "nine_tailed_fox" then
						spawns = spawns + 1
					end
				end
			end

			if spawns >= maxSpawns then
				return
			end
		end

		local spawned = false
		local maxRuns = 5
		local increment = 0
		local randX
		local randY
		local mobsSpawnedOnMap = {}

		while spawned == false do
			local rand = math.random(1, #spawnMapIds)
			local randomMap = spawnMapIds[rand]
			randX = math.random(1, getMapXMax(randomMap))
			randY = math.random(1, getMapYMax(randomMap))

			mobsSpawnedOnMap = core:getObjectsInMap(randomMap, BL_MOB)

			if mobsSpawnedOnMap ~= nil then
				for a = 1, #mobsSpawnedOnMap do
					if mobsSpawnedOnMap[a].yname == "nine_tailed_fox" then
						return
					end
				end
			end

			local pass = getPass(randomMap, randX, randY)
			local obj = getObject(randomMap, randX, randY)
			local warp = getWarp(randomMap, randX, randY)
			local blockCheck = core:getObjectsInCell(
				randomMap,
				randX,
				randY,
				BL_ALL
			)

			if pass == 0 and obj == 0 and not warp and #blockCheck == 0 then
				core:spawn("nine_tailed_fox", randX, randY, 1, randomMap)
				spawned = true
			end

			increment = increment + 1
			if increment >= maxRuns then
				-- failsafe break while loop
				return
			end
		end
	end
}
