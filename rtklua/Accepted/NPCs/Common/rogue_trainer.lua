RogueTrainerNpc = {
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
			table.insert(opts, "Become a Rogue")
		elseif player.baseClass == 2 then
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

		if (npc.mapTitle == "Dagger" and player.baseClass == 2 and player.quest["dagger_blue_rooster"] ~= 0 and not player:hasLegend("dagger_guild_member")) then
			table.insert(opts, "Blue Rooster")
		end

		if npc.mapTitle == "Dagger" and player.level >= 10 and player.baseClass == 2 and not player:hasLegend("dagger_guild_member") then
			table.insert(opts, "Dagger Strangers")
		end

		if player.baseClass == 2 then
			if player.level >= 66 and player:hasLegend("blessed_by_the_stars") and not player:hasLegend("mastered_the_stars") then
				if player.quest["star_armor"] == 0 or player.quest["star_armor"] == 1 then
					table.insert(opts, "Rogue Star 1")
				elseif player.quest["star_armor"] == 2 then
					table.insert(opts, "Rogue Star 2")
				elseif player.quest["star_armor"] == 3 then
					table.insert(opts, "Rogue Star 3")
				end
			end
		end

		if player.baseClass == 2 then
			if player.level >= 76 and player:hasLegend("mastered_the_stars") and not player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["moon_armor"] == 0 or player.quest["moon_armor"] == 1 then
					table.insert(opts, "Rogue Moon 1")
				elseif player.quest["moon_armor"] == 2 then
					table.insert(opts, "Rogue Moon 2")
				elseif player.quest["moon_armor"] == 3 then
					table.insert(opts, "Rogue Moon 3")
				elseif player.quest["moon_armor"] == 4 then
					table.insert(opts, "Rogue Moon 4")
				end
			end
		end

		if player.baseClass == 2 then
			if player.level >= 86 and player:hasLegend("mastered_the_stars") and player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") or player.gmLevel > 0 then
				if player.quest["sun_armor"] == 0 or player.quest["sun_armor"] == 1 then
					table.insert(opts, "Rogue Sun 1")
				elseif player.quest["sun_armor"] == 2 then
					table.insert(opts, "Rogue Sun 2")
				elseif player.quest["sun_armor"] == 3 then
					table.insert(opts, "Rogue Sun 3")
				elseif player.quest["sun_armor"] == 4 then
					table.insert(opts, "Rogue Sun 4")
				elseif player.quest["sun_armor"] == 5 then
					table.insert(opts, "Rogue Sun 5")
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
		elseif choice == "Become a Rogue" then
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
					"Hail, mighty one! Welcome to my sanctuary, the sanctuary of the deadliest of all fighters!.",
					"Have you come to pick your path? I think you would make a great rogue, and a great hero."
				},
				1
			)
			choice2 = player:menuString(
				"Will you join the path of the rogue?",
				{"Yes", "Tell me more", "No"}
			)
		elseif choice == "Divine Secret" then
			if npc.mapTitle == "Dagger" and player.alignment == 0 then
				player:futureSpells(npc, {"daggers_remedy_rogue"})
			elseif npc.mapTitle == "Dagger" and player.alignment == 1 then
				player:futureSpells(npc, {"kwisin_daggers_remedy_rogue"})
			elseif npc.mapTitle == "Dagger" and player.alignment == 2 then
				player:futureSpells(npc, {"mingken_daggers_remedy_rogue"})
			elseif npc.mapTitle == "Dagger" and player.alignment == 3 then
				player:futureSpells(npc, {"ohaeng_daggers_remedy_rogue"})
			else
				player:futureSpells(npc)
			end
		elseif choice == "Learn Secret" then
			if npc.mapTitle == "Dagger" and player.mark >= 2 and player.alignment == 0 then
				player:learnSpell(npc, {"daggers_remedy_rogue"})
			elseif npc.mapTitle == "Dagger" and player.mark >= 2 and player.alignment == 1 then
				player:learnSpell(npc, {"kwisin_daggers_remedy_rogue"})

				-- was KWI-Sin Dagger (but this doesn't happen
			elseif npc.mapTitle == "Dagger" and player.mark >= 2 and player.alignment == 2 then
				player:learnSpell(npc, {"mingken_daggers_remedy_rogue"})

				-- was Ming-Ken Dagger (but this doesn't happen
			elseif npc.mapTitle == "Dagger" and player.mark >= 2 and player.alignment == 3 then
				player:learnSpell(npc, {"ohaeng_daggers_remedy_rogue"})

				-- was Ohaeng (but this doesn't happen
			else
				player:learnSpell(npc)
			end
		elseif choice == "Forget Secret" then
			player:forgetSpell(npc)
		elseif choice == "Dagger Strangers" then
			if player:hasLegend("dagger_guild_member") then
				return
			end

			if player.quest["dagger_blue_rooster"] ~= 0 then
				return
			end

			if player.quest["dagger_clicked"] == 0 then
				player:sendMinitext("I shall not speak with you Ever.")
				player.quest["dagger_clicked"] = 1
				return
			end

			if player.quest["dagger_clicked"] == 1 then
				player:sendMinitext("Bother me again, and you shall die seeing what hides in the shadows.")
				player.quest["dagger_clicked"] = 2
				return
			end

			if player.quest["dagger_clicked"] == 2 then
				player:sendMinitext("This  is what you get for your annoyance. Attack!")
				player.quest["dagger_clicked"] = 3

				-- spawn 3 mobs that look just like npc, despawn after 5 seconds if player goes out of range
				npc:spawn("dagger_assassin", npc.x - 1, npc.y, 1)
				npc:spawn("dagger_assassin", npc.x + 1, npc.y, 1)
				npc:spawn("dagger_assassin", npc.x, npc.y + 1, 1)
				return
			end

			if player.quest["dagger_clicked"] == 3 then
				player.quest["dagger_blue_rooster"] = 1
				player:dialogSeq(
					{
						t,
						"So, you still return to me even after the assault. You have a glimmer of promise... or stupidity. Return when you see a Blue Rooster."
					},
					0
				)
				return
			end
		elseif choice == "Blue Rooster" then
			if player.quest["dagger_blue_rooster"] == 3 then
				if player.quest["handed_maso_scroll"] == 0 then
					player:dialogSeq(
						{
							t,
							"I am still waiting for you to finish your last task."
						},
						0
					)
					return
				end

				player:addItem("round_buckler", 1, 0, player.ID)
				player:addLegend(
					"Member of Dagger's guild (" .. curT() .. ")",
					"dagger_guild_member",
					9,
					128
				)
				player.quest["dagger_clicked"] = 0
				player.quest["dagger_blue_rooster"] = 0
				player.quest["crow_took_silvery_acorn"] = 0
				player.quest["crow_took_silvery_acorn2"] = 0
				player.quest["handed_maso_scroll"] = 0
				player.quest["seen_blue_rooster"] = 0

				player:dialogSeq(
					{
						t,
						"Very good! You have shown yourself to be worthy of the Daggers' protection.",
						"Take this shield. It offers protection without hindering your agility or stealth.",
						"May it aid you in your future missions. This is the only one I shall ever give you."
					},
					1
				)
				return
			end

			if player.quest["dagger_blue_rooster"] == 2 then
				if player:hasItem("silvered_acorn", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"First, go to that pretender Maro in Kugnae.",
							"He keeps in his pocket a Silver acorn for good luck. Snatch it for me to show that even your prowness is better than his."
						},
						0
					)
					return
				end

				player:removeItem("silvered_acorn", 1)
				player:addItem("maso_scroll", 1)

				player.quest["dagger_blue_rooster"] = 3
				player:dialogSeq(
					{
						t,
						"So you have managed to capture the acorn from that fool, Maro, eh? Good for you. Now it is time for you to pull the wool over Maso's eyes in Buya.",
						"I'll take that acorn and place it somewhere safe. Take this scroll and slide it into Maso's pocket. It is easy to be a pickpocket, a bit harder to be a put-pocket.",
						"If you finish with that, and return to me with the ability to learn a spell, then you will be worthy of wearing the uniform of the Daggers."
					},
					0
				)
				return
			end

			if player.quest["seen_blue_rooster"] == 0 then
				player:dialogSeq(
					{t, "Return to me when you see a Blue Rooster."},
					0
				)
				return
			end

			player.quest["dagger_blue_rooster"] = 2
			player:dialogSeq(
				{
					t,
					"Ah, seen the Blue Rooster have you? That is good that you came at my summoning.",
					"I have decided that many of you Strangers may make very good additions to my little clan. Perhaps the ways of the Night will not be lost.",
					"But first, I need to see if you have what it takes. The other so called Rogue masters are merely pretenders. First, go to that pretender Maro in Kugnae.",
					"He keeps in his pocket a Silver acorn for good luck. Snatch it for me to show that even your prowness is better than his."
				},
				0
			)
		end

		if choice2 == "Yes" then
			player:dialogSeq(
				{
					t,
					"Great! You have made a great decision. I see you becoming a great hero in these lands. Now let me set you up with some supplies."
				},
				1
			)

			player:addItem("swift_dagger", 1)
			player:addItem("bears_liver", 26)
			if player.sex == 0 then
				player:addItem("merchant_waistcoat", 1)
				player:addItem("merchant_helm", 1)
			elseif player.sex == 1 then
				player:addItem("summer_blouse", 1)
				player:addItem("spring_helmet", 1)
			end

			player:addGold(500)
			player:updatePath(2, 0)
			player:calcStat()

			player:dialogSeq(
				{
					t,
					"Here is some armor, and a weapon. These are specific to the rogue path, and will help get you started.",
					"I have also given you some gold, it's all I can spare right now. It will help you with repairs, and getting some other equipment like rings.",
					"I have also given you some Bear's livers, these will help you keep your strength up. Eat one when you are feeling weak, and near death. Shop keepers around town sell them if you need more.",
					"If you wish to learn some skills let me know, I can teach you many things to help you in battle."
				},
				1
			)
		elseif choice2 == "Tell me more" then
			player:dialogSeq(
				{
					t,
					"Tell you about rogues? Well, they are the deadliest of the fighter classes. Nible, agile, fast, and unmatched one on one, a true assassin.",
					"Rogues use some magic during their battles, and many skills for attacking a foe. We only attack one at a time, but we kill quickly, and efficiently, moving too quick to be hit easily.",
					"We can solo single creatures with great skill, for larger battles we need a little help from a healer."
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

				player:addItem("swift_dagger", 1)
				player:addItem("bears_liver", 26)
				if player.sex == 0 then
					player:addItem("summer_armor", 1)
				elseif player.sex == 1 then
					player:addItem("summer_armor_dress", 1)
				end

				player:addItem("spring_helmet", 1)

				player:addGold(500)
				player:updatePath(2, 0)
				player:calcStat()

				player:dialogSeq(
					{
						t,
						"Here is some armor, and a weapon. These are specific to the warrior path, and will help get you started.",
						"I have also given you some gold, it's all I can spare right now. It will help you with repairs, and getting some other equipment like rings.",
						"I have also given you some Bear's livers, these will help you keep your strength up. Eat one when you are feeling weak, and near death. Shop keepers around town sell them if you need more.",
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

		if choice == "Rogue Star 1" then
			local star = {graphic = convertGraphic(428, "item"), color = 0}
			player.npcGraphic = star.graphic
			player.npcColor = star.color
			player.dialogType = 0
			player.lastClick = npc.ID

			if player.registry["flushed_kills"] == 0 then
				player:flushKills("muck_ogre")
				player:flushKills("slime_ogre")
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

			if player:killCount("slime_ogre") >= 2 or player:killCount("muck_ogre") >= 2 then
				player.quest["star_armor"] = 2
				player:dialogSeq({t, "You have done well."}, 0)

				return
			end

			player:dialogSeq(
				{
					t,
					"Among the failures are the ogres. Even the most agile ones lack light. Slay 2 of the Slime Ogres or 2 of the Muck Ogres, then return."
				},
				0
			)
			return
		end

		if choice == "Rogue Star 2" then
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
					"You have proven your strength, but what of your grace? Bring me two of the silent bands."
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

			if player:hasItem("whisper_bracelet", 2) ~= true then
				player:dialogSeq(
					{
						t,
						"You are missing the bracelets. Please return when you have them."
					},
					0
				)
				return
			end

			player:removeItem("whisper_bracelet", 2)
			player.quest["star_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Rogue Star 3" then
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
				item = Item("star_waistcoat")
			elseif player.sex == 1 then
				-- female
				item = Item("star_blouse")
			end

			local armor = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"To truly shine with the light of the stars, you must also bring the sword that glows with the star's light."
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

			if player:hasItem("steelthorn", 1) ~= true then
				player:dialogSeq(
					{t, "Please come back when you have a Steelthorn."},
					0
				)
				return
			end

			player:removeItem("steelthorn", 1)

			local choice2 = player:dialogSeq(
				{
					armor,
					"You want to wear this armor? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseGrace = player.baseGrace - 1
				player.karma = player.karma - 1
				player:addItem(item.yname, 1, 0, player.ID)
				player.quest["star_armor"] = 0
				player.quest["flushed_kills"] = 0
				player:addLegend(
					"Mastered the stars (" .. curT() .. ")",
					"mastered_the_stars",
					5,
					128
				)
				player:dialogSeq({t, "You have done well."}, 0)
				player:calcStat()
			end
		end

		if choice == "Rogue Moon 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("dog_assassin")

				-- dog 1
				player:flushKills("dog_cutthroat")

				-- dog 2
				player:flushKills("dog_avenger")

				-- dog 3
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
				{t, "You follow the path of Riches. Prove your worth."},
				1
			)

			if not player:karmaCheck("dog") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to understand the moon. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount("dog_assassin") >= 1 or player:killCount("dog_cutthroat") >= 1 or player:killCount("dog_avenger") >= 1 then
				player.quest["moon_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			if not player:karmaCheck("dog") then
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
					"Dogs in town teach secrets to many. But most animals are not so pure. Slay the Dog that defiles the beautiful rose by carrying it in his mouth."
				},
				1
			)
		end

		if choice == "Rogue Moon 2" then
			if not player:karmaCheck("dog") then
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
					"You follow the path of Riches. Prove your worth. Bring to me all of the following AT THE SAME TIME."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"The full moon drips upon the earth, seeping into the ground. Bring fifty spheres of sweet amber.",
					"The dark moon drips still deeper into the earth. Bring ten of this darker amber.",
					"Only the stealthiest can don this garment. Bring two whisper bracelets to quiet your hands.",
					"Bring me two steelthorns to cut the moon's material.",
					"The moon favors the lucky. Bring also one of the lucky coins."
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

			--player:dialogSeq({t,"Bring me 2 Whisper Bracelets, 2 Steelthorns, 50 Ambers, 10 Dark Ambers, 1 Lucky Coin, and 15,000 coins."},1)

			if player:hasItem("whisper_bracelet", 2) ~= true or player:hasItem(
				"steelthorn",
				2
			) ~= true or player:hasItem("amber", 50) ~= true or player:hasItem(
				"dark_amber",
				10
			) ~= true or player:hasItem("lucky_coin", 1) ~= true or player.money < 15000 then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			player:removeItem("whisper_bracelet", 2)
			player:removeItem("steelthorn", 2)
			player:removeItem("amber", 50)
			player:removeItem("dark_amber", 10)
			player:removeItem("lucky_coin", 1)
			player.money = player.money - 15000
			player:sendStatus()

			player.quest["moon_armor"] = 3
			player.registry["flushed_kills"] = 0
			player:dialogSeq({t, "You have proven your material worth."}, 0)
		end

		if choice == "Rogue Moon 3" then
			if not player:karmaCheck("dog") then
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
					"Soon, my impatient rogue friend. Now display to me your White Moon Axe. I will bond it to your soul, so that no otheer may wield it."
				},
				1
			)

			if player:hasItem("white_moon_axe", 1) ~= true then
				player:dialogSeq({t, "Please return when you have the axe."}, 0)
				return
			end

			player:removeItem("white_moon_axe", 1)
			player:addItem("white_moon_axe", 1, 0, player.ID)
			player.quest["moon_armor"] = 4
			player.registry["flushed_kills"] = 0
			player:dialogSeq({t, "You have done well."}, 0)
			return
		end

		if choice == "Rogue Moon 4" then
			if not player:karmaCheck("dog") then
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
				armor = Item("star_waistcoat")
				item = Item("moon_waistcoat")
			elseif player.sex == 1 then
				-- female
				armor = Item("star_blouse")
				item = Item("moon_blouse")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"The moon's power is not harnessed so easily! Bring me your star blouse."
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
					"You want to wear this armor? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseGrace = player.baseGrace - 2
				player.karma = player.karma - 2
				player:addItem(item.yname, 1, 0, player.ID)
				player.quest["moon_armor"] = 0
				player:addLegend(
					"Understood the moon (" .. curT() .. ")",
					"understood_the_moon",
					5,
					128
				)
				player:dialogSeq({t, "You have done well."}, 0)
				player:calcStat()
			end
		end

		if choice == "Rogue Sun 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("ice_panther")

				-- ogres
				player:flushKills("ogre_citelam")

				-- ogres
				player:flushKills("squirrel")

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

			if player:killCount("ice_panther") >= 12 and player:killCount("ogre_citelam") >= 1 then
				player.quest["sun_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			elseif player:killCount("ice_panther") < 12 then
				player:dialogSeq(
					{
						t,
						"You have not killed enough Ice panthers. You need to slay 12 of them and return to me."
					},
					0
				)
				return
			elseif player:killCount("ogre_citelam") < 1 then
				player:dialogSeq(
					{t, "I am still waiting for you to slay Citelam."},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"I do not envy you, rogue. For to prove your worthiness, you must slay a dozen ice panthers and the dreaded Citelam! If you survive, return so that we may continue."
				},
				1
			)
		end

		if choice == "Rogue Sun 2" then
			local normalRatMobs = {
				"mythic_mouse",
				"vile_rat",
				"blood_rat",
				"rat_sentry",
				"divine_mouse",
				"mud_rat",
				"hunter_rat",
				"lava_rat",
				"rat_guardian",
				"spirit_mouse",
				"earth_rat",
				"fire_rat",
				"beady_eyed_stalker",
				"rat_defender"
			}

			if player.registry["flushed_kills"] == 0 then
				for i = 1, #normalRatMobs do
					player:flushKills(normalRatMobs[i])
				end

				player:flushKills("mythic_rat")

				-- rat 1 bosses
				player:flushKills("mighty_mouse")
				player:flushKills("divine_rat")

				-- rat 2 bosses
				player:flushKills("rat_lord")
				player:flushKills("spirit_rat")

				-- rat 3 bosses
				player:flushKills("rat_avenger")
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{
					t,
					"You have proven your melee prowess. But there is much more to being a rogue, is there not?"
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"Prove now your skill and stealth. Slay the two leaders of the rats, WITHOUT killing any other creatures in the rats cave."
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

			for i = 1, #normalRatMobs do
				-- scans the basic mobs in all mythic rat cave levels, looking for any kills
				if player:killCount(normalRatMobs[i]) >= 1 then
					player.registry["flushed_kills"] = 0
					player:dialogSeq(
						{
							t,
							"You slew a beast you should not have touched. Try again."
						},
						0
					)
					return
				end
			end

			if ((player:killCount("mythic_rat") >= 1 and player:killCount("mighty_mouse") >= 1) or (player:killCount("divine_rat") >= 1 and player:killCount("rat_lord") >= 1) or (player:killCount("spirit_rat") >= 1 and player:killCount("rat_avenger") >= 1)) then
				player.quest["sun_armor"] = 3
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end
		end

		if choice == "Rogue Sun 3" then
			local caveLevel = player:mythicCaveReqCheck("rabbit")
			local mobboss1 = ""
			local mobboss2 = ""
			local normalRabbitMobs = {
				"golden_hare",
				"mad_rabbit",
				"giant_hare",
				"rabbit_sentry",
				"golden_rabbit",
				"mad_hare",
				"giant_rabbit",
				"rabbit_guardian",
				"hop",
				"thump",
				"fluff",
				"rabbit_defender"
			}

			if caveLevel == 1 then
				mobboss1 = "Mythic hare"
				mobboss2 = "Hare witch"
			elseif caveLevel == 2 then
				mobboss1 = "Divine rabbit"
				mobboss2 = "Rabbit witch"
			elseif caveLevel == 3 then
				mobboss1 = "Spirit rabbit"
				mobboss2 = "Rabbit avenger"
			end

			if player.registry["flushed_kills"] == 0 then
				for i = 1, #normalRabbitMobs do
					player:flushKills(normalRabbitMobs[i])
				end

				player:flushKills("mythic_hare")

				-- rabbit 1 bosses
				player:flushKills("hare_witch")
				player:flushKills("divine_rabbit")

				-- rabbit 2 bosses
				player:flushKills("rabbit_witch")
				player:flushKills("spirit_rabbit")

				-- rabbit 3 bosses
				player:flushKills("rabbit_avenger")
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{
					t,
					"Ah, but it is easy to defeat the clumsy rats with stealth! Now for a real challenge."
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"Slay the crafty " .. mobboss1 .. " and " .. mobboss2 .. ", WITHOUT killing any other creatures in that cave."
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

			for i = 1, #normalRabbitMobs do
				-- scans the basic mobs in all mythic rat cave levels, looking for any kills
				if player:killCount(normalRabbitMobs[i]) >= 1 then
					player:flushKills(normalRabbitMobs[i])
					player.registry["flushed_kills"] = 0
					player:dialogSeq(
						{
							t,
							"You slew a beast you should not have touched. Try again."
						},
						0
					)
					return
				end
			end

			if ((player:killCount("mythic_hare") >= 1 and player:killCount("hare_witch") >= 1) or (player:killCount("divine_rabbit") >= 1 and player:killCount("rabbit_witch") >= 1) or (player:killCount("spirit_rabbit") >= 1 and player:killCount("rabbit_avenger") >= 1)) then
				player.quest["sun_armor"] = 4
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end
		end

		if choice == "Rogue Sun 4" then
			player:dialogSeq(
				{
					t,
					"Your stealth is impressive! But your Path is that of Riches, not stealth. Bring me 50,000 gold coins, eight steelthorns, five whisper bracelets and six corrupted rings."
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

			if player.money < 50000 then
				player:dialogSeq({t, "Return when you have enough gold."}, 0)
				return
			end

			if player:hasItem("steelthorn", 8) ~= true or player:hasItem(
				"whisper_bracelet",
				5
			) ~= true or player:hasItem("corrupted_ring", 6) ~= true then
				player:dialogSeq(
					{t, "Return when you have all the required items."},
					0
				)
				return
			end

			player:removeGold(50000)
			player:removeItem("steelthorn", math.random(1, 4))
			player:removeItem("whisper_bracelet", math.random(1, 2))
			player:removeItem("corrupted_ring", math.random(1, 3))

			player.quest["sun_armor"] = 5
			player:dialogSeq(
				{t, "You have done well. I'll let ya keep most of the goods."},
				0
			)
		end

		if choice == "Rogue Sun 5" then
			local item = {}
			local armor = {}
			if player.sex == 0 then
				-- male
				armor = Item("moon_waistcoat")
				item = Item("sun_waistcoat")
			elseif player.sex == 1 then
				-- female
				armor = Item("moon_blouse")
				item = Item("sun_blouse")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"Did you think it was so easy? Your work is still very far from complete. But your pride is too strong. Your greed is too strong also. I see."
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"Humble yourself. Collect 20 gold acorns while you kill 200 squirrels. When you return, bring your unequipped moon garment with you."
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

			if player:killCount("squirrel") < 200 then
				player:dialogSeq(
					{t, "Return when you have slain 200 squirrels."},
					0
				)
				return
			end

			if player:hasItem(armor.yname, 1) ~= true or player:hasItem("gold_acorn", 20) ~= true then
				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			player:removeItem(armor.yname, 1)
			player:removeItem("gold_acorn", 20)

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
				player.baseMight = player.baseMight - 2
				player.baseGrace = player.baseGrace - 3
				player:removeKarma(3)
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

		if speech == "lockpick" then
			if npc.mapTitle == "Maso Sanctum" or npc.mapTitle == "Kwi-Sin Maso" or npc.mapTitle == "Ming-Ken Maso" or npc.mapTitle == "Ohaeng Maso" then
				Tools.checkKarma(player)

				if player.quest["maso_lockpick"] == 0 then
					return
				end

				if player.quest["maso_lockpick"] == 1 then
					player:dialogSeq(
						{
							t,
							"So, you need a lock pick eh? Who told you I could make it?",
							"It doesn't matter, I will find out myself. Anyways, you need one, huh?",
							"I usually keep these just for special people, but since you already know about it, I guess it wouldn't hurt.",
							"It's not like you have the skill needed for it, it usually takes more than just a \"jiggle\" to get a door open.",
							"Now let's see, I will need a piece of Wood for it, and a Fine steel dagger to carve it with."
						},
						0
					)

					if player:hasItem("wood_scraps", 1) ~= true or player:hasItem(
						"fine_steel_dagger",
						1
					) ~= true then
						player:dialogSeq(
							{
								t,
								"I can make you the lockpick as soon as you have the required items, a wood scrap and a fine steel dagger."
							},
							0
						)
						return
					end

					player:removeItem("wood_scraps", 1)
					player:removeItem("fine_steel_dagger", 1)
					player:addItem("lockpick", 1)

					player:dialogSeq(
						{
							t,
							"There you go, good luck using it... and don't break it, it's very delicate."
						},
						0
					)
				end
			end
		elseif speech == "quest" or speech == "minor" or speech == "minor quest" then
			MinorQuest.quest(player, npc)
		elseif speech == "complete" or speech "complete quest" then
			MinorQuest.complete(player, npc)
		end
	end),

	handItem = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local invItem = player:getInventoryItem(player.invSlot)

		if npc.mapTitle == "Maso Sanctum" or npc.mapTitle == "Kwi-Sin Maso" or npc.mapTitle == "Ming-Ken Maso" or npc.mapTitle == "Ohaeng Maso" then
			if invItem.yname == "maso_scroll" and player.quest["dagger_blue_rooster"] == 3 then
				player:removeItem("maso_scroll", 1)
				player.quest["handed_maso_scroll"] = 1
				player:dialogSeq(
					{
						t,
						"\".....Eh? What is this?....\"",
						"\"That arrogant fool! Does Maro really believe that he can destroy me?!!! I will have to take some actions against him...\""
					},
					0
				)
			end
		end
	end)
}
