pestilence_mage = {
	cast = function(player, target)
		local duration = 200000
		local magicCost = 20

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
		player:playSound(5)
		player:sendMinitext("You cast Pestilence.")
		target:setDuration("pestilence_mage", duration)
		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 5
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Pestilence on you.")
			target:calcStat()
		end
	end,
	while_cast = function(block)
		block:sendAnimation(34, 0)
	end,
	recast = function(target)
		target.armor = target.armor + 5
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 5
		target.cursed = 0
		target:SendStatus()
	end,

	requirements = function(player)
		local level = 7
		local items = {"acorn", "wooden_sword", 0}
		local itemAmounts = {15, 1, 50}
		local desc = "A minor curse."
		return level, items, itemAmounts, desc
	end
}
