grim_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

southern_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

muck_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

slime_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

log_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

hill_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

marsh_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

zangze_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}

zinte_ogre = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		local chance = math.random(1, 100)

		if chance == 1 then
			--mob:talk(0,mob.name..": Grroar!")
			mob:talk(2, "~Grroar!~")
		elseif chance == 2 then
			--mob:talk(0,mob.name..": Smash!")
			mob:talk(2, "~Smash!~")
		elseif chance == 3 then
			--mob:talk(0,mob.name..": Crunch!")
			mob:talk(2, "~Crunch!~")
		elseif chance == 4 then
			--mob:talk(0,mob.name..": Grunt!")
			mob:talk(2, "~Grunt!~")
		end

		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
