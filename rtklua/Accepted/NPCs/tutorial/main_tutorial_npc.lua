MainTutorialNpc = {
	--To be used for jadespear and ironheart

	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level >= 5 and player.class == 0 then
			-- choose path -- Peasant lvl 5 check/bother

			local opts = {
				"Can you explain the paths?",
				"Show me the Warriors guild.",
				"Show me the Rogues guild.",
				"Show me the Mage guild.",
				"Show me the Poet guild.",
				"I will pick one later."
			}

			player:dialogSeq(
				{
					t,
					"Oh my, you are growing fast! You have already reached the 5th level. But I notice you have not yet picked your path.",
					"You should really look into picking your path before you continue with these tasks."
				},
				1
			)

			local choice = player:menuSeq(
				"Would you like me to send you to your guild to pick your destiny, or would you like to continue?",
				opts,
				{}
			)

			local returnText = "Remember to return to me later, so you can continue your tutorial."

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"In this land we have 4 main paths. They are the Warriors, the Rogues, the Mages, and the Poets.",
						"Warriors are the fighters, they use their brute force to kill their foes, and can power through large numbers of mobs quickly.",
						"Rogues are also fighters, but use more magic to assist them. A nimble and deadly killer one on one.",
						"Magi are the magic users of the land. Powerful in the art of offensive magic, and relies on range attacks",
						"Finally the Poets. They are the healers of the land. While they kill very little for themselves, they are always a welcomed addition to every group.",
						"You can learn more about each path from the Guild tutors, found in the lower left corner of each guild."
					},
					1
				)
			end

			if choice == 2 then
				-- warriors guild
				player:dialogSeq(
					{
						t,
						"Ah, the heart of a fighter. This is the path for the true fighter. Let me show you to their hall now.",
						returnText
					},
					1
				)
				player:warp(341, 8, 7)
			end

			if choice == 3 then
				-- rogues guild
				player:dialogSeq(
					{
						t,
						"A nimble fighter is what you want to be? Let me show you to their hall now.",
						returnText
					},
					1
				)
				player:warp(343, 8, 7)
			end

			if choice == 4 then
				-- mage guild
				player:dialogSeq(
					{
						t,
						"A mastery of magic is what you seek? Let me show you to their hall now.",
						returnText
					},
					1
				)
				player:warp(342, 8, 7)
			end

			if choice == 5 then
				-- poet guild
				player:dialogSeq(
					{
						t,
						"A caring, nurturing soul you are indeed. Let me show you to their hall now.",
						returnText
					},
					1
				)
				player:warp(344, 8, 7)
			end

			if choice == 6 then
				-- pick later
				player:dialogSeq(
					{
						t,
						"This is your choice... But remember this, any experience you gain now until you pick your path will go to waste. Pick your path soon..."
					},
					1
				)
			end

			return
		end

		if player.baseClass == 1 and player.level >= 5 then
			local chongun = {
				graphic = convertGraphic(29, "monster"),
				color = 12
			}

			if player.quest["tiger_armor"] == 0 then
				player:dialogSeq(
					{
						t,
						"You wish to learn the essence of the tiger?",
						"Listen carefully."
					},
					1
				)
				player:dialogSeq(
					{
						chongun,
						"There is an old, old soul that dwells within a cave. You must hurry to him."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"When you can, go within and speak to him. He will imbue your armor with the essence of the tiger.",
						"He knows me and knows his old title, Chongun. Go to him immediately. Say that to him, and give him what he demands.",
						"But beware, it is the essence within, your own experience that is made into your armor.",
						"Go to the heart of the Tiger's cave and say Chongun."
					},
					0
				)
				return
			end

			if player.quest["tiger_armor"] == player.level then
				player:dialogSeq({
					t,
					"Your tiger armor looks outdated. Go visit my friend Claw again to see about an upgrade."
				})
				return
			end
		end

		if player.quest["tutorial_quest"] == 0 then
			player.quest["tutorial_quest"] = 1
			player:dialogSeq(
				{
					t,
					"Greetings and welcome to my home. I see you are eager to get on with your adventure. Before you do however, there is much more you need to learn. Click on me to learn... "
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 1 then
			local items = {"war_platemail", "spring_mail_dress"}

			local neededItem = items[player.sex + 1]

			if player:hasItem(neededItem, 1) == true or player:hasEquipped(neededItem.yname) then
				player:giveXP(100)
				player.quest["tutorial_quest1_gave_gold"] = 0
				player.quest["tutorial_quest"] = 2

				player:dialogSeq(
					{
						t,
						"You've done well. Keep the armor. It will serve you well against your first foe... later. Press <u> to wear it.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			local titem = {
				graphic = Item(neededItem).icon,
				color = Item(neededItem).iconC
			}
			local tblacksmith = {
				graphic = convertGraphic(6, "monster"),
				color = 13
			}

			if player.quest["tutorial_quest1_gave_gold"] == 1 then
				player:dialogSeq(
					{
						titem,
						"I am still waiting for that " .. Item(neededItem).name .. ". Please go visit the blacksmith."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"A hero has to be very wise of the world, and that only comes from experience.",
					"Experience will teach you that you'd better equip yourself well.",
					"You need to understand how to buy and sell items. First, you need to buy something..."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"You've gained some of this old warrior's trust. Here's some money for some armor."
				},
				1
			)
			player:addGold(20)

			player.quest["tutorial_quest1_gave_gold"] = 1
			player:dialogSeq(
				{
					titem,
					"Go to the blacksmith, get a " .. Item(neededItem).name .. ", and bring it back. You'll find it listed under <Peasant's Clothes>"
				},
				1
			)
			player:dialogSeq(
				{
					tblacksmith,
					"You can find the blacksmith in Buya, at the location 18,103, or in Kugnae, 60,122. If you forget, you can check on the mini map by pressing 'm'."
				},
				1
			)
			player:dialogSeq(
				{
					tblacksmith,
					"Just try clicking on the old man, he's got a one track mind. He'll try to sell you something."
				},
				1
			)
			player:dialogSeq(
				{
					titem,
					"Get the " .. Item(neededItem).name .. " now. Return and tap on me"
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 2 then
			-- Buying Food

			if (player:hasItem("meat_scrap", 1) == true) then
				player:removeItem("meat_scrap", 1, 9)
				player:giveXP(100)
				player.quest["tutorial_quest"] = 3
				player.quest["tutorial_quest2_gave_meat"] = 0
				player:dialogSeq(
					{
						t,
						"You're a lot better than that last apprentice. He was...well, I'll not go on about that."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"Keep it up and you might find yourself getting referred to as a Hero sometime... or a merchant at any rate."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"If you would like another quest, let me know. I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			local tbutcher = {
				graphic = convertGraphic(11, "monster"),
				color = 3
			}
			local trabbitmeat = {
				graphic = Item("rabbit_meat").icon,
				color = Item("rabbit_meat").iconC
			}
			local tmeatscraps = {
				graphic = Item("meat_scrap").icon,
				color = Item("meat_scrap").iconC
			}

			if player.quest["tutorial_quest2_gave_meat"] == 1 then
				player:dialogSeq(
					{
						tmeatscraps,
						"I've already given you the rabbit meat. Buy a meat scrap while you are at the butcher."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Money doesn't make a man, but it does mend a sword. You can take some of the animal flesh to the butcher."
				},
				1
			)
			player:dialogSeq(
				{
					tbutcher,
					"She's stingy... but it's a way to get some money. Anyway, if you're going to the butcher, learn to sell."
				},
				1
			)
			player.quest["tutorial_quest2_gave_meat"] = 1
			player:addItem("rabbit_meat", 5)
			player:dialogSeq(
				{
					trabbitmeat,
					"Here's five rabbit corpses. Whew! they do start to stink. Take these to the butcher's shop."
				},
				1
			)
			player:dialogSeq(
				{
					tbutcher,
					"You can find the butcher in Buya, at the location 39,129, or in Kugnae 41,131. If you forget, you can check on the mini map by pressing 'm'."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"You'll see what kind of bargain she'll get from ya. And don't stop nowhere on the way back."
				},
				1
			)
			player:dialogSeq(
				{
					tmeatscraps,
					"Buy a Meat scrap while you are at the butcher's. I'll be expecting Meat scrap."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 3 then
			-- Finding Items

			if (player:hasItem("chestnut", 5) == true and player:hasItem("rose", 1) == true) then
				player:removeItem("chestnut", 5, 9)
				player:removeItem("rose", 1, 9)
				player:giveXP(150)
				player.quest["tutorial_quest"] = 4

				player:dialogSeq(
					{
						t,
						"Perfect! A Rose for my love, and some Chestnuts to eat. Thank you for getting these items for me.",
						"Remember that there are other ways to get some items to sell to the merchants, or to other citizens."
					},
					1
				)

				player:dialogSeq(
					{
						t,
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"You are quite a merchant now, but you only know how to buy and sell items you already have.",
					"You need to learn about getting your own items. Yes, some come from the creatures you have slain, but there is more you can find."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"First you should find me a Rose, I hear there is a bush in the city that you can pick them from."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"In Buya the bush is located in the South, near 112,138. In Kugnae, the bush is located near the Lotus Chapel at 152,190.\n\nJust go near the bush, and you will find some.",
					"I am also hungry for some Chestnuts, you can collect 5 for me in the Northwest of Buya at 27,47. In Kugnae, there is a small farm at 111,156.\n\nThey are small dark nuts, so you will have to look carefully.",
					"Collect these items, and return to me when you have them."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 4 then
			-- Fishing

			if (player:hasItem("minnow", 1) == true and player.quest["learned_to_fish"] == 1) then
				player:removeItem("minnow", 1, 9)
				player:giveXP(50)
				player:addGold(5)
				player.quest["tutorial_quest"] = 5
				player:dialogSeq(
					{
						t,
						"Thanks for the fish! That wasn't so hard was it?",
						"I've heard stores about people finding pretty strange things while fishing.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					1
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"So, you are interested in more things to do? Fishing can weaken your fighting skills, but is a nice diversion from time to time.",
					"Find Bate on the west side of Kugnae at 28,170 or Wim in the southeast of Buya at 109,88. Say to him out loud 'I'd like to fish'.",
					"If you bring me back a Minnow, I'll give you a little gold."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 5 then
			-- Exploration
			if player.quest["talked_to_tutor"] == 1 then
				player:giveXP(150)
				player.quest["tutorial_quest"] = 6
				player.quest["talked_to_tutor"] = 0

				-- frees this variable so we can reduce player registries

				player:dialogSeq(
					{
						t,
						"I am glad to see you have discovered our kingdoms heart, and I hope you enjoyed looking around inside the safety of the kingdoms walls.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					1
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Well, we are finding our way around now, arn't we? But do you understand the Kingdom around you?",
					"It's time you got some culture in you.\n\nGo to the palace and look around. You will find the main palace with the kingdom greeter in Buya at 73,56, or in Kugnae at 110,123.",
					"To the south east of Buya is the Kingdom of Koguryo, whose capitol city is Kugnae. Their King is called Mhul.",
					"You will also find the theater where the Muses occasionally hold poetry competitions, and the library where our kingdoms knowledge is stored.",
					"When you get to the library mention my name to the librarian, I am sure he will have some words to say to you. Remember to say my name out loud."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 6 then
			-- Ogre Cider

			if (player:hasItemDura("ogre_cider", 1) == true) then
				player:giveXP(150)
				player.quest["tutorial_quest"] = 7
				player:removeItem("ogre_cider", 1, 9)

				player:dialogSeq(
					{
						t,
						"Terrific, you have some Ogre cider! Nothing like some cider to wash down a meal.",
						"If you want to be successful, you'll have to explore many places outside of the cozy towns.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					1
				)
				return
			end

			local item = Item("ogre_cider")
			local togrecider = {graphic = item.icon, color = item.iconC}
			local togre = {graphic = convertGraphic(185, "monster"), color = 14}

			player:dialogSeq(
				{
					t,
					"There's much more to the world than the city. Other lands hold different terrain, challenges, and goods."
				},
				1
			)

			player:dialogSeq(
				{
					togrecider,
					"I have a taste for ogre cider, but it's tough stuff to find around here. Most ogres will rough you up pretty good, too."
				},
				1
			)

			player:dialogSeq(
				{
					togre,
					"But I hear that in Hamgyong Nam-Do to the south east lives a relatively pleasant ogre who sometimes trades with humans."
				},
				1
			)

			player:dialogSeq(
				{
					t,
					"To journey to other lands, first go out the north gate of the city. You'll find yourself in a gathering place. You will be able to get on a map there.",
					"Visit Hamgyong Nam-Do and pick up some cider for me."
				},
				1
			)

			player:dialogSeq(
				{
					togrecider,
					"I'll be waiting here for the cider. Don't get lost now!"
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 7 then
			-- By the Sea (Chu Rua)

			if (player:hasLegend("aided_chu_rua")) then
				player.quest["tutorial_quest"] = 8
				player:dialogSeq(
					{t, "The Dragon King shall fare better because of you."},
					1
				)
				return
			end

			local tturtle = {
				graphic = convertGraphic(174, "monster"),
				color = 0
			}

			player:dialogSeq(
				{
					t,
					"The Dragon King lives beneath the waves, but he has fallen very ill. I know because a turtle told me."
				},
				1
			)
			player:dialogSeq(
				{
					tturtle,
					"The turtle, named Chu Rua, swam to shore to ask young men of land to help him. He is in distress and needs help."
				},
				1
			)

			player.npcGraphic = t.graphic
			player.npcColor = t.color

			local cchoice = player:menuSeq(
				"Will you go to him now? Be careful, it is dangerous and you may get lost.",
				{"I am willing to risk it", "O, in that case, never mind"},
				{}
			)

			if (cchoice == 1) then
				-- willing to risk...
				player:dialogSeq(
					{
						t,
						"I know of a secret way to the shore. From there, you must find Chu Rua and use all your wits and cunning to succeed."
					},
					1
				)
				player:warp(1111, 4, 18)
			elseif (cchoice == 2) then
				--nevermind
				player:dialogSeq({t, "So be it."}, 0)
			end
			return
		end

		if player.quest["tutorial_quest"] == 8 then
			-- group hunting

			local tdeer = {graphic = convertGraphic(89, "monster"), color = 5}
			if player:hasItem("antler", 3) == true then
				player:removeItem("antler", 3, 9)
				player:giveXP(200)
				player.quest["tutorial_quest"] = 9

				sanctuary.cast(npc, player)

				player:dialogSeq(
					{
						t,
						"You are a great fighter, that has learnt well. I hope you fought well and defended your other members well.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"You're coming well by yourself, but solitary legends die fast. Form a covenant with others for great adventure.",
					"Close this scroll. Press <f> or click 'GROUP' tab. Then return and read on.",
					"It is your group status, which might be blank right now.",
					"You will gain more Experience when you are in a group. You and the members have more total Experience gained.",
					"You want to find someone about your level, so that you both get enough Experience.",
					"Adventure with someone you like and trust. You'll learn which Paths combine well. Poets always help groups.",
					"Press <shift><g> to make yourself sociable so that you can join a group.",
					"You can whisper to someone by pressing \"<shift><quote> then typing his or her name.",
					"In a group you can whisper to all the members by pressing \"<shift><quote> then typing !<shift><1> two times."
				},
				1
			)

			player:dialogSeq(
				{
					tdeer,
					"Go now, group with a number of persons to hunt about 12 deer (they have antlers). Hunt more if your group is larger.",
					"It is best to divide the antlers fairly. They, by the way, are a great boon to a warrior, for they hold the power of the deer.",
					"When ground and eaten <u> the vitality flows into you. Be very careful. If you're as fresh as you look you won't survive against a deer!"
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 9 then
			-- Spelunking

			local tmica = {
				graphic = Item("mica").icon,
				color = Item("mica").iconC
			}
			local trats = {graphic = convertGraphic(90, "monster"), color = 11}
			local tpotion = {
				graphic = Item("blue_potion").icon,
				color = Item("blue_potion").iconC
			}

			if player:hasItem("mica", 1) == true then
				player:removeItem("mica", 1, 9)
				player.quest["tutorial_quest"] = 10
				player:addItem("blue_potion", 1)
				player:giveXP(500)

				player:dialogSeq({tmica, "A Mica! Just what I needed."}, 1)
				player:dialogSeq(
					{
						tpotion,
						"Take this, it is one of the potions I made. It will heal some of your wounds..."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"and remember this, you will find many greater secrets in other caves.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"You are ready for something a bit more adventurous now!\nThus far, your travels have been limited to lands above ground, where the Sun keeps much evil away.",
					"But many greater rewards - and challenges - await you beneath the ground."
				},
				1
			)
			local choice = player:menuSeq(
				"I am trying to brew some healing potions. Will you help me to gather the needed components?",
				{"Yes. I am ready for greater things.", "No, not right now."},
				{}
			)

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"Excellent. I have everything I need except for some mica."
					},
					1
				)
				player:dialogSeq(
					{
						trats,
						"There is a cave, not too far from here, where some white rats can occasionally be found."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"You can find their home near a well, beneath a tall golden tree near the Dusk Shaman."
					},
					1
				)
				player:dialogSeq(
					{
						trats,
						"The rats have been corrupted by evil chi. They live not off food like you and I, but from eating the very rock that makes their home."
					},
					1
				)
				player:dialogSeq(
					{
						tmica,
						"Sometimes, you will find that they possess mica, a mineral that can be found in the rock in this area."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"Be careful! Many of the creatures that live below ground are much more dangerous than those you have met thus far.",
						"Bring me one piece of mica so that I may make my potions."
					},
					0
				)
			elseif choice == 2 then
				player:dialogSeq({t, "Perhaps another time, then."}, 0)
			end

			return
		end

		if player.quest["tutorial_quest"] == 10 then
			-- Horse Riding
			local thorse = {graphic = convertGraphic(17, "monster"), color = 3}

			if (player.state == 3 and player.disguise == 26) then
				-- mounted and horse graphic
				player:giveXP(500)
				player.quest["tutorial_quest"] = 11

				player:dialogSeq(
					{
						t,
						"What a great steed you have there. Very impressive indeed, I love to watch horses.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Nothing is better than a swift steed carrying you off to where you want to go. You should learn to ride now, as it will aid you greatly on your way to destiny."
				},
				1
			)
			player:dialogSeq(
				{
					thorse,
					"You can't do much while mounted on a horse, but it is much faster than walking. Go find a horse and ride it back to me."
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"Talk to me again when you are mounted on a horse. Near the top left of the city is a good place to look for horses, there is usually a few there. Once you find one walk up to it and ride it by pressing the [r] key."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 11 then
			if player.quest["helped_haguru"] == 1 then
				player:giveXP(500)
				player.quest["helped_haguru"] = 0
				player.quest["tutorial_quest"] = 12

				player:dialogSeq(
					{
						t,
						"Oh thank you so much for finding my brother! It is such a burden off my mind. He is such a noble one trying to help that town like that.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Oh my... I have just received some bad news. My youngest brother has just gone missing from his home. Are you willing to do me a favor?"
				},
				1
			)

			local choice = player:menuSeq(
				"Will you go look for him, and find out what has happened?",
				{"No, I will not help.", "Yes, I will go look."},
				{}
			)

			if choice == 1 then
				player:dialogSeq(
					{
						t,
						"Oh, what a shame. Sorry, but I can not continue your training until I know what has happened to him"
					},
					0
				)
			elseif choice == 2 then
				player:dialogSeq(
					{
						t,
						"All I can tell you is that he lives in Sanhae, a town far to the north.",
						"You can get there by going back to the stables, and traveling to the Arctic Land.",
						"From there go south east, and follow the valley around. Talk to the Mayor there, he may be able to tell you what happened."
					},
					0
				)
			end
			return
		end

		if player.quest["tutorial_quest"] == 12 then
			-- Better WEapon

			if player:hasLegend("defeated_ice_beast") then
				player.quest["tutorial_quest"] = 13
				player:dialogSeq(
					{
						t,
						"Well done, I see you have upgraded yourself to a better weapon. I hope it works out for you.",
						"If you would like another quest, let me know, I have plenty to teach a young one like yourself."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"So you are still carrying that little stick around to beat on things with? I think you need to upgrade to something better!",
					"Let's see... Ah yes! A good weapon, with great magical properties, and perhaps even a challenge too great for even you.",
					"I have heard tales of a warrior who is a bit of a trickster in the KaMing's encampment. You can get there from the stables you used before.",
					"Go there and talk to him about a new weapon. I am sure he will be willing to \"help\" you, ask about the \"Ice beast\""
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 13 then
			-- End of tutorial quest

			local tstudentcap = {
				graphic = Item("student_cap").icon,
				color = Item("student_cap").iconC
			}

			if player:hasItem("student_cap", 1, 0, player.ID) == true or player:hasEquipped("student_cap") == true then
				-- checks if player has student cap and that it also belongs to them
				player:giveXP(2000)
				player.quest["tutorial_quest"] = 14
				player.quest["visited_yon_and_weaved"] = 0
				player:dialogSeq(
					{
						t,
						"I have taught you all that I can, young one. The time has now come for you to venture out into the Kingdoms and create your own legends."
					},
					0
				)
				return
			end

			if player.quest["visited_yon_and_weaved"] == 1 and player:hasItem("cloth", 1) == true then
				-- checks if playeer actually made the cloth through the npc and that the player still has at least 1 cloth in possession
				player:dialogSeq(
					{
						t,
						"Ah, I see you have visited Yon.. how was she?",
						"Now that you have the cloth, you must visit the museum Caretaker, whom resides in the museum north of Dae Shore. He is the only one who can make your Student Cap."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Well, your time with me is nearly at an end, but before we part I want to give you a small gift to show your time here."
				},
				1
			)
			player:dialogSeq(
				{
					tstudentcap,
					"I will show you the way to prove your worth, by making your very own Student's cap!"
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"This offers good protection during battle even though it is made of cloth.",
					"The first step to making your cap is to get some cloth.\nGoto the center of the wilderness, you will find some sheep there.",
					"Collect some of the wool they drop, and take it to the weavers hut. There are many skills you can learn later on, weaving is just one of them.",
					"There is armor making, weapon smith in both wood and metal, gem crafting, and even cooking!",
					"You will find the weavers near 45,30 in the Wilderness, that's out of the North gate of Kugnae. Ask about \"weaving\" when you get there.",
					"It's quite a walk, so you might want to use a horse. Go now, and return when you have made some cloth."
				},
				0
			)
			return
		end

		if player.quest["tutorial_quest"] == 14 then
			player:dialogSeq(
				{
					t,
					"I have taught you all that I can, young one. The time has come for you to venture out into the Kingdoms and create your own legends."
				},
				0
			)
			return
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

		if speech == "stars" then
			Tools.checkKarma(player)

			if player.level < 60 then
				return
			end

			player:dialogSeq(
				{
					t,
					"Do you seek to understand the stars? It is simple to do. Visit the center of the star with twelve points. Drop a single white amber there. Then you will understand."
				},
				0
			)
			return
		end
	end)
}
