FlashTrapNpc = {
	click = function(block, npc)
		local damage = 500
		local animation = 15
		local duration = 10000

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

		block.attacker = npc.owner

		blind.cast(npc, block)
		removeTrapItem(npc)
		npc:delete()

		--block:sendAnimation(animation,3)

		block:updateState()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
