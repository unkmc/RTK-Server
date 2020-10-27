hindrance_mage = {
	cast = function(player, target)
		local duration = 6000
		local magicCost = 1000

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
			player:sendMinitext("You cast Hindrance.")
			target:setDuration("hindrance_mage", duration)
			target:sendAnimation(1, 0)
			target.armor = target.armor + 40
		elseif (target.blType == BL_PC and player:canPK(target)) then
			player:sendAction(6, 20)
			player.magic = player.magic - magicCost
			player:sendStatus()
			player:playSound(5)
			player:sendMinitext("You cast Hindrance.")
			target:setDuration("hindrance_mage", duration)
			target:sendAnimation(1, 0)
			target:sendMinitext(player.name .. " casts Hindrance on you.")
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
		block.armor = block.armor + 40
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor - 40
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {"il_san_surge", "jolt_trident", "scribes_book", 0}
		local itemAmounts = {1, 2, 2, 60000}
		local description = "Decreases target's defense by 40. (AC+40)."
		return level, items, itemAmounts, description
	end
}
