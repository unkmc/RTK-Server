druid_instance_sonhi_stickman = {
	on_spawn = function(mob)
	end,

	on_healed = function(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob.attacker = attacker.ID
		mob:removeHealth(math.random(2500, 5000))
	end,

	move = function(mob, target)
		local rand = math.random(1, 500)
		local strings = {
			"Haha pathetic townies. This is our kingdom now!",
			"Kaming will not be stopped!",
			"All your riches will be ours!"
		}
		if rand == 1 then
			rand = math.random(1, #strings)
			mob:talk(0, "Sonhi Stickman: " .. strings[rand])
		end
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
		target.attacker = mob.ID
		target:removeHealthExtend(target.maxHealth *.05, 1, 1, 1, 1, 0)
		target:sendStatus()
	end,

	after_death = function(mob, block)
		local rand = math.random(1, 10)
		if rand == 1 then
			mob:talk(0, "Sonhi Stickman: You will not stop us!")
		end
	end
}
