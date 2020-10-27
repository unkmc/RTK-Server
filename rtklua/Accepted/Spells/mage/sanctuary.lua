sanctuary_mage = {
	cast = function(player, target)
		local duration = 300000
		local magicCost = 60

		if (player:canPK(target)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_MOB) then
			player:sendMinitext("You can't cast that now.")
			return
		end

		if target:checkIfCast(sanctuaries) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if (target.blType == BL_PC) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(5)
			player:sendMinitext("You cast Sanctuary.")
			target:setDuration("sanctuary_mage", duration)
			target:sendAnimation(11, 0)
			target:sendMinitext(player.name .. " casts Sanctuary on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
	end,
	recast = function(target)
		target.deduction = target.deduction -.5
		target:sendStatus()
	end,
	uncast = function(target)
		target.deduction = target.deduction +.5
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("ambrosia").id, Item("ancient_robes").id}
		local itemAmounts = {1, 1}
		local desc = "Reduces all damage taken by 1/2."
		return level, items, itemAmounts, desc
	end
}

protect_soul_mage = {
	cast = function(player, target)
		local duration = 300000
		local magicCost = 60

		if (player:canPK(target)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_MOB) then
			player:sendMinitext("You can't cast that now.")
			return
		end

		if target:checkIfCast(sanctuaries) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if (target.blType == BL_PC) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(106)
			player:sendMinitext("You cast Protect Soul.")
			target:setDuration("protect_soul_mage", duration)
			target:sendAnimation(61, 0)
			target:sendMinitext(player.name .. " casts Protect Soul on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
	end,
	recast = function(target)
		target.deduction = target.deduction -.5
		target:sendStatus()
	end,
	uncast = function(target)
		target.deduction = target.deduction +.5
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("ambrosia").id, Item("ancient_robes").id}
		local itemAmounts = {1, 1}
		local desc = "Reduces all damage taken by 1/2."
		return level, items, itemAmounts, desc
	end
}

guard_life_mage = {
	cast = function(player, target)
		local duration = 300000
		local magicCost = 60

		if (player:canPK(target)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_MOB) then
			player:sendMinitext("You can't cast that now.")
			return
		end

		if target:checkIfCast(sanctuaries) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if (target.blType == BL_PC) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(77)
			player:sendMinitext("You cast Guard Life.")
			target:setDuration("guard_life_mage", duration)
			target:sendAnimation(56, 0)
			target:sendMinitext(player.name .. " casts Guard Life on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
	end,
	recast = function(target)
		target.deduction = target.deduction -.5
		target:sendStatus()
	end,
	uncast = function(target)
		target.deduction = target.deduction +.5
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("ambrosia").id, Item("ancient_robes").id}
		local itemAmounts = {1, 1}
		local desc = "Reduces all damage taken by 1/2."
		return level, items, itemAmounts, desc
	end
}

magic_shield_mage = {
	cast = function(player, target)
		local duration = 300000
		local magicCost = 60

		if (player:canPK(target)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType == BL_MOB) then
			player:sendMinitext("You can't cast that now.")
			return
		end

		if target:checkIfCast(sanctuaries) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if (target.blType == BL_PC) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(70)
			player:sendMinitext("You cast Magic Shield.")
			target:setDuration("magic_shield_mage", duration)
			target:sendAnimation(59, 0)
			target:sendMinitext(player.name .. " casts Magic Shield on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
	end,
	recast = function(target)
		target.deduction = target.deduction -.5
		target:sendStatus()
	end,
	uncast = function(target)
		target.deduction = target.deduction +.5
		target:sendStatus()
	end,

	requirements = function(player)
		local level = 38
		local items = {Item("ambrosia").id, Item("ancient_robes").id}
		local itemAmounts = {1, 1}
		local desc = "Reduces all damage taken by 1/2."
		return level, items, itemAmounts, desc
	end
}
