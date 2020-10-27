DeathTrapNpc = {
	click = function(block, npc)
		local damage = 11650

		damage = calculateDamage(block, damage)

		if (block.blType == BL_PC) then
			-- Carnage etc.
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
			block:sendMinitext("You stepped on a trap!")
		end

		if (block.health < damage and block.health > 1) then
			damage = block.health - 1
		elseif (block.health == 1) then
			damage = 0
		end

		block.attacker = npc.owner
		block:removeHealth(damage)
		block:sendAnimation(44)

		removeTrapItem(npc)
		npc:delete()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
