training_dummy = {
	on_healed = function(mob, healer)
		mob.health = mob.maxHealth
	end,

	on_attacked = function(mob, attacker)
		mob.attacker = attacker.ID
		local damage = math.floor(attacker.damage)
		attacker:talkSelf(0, mob.name .. " took damage: " .. damage)
		mob:sendHealth(attacker.damage, attacker.critChance)
		attacker.damage = 0
	end
}
