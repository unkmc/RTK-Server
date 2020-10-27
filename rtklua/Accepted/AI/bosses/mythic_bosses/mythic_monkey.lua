-- MYTHIC MONKEY BOSS --

-- MYTHIC MONKEY ( mythic_monkey )
-- MONKEY MAULER ( monkey_mauler )
-- DIVINE MONKEY ( divine_monkey )
-- MONKEY BASHER ( monkey_basher )
-- SPIRIT MONKEY ( spirit_monkey )
-- MONKEY AVENGER ( monkey_avenger )

-- [ MONKEY 1 KEY BOSS ] --
mythic_monkey = {
	on_spawn = function(mob)
		mob:warp(168, 18, 10)
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 0)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 0)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 2)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ MONKEY 1 ITEM BOSS ] --
monkey_mauler = {
	on_spawn = function(mob)
		mob:warp(167, 18, 22)
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 0)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 0)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 2)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ MONKEY 2 KEY BOSS ] --
divine_monkey = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3166, 21, 16)
		elseif (rand == 2) then
			mob:warp(3168, 18, 10)
		end
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 1)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 1)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 0)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ MONKEY 2 ITEM BOSS ] --
monkey_basher = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3162, 15, 15)
		elseif (rand == 2) then
			mob:warp(3167, 18, 22)
		end
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 1)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 1)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 0)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ MONKEY 3 KEY BOSS ] --
spirit_monkey = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4162, 15, 15)
		elseif (rand == 2) then
			mob:warp(4166, 21, 16)
		elseif (rand == 3) then
			mob:warp(4168, 18, 10)
		end
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 2)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 2)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 0)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ MONKEY 3 ITEM BOSS ] --
monkey_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4163, 6, 5)
		elseif (rand == 2) then
			mob:warp(4164, 24, 32)
		elseif (rand == 3) then
			mob:warp(4167, 18, 22)
		end
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 2)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 2)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 0)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}
