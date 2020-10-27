tripwire_trap = {
	click = function(block, npc)
		if (block.blType == BL_PC) then
			-- Carnage etc.
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
		end

		block.attacker = npc.owner
		removeTrapItem(npc)
		npc:delete()
		tripwire.cast(npc, block)
		block:updateState()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}

tripwire = {
	-- 30AC scourge
	cast = function(block, target)
		local duration = 37000

		if target.state == 1 then
			return
		end

		if target:checkIfCast(curses) then
			return
		end
		if target:checkIfCast(protections) then
			return
		end

		target:setDuration("tripwire", duration)

		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 30
			target.cursed = 1
		elseif (target.blType == BL_PC) then
			target:sendMinitext("Tripwire")
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
	end,
}
