ChuRuaNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local item = Item("sea_ring")
		local tring = {graphic = item.icon, color = item.iconC}

		if player:hasLegend("aided_chu_rua") then
			player:dialogSeq(
				{
					t,
					"Thank you again for your help! I will return you home now."
				},
				1
			)

			if player.country == 1 then
				-- kug
				player:warp(36, 7, 6)
			else
				player:warp(351, 8, 8)
			end
			return
		end

		if (player:hasItem("young_ginseng", 1) == true and not player:hasLegend("aided_chu_rua")) then
			player:dialogSeq(
				{
					t,
					"Ginseng. What an odd looking root.",
					"The Dragon king shall live. Bless you, kind one."
				},
				1
			)

			player:giveXP(400)

			if player.quest["tutorial_quest"] == 7 then
				-- came from ironheart/jadespear
				player:giveXP(200)
			end

			player:addKarma(1)
			player:removeItem("young_ginseng", 1, 9)
			player:addItem("sea_ring", 1)

			player:addLegend(
				"Aided Chu Rua (" .. curT() .. ")",
				"aided_chu_rua",
				5,
				128
			)

			player:dialogSeq(
				{
					tring,
					"Humbly, I offer one of the finest jewels from the sea."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"Thank you again for your help! I will return you home now."
				},
				1
			)

			if player.country == 1 then
				-- kug
				player:warp(36, 7, 6)
			else
				player:warp(351, 8, 8)
			end

			return
		end

		player:dialogSeq(
			{
				t,
				"I have swum as hard as I could. Hey! hey you, honorable human. But a moment! I would that you would hear out an earnest request.",
				"The Lord, Dragon King, is dying as we speak, beneath the waves in his palace. The finest physician has come and declared that he must have an item we cannot procure from within the sea.",
				"I entreat you as a humble servant of the Dragon King, and the only servants who know of the land and the sea.",
				"Please, his highness's health depends upon a root of Young ginseng."
			},
			1
		)

		player:dialogSeq(
			{
				tring,
				"Give this to me, and this ring of the Mermaid Princess I would, in return, give to thee."
			},
			1
		)

		player:dialogSeq(
			{
				t,
				"I... I wish I could point you in the way of the ginseng, but I know not where it grows. There is an old verse,",
				"'Skip north, until rabbits nibbling grass you find, is a path to a king's health and harmony,'",
				"I can tell you, though, that you may greet some of the magic animals of the land. What is you people say, \"Hello\"?",
				"Please get young ginseng for his highness's sake!"
			},
			0
		)
	end),

	move = function(npc, owner)
		npc_ai.moveInPlace(npc, owner)
	end,

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

		if speech == "humm dee do dum do hee" then
			Tools.checkKarma(player)

			if player:hasLegend("lost_legend") then
				player:dialogSeq(
					{
						t,
						"You have already discovered the secrets of the Lost Legend."
					},
					0
				)
				return
			end

			if player.quest["wind_armor"] == 0 or player.quest["min_song_asked"] == 0 then
				player:dialogSeq(
					{t, "I really have no idea what you're talking about."},
					0
				)
				return
			end

			if player.quest["chu_rua_song"] == 0 then
				player.quest["chu_rua_song"] = math.random(1, 2)

				-- randomly decide between version of song
			end

			player:dialogSeq(
				{
					t,
					"The song of the mermaids, where did you hear that?",
					"Is it not a beautiful song?",
					"But why do you not sing the words? Do you not know them?",
					"The words are simple",
					"Oh the waves upon the sea, the green sea of old,",
					"They glide and dance to the shore, a shore of gold,"
				},
				1
			)

			if player.quest["chu_rua_song"] == 1 then
				player:dialogSeq(
					{t, "The dance of the waves does end, a story been retold,"},
					1
				)
			elseif player.quest["chu_rua_song"] == 2 then
				player:dialogSeq(
					{t, "The dance of the waves does end, a story is retold,"},
					1
				)
			end

			player:dialogSeq(
				{
					t,
					"Do not fear for the dance, the waves are too bold,",
					"Far away the tune begins, on the green sea of old."
				},
				0
			)
		end
	end)
}
