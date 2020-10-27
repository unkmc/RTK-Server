GhengisKhanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Ghengis Khan's Welcome"}

		if player.class == 1 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 10) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
			table.insert(opts, "Join the Barbarians")
		end

		if player.quest["subpath_trials"] == 10 then
			table.insert(opts, "Abandon Trials")
		end

		local buyitems = GhengisKhanNpc.buyItems()
		local sellitems = GhengisKhanNpc.sellItems()

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accommodate some of the things you need. What would you like?",
				buyitems
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellitems)
		elseif menu == "Ghengis Khan's Welcome" then
			player:dialogSeq({t, "Hello and welcome to the Barbarian Cave."}, 0)
			return
		elseif menu == "Join the Barbarians" then
			GhengisKhanNpc.joinTheBarbarians(player, npc)
		elseif menu == "Abandon Trials" then
			local abandon = player:menuString(
				"Are you sure you want to abandon your trials?",
				{"Yes", "No"}
			)
			if abandon == "Yes" then
				GhengisKhanNpc.clearQuestLegends(player)
				player:dialogSeq(
					{
						t,
						"Everything you have learned of the Barbarian, has now been forgotten."
					},
					0
				)
			else
				return
			end
		end
	end),

	clearQuestLegends = function(player)
		player.quest["subpath_trials"] = 0
		player.quest["barbarian_trial"] = 0
		player.quest["barbarian_trial_of_willingness"] = 0
		player.quest["barbarian_trial_of_survival"] = 0
		player.quest["barbarian_trial_of_atonement"] = 0
		player.quest["barbarian_trial_of_atonement_meat_collected"] = 0
		player.quest["barbarian_trial_of_repudiation"] = 0
		player.quest["barbarian_trial_of_competency"] = 0
		player.quest["barbarian_trial_of_competency_prior_wins"] = 0

		player:removeLegendbyName("barbarian_trial_of_willingness")
		player:removeLegendbyName("barbarian_trial_of_survival")
		player:removeLegendbyName("barbarian_trial_of_atonement")
		player:removeLegendbyName("barbarian_trial_of_repudiation")
		player:removeLegendbyName("barbarian_trial_of_competency")
	end,

	action = function(npc)
		local random = math.random(1, 15)
		if random == 1 then
			npc:talk(0, npc.name .. ": Welcome to the Cave of the Barbarians")
		end
	end,

	move = function(npc)
		npc.side = math.random(0, 3)
		npc:sendSide()
	end,

	buyItems = function()
		local buyItems = {
			"rabbit_meat",
			"meat_scrap",
			"horse_meat",
			"antler",
			"bears_liver",
			"tigers_heart"
		}
		return buyItems
	end,

	sellItems = function()
		return GhengisKhanNpc.buyItems()
	end,

	joinTheBarbarians = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		--[[1. Willingness
	2. Survival
	3. Atonement
	4. Repudiation
	5. Competency]]
		--

		if player.level < 50 then
			player:dialogSeq({t, "You are too young to join at this time."}, 0)
			return
		end

		if not player:karmaCheck("dog") then
			player:dialogSeq(
				{t, "Your soul is too impure. Improve your karma and return."},
				0
			)
			return
		end

		if player.quest["subpath_trials"] == 0 then
			player:dialogSeq(
				{
					t,
					"Ah, so you wish to join the ranks of the Barbarian horde? Well, I'll tell you right now, it won't be easy.",
					"Be prepared to be tested more than you have ever been in your life. We Barbarians are a proud bunch, and we don't accept just anyone into our family without knowing they're worth first."
				},
				1
			)

			local join = player:menuString(
				"Are you sure you want to begin the process?",
				{"Yes", "No"}
			)

			if join == "Yes" then
				player.quest["subpath_trials"] = 10
			else
				player:dialogSeq(
					{t, "Very well, begone with you, Townie scum!"},
					0
				)
			end
		end

		if player.quest["subpath_trials"] == 10 then
			-- barb

			if player.quest["barbarian_trial"] == 0 then
				-- trial of willingness

				player:dialogSeq(
					{
						t,
						"The first step is to leave your worldly possessions behind. We Barbarians are a simple folk, and we don't much care for the rotten excesses of the city dwellers, or \"Townies\". You must leave the comforts of your home behind, and abandon your family; for if you are to become one of us, we will become your family.",
						"Return to me once you have abandoned your home and renounced the city life."
					},
					1
				)

				if player.country ~= 0 or player.registry["home"] ~= 0 then
					-- checks to make sure you are aligned with neutral and that you aren't living in any side kingdom areas
					player:dialogSeq(
						{
							t,
							"You must still leave your worldly possessions behind and renounce the city life."
						},
						0
					)
					return
				else
					player:addLegend(
						"Passed the Barbarian trial of Willingness",
						"barbarian_trial_of_willingness",
						16,
						15
					)
					player.quest["barbarian_trial"] = 1
					player:dialogSeq(
						{
							t,
							"So, you have taken your first step and forsaken your past life. I must say, I'm pleasantly surprised. Many cannot bear to leave the comforts of city life behind. I can see you are willing to learn our ways. But believe me, the trials have only just begun."
						},
						1
					)
				end
			end

			if player.quest["barbarian_trial"] == 1 then
				--trial of Survival

				if player.quest["barbarian_trial_of_survival"] == 0 then
					player.quest["barbarian_trial_of_survival"] = os.time() + 453600

					-- 126 IRL hours

					player:dialogSeq(
						{
							t,
							"It's not enough simply to reside in the wild. You must become one with the wild. You must become intimately familiar with its strength, its weaknesses, its desires. Only then can you be considered as one of the Barbarian horde.",
							"We Barbarians pride ourselves in our ability to survive on our own. Go now, to the Wild! Go with only the clothes on your back and the axe in your hand. Live in the wild, amongst the flora and fauna, and survive using only your wits and brute strength.",
							"Seek no help from others, you must do this alone. If you can survive this treacherous task for 6 weeks, then you may return to me and continue your training."
						},
						1
					)
				else
					-- already started quest
					if os.time() < player.quest["barbarian_trial_of_survival"] then
						-- not enough time has elapsed
						player:dialogSeq(
							{
								t,
								"You have not proven your ability to survive on your own in the wild. Please return to me when you have done so."
							},
							0
						)
						return
					end

					player:addLegend(
						"Passed the Barbarian trial of Survival",
						"barbarian_trial_of_survival",
						16,
						15
					)
					player.quest["barbarian_trial_of_survival"] = 0
					player.quest["barbarian_trial"] = 2
					player:dialogSeq(
						{
							t,
							"You went all 6 weeks, and you're still alive?! Though, a bit banged up I see. Nevermind that, a little emaciation is good for the soul.",
							"You have shown yourself to be a formidable survivalist, and are now one step closer to being embraced by our tribe."
						},
						0
					)
				end
			end

			if player.quest["barbarian_trial"] == 2 then
				-- trial of atonement

				if player.quest["barbarian_trial_of_atonement"] == 0 then
					-- not started quest
					player:dialogSeq(
						{
							t,
							"There is nothing more important to a Barbarian than his or her family! Tonight, we celebrate our way of life and our love and devotion towards each other.",
							"Go and collect 10 full loads of meat from the vicious tiger, for our kin to enjoy. You will find these tigers in the Iron Labyrinth to the south.",
							"The danger involved in the collection of this Barbarian delicacy only satiates our hunger further."
						},
						1
					)

					player.quest["barbarian_trial_of_atonement"] = 1
				elseif player.quest["barbarian_trial_of_atonement"] == 1 then
					-- started quest

					if player.quest["barbarian_trial_of_atonement_meat_collected"] < 200 then
						if player:hasItem("tiger_meat", 20) ~= true then
							player:dialogSeq(
								{
									t,
									"You need a full stack of tiger meat to add to the total. Come back to me when you do."
								},
								0
							)
							return
						end

						player:removeItem("tiger_meat", 20)
						player.quest[
							"barbarian_trial_of_atonement_meat_collected"
						] = player.quest[
							"barbarian_trial_of_atonement_meat_collected"
						] + 20

						player:dialogSeq(
							{
								t,
								"Thank you for the tiger meat. You now only need (" .. (200 - player.quest["barbarian_trial_of_atonement_meat_collected"]) .. ") more tiger meat to complete this task."
							},
							1
						)
					end

					if player.quest["barbarian_trial_of_atonement_meat_collected"] >= 200 then
						player.quest[
							"barbarian_trial_of_atonement_meat_collected"
						] = 0
						player.quest["barbarian_trial_of_atonement"] = 0
						player.quest["barbarian_trial"] = 3
						player:addLegend(
							"Passed the Barbarian trial of Atonement",
							"barbarian_trial_of_atonement",
							16,
							15
						)
						player:dialogSeq(
							{
								t,
								"Excellent, you have done well. This meat will help to satisfy the massive appetite of the Barbarian horde. Tonight, we feast!"
							},
							1
						)
					end
				end
			end

			if player.quest["barbarian_trial"] == 3 then
				-- trial of repudiation

				local mobs1 = player:allMythicCaveBosses("dragon")
				local quest = "barbarian_trial_of_repudiation"

				if player.quest["barbarian_trial_of_repudiation"] == 0 then
					player:dialogSeq(
						{
							t,
							"Before your next task, first a little exposition. We Barbarians aren't simply against the ways of the townfolk's lavish lifestyles. We stand against everything they hold dear. This includes the unwavering allegiance to unjust hierarchies.",
							"We Barbarians tend to be seen by Townies as cruel, heartless, morons. Nothing could be further from the truth. Nay, it is the townsfolk who are the fools. Their near-perverted idolatry of their kings, queens, generals, and other rulers, makes them little more than pitiful lambs ripe for slaughter.",
							"We prefer to live a primarily non-hierarchical lifestyle, relying heavily on the democratic process. While there is still an Elder, and there are Guides, see these figures more as thought leaders than as dictators or oligarchs to be followed without question.",
							"These are members of our community who have been here the longest, and done the most for our kind. Respect them as such, but you are not required to worship them or treat them as infallible.",
							"It is in this way that Barbarians greatly differ from the other groups you'll find throughout the lands."
						},
						1
					)

					player.quest["barbarian_trial_of_repudiation"] = 1

					-- get current kill counts

					--player:setQuestKillCounts(quest,mobs1)

					player:dialogSeq(
						{
							t,
							"One such group you will find, a particularly distasteful group, are the Dragons. There is no other enclave so hopelessly lost to the ruse of the dreaded hierarchy and the rule of the iron fist.",
							"Alleviate them of their pathetic obsession with being controlled by cutting the heads off of their leaders and bringing them to me. ((Kill 1 of each Dragon boss.))"
						},
						1
					)
				elseif player.quest["barbarian_trial_of_repudiation"] == 1 then
					if not player:killedEnough(mobs1, 1) then
						player:dialogSeq(
							{
								t,
								"You have not heeded my words. I am still waiting for you to kill each Dragon boss."
							},
							0
						)
						return
					end

					-- remove clearquestcounts 2 months from 07/18/19
					player:clearQuestKillCounts(quest, mobs1)

					player.quest["barbarian_trial_of_repudiation"] = 2

					--player:setQuestKillCounts(quest,mobs1)

					player:dialogSeq(
						{
							t,
							"Wonderful, these heads will look great stuffed and mounted above the family mantle. Though, I don't expect what you've done to change the minds of the Dragon clan.",
							"No doubt, the Dragons are already scrambling around, looking for someone else to tell them how to live. Some, I suppose, desperately seek to be dominated.",
							"In fact, we're not done with them yet. Go and bring me the heads of their 2 replacement leaders. ((Kill 1 more of each Dragon boss.))"
						},
						1
					)
				elseif player.quest["barbarian_trial_of_repudiation"] == 2 then
					if not player:killedEnough(mobs1, 1) then
						player:dialogSeq(
							{
								t,
								"You have not heeded my words. I am still waiting for you to kill 1 more of each Dragon boss."
							},
							0
						)
						return
					end

					player:clearQuestKillCounts(quest, mobs1)

					player.quest["barbarian_trial_of_repudiation"] = 0
					player.quest["barbarian_trial"] = 4
					player:addLegend(
						"Passed the Barbarian trial of Repudiation",
						"barbarian_trial_of_repudiation",
						16,
						15
					)
					player:dialogSeq(
						{
							t,
							"I did warn you at the start that this would not be easy, didn't I? But you've made it this far, much further than most.",
							"I commend you on your display of courage and determination. However there is still one final test before you can be considered one of us."
						},
						1
					)
				end
			end

			if player.quest["barbarian_trial"] == 4 then
				-- trial of competency

				if player.quest["barbarian_trial_of_competency"] == 0 then
					-- not started
					player.quest["barbarian_trial_of_competency"] = 1

					player.quest["barbarian_trial_of_competency_prior_wins"] = player.registry[
						"carnageWin"
					]

					player:dialogSeq(
						{
							t,
							"We Barbarians are no pushovers, we are skilled fighters. Go and win 3 more Riches carnage events. Bathe your axe in the blood of the Townie enemies and return it here for me to examine.",
							"If you can prove that you are skilled in the ways of battle, you may join us. Any wins prior to this moment will not count."
						},
						1
					)
				elseif player.quest["barbarian_trial_of_competency"] == 1 then
					--started

					local diff = player.registry["carnageWin"] - player.quest[
						"barbarian_trial_of_competency_prior_wins"
					]

					if diff < 3 then
						-- has not received 3 new carny wins
						player:dialogSeq(
							{
								t,
								"I am still waiting for you to prove your ability in battle. You must attain (" .. (3 - diff) .. ") more Carnage victories to prove your worth."
							},
							0
						)
						return
					end

					GhengisKhanNpc.clearQuestLegends(player)

					-- add legend for barbarian (maybe?)

					player:updatePath(10, player.mark)
					broadcast(
						-1,
						"[SUBPATH]: Congratulations to our newest " .. player.classNameMark .. " " .. player.name .. "!"
					)

					player:dialogSeq(
						{
							t,
							"You've done it. You've finally finished your training. You've demonstrated each of the 5 most important components of a true Barbarian lifestyle.",
							"You've disregarded the allure of the city life and their wasteful existance. You've displayed your wilderness survival skills. You've shown your faithfulness to family (and appreciation for delicious Tiger Meat!).",
							"You've proven your aversion to hierarchies. And now, finally, you've exhibited your exceptional skills in battle.",
							"You are now one of us. Welcome to the family!"
						},
						0
					)
				end
			end
		end
	end,
}
