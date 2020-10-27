berserk_warrior = {
	on_learn = function(player)
		for i = 1, #berserks do
			if (player:hasSpell(berserks[i])) then
				player:removeSpell(berserks[i])
			end
		end
	end,

	cast = function(player)
		local spellNames = {
			"Berserk",
			"No Fear",
			"Tiger's Pounce",
			"Wind's Blast"
		}

		local spellIds = {
			"berserk_warrior",
			"no_fear_warrior",
			"tigers_pounce_warrior",
			"winds_blast_warrior"
		}

		local spellFX = 119 -- Determines spell animation and sound effect
		local aethers = 12000
		local magicCost = 60
		local map = player.m
		local x = 0
		local y = 0
		local side = player.side
		local currentMagic = player.magic
		local alignmentIndex = player.alignment + 1
		local damage = math.ceil(player.health * 0.75)

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
		player:setAether(spellIds[alignmentIndex], aethers)
		player:sendAction(1, 30)
		player:talk(2, "K'YA~!")

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
			player.health = math.ceil(player.health / 3)
		end

		player:sendStatus()
		player:sendMinitext("You cast " .. spellNames[alignmentIndex] .. ".")
	end,

	requirements = function(player)
		local level = 40
		local items = {"iron_sword", "maxcaliber", "amber", 0}
		local itemAmounts = {1, 1, 20, 5000}
		local description = "Focus your rage into an attack that deals critical damage to an enemy."
		return level, items, itemAmounts, description
	end
}

no_fear_warrior = {
	on_learn = function(player)
		berserk_warrior.on_learn(player)
	end,

	cast = function(player)
		berserk_warrior.cast(player)
	end,

	requirements = function(player)
		return berserk_warrior.requirements(player)
	end
}

tigers_pounce_warrior = {
	on_learn = function(player)
		berserk_warrior.on_learn(player)
	end,

	cast = function(player)
		berserk_warrior.cast(player)
	end,

	requirements = function(player)
		return berserk_warrior.requirements(player)
	end
}

winds_blast_warrior = {
	on_learn = function(player)
		berserk_warrior.on_learn(player)
	end,

	cast = function(player)
		berserk_warrior.cast(player)
	end,

	requirements = function(player)
		return berserk_warrior.requirements(player)
	end
}
