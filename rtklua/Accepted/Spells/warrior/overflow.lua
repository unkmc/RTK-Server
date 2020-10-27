Overflow = {
	Cast = function(player, baseDamage, sourceX, sourceY, spellAnimation)
		if (baseDamage < 1) then
			return
		end
		
		local map = player.m
		local totalDamage = math.ceil(baseDamage * 1.05)
		local adjacentPositions = {
			{x = 0, y = 0},
			{x = 0, y = 1},
			{x = 0, y = -1},
			{x = 1, y = 0},
			{x = -1, y = 0}
		}
		local targets = {}

		for i = 1, #adjacentPositions do
			local x = sourceX + adjacentPositions[i].x
			local y = sourceY + adjacentPositions[i].y
			local mobs = player:getAliveObjectsInCell(map, x, y, BL_MOB)

			if (#mobs > 0) then
				table.insert(targets, {mob = mobs[1], x = x, y = y})
			end
		end

		for i = 1, #targets do
			local mob = targets[i].mob
			local x = targets[i].x
			local y = targets[i].y
			local damage = math.ceil(totalDamage / #targets)

			local netDamage = mob:calculateNetDamage(damage, 1, 1, 1, 1, 0, 1)
			local recursiveOverflow = netDamage - mob.health

			global_attack.cast(player, mob, damage, 0, spellAnimation)

			if (recursiveOverflow > 0) then
				Overflow.Cast(player, recursiveOverflow, x, y, spellAnimation)
			end
		end
	end
}
