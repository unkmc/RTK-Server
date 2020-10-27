function Mob.vanish(mob)
	local pc = mob:getObjectsInArea(BL_PC)

	mob.look = 433
	for i = 1, #pc do
		pc[i]:updateState()
	end
	mob:delete()
end

function Mob.vanish2(mob)
	local pc = mob:getObjectsInArea(BL_PC)

	mob.look = 433
	for i = 1, #pc do
		pc[i]:updateState()
	end
	mob:removeHealthWithoutDamageNumbers(mob.maxHealth)
end

function Mob.canPK(player, target)
	return true
end
