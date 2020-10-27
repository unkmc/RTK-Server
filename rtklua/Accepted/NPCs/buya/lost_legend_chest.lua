LostLegendChestNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player.quest["lost_legend_chest_clicked"] = 1
		player:dialogSeq(
			{
				t,
				"Hum dee do dum do hee...",
				"Oh, hello there. Come to visit me?",
				"It's been a while since somebody else came to visit me.",
				"Oh, the fun I used to have. What a long time ago that was.",
				"Now all I have to keep me company is this tune in my head... well, if I had a head that is.",
				"So what is it you seek from me? I hold many secrets you know."
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

		if player:hasLegend("lost_legend") then
			return
		end

		if speech == "legend" then
			Tools.checkKarma(player)

			player.quest["lost_legend_chest_clicked"] = 1
			player:dialogSeq(
				{
					t,
					"Ah, the lost legend of the armor. Seems very popular, a lot of people have been asking for it.",
					"But, I can't just give it to you. It's been magically locked - with a song none the less.",
					"Without the song you are not getting it."
				},
				0
			)

			--player:dialogSeq({t,"Great song."},0)
			return
		end

		-- Mermaid song
		if player.quest["chu_rua_song"] == 0 then
			-- don't do shit if they haven't visited chu rua for the song
			return
		end

		local song = {
			"oh the waves upon the sea, the green sea of old,",
			"they glide and dance to the shore, a shore of gold,"
		}

		if player.quest["chu_rua_song"] == 1 then
			table.insert(
				song,
				"the dance of the waves does end, a story been retold,"
			)
		elseif player.quest["chu_rua_song"] == 2 then
			table.insert(
				song,
				"the dance of the waves does end, a story is retold,"
			)
		end

		table.insert(song, "do not fear for the dance, the waves are too bold,")
		table.insert(song, "far away the tune begins, on the green sea of old.")

		if speech == song[1] and player.quest["chu_rua_song_stanza"] == 0 then
			player.quest["chu_rua_song_stanza"] = 2
			player:dialogSeq({t, "Oh my! You know the song..."}, 0)
		elseif speech == song[2] and player.quest["chu_rua_song_stanza"] == 2 then
			player.quest["chu_rua_song_stanza"] = 3
			player:dialogSeq({t, "Please continue, it is so wonderful!"}, 0)
		elseif speech == song[3] and player.quest["chu_rua_song_stanza"] == 3 then
			player.quest["chu_rua_song_stanza"] = 4
			player:dialogSeq({t, "This is truly music to my ears."}, 0)
		elseif speech == song[4] and player.quest["chu_rua_song_stanza"] == 4 then
			player.quest["chu_rua_song_stanza"] = 5
			player:dialogSeq(
				{t, "Louder! Let the room fill with the song of love!"},
				0
			)
		elseif speech == song[5] and player.quest["chu_rua_song_stanza"] == 5 then
			player.quest["chu_rua_song_stanza"] = 0

			if not player:hasLegend("lost_legend") then
				player:addLegend(
					"Discovered lost legend (" .. curT() .. ")",
					"lost_legend",
					5,
					128
				)
				player:addItem("legend_of_the_winds_2", 1)
			end
			player:dialogSeq(
				{
					t,
					"That's it! That's the song I have needed to hear, and the one I will always hum.",
					"Isn't it beautiful?",
					"Ah, so poetic, so wonderful... if you understand the words.",
					"Well, as promised, here is the legend you seek."
				},
				0
			)
		else
			player.quest["chu_rua_song_stanza"] = 0
			player:dialogSeq(
				{t, "The chest frowns. Maybe you have missed a line?"},
				0
			)
		end
	end)
}
