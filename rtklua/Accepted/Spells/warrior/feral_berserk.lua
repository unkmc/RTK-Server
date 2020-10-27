feral_berserk_warrior = {
	on_learn = function(player)
		for i = 1, #berserks do
			if (player:hasSpell(berserks[i])) then
				player:removeSpell(berserks[i])
			end
		end
	end,

	cast = function(player)
		local spellName = "Feral Berserk"
		local spellId = "feral_berserk_warrior"
		local spellFX = 200 -- Determines spell animation and sound effect
		local manaCost = 60
		local map = player.m
		local x = 0
		local y = 0
		local side = player.side
		local currentMana = player.magic

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (currentMana < manaCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local damage = math.ceil(player.health * 0.85)

		if (player:hasDuration("chin_baek_ho_ryung")) then
			damage = math.ceil(damage * 1.5)
		end

		player.magic = currentMana - manaCost

		player:setAether(spellId, 16000)
		player:sendAction(1, 30)
		player:talk(2, "K'YA~!")
		local landed = 0

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

		local targetX = player.x + x
		local targetY = player.y + y
		local target = player:getAliveObjectsInCell(
			map,
			targetX,
			targetY,
			BL_MOB
		)
		if (#target > 0) then
			local netDamage = target[1]:calculateNetDamage(damage, 1, 1, 1, 1, 0, 1)
			local overflowDamage = netDamage - target[1].health

			global_attack.cast(
				player,
				target[1],
				damage,
				0,
				spellFX
			)

			landed = 1

			if (overflowDamage > 0) then
				Overflow.Cast(
					player,
					overflowDamage,
					targetX,
					targetY,
					spellFX[alignmentIndex]
				)
			end
		end

		target = player:getAliveObjectsInCell(map, targetX, targetY, BL_PC)

		if (#target > 0) then
			local worked = global_attack.cast(
				player,
				target[1],
				damage,
				0,
				spellFX
			)

			if (worked == 2) then
				target[1]:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				landed = 1
			end
		end
		if (landed == 1) then
			player.health = math.ceil(player.health * 0.3333)
		end

		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
	end,

	requirements = function(player)
		local level = 40
		local items = {"iron_sword", "maxcaliber", "amber", 0}
		local itemAmounts = {1, 1, 20, 5000}
		local description = "Focus your rage into an attack that deals critical damage to an enemy."
		return level, items, itemAmounts, description
	end
}
