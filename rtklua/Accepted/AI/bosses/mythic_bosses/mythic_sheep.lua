divine_sheep = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3476, 10, 19)
		end
		if (rand == 2) then
			mob:warp(3472, 11, 8)
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

mythic_sheep = {
	on_spawn = function(mob)
		local rand = math.random(1, 1)
		if (rand == 1) then
			mob:warp(476, 10, 19)
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

sheep_avenger = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4472, 10, 8)
		end
		if (rand == 2) then
			mob:warp(4478, 2, 12)
		end
		if (rand == 3) then
			mob:warp(4476, 3, 10)
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

sheep_shepherd = {
	on_spawn = function(mob)
		local rand = math.random(1, 2)
		if (rand == 1) then
			mob:warp(3481, 3, 7)
		end
		if (rand == 2) then
			mob:warp(3482, 13, 5)
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

sheep_veteran = {
	on_spawn = function(mob)
		local rand = math.random(1, 1)
		if (rand == 1) then
			mob:warp(481, 3, 7)
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

spirit_sheep = {
	on_spawn = function(mob)
		local rand = math.random(1, 3)
		if (rand == 1) then
			mob:warp(4481, 4, 8)
		end
		if (rand == 2) then
			mob:warp(4475, 9, 5)
		end
		if (rand == 3) then
			mob:warp(4477, 14, 9)
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
