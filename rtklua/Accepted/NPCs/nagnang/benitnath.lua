BenitnathNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{
				t,
				"What do you want now? Can't you see I have nothing else for you to steal?!",
				"Oh wait... who are you? You're not part of the hideous army that took over this place... are you?",
				"What are you doing here? Actually, no matter... so long as you're here to put a thorn in the side of \"THEM\".",
				"I'm afraid I can't help you much, there is one way I know into the palace, through the sewers, but I don't think you want to go that way."
			},
			0
		)
	end),

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

		if speech == "sewers" then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					t,
					"The sewers? Yeah, you could make it through, if you can see in there.",
					"That army came in and plugged every last light hole, it's darker than midnight in there, not even the moon and stars for light.",
					"I wouldn't go in there without a torch or lantern, that's for sure!",
					"If you want to go into the sewers just go over the corner there, you will find the drain pretty big, and will lead you down into the sewers.",
					"Good luck, but remember, I warned you!"
				},
				0
			)
		end
	end)
}
