ambush = {
	cast = function(mob, target)
		if target.blType == BL_PC then
			if (target ~= nil and canAmbush(mob, target)) then
				mob:talk(2, "Ambush~~~!")
				mob:attack(target.ID)
			end
		end
	end
}
