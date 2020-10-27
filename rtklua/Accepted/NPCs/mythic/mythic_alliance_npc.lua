MythicAllianceNpc = {
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

		--[[
			Horse <> Rat
			Rooster <> Rabbit
			Snake <> Pig
			Dog <> Dragon
			Sheep <> Ox
			Tiger <> Monkey
		]]--

		local alliance = ""
		local enemy = ""
		local item1
		local item1_amount
		local item2
		local item2_amount

		if player.mapTitle == "Mythic Dragon" then
			alliance = "Dragon"
			enemy = "Dog"
			item1 = "fragile_rose"
			item1_amount = 4
			item2 = "key_to_wind"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Dog" then
			alliance = "Dog"
			enemy = "Dragon"
			item1 = "dragons_liver"
			item1_amount = 4
			item2 = "chung_ryong_key"
			item2_amount = 4
		end
		if player.mapTitle == "Mythic Rat" then
			alliance = "Rat"
			enemy = "Horse"
			item1 = "pearl_charm"
			item1_amount = 4
			item2 = "key_to_thunder"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Horse" then
			alliance = "Horse"
			enemy = "Rat"
			item1 = "battle_helm"
			item1_amount = 4
			item2 = "key_to_pond"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Rooster" then
			alliance = "Rooster"
			enemy = "Rabbit"
			item1 = "lucky_coin"
			item1_amount = 4
			item2 = "key_to_earth"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Rabbit" then
			alliance = "Rabbit"
			enemy = "Rooster"
			item1 = "scribes_pen"
			item1_amount = 4
			item2 = "key_to_heaven"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Snake" then
			alliance = "Snake"
			enemy = "Pig"
			item1 = "magical_dust"
			item1_amount = 4
			item2 = "key_to_mountain"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Pig" then
			alliance = "Pig"
			enemy = "Snake"
			item1 = "scribes_book"
			item1_amount = 4
			item2 = "hyun_moo_key"
			item2_amount = 4
		end
		if player.mapTitle == "Mythic Sheep" then
			alliance = "Sheep"
			enemy = "Ox"
			item1 = "tao_stone"
			item1_amount = 4
			item2 = "key_to_water"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Ox" then
			alliance = "Ox"
			enemy = "Sheep"
			item1 = "lucky_silver_coin"
			item1_amount = 4
			item2 = "ju_jak_key"
			item2_amount = 4
		end
		if player.mapTitle == "Mythic Tiger" then
			alliance = "Tiger"
			enemy = "Monkey"
			item1 = "ambrosia"
			item1_amount = 4
			item2 = "key_to_fire"
			item2_amount = 8
		end
		if player.mapTitle == "Mythic Monkey" then
			alliance = "Monkey"
			enemy = "Tiger"
			item1 = "purified_water"
			item1_amount = 4
			item2 = "baekho_key"
			item2_amount = 4
		end

		if speech == string.lower(enemy) then
			local mobs = player:allMythicCaveBosses(string.lower(enemy))

			Tools.checkKarma(player)

			if player:hasLegend("lesser_alliance_" .. string.lower(enemy)) then
				stormstrike.cast(npc, player)
				player:returnToInn()
				player:dialogSeq(
					{t, "You are allied with our enemies. Die scum!"},
					0
				)
				return
			end
			if player:hasLegend("lesser_alliance_" .. string.lower(alliance)) or player:hasLegend("greater_alliance_" .. string.lower(alliance)) then
				rebirth.cast(npc, player)
				return
			end

			local items = "(" .. item1_amount .. ") " .. Item(item1).name .. " and (" .. item2_amount .. ") " .. Item(item2).name

			if player.quest["lesser_alliance_" .. string.lower(alliance)] == 1 then
				-- already on quest

				local killedEnough = false

				if ((player:killCount(mobs[1]) >= 3 and player:killCount(mobs[2]) >= 3) or (player:killCount(mobs[3]) >= 3 and player:killCount(mobs[4]) >= 3) or (player:killCount(mobs[5]) >= 3 and player:killCount(mobs[6]) >= 3)) then
					killedEnough = true
				end

				if killedEnough == false then
					player:dialogSeq(
						{
							t,
							"You did not heed my words and kill enough to fill my vengeance!"
						},
						0
					)
					return
				end

				if player:hasItem(item1, item1_amount) ~= true or player:hasItem(
					item2,
					item2_amount
				) ~= true then
					player:dialogSeq(
						{t, "You are missing the needed items!"},
						0
					)
					return
				end

				player:removeItem(item1, item1_amount)
				player:removeItem(item2, item2_amount)

				player:addKarma(4)
				player:addItem(alliance .. "s_favor", 1)
				player:giveXP(10000000)
				player:addLegend(
					"Lesser alliance with the " .. alliance .. " (" .. curT() .. ")",
					"lesser_alliance_" .. string.lower(alliance),
					5,
					128
				)
				player.quest["lesser_alliance_" .. string.lower(alliance)] = 0
				player:dialogSeq(
					{
						t,
						"You have proven yourself worthy! Consider yourself an ally of the " .. alliance .. "!"
					},
					1
				)

				return
			end

			local choice = player:menuSeq(
				"Greetings, mortal. Auspicious timing. Will you ally yourself with the mighty " .. alliance .. "?",
				{"With honor.", "I withhold my allegiance."},
				{}
			)

			if choice == 1 then
				-- accept

				local confirm = player:menuSeq(
					"Starting this quest will reset your kills of these mobs that you may have had prior. Continue?",
					{"Yes, reset the kills.", "No, nevermind."},
					{}
				)

				if confirm == 1 then
					local quest = "Started lesser alliance quest for " .. alliance .. "\n"
					quest = quest .. "Mob count before flush:\n"
					for i = 1, #mobs do
						quest = quest .. mobs[i] .. " count: " .. player:killCount(mobs[i]) .. "\n"
					end

					characterLog.questWrite(player, quest)

					for i = 1, #mobs do
						-- flushes mobs at accepting of quest
						player:flushKills(mobs[i])
					end

					player.quest["lesser_alliance_" .. string.lower(alliance)] = 1
					player:dialogSeq(
						{
							t,
							"A wise choice. We do well in our eternal struggle against the vile " .. enemy .. ". I charge you with helping us finish them!"
						},
						1
					)
					player:dialogSeq(
						{
							t,
							"Slay three of each of their leaders and bring to me " .. items .. ". Try not to become too distracted, we want to win! I want the blood of the " .. enemy .. "s fresh on your blade!"
						},
						1
					)
				end
			elseif choice == 2 then
				stormstrike.cast(npc, player)
				player:dialogSeq({t, "Then die."}, 0)
				return
			end
		elseif speech == "greater" or speech == "greater alliance" then
			Tools.checkKarma(player)

			if player:hasLegend("greater_alliance_" .. string.lower(alliance)) then
				rebirth.cast(npc, player)
				return
			end
			if player:hasLegend("lesser_alliance_" .. string.lower(enemy)) then
				stormstrike.cast(npc, player)
				player:returnToInn()
				player:dialogSeq(
					{t, "You are allied with our enemies. Die scum!"},
					0
				)
				return
			end
			if not player:hasLegend("lesser_alliance_" .. string.lower(alliance)) then
				player:dialogSeq({t, "You are not allied with us."}, 0)
				return
			end

			local alliances = {
				"dragon",
				"dog",
				"rat",
				"horse",
				"rooster",
				"rabbit",
				"snake",
				"pig",
				"sheep",
				"ox",
				"tiger",
				"monkey"
			}
			local alliance_count = 0

			for i = 1, #alliances do
				if player:hasLegend("lesser_alliance_" .. alliances[i]) then
					alliance_count = alliance_count + 1
				end
				if player:hasLegend("greater_alliance_" .. alliances[i]) then
					alliance_count = alliance_count + 1
				end
			end

			if alliance_count < 6 then
				player:sendMinitext("" .. alliance_count)
				player:dialogSeq(
					{
						t,
						"You must complete more alliances before embarking on this journey."
					},
					0
				)
				return
			end

			local enemy1, enemy2, enemy3 = player:allEnemyMythicCaveBosses(alliance)

			-- this guarantees one set for the specific cave
			local mobs1 = player:allMythicCaveBosses(string.lower(enemy1))
			local mobs2 = player:allMythicCaveBosses(string.lower(enemy2))
			local mobs3 = player:allMythicCaveBosses(string.lower(enemy3))

			if player.quest["greater_alliance_" .. string.lower(alliance)] == 1 then
				-- already on quest
				local count = 0

				if player:killedEnough(mobs1, 5) then
					count = count + 1
				end
				if player:killedEnough(mobs2, 5) then
					count = count + 1
				end
				if player:killedEnough(mobs3, 5) then
					count = count + 1
				end

				if count < 3 then
					player:dialogSeq(
						{
							t,
							"You have failed to kill all that I have asked for. How can I trust you if you do not listen?"
						},
						0
					)
					return
				end

				-- Remove clearQuestkills 2 months from 07/18/19
				player:clearQuestKillCounts("greater_alliance", mobs1)
				player:clearQuestKillCounts("greater_alliance", mobs2)
				player:clearQuestKillCounts("greater_alliance", mobs3)

				player:addKarma(8)
				player:addLegend(
					"Greater alliance with the " .. alliance .. " (" .. curT() .. ")",
					"greater_alliance_" .. string.lower(alliance),
					5,
					128
				)
				player:removeLegendbyName("lesser_alliance_" .. string.lower(alliance))
				player.quest["greater_alliance_" .. string.lower(alliance)] = 0
				player:dialogSeq(
					{
						t,
						"You have proven yourself worthy! Consider yourself a mighty ally of the " .. alliance .. "!"
					},
					1
				)
				return
			end

			if player.mark == 0 then
				player:dialogSeq(
					{t, "Come back to me when you have more experience."},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Our enemy, the " .. enemy .. " has gained some friends in the war against us.",
					"I charge you, my champion, to take this matter into your own hands and break their alliances."
				},
				1
			)

			local choice = player:menuSeq(
				"Will you help us?",
				{"Yes, I will", "No, I won't"},
				{}
			)

			if choice == 1 then
				-- accept

				local count = 0
				for i = 1, #alliances do
					if player:hasLegend("greater_alliance_" .. string.lower(alliances[i])) then
						count = count + 1
					end
				end

				for i = 1, #alliances do
					if player.quest["greater_alliance_" .. string.lower(alliances[i])] == 1 then
						-- this checks to make sure person is only doing one GA at a time
						if alliances[i] == string.lower(enemy) then
							stormstrike.cast(npc, player)
							player:returnToInn()
							player:dialogSeq(
								{t, "You are aiding our enemy!"},
								0
							)
							return
						else
							player:dialogSeq(
								{
									t,
									"You are already on another Greater alliance quest"
								},
								0
							)
							return
						end
					end
				end

				if count > 3 then
					player:dialogSeq(
						{
							t,
							"You have already completed three Greater alliances."
						},
						0
					)
					return
				end

				local quest = "Started Greater alliance quest for " .. alliance .. "\n"
				quest = quest .. "Mob count before flush:\n"
				for i = 1, #mobs1 do
					quest = quest .. mobs1[i] .. " count: " .. player:killCount(mobs1[i]) .. "\n"
				end
				for i = 1, #mobs2 do
					quest = quest .. mobs2[i] .. " count: " .. player:killCount(mobs2[i]) .. "\n"
				end
				for i = 1, #mobs3 do
					quest = quest .. mobs3[i] .. " count: " .. player:killCount(mobs3[i]) .. "\n"
				end

				characterLog.questWrite(player, quest)

				--player:setQuestKillCounts("greater_alliance",mobs1)
				--player:setQuestKillCounts("greater_alliance",mobs2)
				--player:setQuestKillCounts("greater_alliance",mobs3)

				player.quest["greater_alliance_" .. string.lower(alliance)] = 1
				player:dialogSeq(
					{
						t,
						"The " .. enemy2 .. " have provided supplies to our enemy. Kill 5 of each of their leaders.",
						"The " .. enemy3 .. " have provided men to our enemy. Kill 5 of each of their leaders as well.",
						"Finally, strike another blow for our kind and kill 5 of the " .. enemy1 .. " bosses again.",
						"Return to me immediately. This will crush their morale!"
					},
					1
				)
			elseif choice == 2 then
				stormstrike.cast(npc, player)
				player:dialogSeq({t, "Then die."}, 0)
				return
			end
		end
	end)
}
