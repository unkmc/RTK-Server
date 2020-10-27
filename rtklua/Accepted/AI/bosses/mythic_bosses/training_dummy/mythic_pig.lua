-- MYTHIC PIG BOSS --

-- MYTHIC BOAR ( mythic_boar )
-- BOAR CHAMPION ( boar_champion )
-- DIVINE PIG ( divine_pig )
-- PIG CHAMPION ( pig_champion )
-- SPIRIT PIG ( spirit_pig )
-- PIG AVENGER ( pig_avenger )

-- [ PIG 1 KEY BOSS ] --
dummy_mythic_boar = {
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
dummy_boar_champion = {
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
dummy_divine_pig = {
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
dummy_pig_champion = {
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
dummy_spirit_pig = {
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
dummy_pig_avenger = {
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
