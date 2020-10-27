BonHwaNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.m ~= npc.m then
			return
		end

		if ((player.baseHealth < 80000 and player.baseMagic < 40000) or player.level < 99) then
			player:dialogSeq(
				{
					t,
					"It was foolhardy of you to venture here, one so weak as yourself. There is nothing I can do for you."
				},
				0
			)
			return
		end

		local options = {"Bon-Hwa Immortality", "Shadow Stats"}

		if ((player.baseHealth >= 160000 or player.baseMagic >= 80000) and player.mark == 0) then
			table.insert(options, "Il San")
		elseif ((player.baseHealth >= 320000 or player.baseMagic >= 160000) and player.mark == 1) then
			table.insert(options, "Ee San")
		elseif ((player.baseHealth >= 640000 or player.baseMagic >= 320000) and player.mark == 2) then
			--table.insert(options,"Sam San")
		elseif ((player.baseHealth >= 1280000 or player.baseMagic >= 640000) and player.mark == 3) then
			--table.insert(options,"Sa San")
		elseif ((player.baseHealth >= 2560000 or player.baseMagic >= 1280000) and player.mark == 4) then
			--table.insert(options,"Oh San")
		end

		if player.m ~= npc.m then
			return
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Shadow Stats" then
			ExpSellerNpc.showShadowStatsMenu(player, npc)
		elseif choice == "Bon-Hwa Immortality" then
			if player.m ~= npc.m then
				return
			end

			local options2 = {"My Weapon"}

			local choice2 = player:menuString(
				"What would you like to enchant?",
				options2
			)

			if choice2 == "My Weapon" then
				local availableItems = {}
				local pathItems = {}
				local subpathItems = {}

				--- base paths ---
				if player.baseClass == 1 then
					pathItems = {
						"spike",
						"enchanted_spike",
						"il_san_spike",
						"ee_san_spike",
						"sam_san_spike",
						"sa_san_spike"
					}
				elseif player.baseClass == 2 then
					pathItems = {
						"blood",
						"enchanted_blood",
						"il_san_blood",
						"ee_san_blood",
						"sam_san_blood",
						"sa_san_blood"
					}
				elseif player.baseClass == 3 then
					pathItems = {
						"surge",
						"enchanted_surge",
						"il_san_surge",
						"ee_san_surge",
						"sam_san_surge",
						"sa_san_surge"
					}
				elseif player.baseClass == 4 then
					pathItems = {
						"charm",
						"enchanted_charm",
						"il_san_charm",
						"ee_san_charm",
						"sam_san_charge",
						"sa_san_charge"
					}
				end

				for i = 1, #pathItems do
					table.insert(availableItems, pathItems[i])
				end

				if subpathItems ~= nil then
					for i = 1, #subpathItems do
						table.insert(availableItems, subpathItems[i])
					end
				end

				local itemChoice = player:sell(
					"Please select the weapon you would like to enchant",
					availableItems
				)
				local selection = player:getInventoryItem(itemChoice - 1)
				local selected_item = {
					name = selection.name,
					yname = selection.yname
				}

				local currentItemLevel = 1
				local maxItemLevel = 1
				local maxItemLevelString = ""
				local baseItemLevelString = ""

				if player.mark == 0 and (player.baseHealth >= 80000 or player.baseMagic >= 40000) then
					-- enchanted
					maxItemLevel = 2
					maxItemLevelString = "enchanted"
				elseif player.mark == 1 then
					maxItemLevel = 3
					maxItemLevelString = "il_san"
				elseif player.mark == 2 then
					maxItemLevel = 4
					maxItemLevelString = "ee_san"
				elseif player.mark == 3 then
					maxItemLevel = 5
					maxItemLevelString = "sam_san"
				elseif player.mark == 4 then
					maxItemLevel = 6
					maxItemLevelString = "sa_san"
				end

				for i = 1, #pathItems do
					if selection.yname == pathItems[i] then
						currentItemLevel = i
						baseItemLevelString = pathItems[1]
						break
					end
				end

				if subpathItems ~= nil then
					for i = 1, #subpathItems do
						if selection.yname == subpathItems[i] then
							currentItemLevel = i
							baseItemLevelString = subpathItems[1]
						end
					end
				end

				if currentItemLevel >= maxItemLevel then
					player:dialogSeq(
						{
							t,
							"Your " .. selected_item.name .. " is already upgraded to its max level and cannot be upgraded further."
						},
						0
					)
					return
				end

				local choice3 = player:menuSeq(
					"It will cost " .. Tools.formatNumber(200000000) .. " experience to enchant the " .. selected_item.name .. " to your current mark.\n\nWould you like to upgrade this item?",
					{"Okay", "No"},
					{}
				)

				if choice3 == 1 then
					-- accept
					if player.exp < 200000000 then
						player:dialogSeq(
							{t, "You do not have enough experience."},
							0
						)
						return
					end

					player.exp = player.exp - 200000000
					player:sendStatus()
					player:removeItemSlot(itemChoice - 1, 1)
					player:addItem(
						maxItemLevelString .. "_" .. baseItemLevelString,
						1,
						0,
						player.ID
					)
					player:dialogSeq({t, "Use this weapon well and wisely."}, 0)
				elseif choice3 == 1 then
					-- no
					player:dialogSeq(
						{t, "Please return to me if you change your mind."},
						0
					)
				end
			end
		elseif choice == "Il San" then
			local options = {}

			if player:hasLegend("passed_first_trial_of_knowledge") and player:hasLegend("passed_first_trial_of_strength") and player:hasLegend("passed_first_trial_of_wealth") then
				local anim

				if player.baseClass == 1 then
					anim = 83
				elseif player.baseClass == 2 then
					anim = 82
				elseif player.baseClass == 3 then
					anim = 81
				elseif player.baseClass == 4 then
					anim = 80
				end

				player:sendAnimation(anim, 5)

				player:removeLegendbyName("passed_first_trial_of_knowledge")
				player:removeLegendbyName("passed_first_trial_of_strength")
				player:removeLegendbyName("passed_first_trial_of_wealth")

				player:addLegend(
					"Attained First Mark (" .. curT() .. ")",
					"attained_first_mark",
					32,
					15
				)
				player:updatePath(player.class, 1)
				characterLog.genericWrite(player, "Attained First Mark")
				broadcast(
					-1,
					"[SYSTEM]: " .. player.name .. " has attained First Mark!"
				)
			end

			if not player:hasLegend("passed_first_trial_of_knowledge") then
				table.insert(options, "First Trial of Knowledge")
			end
			if not player:hasLegend("passed_first_trial_of_strength") then
				table.insert(options, "First Trial of Strength")
			end
			if not player:hasLegend("passed_first_trial_of_wealth") then
				table.insert(options, "First Trial of Wealth")
			end

			local choice2 = player:menuString("Please select a trial.", options)

			if choice2 == "First Trial of Knowledge" then
				local choice3 = player:menuSeq(
					"To complete this trial, you must sacrifice to me 1,200,000,000 (1.2 Billion) experience. Do you wish to do so?",
					{"Yes", "No"},
					{}
				)

				if choice3 == 1 then
					-- yes
					if player.exp < 1200000000 then
						player:dialogSeq(
							{t, "Come back when you have enough experience."},
							0
						)
						return
					end

					player.exp = player.exp - 1200000000
					player:sendStatus()

					player:addLegend(
						"Passed First Trial of Knowledge (" .. curT() .. ")",
						"passed_first_trial_of_knowledge",
						3,
						15
					)

					player:dialogSeq(
						{
							t,
							"Congratulations! You have completed the First Trial of Knowledge."
						},
						0
					)
				elseif choice3 == 2 then
					-- no
					player:dialogSeq({t, "Come back when you are serious."}, 0)
				end
			elseif choice2 == "First Trial of Strength" then
				player:dialogSeq(
					{
						t,
						"For this trial, I will need you to kill the pesky Spirit Rat who lurks in the Rat Cave. Return to me when you have done so."
					},
					1
				)

				if player:killCount("spirit_rat") >= 1 then
					-- killed spirit rat
					player:addLegend(
						"Passed First Trial of Strength (" .. curT() .. ")",
						"passed_first_trial_of_strength",
						1,
						15
					)
					player:dialogSeq(
						{
							t,
							"Congratulations! You have completed the First Trial of Strength."
						},
						0
					)
				else
					player:dialogSeq(
						{t, "You still need to slay the Spirit Rat."},
						0
					)
					return
				end
			elseif choice2 == "First Trial of Wealth" then
				local choice3 = player:menuSeq(
					"To complete this trial, you must sacrifice to me 600,000 coins and 5 Well Crafted White ambers. Do you wish to do so?",
					{"Yes", "No"},
					{}
				)

				if choice3 == 1 then
					--yes
					if player.money < 600000 then
						player:dialogSeq(
							{t, "Return to me when you have the gold."},
							0
						)
						return
					end

					if player:hasItem("well_crafted_white_amber", 5) ~= true then
						player:dialogSeq(
							{
								t,
								"Return to me when you have the 5 well crafted white ambers."
							},
							0
						)
						return
					end

					player:removeGold(600000)
					player:removeItem("well_crafted_white_amber", 5)
					player:addLegend(
						"Passed First Trial of Wealth (" .. curT() .. ")",
						"passed_first_trial_of_wealth",
						1,
						15
					)
				elseif choice3 == 2 then
					--no
					player:dialogSeq({t, "Come back when you are serious."}, 0)
					return
				end
			end
		elseif choice == "Ee San" then
			local options = {}

			if player:hasLegend("passed_second_trial_of_knowledge") and player:hasLegend("passed_second_trial_of_strength") and player:hasLegend("passed_second_trial_of_wealth") and player:hasLegend("passed_second_trial_of_skill") and player:hasLegend("passed_second_trial_of_culture") and player:hasLegend("passed_second_trial_of_spirit") then
				local anim

				if player.baseClass == 1 then
					anim = 83
				elseif player.baseClass == 2 then
					anim = 82
				elseif player.baseClass == 3 then
					anim = 81
				elseif player.baseClass == 4 then
					anim = 80
				end

				player:sendAnimation(anim, 5)

				player:removeLegendbyName("passed_second_trial_of_knowledge")
				player:removeLegendbyName("passed_second_trial_of_strength")
				player:removeLegendbyName("passed_second_trial_of_wealth")
				player:removeLegendbyName("passed_second_trial_of_skill")
				player:removeLegendbyName("passed_second_trial_of_culture")
				player:removeLegendbyName("passed_second_trial_of_spirit")

				player:addLegend(
					"Attained Second Mark (" .. curT() .. ")",
					"attained_second_mark",
					33,
					15
				)
				player:updatePath(player.class, 2)
				characterLog.genericWrite(player, "Attained Second Mark")
				broadcast(
					-1,
					"[SYSTEM]: " .. player.name .. " has attained Second Mark!"
				)
			end

			if not player:hasLegend("passed_second_trial_of_knowledge") then
				table.insert(options, "Second Trial of Knowledge")
			end
			if not player:hasLegend("passed_second_trial_of_strength") then
				table.insert(options, "Second Trial of Strength")
			end
			if not player:hasLegend("passed_second_trial_of_wealth") then
				table.insert(options, "Second Trial of Wealth")
			end
			if not player:hasLegend("passed_second_trial_of_skill") then
				table.insert(options, "Second Trial of Skill")
			end
			if not player:hasLegend("passed_second_trial_of_culture") then
				table.insert(options, "Second Trial of Culture")
			end
			if not player:hasLegend("passed_second_trial_of_spirit") then
				table.insert(options, "Second Trial of Spirit")
			end

			local choice2 = player:menuString("Please select a trial.", options)

			if choice2 == "Second Trial of Knowledge" then
				local choice3 = player:menuSeq(
					"To complete this trial, you must sacrifice to me 1,200,000,000 (1.2 Billion) experience. Do you wish to do so?",
					{"Yes", "No"},
					{}
				)

				if choice3 == 1 then
					-- yes
					if player.exp < 1200000000 then
						player:dialogSeq(
							{t, "Come back when you have enough experience."},
							0
						)
						return
					end

					player.exp = player.exp - 1200000000
					player:sendStatus()

					player:addLegend(
						"Passed Second Trial of Knowledge (" .. curT() .. ")",
						"passed_second_trial_of_knowledge",
						3,
						15
					)

					player:dialogSeq(
						{
							t,
							"Congratulations! You have completed the Second Trial of Knowledge."
						},
						0
					)
				elseif choice3 == 2 then
					-- no
					player:dialogSeq({t, "Come back when you are serious."}, 0)
				end
			elseif choice2 == "Second Trial of Culture" then
				player:dialogSeq(
					{
						t,
						"For this trial, I will need you to attain Skilled level or better in either Tailoring, Metalworking, Jewelcrafting, or Carpentry"
					},
					1
				)

				if crafting.checkSkillLevel(player, "tailoring", "skilled") or crafting.checkSkillLevel(
					player,
					"metalworking",
					"skilled"
				) or crafting.checkSkillLevel(player, "woodworking", "skilled") or crafting.checkSkillLevel(
					player,
					"jewelry making",
					"skilled"
				) then
					player:addLegend(
						"Passed Second Trial of Culture (" .. curT() .. ")",
						"passed_second_trial_of_culture",
						3,
						15
					)
					player:dialogSeq(
						{
							t,
							"Congratulations! You have completed the Second Trial of Culture."
						},
						0
					)
					return
				else
					player:dialogSeq(
						{
							t,
							"You are not yet Skilled level in either Tailoring, Metalworking, Jewelcrafting, or Carpentry. Return to me when you are."
						},
						0
					)
					return
				end
			elseif choice2 == "Second Trial of Spirit" then
				if not player:karmaCheck("tiger") then
					player:dialogSeq(
						{
							t,
							"You must have at least Tiger karma or better to pass the Second Trial of Spirit"
						},
						0
					)
					return
				end

				player:addLegend(
					"Passed Second Trial of Spirit (" .. curT() .. ")",
					"passed_second_trial_of_spirit",
					3,
					15
				)
				player:dialogSeq(
					{
						t,
						"Congratulations! You have completed the Second Trial of Spirit."
					},
					0
				)
			elseif choice2 == "Second Trial of Skill" then
				local passed = false
				player:dialogSeq(
					{
						t,
						"For this trial, I will need you to attain at least 6 carnage victories or 12 combined minigame victories. Return to me when you have done so."
					},
					1
				)

				if player.registry["carnageWin"] >= 6 then
					passed = true
				end

				if player.registry["carnageWin"] + player.registry["elixir_war_victories"] + player.registry[
					"bomber_war_wins"
				] + player.registry["beach_war_wins"] + player.registry[
					"sumo_war_wins"
				] >= 12 then
					passed = true
				end

				if passed == false then
					player:dialogSeq(
						{
							t,
							"You have not achieved enough victories to satisfy my desire for blood shed. Return to me when you have."
						},
						0
					)
					return
				end

				player:addLegend(
					"Passed Second Trial of Skill (" .. curT() .. ")",
					"passed_second_trial_of_skill",
					1,
					15
				)
				player:dialogSeq(
					{
						t,
						"Congratulations! You have completed the Second Trial of Skill."
					},
					0
				)
			elseif choice2 == "Second Trial of Strength" then
				local mobs1 = player:allMythicCaveBosses("rabbit")
				local mobs2 = player:allMythicCaveBosses("monkey")
				local mobs3 = player:allMythicCaveBosses("dog")
				local mobs4 = player:allMythicCaveBosses("rooster")
				local mobs5 = player:allMythicCaveBosses("rat")
				local mobs6 = player:allMythicCaveBosses("ox")
				local mobs7 = player:allMythicCaveBosses("horse")
				local mobs8 = player:allMythicCaveBosses("pig")

				local quest = "second_trial_of_strength"

				if player.quest["second_trial_of_strength"] == 0 then
					player:dialogSeq(
						{
							t,
							"For this trial, I will need you to kill the Spirit and Avenger bosses in the Mythic caves, except Tiger, Dragon, Sheep and Snake. Return to me when you have done so."
						},
						1
					)

					player.quest[quest] = 1

					--[[player:setQuestKillCounts(quest,mobs1)
						player:setQuestKillCounts(quest,mobs2)
						player:setQuestKillCounts(quest,mobs3)
						player:setQuestKillCounts(quest,mobs4)
						player:setQuestKillCounts(quest,mobs5)
						player:setQuestKillCounts(quest,mobs6)
						player:setQuestKillCounts(quest,mobs7)
						player:setQuestKillCounts(quest,mobs8)]]
					--
				elseif player.quest[quest] == 1 then
					local count = 0
					local diff = 1

					if player:killedEnough(mobs1, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs2, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs3, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs4, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs5, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs6, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs7, diff) then
						count = count + 1
					end
					if player:killedEnough(mobs8, diff) then
						count = count + 1
					end

					if count < 8 then
						player:dialogSeq(
							{
								t,
								"You did not heed my words and kill enough to fill my vengeance!"
							},
							0
						)
						return
					end

					-- these functions will need disabled in future, let run for 2 months from 07/18/19
					player:clearQuestKillCounts(quest, mobs1)
					player:clearQuestKillCounts(quest, mobs2)
					player:clearQuestKillCounts(quest, mobs3)
					player:clearQuestKillCounts(quest, mobs4)
					player:clearQuestKillCounts(quest, mobs5)
					player:clearQuestKillCounts(quest, mobs6)
					player:clearQuestKillCounts(quest, mobs7)
					player:clearQuestKillCounts(quest, mobs8)

					player:addLegend(
						"Passed Second Trial of Strength (" .. curT() .. ")",
						"passed_second_trial_of_strength",
						1,
						15
					)
					player:dialogSeq(
						{
							t,
							"Congratulations! You have completed the Second Trial of Strength."
						},
						0
					)
				end
			elseif choice2 == "Second Trial of Wealth" then
				local choice3 = player:menuSeq(
					"To complete this trial, you must sacrifice to me 2,000,000 gold. Do you wish to do so?",
					{"Yes", "No"},
					{}
				)

				if choice3 == 1 then
					--yes
					if player.money < 2000000 then
						player:dialogSeq(
							{t, "Return to me when you have the gold."},
							0
						)
						return
					end

					player:removeGold(2000000)

					player:addLegend(
						"Passed Second Trial of Wealth (" .. curT() .. ")",
						"passed_second_trial_of_wealth",
						7,
						15
					)
				elseif choice3 == 2 then
					--no
					player:dialogSeq({t, "Come back when you are serious."}, 0)
					return
				end
			end
		end
	end)
}
