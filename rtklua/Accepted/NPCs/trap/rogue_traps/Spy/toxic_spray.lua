toxic_spray_trap = {
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
		toxic_spray.cast(npc, block)
		block:updateState()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}

toxic_spray = {
	cast = function(player, target)
		local duration = 40000

		if target.blType == BL_MOB then
			duration = 185000
		end

		if (target.blType == BL_MOB) then
			if target:checkIfCast(venoms) then
				return
			end

			target:setDuration("toxic_spray", duration)
			target:sendAnimation(1)
		elseif (target.blType == BL_PC and target:canPK(target)) then
			if target:checkIfCast(venoms) then
				return
			end
			target:sendMinitext("Poison.")
			target:setDuration("toxic_spray", duration)
			target:sendAnimation(1)
		end
	end,

	while_cast = function(target)
		local damage = target.baseHealth *.01

		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end

		if (target.blType == BL_PC) then
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end

			if os.time() % 2 == 0 then
				target:sendMinitext("Poison is spreading through your veins.")
			end
			target:sendAnimation(1, 5)
		elseif target.blType == BL_MOB then
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end
}
