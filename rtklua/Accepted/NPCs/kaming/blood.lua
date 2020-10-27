BloodNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local spells = {"slash_warrior"}

		local opts = {"Buy", "Sell", "Forget Secret"}

		if player:hasLegend("forged_blood_oath") and not player:hasLegend("engaged") and not player:hasLegend("married") then
			table.insert(opts, "Break Off Blood Oath")
		end

		if not player:hasLegend("forged_blood_oath") and not player:hasLegend("sealed_blood_oath") and not player:hasLegend("married") and not player:hasLegend("engaged") and player.partner == 0 then
			table.insert(opts, "Make blood oath")
		end

		if player:hasLegend("forged_blood_oath") and not player:hasLegend("married") and not player:hasLegend("engaged") and player.partner == 0 then
			table.insert(opts, "Seal blood oath")
		end

		if not player:hasLegend("engaged") and not player:hasLegend("married") and not player:hasLegend("forged_blood_oath") and player:hasLegend("sealed_blood_oath") then
			table.insert(opts, "Unseal Blood Oath")
		end

		if player.baseClass == 1 then
			table.insert(opts, "Learn Spell")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)
		local choice2 = ""

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				BloodNpc.buyItems()
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				BloodNpc.sellItems()
			)
		elseif choice == "Forget Secret" then
			player:forgetSpell(npc)
		elseif choice == "Learn Spell" then
			player:learnSpecificSpells(npc, spells)
		elseif choice == "Make blood oath" then
			player:dialogSeq(
				{
					t,
					"So, you'd like to make a commitment to another person by the mixing of each other's blood? You've come to the right place."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"This ritual dates back centuries and is not for the faint of heart, coming with some significant costs and risks. But hey, don't let that stop you from showing someone you care."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"If you are willing to part with some gold, I can help you out."
				},
				1
			)
			choice2 = player:menuString(
				"Are you willing to willing to give 1,000 gold in search of knowledge of the ritual?",
				{"Yes, I want this.", "No, I've changed my mind."},
				{}
			)

			if choice2 == "Yes, I want this." then
				if player.money < 1000 then
					player:dialogSeq(
						{
							t,
							"Knowledge of the ritual does come with a cost and it must be paid before I am willing to share this knowledge. If you'd still like to learn, please return to me when you have enough gold."
						},
						0
					)
					return
				end

				player:removeGold(1000)
				if not player:hasSpell("blood_oath") then
					player:addSpell("blood_oath")
				end

				player:dialogSeq(
					{
						t,
						"I've just provided you with the knowledge you need to begin the ritual and I wish you the best of luck. The ritual is not easy."
					},
					0
				)
				return
			elseif choice2 == "No, I've changed my mind." then
				player:dialogSeq(
					{
						t,
						"Fortunately, such a commitment is not for everyone and it is better you are realizing this now instead of later after you have mixed your blood."
					},
					0
				)
				return
			end
		elseif choice == "Seal blood oath" then
			if (os.time() < player.registry["seal_blood_oath_timer"] and not Config.shotgunWeddingEnabled) then
				player:dialogSeq(
					{
						t,
						"You have forged your blood oath recently. Please return in " .. playerTimerValues(
							player,
							"seal_blood_oath_timer"
						)
					},
					0
				)
				return
			end

			local proposer = Player(player.registry["partner1"])
			local proposee = Player(player.registry["partner2"])

			if proposer == nil or proposee == nil then
				player:dialogSeq(
					{
						t,
						"Both parties must be present for the ceremony to commence"
					},
					0
				)
				return
			end

			if proposer:hasLegend("married") or player:hasLegend("engaged") then
				player:dialogSeq(
					{t, "That person is already engaged or married."},
					0
				)
				return
			end

			if proposer:hasLegend("sealed_blood_oath") then
				player:dialogSeq(
					{t, "That person is already part of a blood union."},
					0
				)
				return
			end

			if player.registry["partner2"] ~= player.ID then
				-- this logic returns true if player accessing menu is the person who orignally proposed the marriage
				player:dialogSeq(
					{t, "The proposee should start the blood oath ceremony."},
					0
				)
				return
			end

			local choice = player:menuSeq(
				"Are you certain you wish to devote yourself to this man or woman for life?",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				-- Yes
				BloodNpc.sealbloodoath(proposer, proposee)
			elseif choice == 2 then
				-- No
				player:dialogSeq(
					{
						t,
						"Come back when you are firm in your resolve to join blood."
					},
					0
				)
			end
		elseif choice == "Break Off Blood Oath" then
			player:dialogSeq(
				{
					t,
					"How sad this is necessary. At least you reached this decision before sealing your oath."
				},
				1
			)

			local var = player:menuSeq(
				"Are you sure you want to end the engagement?",
				{
					"Yes, it is necessary (You will lose some XP)",
					"No, I need to consider further."
				},
				{}
			)

			if var == 1 then
				local penalty = player.baseMagic * 1000

				if penalty > 4294967295 then
					penalty = 4294967295
				end

				if player.exp < penalty then
					player.exp = 0
				else
					player.exp = player.exp - penalty
				end

				player:removeLegendbyName("forged_blood_oath")
				player.registry["partner1"] = 0
				player.registry["partner2"] = 0
				player:sendStatus()
				player:dialogSeq({t, "It is done."}, 0)
				return
			elseif var == 2 then
				player:dialogSeq({t, "I hope you can salvage your bond."}, 0)
				return
			end
		elseif choice == "Unseal Blood Oath" then
			player:dialogSeq(
				{
					t,
					"Oh no! You made a horrible mistake!",
					"However, I can help you remove your blood bond."
				},
				1
			)

			local expCost = player.baseHealth * 2550
			local confirm = player:menuString(
				"It will cost " .. Tools.formatNumber(expCost) .. " experience. Are you sure you want to break your blood bond?",
				{"Yes", "No"}
			)

			if confirm == "Yes" then
				if player.exp < expCost then
					player:dialogSeq(
						{
							t,
							"Hmmm.. you don't have the experience to break your blood bond, but there is something else you can offer."
						},
						1
					)

					local vitaPenalty = 8000
					local manaPenalty = 4000
					local stat = ""

					local choice2 = player:menuSeq(
						"Perhaps some physical suffering would be sufficient?",
						{
							"Sacrifice " .. vitaPenalty .. " Vita",
							"Sacrifice " .. manaPenalty .. " Mana",
							"I'd rather not."
						},
						{}
					)
					local penalty = 0

					if choice2 == 1 then
						stat = "Vita"
						penalty = vitaPenalty
					elseif choice2 == 2 then
						stat = "Mana"
						penalty = manaPenalty
					end

					local confirm2 = player:menuSeq(
						"It will cost you " .. Tools.formatNumber(penalty) .. " base " .. stat .. " as a penalty. Continue?",
						{"Yes, do it", "No, nevermind"},
						{}
					)

					if confirm2 == 1 then
						if choice2 == 1 and player.baseHealth < vitaPenalty then
							player:dialogSeq(
								{
									t,
									"You need to gain more experience in your health before you can make this sacrifice."
								},
								0
							)
							return
						end

						if choice2 == 2 and player.baseMagic < manaPenalty then
							player:dialogSeq(
								{
									t,
									"You need to gain more experience in your magic before you can make this sacrifice."
								},
								0
							)
							return
						end

						player.partner = 0
						player:removeLegendbyName("sealed_blood_oath")
						player:removeItem("blood_stone", 1)

						if choice2 == 1 then
							player.baseHealth = player.baseHealth - penalty
						elseif choice2 == 2 then
							player.baseMagic = player.baseMagic - penalty
						end

						player.registry["baseHealth"] = player.baseHealth
						player.registry["baseMagic"] = player.baseMagic

						player:calcStat()

						player:dialogSeq(
							{t, "You are now free of a blood bond."},
							0
						)
						return
					end

					return
				elseif player.exp >= expCost then
					local confirmXPLoss = player:menuSeq(
						"It will cost you " .. Tools.formatNumber(expCost) .. " experience as a penalty. Continue?",
						{"Yes, do it", "No, nevermind"},
						{}
					)

					if confirmXPLoss == 1 then
						player.exp = player.exp - expCost
						player:sendStatus()
						player.partner = 0
						player:removeLegendbyName("sealed_blood_oath")
						player:removeItem("blood_stone", 1)
						player:dialogSeq(
							{t, "You are now free of a blood bond."},
							0
						)
						return
					end
				end
			elseif confirm == "No" then
				player:dialogSeq(
					{
						t,
						"Patience and love will save your blood bond.\n\nBreaking your blood bond is not something to take lightly."
					},
					0
				)
				return
			end
		end
	end),

	sealbloodoath = async(function(proposer, proposee)
		local choice = proposer:menuSeq(
			"Do you, " .. proposer.name .. " wish to join your blood with " .. proposee.name .. "?",
			{
				"I do. (you will lose much xp if you break this blood bond)",
				"I don't."
			},
			{}
		)

		if choice == 1 then
			proposer:sendMinitext("You are now bound by blood with " .. proposee.name)
			proposee:sendMinitext("You are now bound by blood with " .. proposer.name)

			proposer:removeLegendbyName("forged_blood_oath")
			proposee:removeLegendbyName("forged_blood_oath")

			if proposer.sex == 0 then
				-- male
				proposer:addLegend(
					"$player's Blood brother (" .. curT() .. ")",
					"sealed_blood_oath",
					51,
					1,
					proposee.ID
				)
			elseif proposer.sex == 1 then
				-- female
				proposer:addLegend(
					"$player's Blood sister (" .. curT() .. ")",
					"sealed_blood_oath",
					51,
					1,
					proposee.ID
				)
			end

			if proposee.sex == 0 then
				-- male
				proposee:addLegend(
					"$player's Blood brother (" .. curT() .. ")",
					"sealed_blood_oath",
					51,
					1,
					proposer.ID
				)
			elseif proposee.sex == 1 then
				-- female
				proposee:addLegend(
					"$player's Blood sister (" .. curT() .. ")",
					"sealed_blood_oath",
					51,
					1,
					proposer.ID
				)
			end

			proposer.registry["partner1"] = 0
			proposer.registry["partner2"] = 0
			proposee.registry["partner1"] = 0
			proposee.registry["partner2"] = 0

			proposer.partner = proposee.ID
			proposee.partner = proposer.ID

			proposer:addItem("blood_stone", 1)
			proposee:addItem("blood_stone", 1)

			proposer:dialog(
				"Congratulations you are both now blood siblings.",
				{}
			)
			proposee:dialog(
				"Congratulations you are both now blood siblings.",
				{}
			)

			proposee:sendStatus()
			proposer:sendStatus()
		elseif choice == 2 then
			proposer:sendMinitext("It seems that your partner is not sure of blood union.")
		end
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

		local item = Item("frost_sabre")
		local tfrostsabre = {graphic = item.icon, color = item.iconC}

		if speech == "ice beast" then
			Tools.checkKarma(player)

			if player.level < 7 then
				return
			end

			if player:hasLegend("defeated_ice_beast") == true then
				player:dialogSeq(
					{t, "\"I hope you have found your Frost sabre useful!\""},
					1
				)
				return
			end

			if player.registry["paid_gold_for_frost_sabre"] == 1 then
				if player:hasItem("ice_heart", 1) == true then
					player:dialogSeq(
						{
							t,
							"The Sonhi looks surprised. \"I do not know how one as wimpy as you could defeat an Ice beast, but somehow you have triumphed.\"",
							"\"As promised, I will forge you a Frost sabre.\""
						},
						1
					)
					player:removeItem("ice_heart", 1, 9)
					player:addItem("frost_sabre", 1, 0, player.ID)
					player:giveXP(2300)
					player:addLegend(
						"Defeated the Ice beast (" .. curT() .. ")",
						"defeated_ice_beast",
						5,
						128
					)
					player.registry["paid_gold_for_frost_sabre"] = 0
					return
				end

				player:dialogSeq(
					{
						t,
						"The Sonhi seems to be suppressing laughter. \"Bring me an Ice heart and I will make you a Frost sabre.\""
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"The Sonhi grins. \"Ice Beast, eh? You must be after a Frost sabre.\"",
					"\"You have heard of the Frost sabre, haven't you? No? Then let me tell you what you are missing.\""
				},
				1
			)

			player:dialogSeq(
				{
					tfrostsabre,
					"\"Though only a modest weapon, the Frost sabre has many great powers.\"",
					"\"When you die, it will not leave your side. When it is worn, it can be repaired with ease. In combat, sometimes it chills your foe, making them easier to hit.\"",
					"\"Perhaps most impressive is that only YOU will be able to wield your Forst sabre if it is crafted for you.\nUnfortunately, very, very few know how to make one.\""
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"\"I know what you are thinking. Yes, I know how to craft a Frost sabre. I can see in your eyes that you are eager for one aren't you?\""
				},
				1
			)

			local choice = player:menuSeq(
				"\"For a mere 100 gold, I will forge you one if you bring me the item needed to make one. Will you pay?\"",
				{"Yes, I want a Frost sabre.", "No, I'll keep my money."},
				{}
			)

			if choice == 1 then
				if player.money < 100 then
					player:dialogSeq(
						{t, "Come back when you have more gold."},
						1
					)
					return
				else
					player:removeGold(100)
					player.registry["paid_gold_for_frost_sabre"] = 1
				end

				player:dialogSeq(
					{
						t,
						"\"To forge it, I will need the Ice heart of a mighty and wicked Ice Beast.\"",
						"\"Where do you find an Ice Beast? I wouldn't know. We Sonhi aren't from this area. Perhaps one who has dwelt here a long time would know.\"",
						"As you are leaving, you hear the Sonhi captain chuckle to himself, \"Even if the fool finds an Ice beast, they'll surely die. An easy 100 gold, heh, heh.\""
					},
					0
				)
			elseif choice == 2 then
				player:dialogSeq(
					{
						t,
						"\"As you wish... I suppose I will make a Frost sabre for another then.\""
					},
					1
				)
				return
			end
		end

		if speech == "seal" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] > 0 then
				if player.quest["gave_weaving_tools_sya"] == 0 then
					player:dialogSeq(
						{
							t,
							"Uhh... I really have no idea what you are talking about."
						},
						0
					)
					return
				end

				if player.quest["frost_sabre_for_seal"] == 0 then
					player.quest["frost_sabre_for_seal"] = 1
					player:dialogSeq(
						{
							t,
							"Eh? Who told you about the seal? Nevermind, I think I know, it was that loud mouth Sya.",
							"Gah! Not her fault I guess, I should learn to keep my mouth shut.",
							"It's not even my secret to share, the seal is in the hands of another.",
							"I shouldn't even be telling you this, but my mouth, it just gets me into more and more trouble.",
							"That's probably why KaMing left me here to rot with you ugly townie...",
							"Yes, well, anyways... he left me... here.",
							"Tell you what - I teach many the secrets of the Frost sabre, but it has been my dream for a long time to own one myself.",
							"If you were to bring me one, I will tell you who has it, and how to get it from them!"
						},
						0
					)
				end

				if player.quest["frost_sabre_for_seal"] == 1 then
					if player:hasItem("frost_sabre", 1) ~= true then
						player:dialogSeq(
							{
								t,
								"I am still waiting for that frost sabre before I can tell you more about the seal."
							},
							0
						)
						return
					end

					player.quest["frost_sabre_for_seal"] = 2
					player:removeItem("frost_sabre", 1, 9)

					player:dialogSeq(
						{
							t,
							"This is one fine sabre! Thank you so much for getting it to me.",
							"I don't care who owns it, I will never wield it, but to have this in my collection is such an honor",
							"Well, as promised, the information you seek. Gan was once the personal blacksmith to KaMing himself.",
							"Once when KaMing dropped off his armor to be repaired after battle, Gan found the seal inside once of the folds.",
							"He kept it to one side to return it to KaMing, but KaMing never returned for the armor.",
							"You should talk to him about it, but don't mention the seal, he won't give it to you out right.",
							"You will need to find another way to get him to talk about it."
						},
						0
					)
				end

				if player.quest["frost_sabre_for_seal"] == 2 then
					player:dialogSeq(
						{
							t,
							"Thanks again for the frost sabre. Don't forget to visit Gan."
						},
						0
					)
				end
			end
		end
	end),

	buyItems = function()
		local buyItems = {
			"blood_stone",
			"cooked_fish",
			"rose_petals"
		}

		return buyItems
	end,

	sellItems = function()
		return ChapelNpc.sellItems()
	end
}
