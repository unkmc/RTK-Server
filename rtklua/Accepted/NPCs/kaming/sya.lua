SyaNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local options = {"Buy", "Sell"}
		local buyItems = {"sonhi_cloak", "sonhi_dress", "magic_mirror"}
		local sellItems = {
			"sonhi_cloak",
			"sonhi_dress",
			"magic_mirror",
			"summer_mantle",
			"autumn_mantle",
			"winter_mantle",
			"ancient_mantle",
			"blood_mantle",
			"earth_mantle",
			"summer_drapery",
			"autumn_drapery",
			"winter_drapery",
			"ancient_drapery",
			"leather_drapery",
			"earth_drapery"
		}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyItems
			)
		elseif choice == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellItems)
		end
	end),

	buyItems = function()
		local buyItems = {"sonhi_cloak", "sonhi_dress", "magic_mirror"}

		return buyItems
	end,

	sellItems = function()
		local sellItems = {
			"sonhi_cloak",
			"sonhi_dress",
			"magic_mirror",
			"summer_mantle",
			"autumn_mantle",
			"winter_mantle",
			"ancient_mantle",
			"blood_mantle",
			"earth_mantle",
			"summer_drapery",
			"autumn_drapery",
			"winter_drapery",
			"ancient_drapery",
			"leather_drapery",
			"earth_drapery"
		}

		return sellItems
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

		if speech == "pass" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 then
				player:dialogSeq(
					{
						t,
						"Uhh... I really have no idea what you are talking about."
					},
					0
				)
				return
			end

			if player.quest["talked_to_sya"] == 0 then
				player.quest["talked_to_sya"] = 1
				player:dialogSeq(
					{
						t,
						"Are you mad? You want the seal of KaMing himself?",
						"Do you think he left his seal in his shirt pocket the last time he was in my store?",
						"Or perhaps he left it with me as a sign of respect like ...oh...hmmmm...",
						"How badly do you really want this seal?",
						"I might know something about somebody, who knows something about somebody else, who knows something about the seal.",
						"But I am not about to give out such accurate information so easily... let me think here...",
						"I am trying to mend some old clothes; but my Weaving tools are wearing out.",
						"If you would get me another pair, I might be grateful enough to help you."
					},
					0
				)
				return
			end

			if player.quest["talked_to_sya"] == 1 then
				if player.quest["gave_weaving_tools_sya"] == 0 then
					if player:hasItem("fine_weaving_tools", 1) ~= true then
						player:dialogSeq(
							{
								t,
								"I am trying to mend some old clothes; but my Weaving tools are wearing out.",
								"If you would get me another pair, I might be grateful enough to help you."
							},
							0
						)
						return
					end

					player:removeItem("fine_weaving_tools", 1, 9)
					player.quest["gave_weaving_tools_sya"] = 1
				end

				player:dialogSeq(
					{
						t,
						"Oh, these are nice! These should improve the quality of my work greatly.",
						"Hmmm...well, as promised...",
						"Blood, the warrior who has a shop just south of here, was muttering something about somebody else seeing the seal.",
						"I don't know much more about it, other than that. But I set you on the right track, now you know who to ask"
					},
					0
				)
				return
			end
		end

		if speech == "water skin" then
			player:dialogSeq(
				{
					t,
					"Oh please don't remind me of them!",
					"While growing up with my parents as we moved all over the desert all we had to drink was water from a wolf skin flask."
				},
				1
			)

			if player:hasItem("wolf_pelt", 1) ~= true then
				player:dialogSeq(
					{
						t,
						"That is one of the reasons why I decided to settle here when the opportunity came, I couldn't take it any more."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"I see you have a wolf pelt there, and from what I have been hearing around you need me to help you make a water skin."
				},
				1
			)

			if player.money < 500 then
				player:dialogSeq(
					{
						t,
						"It will take some of my thread and time to make one so I will need to ask for at least 500 gold."
					},
					0
				)
				return
			end

			local choice = player:menuSeq(
				"It will take some of my thread and time to make one, are you willing to pay 500 gold?",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				player:removeGold(500)
				player:removeItem("wolf_pelt", 1, 9)
				player:addItem("empty_water_skin", 1)

				player:dialogSeq({t, "Thanks!"}, 0)
			end
		end
	end)
}
