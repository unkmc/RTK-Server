-- MYTHIC SNAKE BOSS --

-- MYTHIC SNAKE ( mythic_snake )
-- SNAKE SHAMAN ( snake_shaman )
-- DIVINE SNAKE ( divine_snake )
-- SNAKE MAGE ( snake_mage )
-- SPIRIT SNAKE ( spirit_snake )
-- SNAKE AVENGER ( snake_avenger )

-- [ SNAKE 1 KEY BOSS ] --
mythic_snake = {
	on_spawn = function(mob)
		mob:warp(236, 10, 18)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ SNAKE 1 ITEM BOSS ] --
snake_shaman = {
	on_spawn = function(mob)
		mob:warp(237, 10, 9)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ SNAKE 2 KEY BOSS ] --
divine_snake = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3236, 10, 18)
		elseif (rand == 2) then
			mob:warp(3239, 4, 18)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ SNAKE 2 ITEM BOSS ] --
snake_mage = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3237, 10, 9)
		elseif (rand == 2) then
			mob:warp(3232, 3, 12)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ SNAKE 3 KEY BOSS ] --
spirit_snake = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4236, 10, 18)
		elseif (rand == 2) then
			mob:warp(4239, 4, 10)
		elseif (rand == 3) then
			mob:warp(4238, 5, 16)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}

-- [ SNAKE 3 ITEM BOSS ] --
snake_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4237, 10, 9)
		elseif (rand == 2) then
			mob:warp(4233, 12, 14)
		elseif (rand == 3) then
			mob:warp(4232, 16, 19)
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
		mob_ai_mythic.attack(mob, target, 1)
	end,
	after_death = function(mob)
		mob_ai_mythic.after_death(mob)
	end
}
