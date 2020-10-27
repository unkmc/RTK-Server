gimyi = {
	on_spawn = function(mob)
		mob:warp(1308, 2, 5)
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		if (distance(mob, target) == 1) then
			ambush.cast(mob, target)
		end
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
