-- MYTHIC HORSE BOSS --

-- MYTHIC HORSE ( mythic_horse )
-- HORSE DO ( horse_do )
-- DIVINE HORSE ( divine_horse )
-- HORSE CHONGUN ( horse_chongun )
-- SPIRIT HORSE ( spirit_horse )
-- HORSE AVENGER ( horse_avenger )

-- [ HORSE 1 KEY BOSS ] --
mythic_horse = {
	on_spawn = function(mob)
		mob:warp(247, 26, 16)
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

-- [ HORSE 1 ITEM BOSS ] --
horse_do = {
	on_spawn = function(mob)
		mob:warp(248, 16, 12)
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

-- [ HORSE 2 KEY BOSS ] --
divine_horse = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3240, 21, 35)
		elseif (rand == 2) then
			mob:warp(3247, 26, 16)
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

-- [ HORSE 2 ITEM BOSS ] --
horse_chongun = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3242, 15, 21)
		elseif (rand == 2) then
			mob:warp(3248, 16, 12)
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

-- [ HORSE 3 KEY BOSS ] --
spirit_horse = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4240, 21, 35)
		elseif (rand == 2) then
			mob:warp(4243, 6, 24)
		elseif (rand == 3) then
			mob:warp(4248, 16, 12)
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

-- [ HORSE 3 ITEM BOSS ] --
horse_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4242, 15, 21)
		elseif (rand == 2) then
			mob:warp(4245, 15, 3)
		elseif (rand == 3) then
			mob:warp(4247, 26, 16)
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
