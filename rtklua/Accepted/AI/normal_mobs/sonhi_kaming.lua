sonhi_stickman = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		says = {
			"Hi there, townie.",
			"Why is our leader acting so strange?",
			"Can we trust the Zibong?",
			"Why do the Zibong listen to our leader?",
			"*whistles a little tune*",
			"Time for a little nap."
		}

		if math.random(1, 300) == 1 then
			mob:talk(0, mob.name .. ": " .. says[math.random(1, #says)])
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
