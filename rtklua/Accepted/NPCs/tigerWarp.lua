TigerWarpNpc = {
	clearTrap = function(map)
		local blockCheck = core:getObjectsInMap(map, BL_ALL)
		if (#blockCheck > 0) then
			for z = 1, #blockCheck do
				removeTrapItem(blockCheck[z])
				blockCheck[z]:delete()
			end
		end
	end,

	spawnTrap = function(chosenMap, map)
		local spawnedAmount = 0
		local failCheck = 0
		repeat
			local x = math.random(2, getMapXMax(map) - 1)
			local y = math.random(2, getMapYMax(map) - 1)
			local passCheck = getPass(map, x, y)
			local blockCheck = core:getObjectsInCell(map, x, y, BL_ALL)
			if (passCheck == 0 and #blockCheck == 0 and not getWarp(map, x, y)) then
				for z = 1, 10 do
					core:addNPC("" .. chosenMap, map, x, y, 2)
					spawnedAmount = spawnedAmount + 1
				end
			end
			failCheck = failCheck + 1
		until spawnedAmount == 10 or failCheck > 1000
	end
}
