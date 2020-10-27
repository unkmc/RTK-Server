NpcSpawnHandlerNpc = {
	action = function(npc)
		---------------------------
		-- Kug spider cave
		NpcSpawnHandlerNpc.handleSpawn(npc, 90, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 91, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 92, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 93, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 94, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 95, 27, 27, 5)
		NpcSpawnHandlerNpc.handleSpawn(npc, 96, 27, 27, 5)

		---------------------------
		-- Buya Scorp Cave
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			410,
			getMapXMax(410),
			getMapYMax(410),
			3
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			411,
			getMapXMax(411),
			getMapYMax(411),
			3
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			412,
			getMapXMax(412),
			getMapYMax(412),
			3
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			413,
			getMapXMax(413),
			getMapYMax(413),
			4
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			414,
			getMapXMax(414),
			getMapYMax(414),
			4
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			415,
			getMapXMax(415),
			getMapYMax(415),
			4
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			416,
			getMapXMax(416),
			getMapYMax(416),
			5
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			417,
			getMapXMax(417),
			getMapYMax(417),
			5
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			418,
			getMapXMax(418),
			getMapYMax(418),
			5
		)
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			419,
			getMapXMax(419),
			getMapYMax(419),
			6
		)

		---------------------------
		-- Arctic Northern Ogres --
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			135,
			getMapXMax(135),
			getMapYMax(135),
			15
		)

		-- ice canyon
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			136,
			getMapXMax(136),
			getMapYMax(136),
			3
		)

		-- sacred grove
		NpcSpawnHandlerNpc.handleSpawn(
			npc,
			140,
			getMapXMax(140),
			getMapYMax(140),
			10
		)

		-- crystaline isle
	end,

	handleSpawn = function(npc, map, maxX, maxY, maxTraps)
		local totalTraps = 0
		for x = 1, maxX do
			for y = 1, maxY do
				local trapBlocks = npc:getObjectsInCellWithTraps(
					map,
					x,
					y,
					BL_NPC
				)
				if (#trapBlocks > 0) then
					totalTraps = totalTraps + 1
				end
			end
		end

		if (totalTraps < maxTraps) then
			repeat

				local mobCount = npc:getObjectsInMap(map, BL_MOB)

				if #mobCount > 0 then
					if #mobCount > maxTraps then
						totalTraps = maxTraps
						return
					end
				end

				local spawnX = math.random(1, maxX)
				local spawnY = math.random(1, maxY)
				local passCheck = getPass(map, spawnX, spawnY)

				local pcCheck = npc:getObjectsInCell(map, spawnX, spawnY, BL_PC)
				local mobCheck = npc:getObjectsInCell(
					map,
					spawnX,
					spawnY,
					BL_MOB
				)

				local objCheck = getObject(map, spawnX, spawnY)

				if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and not getWarp(
					map,
					spawnX,
					spawnY
				)) then
					if map == 140 then
						broadcast(3333, "spawn 140")
					end
					npc:addNPC("MobSpawnNpc", map, spawnX, spawnY, 2)
					totalTraps = totalTraps + 1
				end
			until totalTraps >= maxTraps
		end
	end
}
