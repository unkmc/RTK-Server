forsake = {
	cast = function(player, target)
		local duration = 62000
		local magicCost = 500

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType == BL_PC and not player:canPK(target)) then
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
		player:sendMinitext("You cast Forsake.")
		target:setDuration("forsake", duration)
		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 45
			target.cursed = 1
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:sendMinitext(player.name .. " casts Corrupt on you.")
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
		target.armor = target.armor + 45
		target.cursed = 1
		target:sendStatus()
	end,
	uncast = function(target)
		target.armor = target.armor - 45
		target.cursed = 0
		target:sendStatus()
	end
}
