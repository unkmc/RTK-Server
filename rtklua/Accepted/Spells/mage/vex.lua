vex_mage = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) or target.blType == BL_NPC then
			player:sendMinitext("You cannot attack that target.")
			return
		end

		if target:checkIfCast(curses) then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:sendMinitext("You cast Vex.")
		target:setDuration("vex_mage", duration)
		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 30
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Vex on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,
	recast = function(target)
		target.armor = target.armor + 30
		target.cursed = 1
		target:SendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 30
		target.cursed = 0
		target:SendStatus()
	end,

	requirements = function(player)
		local level = 44
		local items = {Item("acorn").id, Item("lucky_coin").id, 0}
		local itemAmounts = {70, 1, 250}
		local description = "Gives +30AC to target."
		return level, items, itemAmounts, description
	end
}

deaths_face_mage = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) or target.blType == BL_NPC then
			player:sendMinitext("You cannot attack that target.")
			return
		end

		if target:checkIfCast(curses) then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:sendMinitext("You cast Death's Face.")
		target:setDuration("deaths_face_mage", duration)
		target:sendAnimation(53, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 30
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Death's Face on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,
	recast = function(target)
		target.armor = target.armor + 30
		target.cursed = 1
		target:SendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 30
		target.cursed = 0
		target:SendStatus()
	end,

	requirements = function(player)
		local level = 44
		local items = {Item("acorn").id, Item("lucky_coin").id, 0}
		local itemAmounts = {70, 1, 250}
		local description = "Gives +30AC to target."
		return level, items, itemAmounts, description
	end
}

unnatural_selection_mage = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) or target.blType == BL_NPC then
			player:sendMinitext("You cannot attack that target.")
			return
		end

		if target:checkIfCast(curses) then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(44)
		player:sendMinitext("You cast Unnatural Selection.")
		target:setDuration("unnatural_selection_mage", duration)
		target:sendAnimation(101, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 30
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Unnatural Selection on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,
	recast = function(target)
		target.armor = target.armor + 30
		target.cursed = 1
		target:SendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 30
		target.cursed = 0
		target:SendStatus()
	end,

	requirements = function(player)
		local level = 44
		local items = {Item("acorn").id, Item("lucky_coin").id, 0}
		local itemAmounts = {70, 1, 250}
		local description = "Gives +30AC to target."
		return level, items, itemAmounts, description
	end
}

flaw_mage = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) or target.blType == BL_NPC then
			player:sendMinitext("You cannot attack that target.")
			return
		end

		if target:checkIfCast(curses) then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(26)
		player:sendMinitext("You cast Flaw.")
		target:setDuration("flaw_mage", duration)
		target:sendAnimation(79, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 30
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Flaw on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,
	recast = function(target)
		target.armor = target.armor + 30
		target.cursed = 1
		target:SendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 30
		target.cursed = 0
		target:SendStatus()
	end,

	requirements = function(player)
		local level = 44
		local items = {Item("acorn").id, Item("lucky_coin").id, 0}
		local itemAmounts = {70, 1, 250}
		local description = "Gives +30AC to target."
		return level, items, itemAmounts, description
	end
}
