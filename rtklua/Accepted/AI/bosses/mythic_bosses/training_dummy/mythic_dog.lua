-- MYTHIC DOG BOSS --

-- MYTHIC DOG ( mythic_dog )
-- DOG ASSASSIN ( dog_assassin )
-- DIVINE DOG ( divine_dog )
-- DOG CUTTHROAT ( dog_cutthroat )
-- SPIRIT DOG ( spirit_dog )
-- DOG AVENGER ( dog_avenger )

-- [ DOG 1 KEY BOSS ] --
dummy_mythic_dog = {
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

-- [ DOG 1 ITEM BOSS ] --
dummy_dog_assassin = {
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

-- [ DOG 2 KEY BOSS ] --
dummy_divine_dog = {
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

-- [ DOG 2 ITEM BOSS ] --
dummy_dog_cutthroat = {
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

-- [ DOG 3 KEY BOSS ] --
dummy_spirit_dog = {
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

-- [ DOG 3 ITEM BOSS ] --
dummy_dog_avenger = {
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
