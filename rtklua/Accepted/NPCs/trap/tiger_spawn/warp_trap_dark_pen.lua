WarpTrapDarkPenNpc = {
	click = function(block, npc)
		local npcBlock = npc:getObjectsInSameMap(BL_NPC)
		local counter = 0
		local name = npc.yname
		local m = npc.m

		if block.blType == BL_MOB then
			return
		end

		if block.blType == BL_PC and block.state == 1 then
			return
		end

		for z = 1, #npcBlock do
			if (npcBlock[z].yname == "WarpTrapDarkPenNpc") then
				counter = counter + 1
			end
		end

		if (counter == 1) then
			TigerWarpNpc.spawnTrap(name, m)
			npc:addNPC("WarpTrapShiverNpc", npc.m, npc.x, npc.y, 2)
		end

		if (block.m < 1000) then
			block:warp(109, 15, 15)
		end
		if (block.m > 3000 and block.m < 4000) then
			block:warp(3109, 15, 15)
		end
		if (block.m > 4000 and block.m < 5000) then
			block:warp(4109, 15, 15)
		end

		block:sendMinitext("You fall into a steep winding passage.")
		removeTrapItem(npc)
		npc:delete()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
