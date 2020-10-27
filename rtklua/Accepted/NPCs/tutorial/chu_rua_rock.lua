ChuRuaRockNpc = {
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if (speech == "hello") then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					t,
					"O, it must be good to have feet.",
					"You've been to the sea I'll bet from the smell of you.",
					"That is where I have lived for so long until now; by the sea.",
					"Thank you for spending a moment with this old soul. Be careful of the tiger to the north.",
					"He only thinks of food, though you might distract him if you allude to one of the rabbits that tricked him"
				},
				1
			)
		end
	end)
}
