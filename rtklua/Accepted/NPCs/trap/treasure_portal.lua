TreasurePortalNpc = {
	click = function(block, npc)
		if block.blType == BL_MOB then
			return
		end

		block:msg(
			0,
			"You step into a mysterious portal. Where could it lead?",
			block.ID
		)

		npc:delete()
	end,

	action = function(npc)
		npc:sendAnimationXY(358, npc.x, npc.y)
	end,

	endAction = function(npc)
		npc:delete()
	end,
}
