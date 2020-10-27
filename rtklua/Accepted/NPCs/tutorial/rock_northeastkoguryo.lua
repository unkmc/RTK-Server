RockNpc = {
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		if speech == "hi" then
			local t = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}
			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = npc.ID

			Tools.checkKarma(player)

			player:dialogSeq({t, "\"Quit bugging me will ya?\""}, 0)
		end
	end)
}
