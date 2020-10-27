MuseumGreeterNpc = {
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
				"Well hello there traveler! Welcome to the museum.",
				"There are many fascinating things to see here, and so much to learn. Have you ever wondered how Gut got his name? Who Linskrae was? Or how the greedy King Suyo died?",
				"You can learn all about these things, and more, right here at the museum!",
				"I hope you enjoy your visit. Please remember you are welcome to look at everything, but you must not touch! Some of the items found in this museum are priceless!",
				"And be sure to stop by the caretakers room at the end of the tour. He will surely have a thank you gift waiting there."
			},
			1
		)
	end)
}
