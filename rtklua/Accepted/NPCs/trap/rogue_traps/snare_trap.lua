SnareTrapNpc = {
	click = function(block, npc)
		local animation = 1

		if (block.blType == BL_PC) then
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
			block:sendMinitext("You stepped on a trap!")
			removeTrapItem(npc)
			npc:delete()
			if block:checkIfCast(protections) then
				return
			end
			SnareTrapNpc.cast(block)
			return
		elseif block.blType == BL_MOB then
			if not block:checkIfCast(snares) then
				block.attacker = npc.owner
				SnareTrapNpc.cast(block)
			end
			removeTrapItem(npc)
			npc:delete()
			return
		end
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end,

	cast = function(block)
		local duration = 75000

		if (block.cursed == 1) then
			return
		end

		if (block.blType == BL_PC) then
			if not block:canPK(block) then
				return
			end
			block:sendStatus()
		end

		if block:hasDuration("snare_trap") then
			block:setDuration("snare_trap", 0)
			block:setDuration("snare_trap", duration)
		else
			block:setDuration("snare_trap", duration)
		end
		if block.blType == BL_MOB then
			block.armor = block.armor + 20
			block.cursed = 1
		elseif block.blType == BL_PC then
			block:calcStat()
		end

		block:sendAnimation(1, 0)
	end,

	recast = function(block)
		block.armor = block.armor + 20
		block.cursed = 1
		block:sendStatus()
	end,

	while_cast = function(block)
		block:sendAnimation(34, 0)
	end,

	uncast = function(block)
		block.armor = block.armor - 20
		block.cursed = 0
		block:sendStatus()
	end
}
