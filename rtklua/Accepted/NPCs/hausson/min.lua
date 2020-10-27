MinNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local options = {"Buy", "Sell", "Cooking Skills"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				MinNpc.buyItems(npc)
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				MinNpc.sellItems(npc)
			)
		elseif choice == "Cooking Skills" then
			MinNpc.cookingSkills(player, npc)
		end
	end),

	buyItems = function(npc)
		local buyItems = {
			"acorn",
			"chestnut",
			"meat_scrap",
			"rabbit_meat",
			"wolf_meat",
			"tigers_heart"
		}

		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = ButcherNpc.sellItems()

		table.insert(sellItems, "egg")
		table.insert(sellItems, "tiger_meat")
		table.insert(sellItems, "tigers_heart")
		table.insert(sellItems, "splendid_tiger_pelt")

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "ambrosia")
			table.insert(sellItems, "dragons_liver")
		end

		return sellItems
	end,

	cookingSkills = function(player, npc)
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
				"Ah, the joy of cooking. It's a favorite passion of the people of Hausson.",
				"We only know how to refine the food and make a basic noodle dish.",
				"I am sure, however, that there are some great recipies from other kingdoms that can be used.",
				"For now, I can only help you prepare wheat, eggs, and some meats for cooking with.",
				"Once you are able to prepare food, I will help you make some noodles.",
				"Just tell me what you want to prepare, and I will assist you."
			},
			0
		)
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

		if speech:match("prepare ") then
			crafting.craftingDialog(player, npc, speech)
		end

		if speech == "virtue" and player.quest["gloth_clicked"] == 1 and player.quest["wind_armor"] == 1 then
			Tools.checkKarma(player)

			if player.quest["min_clicked"] == 0 then
				player.quest["min_clicked"] = 1
				player:dialogSeq(
					{
						t,
						"So, you seek the path of Virtue? Yes, I am the one who set the guard to protect the secret.",
						"You have done well to get this far, and I am pleased with your progress.",
						"You have shown yourself to have virtue enough to get this far, and that is a great accomplishment in itself.",
						"((The woman smiles at you))",
						"You do not even realize it yourself, do you? Well in time you will, of this I am sure.",
						"I alone am not the only keeper of the secret, another must judge you as well.",
						"He is my old friend Chul, who lives in the Nagnang capitol.",
						"Bring him a Stardrop, and he will tell you more.",
						"Take care of yourself on your journey. I will see you again, you still have far to go."
					},
					0
				)
				return
			end

			if player.quest["min_clicked"] == 1 then
				player:dialogSeq(
					{t, "Go on my friend, this journey you must finish alone."},
					0
				)
				return
			end
		end

		if speech == "humm dee do dum do hee" then
			Tools.checkKarma(player)

			if player.quest["lost_legend_chest_clicked"] == 0 or player.quest["wind_armor"] == 0 then
				player:dialogSeq(
					{t, "I really have no idea what you are talking about."},
					0
				)
				return
			end

			player.quest["min_song_asked"] = 1
			player:dialogSeq(
				{
					t,
					"Ah, so you are back, and you have heard the song. I am glad you have made it so far.",
					"That tune, it was one of my favorites, long ago.",
					"I wish I could remember the tune, but I forgot it so long ago.",
					"I just remember hearing it while on that ship that brought me to this land."
				},
				0
			)
		end

		if speech == "kawlana" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 or player.quest["dae_shore_paper_burned"] == 0 then
				player:dialogSeq(
					{t, "I really have no idea what you are talking about."},
					0
				)
				return
			end

			player.quest["min_kawlana"] = 1
			player:dialogSeq(
				{
					t,
					"Why does it not surprise me that you have made it this far?",
					"Your heart is strong, and full of fire. You will not be swayed from your goal.",
					"Well, I am sure you are not here for praise, though it never hurts.",
					"Kawlana is a word from my own home town. It is the realm of shadows where your spirit roams free and the winds of true power live.",
					"Kawlana is the source of your power. It lives and resides within each and every one of us.",
					"During my journeys I needed a way to attract the winds to the net so they could be captured.",
					"With the magical and powerful Kawlana I was able to get the winds close enough, but at a heavy cost.",
					"That is when the true battle began, one that I thought I would never live through.",
					"Thank the stars above I had enough life force to survive the battle.",
					"You will need to get your own Kawlana if you intend to capture the winds."
				},
				0
			)
		end

		if speech == "weave wind" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 then
				player:dialogSeq(
					{t, "I really have no idea what you are talking about."},
					0
				)
				return
			end

			if player:hasItem("captured_wind", 1) ~= true then
				player:dialogSeq(
					{t, "You must have a captured wind to continue."},
					0
				)
				return
			end

			if player.quest["min_weave_wind"] == 0 then
				player.quest["min_weave_wind"] = 1
				player:dialogSeq(
					{
						t,
						"Oh my... I will never get used to that sight.",
						"The wind, trapped like that.",
						"But yes, I will help you weave the wind into a garment. I am the only one who could show you how.",
						"But you will need help from weaver and a tailor, who have at least mastered their craft.",
						"Together the four of us (or three if you possess these skills) will be able to make the armor.",
						"Sorry, it won't be like the armor you are used to. I only know styles from my homeland.",
						"Go now, and when you have the people, return and we will begin."
					},
					0
				)
				return
			end

			if player.quest["min_weave_wind"] == 1 then
				local choice = player:menuSeq(
					"So, do you have the people you need to weave this garment? (If you have people with you, they do not need to be grouped. Only present.)",
					{"Yes, they are here.", "No, they aren't here."},
					{}
				)

				if choice == 1 then
					local input = player:inputLetterCheck(player:input("Who is it that will weave your armor?"))
					local weaver = Player(input)

					if weaver == nil then
						player:dialogSeq({t, "That person is not online."}, 0)
						return
					end

					input = player:inputLetterCheck(player:input("Who is it that will tailor your armor?"))
					local tailor = Player(input)

					if tailor == nil then
						player:dialogSeq({t, "That person is not online."}, 0)
						return
					end

					if weaver.m ~= player.m then
						player:dialogSeq(
							{t, "Your weaver must be in here with you."},
							0
						)
						return
					end
					if tailor.m ~= player.m then
						player:dialogSeq(
							{t, "Your tailor must be in here with you."},
							0
						)
						return
					end

					if not crafting.checkSkillLevel(weaver, "weaving", "master") then
						player:dialogSeq(
							{
								t,
								"You are missing the skills required to make your wind armor. Increase your skills or bring along others who have the required skills."
							},
							0
						)
						return
					end
					if not crafting.checkSkillLevel(tailor, "tailoring", "master") then
						player:dialogSeq(
							{
								t,
								"You are missing the skills required to make your wind armor. Increase your skills or bring along others who have the required skills."
							},
							0
						)
						return
					end

					local item = ""

					if player.baseClass == 1 and player.sex == 0 then
						-- warrior male
						item = "wind_platemail"
					elseif player.baseClass == 1 and player.sex == 1 then
						-- warrior female
						item = "wind_platemail_dress"
					elseif player.baseClass == 2 and player.sex == 0 then
						-- rogue male
						item = "wind_armor"
					elseif player.baseClass == 2 and player.sex == 1 then
						-- rogue female
						item = "wind_armor_dress"
					elseif player.baseClass == 3 and player.sex == 0 then
						-- mage male
						item = "wind_garb"
					elseif player.baseClass == 3 and player.sex == 1 then
						-- mage female
						item = "wind_skirt"
					elseif player.baseClass == 4 and player.sex == 0 then
						-- poet male
						item = "wind_robes"
					elseif player.baseClass == 4 and player.sex == 1 then
						-- poet female
						item = "wind_gown"
					end

					player:removeItem("captured_wind", 1)
					player:addItem(item, 1, 0, player.ID)

					if not player:hasLegend("captured_the_wind") then
						player:addLegend(
							"Captured the wind (" .. curT() .. ")",
							"captured_the_wind",
							0,
							128
						)
					end

					weaver:addKarma(1)
					tailor:addKarma(1)

					player.quest["wind_armor"] = 0
					player.quest["min_clicked"] = 0
					player.quest["star_swords"] = 0
					player.quest["min_song_asked"] = 0
					player.quest["kawlana_used"] = 0
					player.quest["kawlana_dropped"] = 0
					player.quest["min_kawlana"] = 0
					player.quest["lost_legend_chest_clicked"] = 0
					player.quest["chu_rua_song"] = 0
					player.quest["chu_rua_song_stanza"] = 0
					player.quest["gan_metal"] = 0
					player.quest["presented_sonhi_pass"] = 0

					player:dialogSeq(
						{
							t,
							"And there you go! The armor you have been seeking for so long!",
							"Wear it well, and wear it with great pride."
						},
						0
					)
				elseif choice == 2 then
					player:dialogSeq(
						{t, "Please come back when you are ready."},
						0
					)
				end
			end
		end
	end)
}
