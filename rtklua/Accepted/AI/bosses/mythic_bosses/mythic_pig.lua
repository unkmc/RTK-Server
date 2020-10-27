-- MYTHIC PIG BOSS --

-- MYTHIC BOAR ( mythic_boar )
-- BOAR CHAMPION ( boar_champion )
-- DIVINE PIG ( divine_pig )
-- PIG CHAMPION ( pig_champion )
-- SPIRIT PIG ( spirit_pig )
-- PIG AVENGER ( pig_avenger )

-- [ PIG 1 KEY BOSS ] --
mythic_boar = {
	on_spawn = function(mob)
		mob:warp(189, 7, 9)
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

-- [ PIG 1 ITEM BOSS ] --
boar_champion = {
	on_spawn = function(mob)
		mob:warp(188, 16, 4)
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

-- [ PIG 2 KEY BOSS ] --
divine_pig = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3189, 7, 9)
		elseif (rand == 2) then
			mob:warp(3187, 20, 23)
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

-- [ PIG 2 ITEM BOSS ] --
pig_champion = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3184, 5, 15)
		elseif (rand == 2) then
			mob:warp(3186, 12, 8)
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

-- [ PIG 3 KEY BOSS ] --
spirit_pig = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4187, 20, 23)
		elseif (rand == 2) then
			mob:warp(4189, 9, 3)
		elseif (rand == 3) then
			mob:warp(4190, 16, 8)
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

-- [ PIG 3 ITEM BOSS ] --
pig_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4184, 3, 15)
		elseif (rand == 2) then
			mob:warp(4186, 11, 6)
		elseif (rand == 3) then
			mob:warp(4188, 8, 18)
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
