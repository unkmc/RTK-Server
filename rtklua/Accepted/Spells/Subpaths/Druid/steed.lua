steed = {
	cast = function(player)
		local magicCost = 2000
		local aethers = 110000

		if player.gmLevel > 0 then
			aethers = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 25)
		player:setAether("steed", aethers)

		local spawnM = player.m
		local spawnX, spawnY = 0, 0

		if player.side == 0 then
			spawnX = player.x
			spawnY = player.y - 1
		elseif player.side == 1 then
			spawnX = player.x + 1
			spawnY = player.y
		elseif player.side == 2 then
			spawnX = player.x
			spawnY = player.y + 1
		elseif player.side == 3 then
			spawnX = player.x - 1
			spawnY = player.y
		end

		local objCheck = getObject(spawnM, spawnX, spawnY)
		local passCheck = getPass(spawnM, spawnX, spawnY)
		local blockCheck = player:getObjectsInCell(
			spawnM,
			spawnX,
			spawnY,
			BL_ALL
		)
		local warpCheck = getWarp(spawnM, spawnX, spawnY)

		if objCheck == 0 and passCheck == 0 and #blockCheck == 0 and not warpCheck and spawnX >= 0 and spawnX < getMapXMax(spawnM) and spawnY >= 0 and spawnY < getMapYMax(spawnM) then
			player:spawn("arawns_stag", spawnX, spawnY, 1)
		else
			player:spawn("arawns_stag", player.x, player.y, 1, player.m)
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {}
		local itemAmounts = {}
		local desc = "This spell."
		return level, items, itemAmounts, desc
	end
}
