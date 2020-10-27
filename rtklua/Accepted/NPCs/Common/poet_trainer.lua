PoetTrainerNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {}

		if player.class == 0 then
			table.insert(opts, "Become a Poet")
		elseif player.baseClass == 4 then
			if player.level < 99 then
				table.insert(opts, "Divine Secret")
			end
			table.insert(opts, "Learn Secret")
		end
		table.insert(opts, "Forget Secret")

		table.insert(opts, "Become Noble")
		table.insert(opts, "Minor Quest")

		if (player.registryString["minor_quest"] ~= "") then
			table.insert(opts, "Complete Minor Quest")
		end

		if npc.mapTitle == "Staff" and player.baseClass == 4 and player.level >= 10 and not player:hasLegend("destroyed_nagnang_evil") then
			table.insert(opts, "Poet Welcome")
		end

		if player.baseClass == 4 then
			if player.level >= 66 and player:hasLegend("blessed_by_the_stars") and not player:hasLegend("mastered_the_stars") then
				if player.quest["star_armor"] == 0 or player.quest["star_armor"] == 1 then
					table.insert(opts, "Poet Star 1")
				elseif player.quest["star_armor"] == 2 then
					table.insert(opts, "Poet Star 2")
				elseif player.quest["star_armor"] == 3 then
					table.insert(opts, "Poet Star 3")
				end
			end
		end

		if player.baseClass == 4 then
			if player.level >= 76 and player:hasLegend("mastered_the_stars") and not player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["moon_armor"] == 0 or player.quest["moon_armor"] == 1 then
					table.insert(opts, "Poet Moon 1")
				elseif player.quest["moon_armor"] == 2 then
					table.insert(opts, "Poet Moon 2")
				elseif player.quest["moon_armor"] == 3 then
					table.insert(opts, "Poet Moon 3")
				elseif player.quest["moon_armor"] == 4 then
					table.insert(opts, "Poet Moon 4")
				end
			end
		end

		if player.baseClass == 4 then
			if player.level >= 86 and player:hasLegend("mastered_the_stars") and player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["sun_armor"] == 0 or player.quest["sun_armor"] == 1 then
					table.insert(opts, "Poet Sun 1")
				elseif player.quest["sun_armor"] == 2 then
					table.insert(opts, "Poet Sun 2")
				elseif player.quest["sun_armor"] == 3 then
					table.insert(opts, "Poet Sun 3")
				elseif player.quest["sun_armor"] == 4 then
					table.insert(opts, "Poet Sun 4")
				elseif player.quest["sun_armor"] == 5 then
					table.insert(opts, "Poet Sun 5")
				elseif player.quest["sun_armor"] == 6 then
					table.insert(opts, "Poet Sun 6")
				end
			end
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)
		local choice2

		if choice == "Become Noble" then
			if player.level < 75 then
				player:dialogSeq(
					{
						t,
						"You are still young, and not ready for this yet. Return when you have gained your 75th level."
					},
					1
				)
				return
			else
				general_npc_funcs.setTitle(player, npc)
			end
		elseif choice == "Minor Quest" then
			MinorQuest.quest(player, npc)
		elseif choice == "Complete Minor Quest" then
			MinorQuest.complete(player, npc)
		elseif choice == "Become a Poet" then
			if player.level < 5 then
				player:dialogSeq(
					{
						t,
						"Hail, little one! Please return to me when you have reached the 5th insight."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Hail, mighty one! Welcome to my sanctuary, the sanctuary of the healer.",
					"Have you come to pick your path? I think you would make a great poet, and a great hero."
				},
				1
			)
			choice2 = player:menuString(
				"Will you join the path of the poet?",
				{"Yes", "Tell me more", "No"}
			)
		elseif choice == "Divine Secret" then
			player:futureSpells(npc)
		elseif choice == "Learn Secret" then
			player:learnSpell(npc)
		elseif choice == "Forget Secret" then
			player:forgetSpell(npc)
		elseif choice == "Poet Welcome" then
			if player.quest["nangen_acolyte"] == 1 then
				if player:hasItem("forever_branch", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"I am still waiting for you to bring me a branch from the Forever tree."
						},
						0
					)
					return
				end

				player:removeItem("forever_branch", 1)
				player.quest["nangen_acolyte"] = 2

				if not player:hasLegend("nangen_acolyte") then
					player:addLegend(
						"Became Nangen Acolyte (" .. curT() .. ")",
						"nangen_acolyte",
						4,
						128
					)
				end

				player:dialogSeq(
					{
						t,
						"Ah, the wood will be well used in this order of Poets. Thank you."
					},
					0
				)
			end

			if player.quest["nangen_acolyte"] == 2 then
				local sacred_water = {
					graphic = convertGraphic(252, "item"),
					color = 0
				}
				local infected_creature = {
					graphic = convertGraphic(193, "monster"),
					color = 16
				}
				local magic_rabbit = {
					graphic = convertGraphic(125, "monster"),
					color = 25
				}

				if player:killCount("magic_rabbit") ~= 0 then
					player:dialogSeq(
						{
							magic_rabbit,
							"You killed one of our rabbits! You must cleanse yourself by asking for forgiveness from all of the Totem Animals."
						},
						0
					)
					return
				end

				if player.quest["destroyed_infected"] == 1 then
					player:dialogSeq(
						{
							t,
							"Congratulations! You have helped us in our need to keep balance in our kingdom by relieving a great pressure of evil from within our land.",
							"Please take this protective charm. It has been imbued with the essence of the sacred water that you used to destroy the evil presence.",
							"May it shield you from evil in your upcoming battles. This is the only one I shall ever give you. Thank you again."
						},
						1
					)

					player:addLegend(
						"Destroyed Nagnang Evil (" .. curT() .. ")",
						"destroyed_nagnang_evil",
						7,
						128
					)
					player:addItem("essence_charm", 1, 0, player.ID)
					player.quest["nangen_acolyte"] = 0
					player.quest["destroyed_infected"] = 0
					player.quest["sacred_water_timer"] = 0
					player.quest["gave_sonhi_pipe"] = 0

					return
				end

				player:dialogSeq(
					{
						t,
						"Now for the story of our service. A long time ago, a great evil presence grew here. It began to affect the townsfolk, turning them into a warlike people.",
						"Nagnang has always been strong with a sword, but these people began to become crazy with power. It was only through the honor and intelligence of our Leader Kija that we managed to drive them out.",
						"But the evil stil existed. The Poets managed to banish this presence to another realm. But it grows upon war and pain and our lands are filled with it.",
						"To keep the evil in check, we created magical rabbits to keep the evil balanced. But now it is out of our control once again.",
						"It has begun to pour all of its energy into one of itself, deep in a hidden pocket of Oblivion. If the power increases too much, a hole will tear into this realm and the evil will be free once again."
					},
					1
				)

				if os.time() <= player.quest["sacred_water_timer"] then
					player:dialogSeq(
						{
							t,
							"You must wait 24 hours before I give you another sacred water."
						},
						0
					)
					return
				end

				player.quest["sacred_water_timer"] = os.time() + 86400

				-- 24 hrs
				player:dialogSeq(
					{
						sacred_water,
						"You need to take this sacred water into the realm and drop it next to the ugly green infected creature. The water will destroy it and balance will be restored once again."
					},
					1
				)
				player:addItem("sacred_water", 1)

				player:flushKills("magic_rabbit")

				player:dialogSeq(
					{
						infected_creature,
						"Note! You need to be NEXT to the creature and FACING it in order for the magic water to work! Do not lose or give this water away. That would be disrespectful."
					},
					1
				)

				player:dialogSeq(
					{
						magic_rabbit,
						"Do not kill any of the rabbits you see. They are our allegiance and our power against the evil."
					},
					1
				)

				player:dialogSeq(
					{
						t,
						"The entrance to this realm is at the pagoda just south of here. Only our order my enter. When you return... if you return... come see me, I will be most grateful for your help."
					},
					0
				)
			end

			if player.quest["nangen_acolyte"] == 0 then
				if player.quest["gave_sonhi_pipe"] == 0 then
					if player:hasItem("sonhi_pipe", 1) ~= true then
						player:sendMinitext("Hmmm, what? Oh hello, Stranger")
						return
					end

					player:removeItem("sonhi_pipe", 1)
					player.quest["gave_sonhi_pipe"] = 1
				end

				player:dialogSeq(
					{
						t,
						"Why, thank you for the pipe. I have not seen its kind since we had moved into the town. What a thoughtful gift.",
						"Perhaps not all strangers are as evil as we have thought. Hmm... Perhaps we could even ask them to assist us in our service."
					},
					1
				)

				local choice2 = player:menuSeq(
					"I wonder, would you be willing to help us? It would require you to follow the path of the Staff and of Nagnang, if only for a short while.",
					{
						"I would be honored to help you and your lovely town.",
						"I am sorry, but my path lies along another way."
					},
					{}
				)

				if choice2 == 1 then
					-- accept
					player.quest["nangen_acolyte"] = 1
					player:dialogSeq(
						{
							t,
							"Well then, you will still need to become an initiate of the Staff before we can allow you to know our secrets. You must quest to find a shard of wood that will last forever.",
							"Bring it back to me as a gift and I will allow you to be an initiate of the Staff. Note - it MUST be you who picks up the branch from the tree."
						},
						0
					)
				elseif choice2 == 2 then
					-- deny
					player:sendMinitext("Then I wish you the best of luck on your path.")
					player:sendMinitext("Thanks again for the pipe.")
					return
				end
			end
		end

		if choice2 == "Yes" then
			player:dialogSeq(
				{
					t,
					"Great! You have made a great decision. I see you becoming a great hero in these lands. Now let me set you up with some supplies."
				},
				1
			)

			player:addItem("staff_of_defense", 1)

			if player.sex == 0 then
				player:addItem("summer_robes", 1)
				player:addItem("merchant_helm", 1)
			elseif player.sex == 1 then
				player:addItem("summer_gown", 1)
				player:addItem("spring_helmet", 1)
			end

			player:addItem("herb_pipe", 4)

			player:addGold(500)
			player:updatePath(4, 0)
			player:calcStat()

			player:dialogSeq(
				{
					t,
					"Here is some armor, and a weapon. These are specific to the poet path, and will help get you started.",
					"I have also given you some gold, it's all I can spare right now. It will help you with repairs, and getting some other equipment like rings.",
					"You also have four herb pipes, these will replenish your mana. Once they are used up you should buy some more, shop keepers around town sell them",
					"If you wish to learn some skills let me know, I can teach you many things to help you in battle."
				},
				1
			)
		elseif choice2 == "Tell me more" then
			player:dialogSeq(
				{
					t,
					"Tell you about poets? Poets are the most sought after path, wanted by every other path to join them in adventures.",
					"Poets are masters of defense with the ability to heal and protect large numbers of people easily.",
					"Higher level poets gain the ability to charm animals, and can become an incredible power themselves if they have the skill."
				},
				1
			)

			local choice3 = player:menuString(
				"Will you join us now?",
				{"Yes", "No"}
			)

			if choice3 == "No" then
				player:dialogSeq(
					{
						t,
						"Very well, I will be waiting here if you change your mind. I am seeking great people all the time to join this great path."
					},
					1
				)
			elseif choice3 == "Yes" then
				player:dialogSeq(
					{
						t,
						"Great! You have made a great decision. I see you becoming a great hero in these lands. Now let me set you up with some supplies."
					},
					1
				)

				player:addItem("staff_of_defense", 1)

				if player.sex == 0 then
					player:addItem("summer_robes", 1)
				elseif player.sex == 1 then
					player:addItem("summer_gown", 1)
				end

				player:addItem("merchant_helm", 1)
				player:addItem("herb_pipe", 4)

				player:addGold(500)
				player:updatePath(4, 0)
				player:calcStat()

				player:dialogSeq(
					{
						t,
						"Here is some armor, and a weapon. These are specific to the poet path, and will help get you started.",
						"I have also given you some gold, it's all I can spare right now. It will help you with repairs, and getting some other equipment like rings.",
						"You also have four herb pipes, these will replenish your mana. Once they are used up you should buy some more, shop keepers around town sell them",
						"If you wish to learn some skills let me know, I can teach you many things to help you in battle."
					},
					1
				)
			end
		elseif choice2 == "No" then
			player:dialogSeq(
				{
					t,
					"Very well, I will be waiting here if you change your mind. I am seeking great people all the time to join this great path."
				},
				1
			)
		end

		if choice == "Poet Star 1" then
			local star = {graphic = convertGraphic(428, "item"), color = 0}
			player.npcGraphic = star.graphic
			player.npcColor = star.color
			player.dialogType = 0
			player.lastClick = npc.ID

			if player.registry["flushed_kills"] == 0 then
				player:flushKills("nine_tailed_fox")
				player.registry["flushed_kills"] = 1
			end
			player.quest["star_armor"] = 1

			player:dialogSeq({t, "Every man and woman is a star."}, 1)
			player:dialogSeq({star, "You wish to twinkle?"}, 1)
			player:dialogSeq({t, "Everyone does. Yet many have failed."}, 1)

			if not player:karmaCheck("rabbit") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to master the stars. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount("nine_tailed_fox") >= 9 then
				player.quest["star_armor"] = 2
				player:dialogSeq({t, "You have done well."}, 0)

				return
			end

			player:dialogSeq(
				{
					t,
					"One that has failed has turned to trickery and deceit. Find him. He's grown anotheer tail for each of his generations of deceit. Slay him once for each tail, then return."
				},
				0
			)
		end

		if choice == "Poet Star 2" then
			if not player:karmaCheck("rabbit") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to master the stars. Improve your karma and return."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Your hands do not show any power. Receive the power of the Sen Gloves."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if player:hasItem("sen_glove", 2) ~= true then
				player:dialogSeq(
					{
						t,
						"You are missing the gloves. Please return when you have them."
					},
					0
				)
				return
			end

			player:removeItem("sen_glove", 2)
			player.quest["star_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Star 3" then
			if not player:karmaCheck("rabbit") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to master the stars. Improve your karma and return."
					},
					0
				)
				return
			end

			local item = {}

			if player.sex == 0 then
				-- male
				item = Item("star_robes")
			elseif player.sex == 1 then
				-- female
				item = Item("star_gown")
			end

			local armor = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"To twinkle brightly, you must present that lance that twinkles most brightly."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if player:hasItem("titanium_lance", 1) ~= true then
				player:dialogSeq(
					{t, "Please come back when you have a Titanium Lance."},
					0
				)
				return
			end

			player:removeItem("titanium_lance", 1)

			local choice2 = player:dialogSeq(
				{
					armor,
					"You want to wear this armor? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseWill = player.baseWill - 1
				player.karma = player.karma - 1
				player:addItem(item.yname, 1, 0, player.ID)
				player.quest["star_armor"] = 0
				player.registry["flushed_kills"] = 0
				player:addLegend(
					"Mastered the stars (" .. curT() .. ")",
					"mastered_the_stars",
					5,
					128
				)
				player:dialogSeq({t, "It is yours."}, 0)
				player:calcStat()
			end
		end

		if choice == "Poet Moon 1" then
			if player.registry["flushed_kills"] == 0 then
				player.registry["flushed_kills"] = 1
			end
			player.quest["moon_armor"] = 1

			player:dialogSeq(
				{t, "You have returned for guidance from the moon?"},
				1
			)
			player:dialogSeq(
				{t, "Very well, but the sacrifices shall be much greater!"},
				1
			)
			player:dialogSeq(
				{
					t,
					"You follow the path of Love. Prove your devotion through sacrifice."
				},
				1
			)

			if not player:karmaCheck("ox") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to understand the moon. Improve your karma and return."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Not all victories stem from combat. Bring to me 50 roses to offer in the name of love."
				},
				1
			)

			if player:hasItem("rose", 50) ~= true then
				player:dialogSeq(
					{t, "Please return to me when you have the 50 roses."},
					0
				)
				return
			end

			player:removeItem("rose", 50)
			player.quest["moon_armor"] = 2
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Moon 2" then
			if not player:karmaCheck("ox") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to understand the moon. Improve your karma and return."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Do you understand the feeling of true companionship? Has another touched your soul?"
				},
				1
			)

			if player.partner == 0 then
				-- no marriage or blood brother/sister
				player:dialogSeq(
					{t, "Please return to me when you have made a commitment."},
					0
				)
				return
			end

			player.quest["moon_armor"] = 3
			player:dialogSeq(
				{
					t,
					"I see that you have found your true companion. That is good."
				},
				0
			)
		end

		if choice == "Poet Moon 3" then
			if not player:karmaCheck("ox") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to understand the moon. Improve your karma and return."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"For this next task, I will ask that you show me another example of commitment, mentoring 3 others."
				},
				1
			)

			if player.registry["mentored"] < 3 then
				player:dialogSeq(
					{
						t,
						"Return to me when you have mentored at least 3 others."
					},
					0
				)
				return
			end

			player.quest["moon_armor"] = 4
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Moon 4" then
			if not player:karmaCheck("ox") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to understand the moon. Improve your karma and return."
					},
					0
				)
				return
			end

			local item = {}
			local armor = {}
			if player.sex == 0 then
				-- male
				armor = Item("star_robes")
				item = Item("moon_robes")
			elseif player.sex == 1 then
				-- female
				armor = Item("star_gown")
				item = Item("moon_gown")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"I require your star garment from which to create your new clothing."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if player:hasItem(armor.yname, 1) ~= true then
				player:dialogSeq(
					{t, "Please return when you have the required item."},
					0
				)
				return
			end

			player:removeItem(armor.yname, 1)

			local choice2 = player:dialogSeq(
				{
					armorg,
					"You want to wear this clothing? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseWill = player.baseWill - 2
				player.karma = player.karma - 2
				player:addItem(item.yname, 1, 0, player.ID)
				player.quest["moon_armor"] = 0
				player.registry["flushed_kills"] = 0
				player:addLegend(
					"Understood the moon (" .. curT() .. ")",
					"understood_the_moon",
					5,
					128
				)
				player:dialogSeq({t, "It is yours."}, 0)
				player:calcStat()
			end
		end

		if choice == "Poet Sun 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("massive_scorpion")
				player:flushKills("sute")
				player.registry["flushed_kills"] = 1
			end

			player.quest["sun_armor"] = 1

			player:dialogSeq(
				{t, "The sun is the mightiest and fiercest of all."},
				1
			)
			player:dialogSeq(
				{t, "Only the very best and most true can master it."},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount("massive_scorpion") >= 1 and player:killCount("sute") >= 1 then
				player.quest["sun_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"I do not envy you, mage. For to prove your worthiness, you must slay 1 Massive Scorpion and Sute."
				},
				1
			)
		end

		if choice == "Poet Sun 2" then
			player:dialogSeq(
				{
					t,
					"Next I would like you to bring to me: 10 crafted white ambers, 1 purified water, and 6 sen gloves"
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:hasItem("crafted_white_amber", 10) ~= true or player:hasItem(
				"purified_water",
				1
			) ~= true or player:hasItem("sen_glove", 6) ~= true then
				player:dialogSeq(
					{t, "Please return when you have all the items."},
					0
				)
				return
			end

			player:removeItem("crafted_white_amber", 10)
			player:removeItem("purified_water", 1)
			player:removeItem("sen_glove", 6)

			player.quest["sun_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Sun 3" then
			player:dialogSeq(
				{
					t,
					"Next I would like you to show your devotion to the four totem animals.",
					"First I would like you to worship Chung ryong, then Baekho, then Ju Jak, and finally Hyun moo."
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"You do not need to return to me after you worship each totem, only when you have worshipped all four totems."
				},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player.quest["sun_armor_ntotem"] ~= 4 then
				player:dialogSeq(
					{
						t,
						"You have yet to worship all four totems, please return to me when you have done so."
					},
					0
				)
				return
			end

			player.quest["sun_armor"] = 4
			player.quest["sun_armor_ntotem"] = 0

			-- reset registry
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Sun 4" then
			player:dialogSeq(
				{
					t,
					"Next I would like to see your devotion to the crafts. You will need to be the level of Adept or higher in either Tailoring, Smithing, or Carpentry"
				},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if crafting.checkSkillLevel(player, "tailoring", "adept") or crafting.checkSkillLevel(
				player,
				"metalworking",
				"adept"
			) or crafting.checkSkillLevel(player, "woodworking", "adept") then
				player.quest["sun_armor"] = 5
				player:dialogSeq(
					{t, "You have shown your devotion to the crafts."},
					0
				)
				return
			else
				player:dialogSeq(
					{
						t,
						"Return to me when you have achieved Adept status in Tailoring, Smithing, or Carpentry."
					},
					0
				)
			end
		end

		if choice == "Poet Sun 5" then
			player:dialogSeq({t, "Next I will require 2 Titanium Lances"}, 1)

			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:hasItem("titanium_lance", 2) ~= true then
				player:dialogSeq(
					{t, "Return when you have 2 titanium lances"},
					0
				)
				return
			end

			player:removeItem("titanium_lance", 2)

			player.quest["sun_armor"] = 6
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Poet Sun 6" then
			local item = {}
			local armor = {}
			if player.sex == 0 then
				-- male
				armor = Item("moon_robes")
				item = Item("sun_robes")
			elseif player.sex == 1 then
				-- female
				armor = Item("moon_gown")
				item = Item("sun_gown")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq({t, "Please present your moon garment"}, 1)

			player:dialogSeq(
				{
					t,
					"((Press \"Next\" ONLY if you are ready to have your items taken. Otherwise, Press \"Quit\".))"
				},
				1
			)

			if not player:karmaCheck("bear") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:hasItem(armor.yname, 1) ~= true then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			player:removeItem(armor.yname, 1)

			player:dialogSeq(
				{
					t,
					"You have persevered through many trials. A mighty reward is almost yours!"
				},
				1
			)

			local choice2 = player:dialogSeq(
				{
					armorg,
					"You want to wear this armor? It shall drain your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseWill = player.baseWill - 3
				player:removeKarma(5)
				player:addItem(item.yname, 1, 0, player.ID)
				player.registry["flushed_kills"] = 0
				player.quest["sun_armor"] = 0
				player:addLegend(
					"Survived the sun (" .. curT() .. ")",
					"survived_the_sun",
					5,
					128
				)
				player:dialogSeq({t, "It is yours."}, 0)
				player:calcStat()
			end
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

		if speech == "quest" or speech == "minor" or speech == "minor quest" then
			MinorQuest.quest(player, npc)
		elseif speech == "complete" or speech "complete quest" then
			MinorQuest.complete(player, npc)
		end
	end)
}
