man_shik = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
	end,

	attack = function(mob, target)
		local moved

		if (mob.target == 0) then
			mob.state = MOB_ALIVE
			return
		end

		if (mob.paralyzed or mob.sleep ~= 1) then
			return
		end

		if (target) then
			threat.calcHighestThreat(mob)
			local block = mob:getBlock(mob.target)
			if (block ~= nil) then
				target = block
			end

			local upBlock = mob:getObjectsInCell(mob.m, mob.x, mob.y - 1, BL_PC)

			if upBlock ~= nil then
				mob:attack(upBlock[1].ID)
			end
		else
			mob.state = MOB_ALIVE
		end
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
