mob_ai_mythic = {
	on_attacked = function(mob, attacker, level)
		local healAmount = 15000

		if (level == 0) then
			healAmount = 500
		elseif (level == 1) then
			healAmount = 5000
		end

		local paraHeal = math.random(1, 2)
		if (mob.paralyzed == true and paraHeal == 1) then
			mob:sendAnimation(5)
			mob:playSound(708)
			mob.attacker = mob.ID
			mob:addHealthExtend(healAmount, 0, 0, 0, 0, 0)
		end

		if healAmount == 5000 then
			paraHeal = math.random(1, 3)
		end
		if healAmount == 15000 then
			paraHeal = math.random(1, 4)
		end

		if (attacker.damage >= mob.health) then
			if mob.magic == 100 then
				last_stand.cast(mob, level)
			elseif attacker.damage >= mob.health + healAmount then
				mob_ai_basic.on_attacked(mob, attacker)
				return
			end

			if paraHeal == 1 then
				mob_ai_basic.on_attacked(mob, attacker)
				return
			end

			mob:sendAnimation(5)
			mob:playSound(708)
			mob.attacker = mob.ID
			mob:addHealthExtend(healAmount, 0, 0, 0, 0, 0)
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target, level)
		local healAmount = 15000

		if (level == 0) then
			healAmount = 500
		elseif (level == 1) then
			healAmount = 5000
		end

		if target ~= nil then
			if mob.m ~= target.m then
				mob.target = 0
			end
		end

		if (os.time() % 15 == 0 and distanceSquare(mob, target, 5) and mob.paralyzed == false) then
			local pick_spell = math.random(1, 10)
			if (pick_spell == 1) then
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					if (level == 0) then
						vex.cast(mob, target)
					else
						scourge.cast(mob, target)
					end
				end
			elseif (pick_spell == 2) then
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					venom.cast(mob, target)
				end
			elseif (pick_spell == 3) then
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					blind.cast(mob, target)
				end
			else
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					if (level == 0) then
						ion.cast(mob, target)
					elseif (level == 1) then
						call_lightning.cast(mob, target)
					else
						thunder_touch.cast(mob, target)
					end
				end
			end
		end
		if (os.time() % 3 == 0 and mob.paralyzed == true) then
			local paraHeal = math.random(1, 2)
			if (paraHeal == 1) then
				mob:sendAnimation(5)
				mob:playSound(708)
				mob.attacker = mob.ID
				mob:addHealthExtend(healAmount, 0, 0, 0, 0, 0)
			end
		end
		if (os.time() % 10 == 0 and mob.paralyzed == false) then
			local curseChance = math.random(1, 3)
			if (curseChance == 1) then
				for i = 1, #curses do
					if (mob:hasDuration(curses[i])) then
						mob:setDuration(curses[i], 0)
						curseChance = 69
					end
				end

				if (curseChance == 69) then
					mob:sendAnimation(10)
				end
			end
		end
		if (mob:hasDuration("last_stand")) then
			mob:sendAnimation(5)
			mob:playSound(708)
			mob.attacker = mob.ID
			mob:addHealthExtend(healAmount, 0, 0, 0, 0, 0)
		end
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target, switch)
		if target ~= nil then
			if mob.m ~= target.m then
				mob.target = 0
			end
		end

		if (os.time() % 15 == 0 and distanceSquare(mob, target, 3)) then
			local pick_spell = math.random(1, 5)
			if (pick_spell == 1) then
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					if (switch == 1) then
						scourge.cast(mob, target)
					elseif (switch == 2) then
						vex.cast(mob, target)
					else
						venom.cast(mob, target)
					end
				end
			else
				if (mob.target > 0) then
					mob:talk(0, mob.name .. ": ** summons power **")
					if (switch == 1) then
						venom.cast(mob, target)
					elseif (switch == 2) then
						vex.cast(mob, target)
					else
						scourge.cast(mob, target)
					end
				end
			end
		end
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob.paralyzed = false
		mob.sleep = 1
		mob.state = 1
	end
}
