yin_mouse = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		if mob:checkIfCast(curses) then
			attacker.quest["zapped_" .. mob.yname] = 1
			mob:talk(0, mob.name .. ": Squeek!")
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		local chance = math.random(1, 10)

		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

yang_mouse = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		if mob:checkIfCast(curses) then
			attacker.quest["zapped_" .. mob.yname] = 1
			mob:talk(0, mob.name .. ": Squeek!")
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		local chance = math.random(1, 10)

		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

void_mouse = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		if mob:checkIfCast(curses) then
			attacker.quest["zapped_" .. mob.yname] = 1
			mob:talk(0, mob.name .. ": Squeek!")
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		local chance = math.random(1, 10)

		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
