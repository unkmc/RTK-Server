WarpTrapShiverNpc = {
	click = function(block, npc)
		if block.blType == BL_MOB then
			return
		end
		if block.blType == BL_PC and block.state == 1 then
			return
		end

		block:sendMinitext('You feel a sudden shiver.')
		removeTrapItem(npc)
		npc:delete()
	end,
	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
