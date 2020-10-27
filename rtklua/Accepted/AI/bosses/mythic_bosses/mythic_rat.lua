-- MYTHIC RAT BOSS --

-- MYTHIC RAT ( mythic_rat )
-- MIGHTY MOUSE ( mighty_mouse )
-- DIVINE RAT ( divine_rat )
-- RAT LORD ( rat_lord )
-- SPIRIT RAT ( spirit_rat )
-- RAT AVENGER ( rat_avenger )

-- [ RAT 1 KEY BOSS ] --
mythic_rat = {
	on_spawn = function(mob)
		mob:warp(157, 23, 15)
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

-- [ RAT 1 ITEM BOSS ] --
mighty_mouse = {
	on_spawn = function(mob)
		mob:warp(158, 23, 13)
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

-- [ RAT 2 KEY BOSS ] --
divine_rat = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3155, 10, 6)
		elseif (rand == 2) then
			mob:warp(3157, 23, 15)
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

-- [ RAT 2 ITEM BOSS ] --
rat_lord = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3158, 23, 13)
		elseif (rand == 2) then
			mob:warp(3159, 20, 12)
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

-- [ RAT 3 KEY BOSS ] --
spirit_rat = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4156, 20, 12)
		elseif (rand == 2) then
			mob:warp(4158, 23, 13)
		elseif (rand == 3) then
			mob:warp(4159, 20, 12)
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

-- [ RAT 3 ITEM BOSS ] --
rat_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4153, 13, 23)
		elseif (rand == 2) then
			mob:warp(4155, 10, 6)
		elseif (rand == 3) then
			mob:warp(4157, 23, 15)
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
