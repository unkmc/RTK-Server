SleepTrapNpc = {
	click = function(block, npc)
		local animation = 2

		if (block.blType == BL_PC) then
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
			if (block.state == 1) then
				return
			end
			block:sendMinitext("You stepped on a trap!")
		end

		block.attacker = npc.owner
		SleepTrapNpc.cast(block)
		removeTrapItem(npc)
		npc:delete()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end,

	cast = function(block)
		local duration = 38000

		if block:hasDuration("sleep_trap") then
			block:setDuration("sleep_trap", 0)
			block:setDuration("sleep_trap", duration)
		else
			block:setDuration("sleep_trap", duration)
		end

		block.sleep = 1.3
		block:playSound(739)
	end,

	while_cast = function(block)
		block.sleep = 1.3
		block:playSound(739)
		block:sendAnimation(2)
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("sleep_trap", 0)
	end,

	uncast = function(block)
		block.sleep = 1
	end
}
