WoodcuttingSpawnHandlerNpc = {
	action = function(npc)
		--(npc,map,{mob ids},{mob counts},timer)

		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 1153, {541}, {250}, 300)
		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 1151, {541}, {250}, 300)
		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 1152, {541}, {250}, 300)
		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 1154, {541}, {500}, 300)

		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 2977, {541}, {100}, 300)
		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 2978, {541}, {100}, 300)
		WoodcuttingSpawnHandlerNpc.handleSpawn(npc, 2979, {541}, {100}, 300)
	end,

	spawnMob = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
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

		local pc = npc:getObjectsInMap(map, BL_PC)
		if (os.time() > (getMapRegistry(map, "lastSpawn" .. mobs[1]) + timer) and #pc > 0) then
			local mobBlocks = npc:getObjectsInMap(map, BL_MOB)

			for z = 1, #mobs do
				local fail = 0
				local mobCount = 0
				if (#mobBlocks > 0) then
					for i = 1, #mobBlocks do
						if (mobBlocks[i].mobID == mobs[z]) then
							mobCount = mobCount + 1
						end
					end
				end

				if (mobCount < maxMobs[z]) then
					repeat
						local spawnX = math.random(minX, maxX)
						local spawnY = math.random(minY, maxY)

						local passCheck = getPass(map, spawnX, spawnY)
						local pcCheck = npc:getObjectsInCell(
							map,
							spawnX,
							spawnY,
							BL_PC
						)
						local mobCheck = npc:getObjectsInCell(
							map,
							spawnX,
							spawnY,
							BL_MOB
						)
						if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and not getWarp(
							map,
							spawnX,
							spawnY
						)) then
							npc:spawn(mobs[z], spawnX, spawnY, 1, map)
							mobCount = mobCount + 1
						else
							fail = fail + 1
							if (fail >= maxMobs[z] * 5) then
								mobCount = maxMobs[z]
							end
						end
					until mobCount >= maxMobs[z]
				end
			end
			setMapRegistry(map, "lastSpawn" .. mobs[1], os.time())
		end
	end,
	deleteMob = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
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

		local pc = npc:getObjectsInMap(map, BL_PC)
		local mobBlocks = {}
		if (#pc == 0 and (os.time() > (getMapRegistry(map, "lastSpawn" .. mobs[1]) + timer))) then
			mobBlocks = npc:getObjectsInMap(map, BL_MOB)
			if (#mobBlocks > 0) then
				for i = 1, #mobBlocks do
					for z = 1, #mobs do
						if (mobBlocks[i] ~= nil) then
							if (mobBlocks[i].mobID == mobs[z] and mobBlocks[i].x >= minX and mobBlocks[i].x <= maxX and mobBlocks[
								i
							].y >= minY and mobBlocks[i].y <= maxY) then
								mobBlocks[i]:delete()
								mobBlocks[i] = nil

								--table.remove(mobBlocks,mobBlocks[i])
								--i=i-1
							end
						end
					end
				end
			end
		end
	end,

	handleSpawn = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
		WoodcuttingSpawnHandlerNpc.deleteMob(
			npc,
			map,
			mobs,
			maxMobs,
			timer,
			spawnMinX,
			spawnMinY,
			spawnMaxX,
			spawnMaxY
		)
		WoodcuttingSpawnHandlerNpc.spawnMob(
			npc,
			map,
			mobs,
			maxMobs,
			timer,
			spawnMinX,
			spawnMinY,
			spawnMaxX,
			spawnMaxY
		)
	end
}
