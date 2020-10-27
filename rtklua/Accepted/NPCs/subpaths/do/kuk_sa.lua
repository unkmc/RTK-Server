KukSaNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Kuk-Sa's Welcome"}

		if player.class == 1 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 18) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
			table.insert(opts, "Join the Do")
		end

		if player.quest["subpath_trials"] == 18 then
			table.insert(opts, "Abandon Trials")
		end

		local buyitems = KukSaNpc.buyItems()
		local sellitems = KukSaNpc.sellItems()

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accommodate some of the things you need. What would you like?",
				buyitems
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellitems)
		elseif menu == "Kuk-Sa's Welcome" then
			player:dialogSeq(
				{
					t,
					"Hello and welcome to the Do Training Arena.",
					"Here you can learn to fight."
				},
				1
			)
			return
		elseif menu == "Join the Do" then
			KukSaNpc.joinTheDo(player, npc)
		elseif menu == "Abandon Trials" then
			local abandon = player:menuString(
				"Are you sure you want to abandon your trials?",
				{"Yes", "No"}
			)
			if abandon == "Yes" then
				KukSaNpc.clearQuestLegends(player)
				player:dialogSeq(
					{
						t,
						"Everything you have learned of the Do, has now been forgotten."
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
		player.quest["do_trial"] = 0
		player.quest["do_trial_of_patience"] = 0

		player:removeLegendbyName("do_trial_of_patience")
	end,

	action = function(npc)
		local random = math.random(1, 15)
		if random == 1 then
			npc:talk(0, npc.name .. ": Welcome to the Do Training Arena")
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
		return KukSaNpc.buyItems()
	end,

	joinTheDo = function(player, npc)
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
					"Ah, so you wish to walk amongst the Do? Well, we do not just teach anyone our ways.",
					"It takes a special warrior to understand our ways and our life.",
					"I can only show you the door to enlightenment but it is you who must learn to walk the path."
				},
				1
			)

			local join = player:menuString(
				"Are you sure you want to begin the process of becoming a Do?",
				{"Yes", "No"}
			)

			if join == "Yes" then
				player.quest["subpath_trials"] = 18
			else
				player:dialogSeq({t, "Very well."}, 0)
			end
		end

		if player.quest["subpath_trials"] == 18 then
			-- do

			if player.quest["do_trial"] == 0 then
				-- trial of patience

				player.quest["do_trial"] = 1
				player.quest["do_trial_of_patience"] = os.time() + 302400

				-- 84 hours
				player:dialogSeq(
					{
						t,
						"The first step is to learn the meaning of patience and self reflection. It is imperative that one fully understands that we can only teach those who are willing to understand.",
						"Please return to me in 4 weeks and I will assess that you have learned your first lesson well."
					},
					0
				)
				return
			else
				if os.time() < player.quest["do_trial_of_patience"] then
					player:dialogSeq(
						{
							t,
							"You have not yet shown that you are willing to be patient. You need to self-reflect and prove you are willing to learn."
						},
						0
					)
					return
				end

				player:addLegend(
					"Passed the Do trial of Patience",
					"do_trial_of_patience",
					18,
					15
				)
				player.quest["do_trial"] = 2
				player:dialogSeq(
					{
						t,
						"Ah, so you have taken your first step towards enlightenment. I can see that you are truly willing to learn our ways and life. You have taken your first step towards becoming one with us."
					},
					1
				)
			end

			--[[if player.quest["do_trial"] == 2 then -- trial of atonement

			if player.quest["barbarian_trial_of_atonement"] == 0 then -- not started quest
				player:dialogSeq({t,"There is nothing more important to a Barbarian than his or her family! Tonight, we celebrate our way of life and our love and devotion towards each other.",
							"Go and collect 10 full loads of meat from the vicious tiger, for our kin to enjoy. You will find these tigers in the Iron Labyrinth to the south.",
							"The danger involved in the collection of this Barbarian delicacy only satiates our hunger further."},1)

				player.quest["barbarian_trial_of_atonement"] = 1

			elseif player.quest["barbarian_trial_of_atonement"] == 1 then -- started quest

				if player.quest["barbarian_trial_of_atonement_meat_collected"] < 200 then

					if player:hasItem("tiger_meat",20) ~= true then
						player:dialogSeq({t,"You need a full stack of tiger meat to add to the total. Come back to me when you do."},0)
					return
					end

					player:removeItem("tiger_meat",20)
					player.quest["barbarian_trial_of_atonement_meat_collected"] = player.quest["barbarian_trial_of_atonement_meat_collected"] + 20

					player:dialogSeq({t,"Thank you for the tiger meat. You now only need ("..(200-player.quest["barbarian_trial_of_atonement_meat_collected"])..") more tiger meat to complete this task."},1)

				end

				if player.quest["barbarian_trial_of_atonement_meat_collected"] >= 200 then

					player.quest["barbarian_trial_of_atonement_meat_collected"] = 0
					player.quest["barbarian_trial_of_atonement"] = 0
					player.quest["barbarian_trial"] = 3
					player:addLegend("Passed the Barbarian trial of Atonement","barbarian_trial_of_atonement",16,15)
					player:dialogSeq({t,"Excellent, you have done well. This meat will help to satisfy the massive appetite of the Barbarian horde. Tonight, we feast!"},1)

				end
			end
		end

		if player.quest["barbarian_trial"] == 3 then -- trial of repudiation

			local mobs1 = player:allMythicCaveBosses("dragon")
			local quest = "barbarian_trial_of_repudiation"

			if player.quest["barbarian_trial_of_repudiation"] == 0 then

				player:dialogSeq({t,"Before your next task, first a little exposition. We Barbarians aren't simply against the ways of the townfolk's lavish lifestyles. We stand against everything they hold dear. This includes the unwavering allegiance to unjust hierarchies.",
						"We Barbarians tend to be seen by Townies as cruel, heartless, morons. Nothing could be further from the truth. Nay, it is the townsfolk who are the fools. Their near-perverted idolatry of their kings, queens, generals, and other rulers, makes them little more than pitiful lambs ripe for slaughter.",
						"We prefer to live a primarily non-hierarchical lifestyle, relying heavily on the democratic process. While there is still an Elder, and there are Guides, see these figures more as thought leaders than as dictators or oligarchs to be followed without question.",
						"These are members of our community who have been here the longest, and done the most for our kind. Respect them as such, but you are not required to worship them or treat them as infallible.",
						"It is in this way that Barbarians greatly differ from the other groups you'll find throughout the lands."},1)

				player.quest["barbarian_trial_of_repudiation"] = 1

				-- get current kill counts

				player:setQuestKillCounts(quest,mobs1)

				player:dialogSeq({t,"One such group you will find, a particularly distasteful group, are the Dragons. There is no other enclave so hopelessly lost to the ruse of the dreaded hierarchy and the rule of the iron fist.",
					"Alleviate them of their pathetic obsession with being controlled by cutting the heads off of their leaders and bringing them to me. ((Kill 1 of each Dragon boss.))"},1)

			elseif player.quest["barbarian_trial_of_repudiation"] == 1 then

				if not player:killedEnough(quest,mobs1,1) then
					player:dialogSeq({t,"You have not heeded my words. I am still waiting for you to kill each Dragon boss."},0)
				return
				end

				player:clearQuestKillCounts(quest,mobs1)
				player.quest["barbarian_trial_of_repudiation"] = 2

				player:setQuestKillCounts(quest,mobs1)

				player:dialogSeq({t,"Wonderful, these heads will look great stuffed and mounted above the family mantle. Though, I don't expect what you've done to change the minds of the Dragon clan.",
						"No doubt, the Dragons are already scrambling around, looking for someone else to tell them how to live. Some, I suppose, desperately seek to be dominated.",
						"In fact, we're not done with them yet. Go and bring me the heads of their 2 replacement leaders. ((Kill 1 more of each Dragon boss.))"},1)

			elseif player.quest["barbarian_trial_of_repudiation"] == 2 then

				if not player:killedEnough(quest,mobs1,1) then
					player:dialogSeq({t,"You have not heeded my words. I am still waiting for you to kill 1 more of each Dragon boss."},0)
				return
				end

				player:clearQuestKillCounts(quest,mobs1)
				player.quest["barbarian_trial_of_repudiation"] = 0
				player.quest["barbarian_trial"] = 4
				player:addLegend("Passed the Barbarian trial of Repudiation","barbarian_trial_of_repudiation",16,15)
				player:dialogSeq({t,"I did warn you at the start that this would not be easy, didn't I? But you've made it this far, much further than most.",
						"I commend you on your display of courage and determination. However there is still one final test before you can be considered one of us."},1)
			end
		end

		if player.quest["barbarian_trial"] == 4 then -- trial of competency

			if player.quest["barbarian_trial_of_competency"] == 0 then -- not started
				player.quest["barbarian_trial_of_competency"] = 1

				player.quest["barbarian_trial_of_competency_prior_wins"] = player.registry["carnageWin"]

				player:dialogSeq({t,"We Barbarians are no pushovers, we are skilled fighters. Go and win 3 more Riches carnage events. Bathe your axe in the blood of the Townie enemies and return it here for me to examine.",
						"If you can prove that you are skilled in the ways of battle, you may join us. Any wins prior to this moment will not count."},1)

			elseif player.quest["barbarian_trial_of_competency"] == 1 then --started

				local diff = player.registry["carnageWin"] - player.quest["barbarian_trial_of_competency_prior_wins"]

				if diff < 3 then -- has not received 3 new carny wins
					player:dialogSeq({t,"I am still waiting for you to prove your ability in battle. You must attain ("..(3-diff)..") more Carnage victories to prove your worth."},0)
				return
				end

				GhengisKhanNpc.clearQuestLegends(player)
				-- add legend for barbarian (maybe?)

				player:updatePath(18,player.mark)
				broadcast(-1,"[SUBPATH]: Congratulations to our newest "..player.classNameMark.." "..player.name.."!")

				player:dialogSeq({t,"You've done it. You've finally finished your training. You've demonstrated each of the 5 most important components of a true Barbarian lifestyle.",
					"You've disregarded the allure of the city life and their wasteful existance. You've displayed your wilderness survival skills. You've shown your faithfulness to family (and appreciation for delicious Tiger Meat!).",
					"You've proven your aversion to hierarchies. And now, finally, you've exhibited your exceptional skills in battle.",
					"You are now one of us. Welcome to the family!"},0)

			end
		end]]
			--
		end
	end,
}
