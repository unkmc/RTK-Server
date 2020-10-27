dagger_assassin = {
	on_spawn = function(mob)
		mob.side = 2
		mob:sendSide()
	end,

	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		if target == nil then
			mob.registry["no_target_times"] = mob.registry["no_target_times"] + 1
		elseif target ~= nil then
			--target:talk(0,""..distance(mob,target))
			if distance(mob, target) >= 3 then
				mob.registry["no_target_times"] = mob.registry[
					"no_target_times"
				] + 1
			end
		end

		if mob.registry["no_target_times"] >= 5 then
			mob.attacker = mob.mobID
			mob:removeHealthExtend(mob.maxHealth, 0, 0, 0, 0, 0)
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
