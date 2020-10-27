-- MYTHIC DRAGON BOSS --

-- MYTHIC DRAGON ( mythic_dragon )
-- DRAGON MAGE ( dragon_mage )
-- DIVINE DRAGON ( divine_dragon )
-- DRAGON SLAYER ( dragon_slayer )
-- SPIRIT DRAGON ( spirit_dragon )
-- DRAGON AVENGER ( dragon_avenger )

-- [ DRAGON 1 KEY BOSS ] --
mythic_dragon = {
	on_spawn = function(mob)
		mob:warp(258, 8, 29)
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

-- [ DRAGON 1 ITEM BOSS ] --
dragon_mage = {
	on_spawn = function(mob)
		mob:warp(250, 13, 5)
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

-- [ DRAGON 2 KEY BOSS ] --
divine_dragon = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3258, 9, 9)
		elseif (rand == 2) then
			mob:warp(3253, 13, 6)
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

-- [ DRAGON 2 ITEM BOSS ] --
dragon_slayer = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3250, 8, 9)
		elseif (rand == 2) then
			mob:warp(3256, 10, 6)
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

-- [ DRAGON 3 KEY BOSS ] --
spirit_dragon = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4254, 16, 5)
		elseif (rand == 2) then
			mob:warp(4258, 7, 13)
		elseif (rand == 3) then
			mob:warp(4253, 13, 6)
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

-- [ DRAGON 3 ITEM BOSS ] --
dragon_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4250, 4, 12)
		elseif (rand == 2) then
			mob:warp(4256, 9, 6)
		elseif (rand == 3) then
			mob:warp(4252, 7, 8)
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
