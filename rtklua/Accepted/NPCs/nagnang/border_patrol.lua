BorderPatrolNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["leviathan"] == 0 then
			player:dialogSeq(
				{
					t,
					"Just doin' my job here. Keep yer nose clean and I won't have to do my job on you."
				},
				0
			)
		end

		if player.quest["leviathan"] ~= 0 then
			player:dialogSeq(
				{
					t,
					"Eh? What's that? Sorry Stranger, we don't let anyone past our borders here.",
					"Hmmm, you have the scent of the Leviathans on you. Perhaps I could look the other way if you were to hand me one of those lovely pelts the green squirrels drop."
				},
				1
			)
		end
	end),

	handItem = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local invItem = player:getInventoryItem(player.invSlot)

		if invItem.yname == "green_squirrel_pelt" and player.quest["leviathan"] ~= 0 then
			player:removeItem("green_squirrel_pelt", 1, 9)
			player:dialogSeq(
				{
					t,
					"Well thank you kindly! Now be on your way and I don't know you. Oh, and look out for those tricky Fox spirits. They enjoy their little games."
				},
				1
			)
			player:warp(2542, 1, 16)
		end
	end)
}
