ice_beast = {
	on_spawn = function(mob)
		mob:talk(0, "Ice Beast: Ho, ho! It is good to be back!")
	end,

	move = function(mob, target)
		if target ~= nil then
			if distanceSquare(mob, target, 3) then
				if math.random(1, 20) == 10 then
					mob:talk(0, "Ice Beast: I'm coming to eat you!")
				end
			else
				mob.target = 0
				mob.returning = true
				if math.random(1, 20) == 15 then
					mob:talk(0, "Ice Beast: Where did it go?")
					return
				end
			end
		end

		mob_ai_basic.move(mob, target)

		if ((mob.x == 29 or mob.x == 30) and (mob.y >= 14 and mob.y <= 16)) then
			-- on thee lava tiles
			mob:talk(2, "I'm melting!")
			mob.attacker = mob.ID
			mob:removeHealthExtend(mob.maxHealth, 1, 1, 1, 1, 0)
			mob:sendAnimation(4, 5)
		end
	end,
	after_death = function(mob)
		mob.attacker = mob.target
		mob:dropItem("ice_heart", 1)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end
}
