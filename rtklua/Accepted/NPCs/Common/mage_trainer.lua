MageTrainerNpc = {
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
			table.insert(opts, "Become a Mage")
		elseif player.baseClass == 3 then
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

		if player.baseClass == 3 then
			if player.level >= 66 and player:hasLegend("blessed_by_the_stars") and not player:hasLegend("mastered_the_stars") then
				if player.quest["star_armor"] == 0 or player.quest["star_armor"] == 1 then
					table.insert(opts, "Mage Star 1")
				elseif player.quest["star_armor"] == 2 then
					table.insert(opts, "Mage Star 2")
				elseif player.quest["star_armor"] == 3 then
					table.insert(opts, "Mage Star 3")
				end
			end
		end

		if player.baseClass == 3 then
			if player.level >= 76 and player:hasLegend("mastered_the_stars") and not player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["moon_armor"] == 0 or player.quest["moon_armor"] == 1 then
					table.insert(opts, "Mage Moon 1")
				elseif player.quest["moon_armor"] == 2 then
					table.insert(opts, "Mage Moon 2")
				elseif player.quest["moon_armor"] == 3 then
					table.insert(opts, "Mage Moon 3")
				elseif player.quest["moon_armor"] == 4 then
					table.insert(opts, "Mage Moon 4")
				elseif player.quest["moon_armor"] == 5 then
					table.insert(opts, "Mage Moon 5")
				end
			end
		end

		if player.baseClass == 3 then
			if player.level >= 86 and player:hasLegend("mastered_the_stars") and player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["sun_armor"] == 0 or player.quest["sun_armor"] == 1 then
					table.insert(opts, "Mage Sun 1")
				elseif player.quest["sun_armor"] == 2 then
					table.insert(opts, "Mage Sun 2")
				elseif player.quest["sun_armor"] == 3 then
					table.insert(opts, "Mage Sun 3")
				elseif player.quest["sun_armor"] == 4 then
					table.insert(opts, "Mage Sun 4")
				elseif player.quest["sun_armor"] == 5 then
					table.insert(opts, "Mage Sun 5")
				elseif player.quest["sun_armor"] == 6 then
					table.insert(opts, "Mage Sun 6")
				elseif player.quest["sun_armor"] == 7 then
					table.insert(opts, "Mage Sun 7")
				elseif player.quest["sun_armor"] == 8 then
					table.insert(opts, "Mage Sun 8")
				end
			end
		end

		if npc.mapTitle == "Wand" and player.level >= 10 and player.baseClass == 3 and not player:hasLegend("family_nangen_mages") then
			table.insert(opts, "Ward")
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
		elseif choice == "Become a Mage" then
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
					"Hail, mighty one! Welcome to my sanctuary, the sanctuary of the great magic users.",
					"Have you come to pick your path? I think you would make a great mage, and a great hero."
				},
				1
			)
			choice2 = player:menuString(
				"Will you join the path of the mage?",
				{"Yes", "Tell me more", "No"}
			)
		elseif choice == "Divine Secret" then
			player:futureSpells(npc)
		elseif choice == "Learn Secret" then
			player:learnSpell(npc)
		elseif choice == "Forget Secret" then
			player:forgetSpell(npc)
		elseif choice == "Strangers" then
			player:sendMinitext("I have nothing for you, Stranger.")
		elseif choice == "Ward" then
			if player.quest["mage_ward"] == 1 then
				if player.quest["zapped_yin_mouse"] == 0 or player.quest["zapped_yang_mouse"] == 0 or player.quest[
					"zapped_void_mouse"
				] == 0 or player.quest["mage_ward_met_ghost"] == 0 or player:hasItem(
					"rose",
					1
				) ~= true or player:hasItem("ore_high", 1) ~= true then
					player:sendMinitext("You have not completed all of the tasks handed to you.")
					return
				end

				player:removeItem("ore_high", 1)
				player:removeItem("rose", 1)

				if not player:hasLegend("family_nangen_mages") then
					player:addLegend(
						"Family to the Nangen Mages (" .. curT() .. ")",
						"family_nangen_mages",
						3,
						128
					)
				end

				-- unset values
				player.quest["zapped_yin_mouse"] = 0
				player.quest["zapped_yang_mouse"] = 0
				player.quest["zapped_void_mouse"] = 0
				player.quest["mage_ward_met_ghost"] = 0
				player.quest["mage_ward"] = 0

				player:addItem("magicians_ward", 1, 0, player.ID)

				player:dialogSeq(
					{
						t,
						"You have learned well and earned the protection of the Nangen Mages. Take this ward, forged long ago by the same prophets who instructed you in our ways.",
						"It will not only boost your magical strength but also shield you in your upcoming battles. This is the only one I shall ever give you."
					},
					0
				)

				return
			end

			player:dialogSeq(
				{
					t,
					"Ah, I see that you have come for the knowledge of the Mages of Nagnang."
				},
				1
			)
			local choice = player:menuSeq(
				"Well, I am not the person who has the knowledge, merely the one who tells those who are worthy where to seek out that knowledge. Are you such a worthy person?",
				{"Yes, I am worthy", "No, I am not worthy."},
				{}
			)

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"Well then, I will tell you where to find the knowledge you seek. Above this cave, there is another. Inside of it is the home to three prohets.",
						"Each embodies a mystical force. One is for Yin, the other, Yang and the third is the Void. Each of them will evaluate your potential and will then instruct you on what to do.",
						"If you follow their instructions, and prove to me that you are honorable and wise by returning here after completing all of their tasks, I will reward you with a protective ward.",
						"To visit each prophet, you need to first attack one of the mice with a spell and then curse that same immortal mouse. The creature will die as an offering and you can then enter.",
						"Take care to curse only ONE creature before entering each room. If you curse more, the wise men will not speak with you and you will need to return to me.",
						"I also implore you, listen to ALL of them and all they have to say. If you do not, I will not grant you the ward."
					},
					1
				)
				player.quest["mage_ward"] = 1
				player:sendMinitext("Good luck.")
			elseif choice == 2 then
				player:sendMinitext("I admire your honesty.")
				return
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

			player:addItem("staff_of_power", 1)

			if player.sex == 0 then
				player:addItem("summer_garb", 1)
				player:addItem("merchant_helm", 1)
			elseif player.sex == 1 then
				player:addItem("summer_dress", 1)
				player:addItem("spring_helmet", 1)
			end

			player:addItem("herb_pipe", 4)

			player:addGold(500)
			player:updatePath(3, 0)
			player:calcStat()

			player:dialogSeq(
				{
					t,
					"Here is some armor, and a weapon. These are specific to the mage path, and will help get you started.",
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
					"Tell you about mages? Well, mages are the magic users of the land, combining great offensive and defensive magic.",
					"We use magic to subdue our foes, and to conquer all who stand before us. We can also use our great powers defensively, to heal and save ourselves, or others.",
					"The mage is a self contained hunter, and can easily solo hunt without the aid of others, however it is always best to join others - safety in numbers!"
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

				player:addItem("staff_of_power", 1)

				if player.sex == 0 then
					player:addItem("summer_garb", 1)
				elseif player.sex == 1 then
					player:addItem("summer_dress", 1)
				end

				player:addItem("spring_helmet", 1)
				player:addItem("herb_pipe", 4)

				player:addGold(500)
				player:updatePath(3, 0)
				player:calcStat()

				player:dialogSeq(
					{
						t,
						"Here is some armor, and a weapon. These are specific to the mage path, and will help get you started.",
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

		if choice == "Mage Star 1" then
			local star = {graphic = convertGraphic(428, "item"), color = 0}
			player.npcGraphic = star.graphic
			player.npcColor = star.color
			player.dialogType = 0
			player.lastClick = npc.ID

			if player.registry["flushed_kills"] == 0 then
				player:flushKills("skeleton_mage")
				player:flushKills("skeleton_warrior")
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

			if player:killCount("skeleton_mage") >= 1 and player:killCount("skeleton_warrior") >= 1 then
				player.quest["star_armor"] = 2
				player:dialogSeq({t, "You have done well."}, 0)

				return
			end

			player:dialogSeq(
				{
					t,
					"Among the failures are the Skeleton Mage and Skeleton Warrior. Slay both of them, then return."
				},
				0
			)
		end

		if choice == "Mage Star 2" then
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
					"You have the speed of a star, but have you its strength? Bring me two holy rings."
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

			if player:hasItem("holy_ring", 2) ~= true then
				player:dialogSeq(
					{
						t,
						"You are missing the rings. Please return when you have them."
					},
					0
				)
				return
			end

			player:removeItem("holy_ring", 2)
			player.quest["star_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Mage Star 3" then
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
				item = Item("star_garb")
			elseif player.sex == 1 then
				-- female
				item = Item("star_dress")
			end

			local armor = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"To truly shine with the light of the stars, you must also bring the staff that glows with the star's light."
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

			if player:hasItem("star_staff", 1) ~= true then
				player:dialogSeq(
					{t, "Please come back when you have a Star-staff."},
					0
				)
				return
			end

			player:removeItem("star_staff", 1)

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
				player:dialogSeq({t, "You have done well."}, 0)
				player:calcStat()
			end
		end

		if choice == "Mage Moon 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("li")

				-- in Sute cave
				player:flushKills("white_wolf")

				-- in Buya Fox
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
				{t, "You follow the path of Magic. Prove yours."},
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

			if player:killCount("li") >= 1 then
				player.quest["moon_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"A foul beast has stolen light from the moon to serve his vanity. Slay the monster with the shortest name in all the lands to free the moon's power."
				},
				1
			)
			player:dialogSeq(
				{t, "Please return to me when you have completed this task."},
				0
			)
		end

		if choice == "Mage Moon 2" then
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

			if player:killCount("white_wolf") >= 1 then
				player.quest["moon_armor"] = 3
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"A foul beast has stolen light from the moon to serve his vanity. Slay the slowest creature in all the lands to free the moon's power."
				},
				1
			)
			player:dialogSeq(
				{t, "Please return to me when you have completed this task."},
				0
			)
		end

		if choice == "Mage Moon 3" then
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
					"For this next task, I will require that you bring me complete key set"
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"I will need:\nKey to Earth\nKey to Fire\nKey to Heaven\nKey to Mountain\nKey to Wind\nKey to Pond\nKey to Thunder\nKey to Water\nSute's Key"
				},
				1
			)

			local keys = {
				"key_to_earth",
				"key_to_fire",
				"key_to_heaven",
				"key_to_mountain",
				"key_to_wind",
				"key_to_pond",
				"key_to_thunder",
				"key_to_water",
				"sutes_key"
			}

			for i = 1, #keys do
				if player:hasItem(keys[i], 1) ~= true then
					player:dialogSeq(
						{t, "Please return when you have all the keys."},
						0
					)
					return
				end
			end

			for i = 1, #keys do
				player:removeItem(keys[i], 1)
			end

			player.quest["moon_armor"] = 4
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Mage Moon 4" then
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
					"For this next task, I will require that you bring me 2 Star-staves and a holy ring."
				},
				1
			)

			if player:hasItem("star_staff", 2) ~= true or player:hasItem("holy_ring", 1) ~= true then
				player:dialogSeq(
					{
						t,
						"Please return to me when you have the star-staves and a holy ring."
					},
					0
				)
				return
			end

			player:removeItem("star_staff", 2)
			player:removeItem("holy_ring", 1)

			player.quest["moon_armor"] = 5
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Mage Moon 5" then
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
				armor = Item("star_garb")
				item = Item("moon_garb")
			elseif player.sex == 1 then
				-- female
				armor = Item("star_dress")
				item = Item("moon_dress")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"The moon's power is not harnessed so easily! Bring me your unequipped " .. armor.name .. "."
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
				player.baseGrace = player.baseWill - 2
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
				player:dialogSeq({t, "You have done well."}, 0)
				player:calcStat()
			end
		end

		if choice == "Mage Sun 1" then
			local caveLevel = player:mythicCaveReqCheck("rabbit")
			local mobs = {}
			local mobAmounts = {}
			local mobName1 = ""
			local mobName2 = ""

			if caveLevel == 2 then
				mobs = {"mad_hare", "giant_rabbit"}
				mobAmounts = {60, 60}
				mobName1 = "Mad hare"
				mobName2 = "Giant rabbit"
			elseif caveLevel == 3 then
				mobs = {"fluff", "thump"}
				mobAmounts = {40, 40}
				mobName1 = "Fluff"
				mobName2 = "Thump"
			end

			if player.registry["flushed_kills"] == 0 then
				for i = 1, #mobs do
					player:flushKills(mobs[i])

					-- ogres
				end
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

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount(mobs[1]) >= mobAmounts[1] and player:killCount(mobs[2]) >= mobAmounts[
				2
			] then
				player.quest["sun_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"I do not envy you, mage. For to prove your worthiness, you must slay " .. mobAmounts[
						1
					] .. " " .. mobName1 .. " and " .. mobAmounts[2] .. " " .. mobName2 .. "."
				},
				1
			)
		end

		if choice == "Mage Sun 2" then
			local count = 0

			player:dialogSeq(
				{
					t,
					"Next I will require three items with \"Star\" in the name."
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

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			local items = {
				"star_powder",
				"stardrop",
				"star_staff",
				"star_burst"
			}

			for i = 1, #items do
				if player:hasItem(items[i], 1) == true then
					count = count + 1
				end
			end

			if count < 3 then
				player:dialogSeq(
					{
						t,
						"I need three items with the word \"Star\" in the name."
					},
					0
				)
				return
			end

			for i = 1, #items do
				--player:talk(0,""..itemTake[i].." "..itemAmounts[i])
				player:removeItem(items[i], 1)
			end

			player.quest["sun_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Mage Sun 3" then
			local mobsToKill = {
				"skeleton_warrior",
				"wild_horse",
				"wild_rooster"
			}

			if player.registry["flushed_kills"] == 0 then
				for i = 1, #mobsToKill do
					player:flushKills(mobsToKill[i])
				end
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{
					t,
					"Please kill a creature with the word \"Slow\" in its name."
				},
				1
			)

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount(mobsToKill[1]) >= 1 or player:killCount(mobsToKill[2]) >= 1 or player:killCount(mobsToKill[3]) >= 1 then
				player.quest["sun_armor"] = 4
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			else
				player:dialogSeq(
					{
						t,
						"You have not slain a creature with the word \"Slow\" in its name."
					},
					0
				)
			end
		end

		if choice == "Mage Sun 4" then
			player:dialogSeq(
				{
					t,
					"Next I will require 20 White Ambers, 4 Holy Rings, 5 Star-staves, and 2 Corrupted staves."
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

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:hasItem("white_amber", 20) ~= true or player:hasItem("holy_ring", 4) ~= true or player:hasItem(
				"star_staff",
				5
			) ~= true or player:hasItem("corrupted_staff", 2) ~= true then
				player:dialogSeq(
					{t, "Return when you have all the required items."},
					0
				)
				return
			end

			player:removeItem("white_amber", 20)
			player:removeItem("holy_ring", 4)
			player:removeItem("star_staff", 5)
			player:removeItem("corrupted_staff", 2)

			player.quest["sun_armor"] = 5
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Mage Sun 5" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("massive_scorpion")
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{t, "Please kill the Massive Scorpion in Kugnae Spider cave."},
				1
			)

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount("massive_scorpion") >= 1 then
				player.quest["sun_armor"] = 6
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			else
				player:dialogSeq(
					{t, "You have not slain the Massive Scorpion."},
					0
				)
			end
		end

		if choice == "Mage Sun 6" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("rabbit")
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{t, "Please kill 200 rabbits and return to me."},
				1
			)

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:killCount("rabbit") >= 200 then
				player.quest["sun_armor"] = 7
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			else
				player:dialogSeq(
					{t, "You have not slain at least 200 rabbits."},
					0
				)
			end
		end

		if choice == "Mage Sun 7" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("squirrel")
				player.registry["flushed_kills"] = 1
			end

			player:dialogSeq(
				{
					t,
					"Please get me 14 gold acorns while you kill 200 squirrels and then return to me."
				},
				1
			)

			if not player:karmaCheck("tiger") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure to survive the sun. Improve your karma and return."
					},
					0
				)
				return
			end

			if player:hasItem("gold_acorn", 14) ~= true then
				player:dialogSeq({t, "You are missing the gold acorns."}, 0)
				return
			end

			if player:killCount("squirrel") >= 200 then
				player:removeItem("gold_acorn", 14)
				player.quest["sun_armor"] = 8
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			else
				player:dialogSeq(
					{t, "You have not slain at least 200 squirrels."},
					0
				)
			end
		end

		if choice == "Mage Sun 8" then
			local item = {}
			local armor = {}
			if player.sex == 0 then
				-- male
				armor = Item("moon_garb")
				item = Item("sun_garb")
			elseif player.sex == 1 then
				-- female
				armor = Item("moon_dress")
				item = Item("sun_dress")
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

			if not player:karmaCheck("tiger") then
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
				player.baseMight = player.baseMight - 2
				player.baseGrace = player.baseGrace - 2
				player.baseWill = player.baseWill - 3
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

		if speech == "sute" then
			Tools.checkKarma(player)

			if player:hasItem("sutes_key", 1) == true and player:hasLegend("slew_mighty_sute") == false then
				player:removeItem("sutes_key", 1)
				player:addLegend(
					"Slew the mighty Sute (" .. curT() .. ")",
					"slew_mighty_sute",
					5,
					16
				)
				player:giveXP(50000)
				player.registry["sute_quest_dye"] = 0
				player.registry["sute_quest_timer"] = 0
				player:dialogSeq(
					{
						t,
						"You have done well and all will know of your efforts. Unfortunately, I have learned that his spirit is not yet at rest. Sute will soon be reborn."
					},
					0
				)
				return
			end

			if os.time() < player.registry["sute_quest_timer"] then
				player:dialogSeq(
					{
						t,
						"Not enough time has passed. If I apply more powder now, it will kill you. Return later."
					},
					0
				)
				return
			end

			--if player:hasLegend("slew_mighty_sute") then
			--	player:dialogSeq({t,"You have already helped me with Sute. thanks again."},0)
			--return
			--end

			if player.level < 28 then
				player:dialogSeq(
					{
						t,
						"Eldritch's face looks grim. 'You are still too young to learn of that.'"
					},
					0
				)
				return
			end

			local choice = player:menuString(
				"Yes, I can tell you about Sute. Do you wish to hear the whole story?",
				{"Please enlighten me.", "No, just tell me what must be done."},
				{}
			)
			local choice2

			if choice == "Please enlighten me." then
				player:dialogSeq(
					{
						t,
						"'Ah, Sute...' the mage sighs sadly. Sute was once a great pupil of mine. He had an incredible talent for magic. But he also had too much confidence, too much pride.'",
						"'About two decades ago, the Northern Ogres launched a massive surprise assault against Buya. They used elaborate tactics and were supported by strange magics.'",
						"Eldritch gazes upward, recalling the old memories. 'The very gates of Buya fell and we were forced to withdraw into the palace. After the initial attack, we were able to survive, but could not overcome the Ogres.'",
						"'We know the Ogre must havve been united by some more cunning power to attack us so effectively. We suspected it was a corrupt mage eof some sort, but never leeared the truth.'",
						"'As we were developing plans to overcome this threat, the impatient Sute, who had just earned his Ancient clothes, headed alone to the Arctic Land. Before we realized he had left, the Ogres mysteriously retreated.'",
						"'We assumed Sute dead and were amazed that he somehow was successful. Two years after, what was once eSute returned. His body was frozeeen and he babbled incoherently.'",
						"'A poet, Lintong, tried to heal him, but Sute smote ehim with a powerful ice spell.'",
						"'As we tried to subdue him, Sute flew into an insane rage and fled to that cave on the north side of Buya, though we did not know where he had gone to at the time. He formed a virtual army of bizarre creations.'",
						"'Strangely, he did not use them to attack, but to mine the cave for silver, which he reportedly hoarded. But we were worried about Sute's future plans.'",
						"'Several groups of heroes were sent into the cave to put Sute out of his misery, but all failed.'",
						"'Many died. Some were even able to defeat Sutee, but his body would later rise again. There was no other choice,' Eldritch says with regret. 'I sealed Sute and his creations in the cave.'",
						"'Some incredibly evil force has polluted Sute's soul. I doubt that you will be able to finally put him to rest, but, if you are brave enough, I will help you try.'",
						"'I can coat you with a special powder that wiill allow you to enter Sute's cave. I have one batch of powder available, but it will only let you into the cave once.'",
						"'If you leave the cave, you will have to recoated and it is dangerous to apply the powder more than once per hour. It will cost 200 gold for the powder.'"
					},
					1
				)

				choice2 = player:menuString(
					"Do you want me to apply it to you?",
					{"Yes, I am willing to pay.", "No thank you."},
					{}
				)
			elseif choice == "No, just tell me what must be done." then
				player:dialogSeq(
					{
						t,
						"'Some incredibly evil force has polluted Sute's soul. I doubt that you will be able to finally put him to rest, but, if you are brave enough, I will help you try.'",
						"'I can coat you with a special powder that wiill allow you to enter Sute's cave. I have one batch of powder available, but it will only let you into the cave once.'",
						"'If you leave the cave, you will have to recoated and it is dangerous to apply the powder more than once per hour. It will cost 200 gold for the powder.'"
					},
					1
				)
				choice2 = player:menuString(
					"Do you want me to apply it to you?",
					{"Yes, I am willing to pay.", "No thank you."},
					{}
				)
			end

			if (choice2 == "Yes, I am willing to pay.") then
				if player.money < 200 then
					player:dialogSeq(
						{t, "Sorry but you do not have enough gold."},
						0
					)
					return
				end

				local armor = player:getEquippedItem(EQ_ARMOR)

				if armor == nil then
					player:dialogSeq(
						{t, "You must be wearing an armor for me to dye you."},
						0
					)
					return
				end

				player:removeGold(200)
				player.registry["sute_quest_dye"] = 1
				player.registry["sute_quest_timer"] = os.time() + 86400

				-- 1 day
				player.armorColor = 26

				player:dialogSeq(
					{
						t,
						"The powder turns your clothing a strange color.",
						"If you manage to kill Sute, return to me and I will see that your efforts are acknowledged."
					},
					1
				)

				player:sendStatus()
				player:updateState()
			end
		elseif speech == "quest" or speech == "minor" or speech == "minor quest" then
			Tools.checkKarma(player)
			MinorQuest.quest(player, npc)
		elseif speech == "complete" or speech "complete quest" then
			Tools.checkKarma(player)
			MinorQuest.complete(player, npc)
		end
	end)
}
