local _showShieldDialog = function(player)
	player:dialogSeq(
		{
			"Anyone who dedicates their lives to the weapon should learn how to use a shield.",
			"First, though, I will ask you to prove this to me. To the West and North of here, there is a cave. This is the training caves for our Warriors.",
			"In it, you will find many different dyed creatures. You may not kill the red and blue ones, you must avoid them.",
			"At the end of the caves, there is a statue of Chung Ryong. If you reach it without killing any of the Blue or Red animals, you will be rewarded with a shield."
		},
		1
	)
end

WarriorTrainerNpc = {
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
			table.insert(opts, "Become a Warrior")
		elseif player.baseClass == 1 then
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

		if player.baseClass == 1 then
			if player.level >= 66 and player:hasLegend("blessed_by_the_stars") and not player:hasLegend("mastered_the_stars") then
				if player.quest["star_armor"] == 0 or player.quest["star_armor"] == 1 then
					table.insert(opts, "Warrior Star 1")
				elseif player.quest["star_armor"] == 2 then
					table.insert(opts, "Warrior Star 2")
				elseif player.quest["star_armor"] == 3 then
					table.insert(opts, "Warrior Star 3")
				end
			end
		end

		if player.baseClass == 1 then
			if player.level >= 76 and player:hasLegend("mastered_the_stars") and not player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["moon_armor"] == 0 or player.quest["moon_armor"] == 1 then
					table.insert(opts, "Warrior Moon 1")
				elseif player.quest["moon_armor"] == 2 then
					table.insert(opts, "Warrior Moon 2")
				elseif player.quest["moon_armor"] == 3 then
					table.insert(opts, "Warrior Moon 3")
				elseif player.quest["moon_armor"] == 4 then
					table.insert(opts, "Warrior Moon 4")
				end
			end
		end

		if player.baseClass == 1 then
			if player.level >= 86 and player:hasLegend("mastered_the_stars") and player:hasLegend("understood_the_moon") and not player:hasLegend("survived_the_sun") then
				if player.quest["sun_armor"] == 0 or player.quest["sun_armor"] == 1 then
					table.insert(opts, "Warrior Sun 1")
				elseif player.quest["sun_armor"] == 2 then
					table.insert(opts, "Warrior Sun 2")
				elseif player.quest["sun_armor"] == 3 then
					table.insert(opts, "Warrior Sun 3")
				elseif player.quest["sun_armor"] == 4 then
					table.insert(opts, "Warrior Sun 4")
				elseif player.quest["sun_armor"] == 5 then
					table.insert(opts, "Warrior Sun 5")
				elseif player.quest["sun_armor"] == 6 then
					table.insert(opts, "Warrior Sun 6")
				end
			end
		end

		if npc.mapTitle == "Sword" and player.level >= 10 and player.baseClass == 1 and not player:hasLegend("nagnang_warrior_trial") then
			if player.quest["nagnang_warrior_trial"] == 0 then
				table.insert(opts, "Strangers")
			elseif player.quest["nagnang_warrior_trial"] == 1 then
				table.insert(opts, "Shield")
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
		elseif choice == "Become a Warrior" then
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
					"Hail, mighty one! Welcome to my sanctuary, the sanctuary of the mightiest of all fighters.",
					"Have you come to pick your path? I think you would make a great warrior, and a great hero."
				},
				1
			)
			choice2 = player:menuString(
				"Will you join the path of the warrior?",
				{"Yes", "Tell me more", "No"}
			)
		elseif choice == "Divine Secret" then
			if npc.mapTitle == "Sword" or npc.mapTitle == "Kwi-Sin Sword" or npc.mapTitle == "Ming-Ken Sword" or npc.mapTitle == "Ohaeng Sword" then
				player:futureSpells(npc, {"feral_berserk_warrior"})
			else
				player:futureSpells(npc)
			end
		elseif choice == "Learn Secret" then
			if npc.mapTitle == "Sword" or npc.mapTitle == "Kwi-Sin Sword" or npc.mapTitle == "Ming-Ken Sword" or npc.mapTitle == "Ohaeng Sword" then
				player:learnSpell(npc, {"feral_berserk_warrior"})
			else
				player:learnSpell(npc)
			end
		elseif choice == "Forget Secret" then
			player:forgetSpell(npc)
		elseif choice == "Strangers" then
			local mobs = {
				"red_deer",
				"red_doe",
				"red_rabbit",
				"blue_deer",
				"blue_doe",
				"blue_rabbit"
			}

			if player:hasItem("green_squirrel_pelt", 1) ~= true then
				player:sendMinitext("Eh? Please don't bother me.")
				player:sendMinitext("You probably couldn't even kill one of the Green squirrels to the south.")
				return
			end
			player:removeItem("green_squirrel_pelt", 1)
			player.quest["nagnang_warrior_trial"] = 1

			for i = 1, #mobs do
				player:flushKills(mobs[i])
			end

			_showShieldDialog(player)
		elseif choice == "Shield" then
			_showShieldDialog(player)
		end

		if choice2 == "Yes" then
			player:dialogSeq(
				{
					t,
					"Great! You have made a great decision. I see you becoming a great hero in these lands. Now let me set you up with some supplies."
				},
				1
			)

			player:addItem("sword_of_power", 1)
			player:addItem("bears_liver", 25)
			if player.sex == 0 then
				player:addItem("jade_scale_mail", 1)
				player:addItem("merchant_helm", 1)
			elseif player.sex == 1 then
				player:addItem("summer_mail_dress", 1)
				player:addItem("spring_helmet", 1)
			end

			player:addGold(500)
			player:updatePath(1, 0)
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
		elseif choice2 == "Tell me more" then
			player:dialogSeq(
				{
					t,
					"Tell you about warriors? Well, they are the greatest of the fighter classes. A one man army, so to speak. Warriors are fierce, and powerful, and can battle many foes at once.",
					"Warriors use little magic, instead we prefer to use skills, such as the ability to hit more than one creature at a time.",
					"We depend on the healing skills of other paths, like the poets, but they are always willing to group with a warrior for our awesome killing abilities."
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

				player:addItem("sword_of_power", 1)
				player:addItem("bears_liver", 25)

				if player.sex == 0 then
					player:addItem("jade_scale_mail", 1)
					player:addItem("merchant_helm", 1)
				elseif player.sex == 1 then
					player:addItem("summer_mail_dress", 1)
					player:addItem("spring_helmet", 1)
				end

				player:addGold(500)
				player:updatePath(1, 0)
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

		if choice == "Warrior Star 1" then
			local star = {graphic = convertGraphic(428, "item"), color = 0}
			player.npcGraphic = star.graphic
			player.npcColor = star.color
			player.dialogType = 0
			player.lastClick = npc.ID

			if player.registry["flushed_kills"] == 0 then
				player:flushKills("spry_monkey")
				player:flushKills("agile_monkey")
				player:flushKills("fast_monkey")
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

			if player:killCount("spry_monkey") >= 18 or player:killCount("agile_monkey") >= 18 or player:killCount("fast_monkey") >= 18 then
				player.quest["star_armor"] = 2
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"Among the failures are the evil monkeys. Even the most agile ones lack light. Slay 18 of the fastest monkeys, then return."
				},
				0
			)
		end

		if choice == "Warrior Star 2" then
			player:dialogSeq(
				{
					t,
					"You have the speed of a star, but have you its strength? Bring me two titanium gloves."
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

			if player:hasItem("titanium_glove", 2) ~= true then
				player:dialogSeq(
					{
						t,
						"You are missing the gloves. Please return when you have them."
					},
					0
				)
				return
			end

			player:removeItem("titanium_glove", 2)
			player.quest["star_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Warrior Star 3" then
			local item = {}

			if player.sex == 0 then
				-- male
				item = Item("star_scale_mail")
			elseif player.sex == 1 then
				-- female
				item = Item("star_mail_dress")
			end

			local armor = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"To truly shine with the light of the stars, you must also bring the sword that gloves with the star's light."
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

			if player:hasItem("electra", 1) ~= true then
				player:dialogSeq(
					{t, "Please come back when you have an electra."},
					0
				)
				return
			end

			player:removeItem("electra", 1)

			local choice2 = player:dialogSeq(
				{
					armor,
					"You want to wear this armor? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseMight = player.baseMight - 1
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

		if choice == "Warrior Moon 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("boar_champion")

				-- pig 1
				player:flushKills("pig_champion")

				-- pig 2
				player:flushKills("pig_avenger")

				-- pig 3
				player:flushKills("mad_dog")

				-- dog 1
				player:flushKills("crazed_mongrel")

				-- dog 2
				player:flushKills("frothing_mutt")

				-- dog 3
				player:flushKills("grim_ogre")
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
				{t, "You follow the path of Valor. Prove yours."},
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

			if player:killCount("boar_champion") >= 1 or player:killCount("pig_champion") >= 1 or player:killCount("pig_avenger") >= 1 then
				player.quest["moon_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"A foul beast has stolen light from the moon to serve his vanity. Slay the glowing pig-man to free the moon's power."
				},
				1
			)
		end

		if choice == "Warrior Moon 2" then
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

			if player:killCount("mad_dog") >= 30 or player:killCount("crazed_mongrel") >= 30 or player:killCount("frothing_mutt") >= 30 then
				player.quest["moon_armor"] = 3
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"The most insane mutts were corrupted by the moon's power. Slay thirty of them to realize the moon's strength."
				},
				1
			)
		end

		if choice == "Warrior Moon 3" then
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

			if player:killCount("grim_ogre") >= 20 then
				if player:hasItem("amber", 20) ~= true then
					player:dialogSeq(
						{t, "Please return when you have the twenty ambers."},
						0
					)
					return
				end

				player:removeItem("amber", 20)
				player.quest["moon_armor"] = 4
				player:dialogSeq({t, "You have done well."}, 0)
				return
			else
				player:dialogSeq(
					{t, "I see no blood of the ogres on your blade."},
					1
				)
			end

			player:dialogSeq(
				{
					t,
					"The full moon drips upon the earth, seeping into the ground. The grim ogres try to harness this power. Kill twenty of them and bring me as many ambers."
				},
				1
			)
		end

		if choice == "Warrior Moon 4" then
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
				armor = Item("star_scale_mail")
				item = Item("moon_scale_mail")
			elseif player.sex == 1 then
				-- female
				armor = Item("star_mail_dress")
				item = Item("moon_mail_dress")
			end

			if armorequip ~= nil then
				if armorequip.id == armor.id then
					wearing = true
				end
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			player:dialogSeq(
				{
					t,
					"The moon's power is not harnessed so easily! Bring the following all at once: one titanium glove, three electras, and your star mail."
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

			if (player:hasItem("titanium_glove", 1) ~= true or
				player:hasItem("electra", 3) ~= true or
				player:hasItem(armor.yname, 1) ~= true) then

				player:dialogSeq(
					{t, "Please return when you have all the required items."},
					0
				)
				return
			end

			player:removeItem(armor.yname, 1)
			player:removeItem("titanium_glove", 1)
			player:removeItem("electra", 3)

			local choice2 = player:dialogSeq(
				{
					armorg,
					"You want to wear this armor? It shall cost you some of your abilities and some karma."
				},
				1
			)

			if choice2 == true then
				player.baseMight = player.baseMight - 2
				player.baseGrace = player.baseGrace - 1
				player.karma = player.karma - 2
				player:addItem(item.yname, 1, 0, player.ID)
				player.registry["flushed_kills"] = 0
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

		if choice == "Warrior Sun 1" then
			if player.registry["flushed_kills"] == 0 then
				player:flushKills("frost_ogre")

				-- ogres
				player:flushKills("ice_ogre")

				-- ogres
				player:flushKills("rabbit")

				-- regular shit rabbits
				player:flushKills("squirrel")
				player:flushKills("mythic_monkey")

				-- monkey 1
				player:flushKills("monkey_mauler")

				-- monkey 1
				player:flushKills("divine_monkey")

				-- monkey 2
				player:flushKills("monkey_basher")

				-- monkey 2
				player:flushKills("spirit_monkey")

				-- monkey 3
				player:flushKills("monkey_avenger")

				-- monkey 3
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

			if player:killCount("frost_ogre") >= 60 and player:killCount("ice_ogre") >= 60 then
				player.quest["sun_armor"] = 2
				player.registry["flushed_kills"] = 0
				player:dialogSeq({t, "You have done well."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"Far to the north is a land the sun only grazes. Master that land. Slay 60 ogres of ice and 60 ogres of frost then return."
				},
				1
			)
		end

		if choice == "Warrior Sun 2" then
			if not player:karmaCheck("tiger") then
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
					"Now bring to me 20 of the purest ambers so that we may capture the light of the sun."
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

			if player:hasItem("white_amber", 20) ~= true then
				player:dialogSeq(
					{t, "Return to me when you have the ambers."},
					0
				)
				return
			end

			player:removeItem("white_amber", 20)
			player.quest["sun_armor"] = 3
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Warrior Sun 3" then
			if not player:karmaCheck("tiger") then
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
					"You must now bring me several things to complete your armor. Read carefully and do not return unless you have ALL of them.",
					"Such fragile hands you have. Mere flesh and bone is not enough. Bring two titanium gloves.",
					"And to cut your armor from the sun? I will need four electras.",
					"Only with impurities can true purity be reached. You must also bring to me two corrupted blades."
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

			if (player:hasItem("titanium_glove", 2) ~= true or
				player:hasItem("corrupted_blade", 2) ~= true or
				player:hasItem("electra", 4) ~= true) then

				player:dialogSeq(
					{t, "Return to me when you have all the required items."},
					0
				)
				return
			end

			player:removeItem("titanium_glove", math.random(1, 2))
			player:removeItem("corrupted_blade", math.random(1, 2))
			player:removeItem("electra", math.random(2, 4))

			player.quest["sun_armor"] = 4
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Warrior Sun 4" then
			if not player:karmaCheck("tiger") then
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
					"Did you think it was so easy? Your work is still very far from complete. Your pride is too strong. Your greed is too strong also, I see.",
					"Humble yourself. Slay 200 rabbits."
				},
				1
			)

			if player:killCount("rabbit") < 200 then
				player:dialogSeq(
					{t, "Return when you have slain 200 rabbits."},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"I heard your mind complaining at that tedious task. Perhaps you are not yet humble enough. Collect 14 gold acorns while you kill 200 squirrels."
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

			if player:hasItem("gold_acorn", 14) ~= true then
				player:dialogSeq(
					{t, "Return when you have all 14 gold acorns."},
					0
				)
				return
			end

			if player:killCount("squirrel") < 200 then
				player:dialogSeq(
					{t, "Return when you slain all 200 squirrels."},
					0
				)
				return
			end

			player:removeItem("gold_acorn", 14)

			player.quest["sun_armor"] = 5
			player:dialogSeq({t, "You have done well."}, 0)
		end

		if choice == "Warrior Sun 5" then
			if not player:karmaCheck("tiger") then
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
				{t, "Prove your combat expertise. Win at least two Carnages."},
				1
			)

			if player.registry["carnageWin"] >= 2 then
				player.quest["sun_armor"] = 6
				player:dialogSeq({t, "You have done well."}, 0)
			else
				player:dialogSeq(
					{
						t,
						"You are missing the two required carnage victories that you need."
					},
					0
				)
			end
		end

		if choice == "Warrior Sun 6" then
			local item = {}
			local armor = {}

			if player.sex == 0 then
				-- male
				armor = Item("moon_scale_mail")
				item = Item("sun_scale_mail")
			elseif player.sex == 1 then
				-- female
				armor = Item("moon_mail_dress")
				item = Item("sun_mail_dress")
			end

			local armorg = {graphic = item.icon, color = item.iconC}

			if not player:karmaCheck("tiger") then
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
					"Prove your superiority over the monkeys. Slay their two leaders."
				},
				1
			)

			if ((player:killCount("mythic_monkey") >= 1 and player:killCount("monkey_mauler") >= 1) or (player:killCount("divine_monkey") >= 1 and player:killCount("monkey_basher") >= 1) or (player:killCount("spirit_monkey") >= 1 and player:killCount("monkey_avenger") >= 1)) then
				player:dialogSeq(
					{
						t,
						"Now bring me 20,000 coins of gold which I will melt and use to forge your armor. Bring also your unequipped moon mail."
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

				if player.money < 20000 or player:hasItem(armor.yname, 1) ~= true then
					player:dialogSeq(
						{
							t,
							"Please return when you have all the required items."
						},
						0
					)
					return
				end

				player:removeItem(armor.yname, 1)

				player:removeGold(20000)

				local choice2 = player:dialogSeq(
					{
						armorg,
						"You want to wear this armor? It shall drain your abilities and some karma."
					},
					1
				)

				if choice2 == true then
					player.baseMight = player.baseMight - 3
					player.baseGrace = player.baseGrace - 2
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
	end),
}
