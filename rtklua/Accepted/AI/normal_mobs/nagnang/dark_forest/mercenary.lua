mercenary = {
	on_spawn = function(mob)
		setNagnangQuestMobDifficulty(mob)
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		says = {
			"TO ARMS!",
			"Get the Slime!",
			"I wish I hadn't fallen behind the rest...",
			"I wish I hadn't used all my compasses.",
			"Must find my way to my tribe...",
			"If I had just one more compass..."
		}

		if math.random(1, 15) == 1 then
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
