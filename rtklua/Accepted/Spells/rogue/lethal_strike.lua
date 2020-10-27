lethal_strike_rogue = {
	cast = function(player)
		local spellNames = {
			"Lethal Strike",
			"Afterlife's Embrace",
			"Ming-Ken's Judgement",
			"Calculating Blow"
		}

		local spellIds = {
			"lethal_strike_rogue",
			"afterlifes_embrace_rogue",
			"mingkens_judgement_rogue",
			"calculating_blow_rogue"
		}

		local spellFX = 201 -- Determines spell animation and sound effect
		local aethers = 23000
		local magicCost = 120
		local map = player.m
		local x = 0
		local y = 0
		local side = player.side
		local currentHealth = player.health
		local currentMagic = player.magic
		local alignmentIndex = player.alignment + 1
		local damage = math.ceil(currentHealth / 2) + math.ceil(currentMagic * 2.5)

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (currentMagic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = currentMagic - magicCost
		player:sendAction(1, 30)
		player:setAether(spellIds[alignmentIndex], aethers)
		player:talk(2, "Ka~~!")
		
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

		local backflowAmount = 0
		local landed = 0
		local targetX = player.x + x
		local targetY = player.y + y
		local targets = player:getAliveObjectsInCell(map, targetX, targetY, BL_MOB)

		if (#targets > 0) then
			local netDamage = targets[1]:calculateNetDamage(damage, 1, 1, 1, 1, 0, 1)
			backflowAmount = netDamage - targets[1].health

			global_attack.cast(
				player,
				targets[1],
				damage,
				0,
				spellFX
			)

			landed = 1
		end

		targets = player:getAliveObjectsInCell(map, targetX, targetY, BL_PC)

		if (#targets > 0) then
			--local netDamage = targets[1]:calculateNetDamage(damage, 1, 1, 1, 1, 0, 1)
			--backflowAmount = netDamage - targets[1].health

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
			player.health = math.ceil(player.health / 2)
			Backflow.Cast(player, backflowAmount, currentHealth, currentMagic)
		end

		player:sendStatus()
		player:sendMinitext("You cast " .. spellNames[alignmentIndex] .. ".")
	end,

	requirements = function(player)
		local level = 63
		local items = {"deaths_head", "titanium_glove", "whisper_bracelet", 0}
		local itemAmounts = {1, 1, 1, 5000}
		local description = "An attack that deals massive critical damage to an enemy."
		return level, items, itemAmounts, description
	end
}

afterlifes_embrace_rogue = {
	cast = function(player)
		lethal_strike_rogue.cast(player)
	end,

	requirements = function(player)
		return lethal_strike_rogue.requirements(player)
	end
}

mingkens_judgement_rogue = {
	cast = function(player)
		lethal_strike_rogue.cast(player)
	end,

	requirements = function(player)
		return lethal_strike_rogue.requirements(player)
	end
}

calculating_blow_rogue = {
	cast = function(player)
		lethal_strike_rogue.cast(player)
	end,

	requirements = function(player)
		return lethal_strike_rogue.requirements(player)
	end
}
