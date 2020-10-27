druid_instance_tree = {
	on_spawn = function(mob)
		mob.health = 1
		mob:updateState()
	end,

	on_healed = function(mob, healer)
		local fire = false
		for x = 193, 198 do
			local obj = mob:getObjectsInCell(mob.m, x, 115, BL_NPC)
			if #obj > 0 then
				fire = true
			end
		end
		if fire == false then
			if healer.level < 99 then
				mob.attacker = healer.ID
				mob:sendHealth(-5000, healer.critChance)
				healer.damage = 0
			else
				mob_ai_basic.on_healed(mob, healer)
			end
		end
	end,

	on_attacked = function(mob, attacker)
	end,

	move = function(mob, target)
	end,

	attack = function(mob, target)
	end,

	after_death = function(mob, block)
	end
}
