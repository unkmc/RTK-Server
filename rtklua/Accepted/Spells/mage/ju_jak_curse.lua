ju_jak_curse_mage = {
	cast = function(player, target)
		local duration = 6000
		local magicCost = 2000

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

		if target:checkIfCast(curses) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		if target:checkIfCast(protections) then
			player:sendMinitext("The target is already protected.")
			return
		end

		if (target.blType == BL_MOB) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(5)
			player:sendMinitext("You cast Ju Jak Curse.")
			target:setDuration("ju_jak_curse_mage", duration)
			target:sendAnimation(1, 0)
			target.armor = target.armor + 45
		elseif (target.blType == BL_PC and player:canPK(target)) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(5)
			player:sendMinitext("You cast Ju Jak Curse.")
			target:setDuration("ju_jak_curse_mage", duration)
			target:sendAnimation(1, 0)
			target:sendMinitext(player.name .. " casts Ju Jak Curse on you.")
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

	recast = function(block)
		block.armor = block.armor + 45
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 45
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {"ee_san_surge", "frozen_spear", "scribes_book", 0} -- @TODO: Maybe replace Frozen spear once you have an entry level Enchanted weapon figured out
		local itemAmounts = {1, 4, 4, 60000}
		local description = "Decreases target's defense by 45. (AC+45)."
		return level, items, itemAmounts, description
	end
}
