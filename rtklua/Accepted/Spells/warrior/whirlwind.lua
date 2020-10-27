whirlwind_warrior = {
	cast = function(player)
		local spellNames = {
			"Whirlwind",
			"Death's Angel",
			"Nature's Own",
			"Bladedance"
		}

		local spellIds = {
			"whirlwind_warrior",
			"deaths_angel_warrior",
			"natures_own_warrior",
			"bladedance_warrior"
		}

		local spellFX = 125 -- Determines spell animation and sound effect
		local damageFactor = {1.75, 1.75, 1.525, 1.525}
		local aethers = {30000, 25000, 25000, 25000}
		local magicCost = 120
		local map = player.m
		local x = 0
		local y = 0
		local side = player.side
		local currentMagic = player.magic
		local alignmentIndex = player.alignment + 1
		local damage = math.ceil(player.health * damageFactor[alignmentIndex])

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (currentMagic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (player:hasDuration("chin_baek_ho_ryung")) then
			damage = math.ceil(damage * 1.5)
		end

		player.magic = currentMagic - magicCost
		player:setAether(spellIds[alignmentIndex], aethers[alignmentIndex])
		player:sendAction(1, 30)
		player:talk(2, "Sa-AAA~~!")

		if (side == 0) then
			y = -1
		elseif (side == 1) then
			x = 1
		elseif (side == 2) then
			y = 1
		elseif (side == 3) then
			x = -1
		else
			return
		end

		local landed = 0
		local targetX = player.x + x
		local targetY = player.y + y
		local targets = player:getAliveObjectsInCell(map, targetX, targetY, BL_MOB)

		if (#targets > 0) then
			local netDamage = targets[1]:calculateNetDamage(damage, 1, 1, 1, 1, 0, 1)
			local overflowDamage = netDamage - targets[1].health

			global_attack.cast(
				player,
				targets[1],
				damage,
				0,
				spellFX
			)

			landed = 1

			Overflow.Cast(
				player,
				overflowDamage,
				targetX,
				targetY,
				spellFX
			)
		end

		targets = player:getAliveObjectsInCell(map, targetX, targetY, BL_PC)

		if (#targets > 0) then
			local worked = global_attack.cast(
				player,
				targets[1],
				damage,
				0,
				spellFX
			)

			if (worked == 2) then
				targets[1]:sendMinitext(player.name .. " cast " .. spellNames[alignmentIndex] .. " on you.")
				landed = 1
			end
		end

		if (landed == 1) then
			if (alignmentIndex > 2) then
				-- Ming-Ken or Ohaeng
				player.health = math.ceil(player.health * 0.10)
			else
				-- Unaligned or Kwi-Sin
				player.health = 10
			end
		end

		player:sendStatus()
		player:sendMinitext("You cast " .. spellNames[alignmentIndex] .. ".")
	end,

	requirements = function(player)
		local level = 63
		local items = {"angels_tear", "dark_amber", "electra", 0}
		local itemAmounts = {1, 20, 1, 10000}
		local description = "Focus your rage into an attack that deals massive critical damage to an enemy."
		return level, items, itemAmounts, description
	end
}

deaths_angel_warrior = {
	cast = function(player)
		whirlwind_warrior.cast(player)
	end,

	requirements = function(player)
		return whirlwind_warrior.requirements(player)
	end
}

natures_own_warrior = {
	cast = function(player)
		whirlwind_warrior.cast(player)
	end,

	requirements = function(player)
		return whirlwind_warrior.requirements(player)
	end
}

bladedance_warrior = {
	cast = function(player)
		whirlwind_warrior.cast(player)
	end,

	requirements = function(player)
		return whirlwind_warrior.requirements(player)
	end
}
