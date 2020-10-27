nine_tailed_fox = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		if (mob.health > mob.baseHealth *.15) then
			mob_ai_basic.move(mob, target)
		else
			local rand = math.random(0, 3)
			mob.side = rand
			mob:move()
			mob:move()
			mob:move()
		end
	end,

	attack = function(mob, target)
		if (mob.health > mob.baseHealth *.15) then
			mob_ai_basic.attack(mob, target)
		else
			local rand = math.random(0, 3)
			mob.side = rand
			mob:move()
			mob:move()
			mob:move()
		end
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
