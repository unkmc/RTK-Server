PoisonDartTrapNpc = {
	click = function(block, npc)
		local animation = 1

		if (block.blType == BL_PC) then
			if block.state == 1 then
				return
			end
			block:sendMinitext("You stepped on a trap!")

			if not block:canPK(block) then
				return
			end
		end

		block.attacker = npc.owner
		removeTrapItem(npc)
		npc:delete()

		if block:checkIfCast(protections) then
			return
		end
		if block:checkIfCast(venoms) then
			return
		end

		PoisonDartTrapNpc.cast(block)
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end,

	cast = function(block)
		local duration = 224000
		if (block.blType == BL_PC) then
			duration = 224000
		end
		if (block.blType == BL_MOB) then
			duration = 1 + math.random(1500, 30000)
		end

		if block:hasDuration("poison_dart_trap") then
			block:setDuration("poison_dart_trap", 0)
			block:setDuration("poison_dart_trap", duration)
		else
			block:setDuration("poison_dart_trap", duration)
		end
		block:sendAnimation(11, 5)
	end,

	while_cast_1500 = function(block)
		local damage = block.baseHealth *.01
		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end
		block:sendAnimation(1, 5)
		if block.health > damage then
			block:sendHealth(damage, 0)
		end
	end
}
