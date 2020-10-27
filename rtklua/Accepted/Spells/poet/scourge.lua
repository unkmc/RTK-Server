scourge_poet = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 90

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

		if target:checkIfCast(curses) or target.cursed == 1 then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		if target:hasDuration("snare_trap") then
			target:setDuration("snare_trap", 0)
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:sendMinitext("You cast Scourge.")
		target:setDuration("scourge_poet", duration)
		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 50
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Scourge on you.")
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
		target.armor = target.armor + 50
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 50
		target.cursed = 0
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 55
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 2, 1000}
		local description = "Raises target +50 AC"
		return level, items, itemAmounts, description
	end
}

damage_will_poet = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 90

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

		if target:checkIfCast(curses) or target.cursed == 1 then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		if target:hasDuration("snare_trap") then
			target:setDuration("snare_trap", 0)
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(43)
		player:sendMinitext("You cast Damage Will.")
		target:setDuration("damage_will_poet", duration)
		target:sendAnimation(53, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 50
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Damage Will on you.")
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
		target.armor = target.armor + 50
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 50
		target.cursed = 0
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 55
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 2, 1000}
		local description = "Raises target +50 AC"
		return level, items, itemAmounts, description
	end
}

drop_guard_poet = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 90

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

		if target:checkIfCast(curses) or target.cursed == 1 then
			player:sendMinitext("Another spell of this type is in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		if target:hasDuration("snare_trap") then
			target:setDuration("snare_trap", 0)
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(44)
		player:sendMinitext("You cast Drop Guard.")
		target:setDuration("drop_guard_poet", duration)
		target:sendAnimation(101, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 50
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Drop Guard on you.")
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
		target.armor = target.armor + 50
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 50
		target.cursed = 0
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 55
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 2, 1000}
		local description = "Raises target +50 AC"
		return level, items, itemAmounts, description
	end
}

unalign_armor_poet = {
	cast = function(player, target)
		local duration = 425000
		local magicCost = 90

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

		if target:hasDuration("snare_trap") then
			target:setDuration("snare_trap", 0)
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(26)
		player:sendMinitext("You cast Unalign Armor.")
		target:setDuration("unalign_armor_poet", duration)
		target:sendAnimation(79, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 50
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Unalign Armor on you.")
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
		target.armor = target.armor + 50
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 50
		target.cursed = 0
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 55
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 2, 1000}
		local description = "Raises target +50 AC"
		return level, items, itemAmounts, description
	end
}
