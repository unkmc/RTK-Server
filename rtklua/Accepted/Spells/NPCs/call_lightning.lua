call_lightning = {
	cast = function(mob, target)
		target:sendAnimation(4)
		target:playSound(8)
		target.attacker = mob.ID

		if target.blType == BL_PC then
			target:sendMinitext(mob.name .. " attacks you with Call Lightning spell.")
		end

		target:removeHealthExtend(693, 1, 1, 1, 1, 0)
	end
}
