NamelessHermitNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local country = ""

		if player.country == 1 then
			country = "Kugnae"
		elseif player.country == 2 then
			country = "Buya"
		end

		if player:hasItem("aged_wine", 1) == true then
			local choice = player:menuSeq(
				"Are you willing to part with that Aged wine?",
				{"Of course!", "I kind of need it."},
				{}
			)

			if choice == 1 then
				player:removeItem("aged_wine", 1, 9)
				player:addItem("traveling_shoes", 1)
				player:dialogSeq(
					{
						t,
						"\"Why thank you! Here.\" The hermit rumaged through a dusty chest. \"Take these shoes if you'd like.\""
					},
					1
				)
			elseif choice == 2 then
				player:dialogSeq(
					{t, "The hermit sighs. \"That's too bad.\""},
					1
				)
			end
		end

		player:dialogSeq(
			{
				t,
				"Well, hello! Not too many visitors out in these parts.",
				"You're from " .. country .. ", aren't you? I could tell by your urban mannerisms."
			},
			1
		)

		local choice = player:menuSeq(
			"So, traveler. What brings you by?",
			{
				"What do you know about the dreaded Ice Beast?",
				"I'm just looking around."
			},
			{}
		)

		if choice == 1 then
			player:dialogSeq(
				{
					t,
					"You're here for the Ice Beast?!? I hope you're not serious. That Beast has been in this area for as long as I can remember.",
					"They say that it's semi-immortal. It can be defeated, but it will later reform! I don't know if that's true. I'm not sure anyone has defeated it!",
					"\"Thank goodness there's that lava between us. It stays on its side, I stay on mine.\" The haggard man laughs. \"Well, except when I dash over there to hunt rabbits. I'm real quick about it though.\"",
					"When you see how big it is, you'll want to stand clear, too. One good 'SMACK' and you'll be done for, I reckon.",
					"If you want some advice, leave that vile beast alone. The world is better off with you alive."
				},
				1
			)
		elseif choice == 2 then
			player:dialogSeq(
				{t, "Okay. Say, I'd stay on this side of the lava were I you."},
				0
			)
		end
	end)
}
