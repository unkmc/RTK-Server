underground_casino_quest = {
	quest = function(maps, owner)
		local player = Player(owner)
		local guitext = ""

		if player.m == maps[1] then
			if player.quest["underground_casino_quest"] == 0 then
				player.quest["underground_casino_quest"] = 1

				player:spawn(728, 46, 71, 1)
				player:spawn(728, 34, 72, 1)
				player:spawn(728, 39, 59, 1)
				player:spawn(728, 30, 59, 1)
				player:spawn(728, 48, 59, 1)
				player:spawn(728, 39, 48, 1)
				player:spawn(728, 30, 48, 1)
				player:spawn(728, 48, 48, 1)
				player:spawn(728, 47, 37, 1)
				player:spawn(728, 30, 37, 1)
				player:spawn(728, 30, 24, 1)
				player:spawn(728, 38, 24, 1)
				player:spawn(728, 47, 24, 1)
				player:spawn(728, 18, 57, 1)
				player:spawn(728, 57, 56, 1)

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
					) and getTile(player.m, spawnX, spawnY) == 25689) then
						player:spawn(727, spawnX, spawnY, 1)
					end
				end

				for z = 1, 2500 do
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
					) and getTile(player.m, spawnX, spawnY) == 25689) then
						player:spawn(725, spawnX, spawnY, 1)
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
					) and getTile(player.m, spawnX, spawnY) == 25689) then
						player:spawn(726, spawnX, spawnY, 1)
						break
					end
				end

				setMapAttribute(maps[1], "indoor", 1)
				clone.wipe(player)
				clone.equip(player, player)
				if player.sex == 0 then
					player.gfxArmor = 10090
				else
					player.gfxArmor = 10091
				end
				player.gfxArmorC = 0
				player.gfxClone = 1
				player:refresh()
				player:updateState()
			end
		end
	end,
}
