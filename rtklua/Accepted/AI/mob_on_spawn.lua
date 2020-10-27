on_spawn = function(mob)
	local random = math.random(0, 1)
	local multiplier = 1

	if random == 1 then
		multiplier = -1
	end

	local healthMod = math.random((mob.minDam + mob.maxDam) * 2) * multiplier

	mob.maxHealth = mob.maxHealth + healthMod
	mob.health = mob.maxHealth

	--mob:talk(0,""..mob.maxHealth)
end
