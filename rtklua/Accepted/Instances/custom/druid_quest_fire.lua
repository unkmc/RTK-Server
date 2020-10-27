DruidQuestFireNpc = {
	action = function(npc)
		npc:sendAnimationXY(48, npc.x, npc.y, 1)
	end,

	click = function(block, npc)
		if block.blType == BL_PC then
			block.registry["druid_quest_stage1_amount"] = block.registry[
				"druid_quest_stage1_amount"
			] + 1
			block:sendAnimation(8)
			block:removeHealth(block.maxHealth *.75)
			block:sendStatus()
			removeTrapItem(npc)
			npc:delete()
		end
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
