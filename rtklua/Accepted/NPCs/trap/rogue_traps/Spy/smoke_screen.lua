smoke_screen_trap = {
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
		smoke_screen.cast(npc, block)
		block:updateState()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}

smoke_screen = {
	cast = function(player, target)
		local duration = 25000

		if target:checkIfCast(blinds) then
			return
		end

		if target.blType == BL_PC then
			target:sendMinitext("You cannot see anything.")
		end

		target:setDuration("smoke_screen", duration)
		target.blind = true
		target:updateState()
	end,

	while_cast = function(block)
		block.blind = true
	end,

	uncast = function(block)
		block.blind = false
		block:updateState()
	end
}
