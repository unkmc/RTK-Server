strange_thing = {
	on_spawn = function(mob)
		local mobCount = 0
		local mobsSouthernKoguryo = mob:getObjectsInMap(1009, BL_MOB)
		local mobsNagnang = mob:getObjectsInMap(2500, BL_MOB)

		if (mobsSouthernKoguryo ~= nil) then
			for i = 1, #mobsSouthernKoguryo do
				if mobsSouthernKoguryo[i].yname == "strange_thing" then
					mobCount = mobCount + 1
				end
			end
		end

		if (mobsNagnang ~= nil) then
			for i = 1, #mobsNagnang do
				if mobsNagnang[i].yname == "strange_thing" then
					mobCount = mobCount + 1
				end
			end
		end

		if mobCount > 1 then
			mob:vanish()
		end
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
