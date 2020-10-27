dishearten_poet = {
	cast = function(player, target)
		local duration = 18000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) or target.blType == BL_NPC then
			player:sendMinitext("You cannot attack that target.")
			return
		end

		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(5)
		player:sendMinitext("You cast Dishearten.")
		target:setDuration("dishearten_poet", duration)
		target:sendAnimation(1, 0)
		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " casts Dishearten on you.")
			target:calcStat()
		elseif target.blType == BL_MOB then
			target.armor = target.armor + 6
		end
	end,

	recast = function(block)
		block.armor = block.armor + 6
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 6
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Weaken a target's armor."
		return level, items, itemAmounts, description
	end
}

dark_fear_poet = {
	cast = function(player, target)
		local duration = 18000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:sendMinitext("You cast Dark Fear.")
		target:setDuration("dark_fear_poet", duration)
		target:sendAnimation(53, 0)
		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " casts Dark Fear on you.")
			target:calcStat()
		elseif target.blType == BL_MOB then
			target.armor = target.armor + 6
		end
	end,

	recast = function(block)
		block.armor = block.armor + 6
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 6
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Weaken a target's armor."
		return level, items, itemAmounts, description
	end
}

break_will_poet = {
	cast = function(player, target)
		local duration = 18000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(26)
		player:sendMinitext("You cast Break Will.")
		target:setDuration("break_will_poet", duration)
		target:sendAnimation(101, 0)
		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " casts Break Will on you.")
			target:calcStat()
		elseif target.blType == BL_MOB then
			target.armor = target.armor + 6
		end
	end,

	recast = function(block)
		block.armor = block.armor + 6
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 6
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Weaken a target's armor."
		return level, items, itemAmounts, description
	end
}

harshen_attack_poet = {
	cast = function(player, target)
		local duration = 18000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(26)
		player:sendMinitext("You cast Harshen Attack.")
		target:setDuration("harshen_attack_poet", duration)
		target:sendAnimation(79, 0)
		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " casts Harshen Attack on you.")
			target:calcStat()
		elseif target.blType == BL_MOB then
			target.armor = target.armor + 6
		end
	end,

	recast = function(block)
		block.armor = block.armor + 6
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 6
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Weaken a target's armor."
		return level, items, itemAmounts, description
	end
}
