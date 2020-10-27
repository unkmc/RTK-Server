thunder_touch = {
	cast = function(mob, target)
		target:sendAnimation(4)
		target:playSound(8)
		target.attacker = mob.ID
		if target.blType == BL_PC then
			target:sendMinitext(mob.name .. " attacks you with Thunder touch spell.")
		end
		target:removeHealthExtend(6496, 1, 1, 1, 1, 0)
	end
}
