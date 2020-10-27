-- MYTHIC ROOSTER BOSS --

-- MYTHIC ROOSTER ( mythic_rooster )
-- ROOSTER SWORDSMAN ( rooster_swordsman )
-- DIVINE ROOSTER ( divine_rooster )
-- ROOSTER BARBARIAN ( rooster_barbarian )
-- SPIRIT ROOSTER ( spirit_rooster )
-- ROOSTER AVENGER ( rooster_avenger )

-- [ ROOSTER 1 KEY BOSS ] --
dummy_mythic_rooster = {
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

-- [ ROOSTER 1 ITEM BOSS ] --
dummy_rooster_swordsman = {
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

-- [ ROOSTER 2 KEY BOSS ] --
dummy_divine_rooster = {
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

-- [ ROOSTER 2 ITEM BOSS ] --
dummy_rooster_barbarian = {
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

-- [ ROOSTER 3 KEY BOSS ] --
dummy_spirit_rooster = {
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

-- [ ROOSTER 3 ITEM BOSS ] --
dummy_rooster_avenger = {
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
