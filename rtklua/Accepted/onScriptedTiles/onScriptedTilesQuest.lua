onScriptedTilesQuest = async(function(player)
	if player.mapTitle == "Tiger's Steps" then
		if (player.x == 14 or player.x == 15) and player.y == 3 then
			if player.quest["unlocked_spirit"] >= 9 and os.time() < player.quest[
				"unlocked_spirit_timer"
			] then
				-- warp
				player:warp(220, 17, 20)
			else
				local npc = NPC("Unlocked spirit")

				local t = {
					graphic = convertGraphic(npc.look, "monster"),
					color = npc.lookColor
				}
				player.npcGraphic = t.graphic
				player.npcColor = t.color
				player.dialogType = 0
				player.lastClick = npc.ID

				player:warp(player.m, player.x, player.y + 2)
				player:dialogSeq({t, "A locked spirit cannot enter."}, 0)
			end
		end
	end

	--- Blessed by the Watcher

	if (player.mapTitle == "Buya") then
		if (player.x >= 6 and player.x <= 28 and player.y >= 4 and player.y <= 14) then
			local random = math.random(1, 50)

			local t = {graphic = convertGraphic(21, "monster"), color = 3}
			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = 0

			if random == 1 and player.quest["blessed_by_watcher"] == 0 then
				if player:karmaCheck("ox") then
					-- reqs satisfied
					player.quest["blessed_by_watcher"] = 1
					player:dialogSeq(
						{
							t,
							"Out of the corner of your eye, you spot a rabbit watching you. It seems to smile slightly at you, then bounds away."
						},
						0
					)
				else
					player:dialogSeq(
						{
							t,
							"Out of the corner of your eye, you spot a rabbit watching you. As you turn your head, it bounds away."
						},
						0
					)
				end
			end
		end
	end

	if player.mapTitle == "Maro Sanctum" or player.mapTitle == "Kwi-Sin Maro" or player.mapTitle == "Ming-Ken Maro" or player.mapTitle == "Ohaeng Maro" then
		if player.quest["dagger_blue_rooster"] == 2 and player.x >= 4 and player.x <= 6 and player.y >= 3 and player.y <= 5 then
			-- tiles directly around maru
			if player:hasItem("silvery_acorn", 1) ~= true then
				local t = {graphic = convertGraphic(214, "item"), color = 0}
				player:addItem("silvery_acorn", 1)

				player:dialogSeq(
					{
						t,
						"You slip your hand into Maro's pocket and manage to snag the acorn inside."
					},
					0
				)
			end
		end
	end

	if player.mapTitle == "Nagnang" then
		if ((player.x == 99 or player.x == 100) and player.y == 114) then
			if not player:hasLegend("nangen_acolyte") then
				player:warp(player.m, player.x, player.y + 2)
				player:sendMinitext("Only Nangen Acolyte may enter.")
				return
			end

			player:warp(2522, math.random(18, 20), 38)
		end
	end

	if player.mapTitle == "Wilderness" then
		if player.x >= 5 and player.x <= 25 and player.y >= 76 and player.y <= 95 then
			-- forever tree area
			if player.quest["nangen_acolyte"] == 1 then
				local random = math.random(1, 100)
				local forever_branch = {
					graphic = convertGraphic(725, "item"),
					color = 0
				}

				if random == 1 and player:hasItem("forever_branch", 1) ~= true then
					player:addItem("forever_branch", 1)

					player:dialogSeq(
						{
							forever_branch,
							"You find one of the Tree's branches upon the ground."
						},
						0
					)
				end
			end
		end

		-- FOREVER TREE
		if player.x == 19 and player.y == 91 and (player.baseHealth >= 80000 or player.baseMagic >= 40000) then
			local t = {graphic = convertGraphic(0, "monster"), color = 0}
			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = 0

			player:dialogSeq(
				{
					t,
					"You spot a crevasse leading into a sandy area. Deathly screeches echo from within. A sense of doom overcomes you; you realize that only  the truly mighty could survive in there."
				},
				1
			)

			player:warp(1228, math.random(3, 6), math.random(19, 22))
		end
	end

	if player.mapTitle == "Oblivion" then
		if player.x >= 5 and player.x <= 34 and player.y >= 6 and player.y <= 36 then
			local random = math.random(1, 100)

			--player:talk(0,""..random)

			if random == 1 then
				player:sendMinitext("You fall into a sub void.")
				player:warp(2530, 5, 10)
			end
		end
	end

	if player.mapTitle == "Oh-mudum crypt" and player.quest["zapped_void_mouse"] == 1 and player.quest[
		"mage_stone_met_ghost"
	] == 0 then
		local chance = math.random(1, 1)

		local t = {graphic = convertGraphic(167, "monster"), color = 11}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = 0

		if chance == 1 then
			player.quest["mage_ward_met_ghost"] = 1
			player:sendMinitext("A spirit appears!")
			player:dialogSeq(
				{
					t,
					"Who walks these halls? One of the living? Why?",
					"Ah. I see that you are pondering the Void of the Void. Well, the void is not a place but a state of being. Even in complete nothingness, there is always something.",
					"However, within one's own mind, one may be totally alone. Imagine and feel the emptiness. Only in your mind can the Void be experienced.",
					"Heed these words. There may be a time when you need to remember them. Dwell upon them and take solace in the fact you are not ever truly alone."
				},
				1
			)
		end
	end

	-- WIND ARMOR DAE SHORE
	if player.mapTitle == "Dae Shore" then
		if player.quest["wind_armor"] ~= 0 and player:hasItem(
			"legend_of_the_winds_2",
			1
		) == true and player:karmaCheck("spirit") then
			if player.x >= 70 and player.y >= 0 and player.y <= 42 then
				-- on the beach
				if curTime() >= 6 and curTime() <= 12 then
					-- game hour morning
					local random = math.random(1, 10)

					if random == 1 then
						player:dialogSeq(
							{
								t,
								"The morning sun shines brightly, and you hold the scroll up to it.",
								"Through the paper you see a faded watermark, and the words start to form.",
								"\"The secret is in the power of the Kawlana\""
							},
							1
						)

						player:removeItem("legend_of_the_winds_2", 1)
						player.quest["dae_shore_paper_burned"] = 1

						player:dialogSeq(
							{
								t,
								"As you ponder these words, the paper catches fire and burns away."
							},
							0
						)
					end
				end
			end
		end
	end

	if (player.mapTitle == "Buya Library") then
		if ((player.x == 13 or player.x == 14) and player.y == 0) then
			if player.quest["wind_lake_cavern"] == 0 then
				player:warp(player.m, player.x, player.y + 2)
				player:sendMinitext("You are not permitted entry. Speak to Lake.")
				return
			end

			player:dialogSeq(
				{
					t,
					"You step into the doorway which leads into the depths of the caverns below",
					"It is dark and musty, a foul stench hanges in the air.",
					"You summon your courage, and venture in!"
				},
				1
			)

			player:eventCaveLevelPrompt({6503, 6523, 6543, 6563, 6583}, 9, 1)
		end
	end

	if player.m == 6512 or player.m == 6532 or player.m == 6552 or player.m == 6572 or player.m == 6592 then
		-- Buya LIbrary Caverns Sonhi guard map

		if player.x >= 8 and player.x <= 10 and player.y <= 10 then
			if player.quest["presented_sonhi_pass"] == 0 then
				player:warp(player.m, player.x, player.y + 2)
				player:sendMinitext("You cannot proceed further without showing the guard your sonhi pass.")
			end
		end
	end

	if player.m == 6519 or player.m == 6539 or player.m == 6559 or player.m == 6579 or player.m == 6599 then
		-- Buya LIbrary Caverns Gloth map

		if player.x >= 14 and player.x <= 16 and player.y >= 10 then
			local npc = NPC("Gloth")

			GlothNpc.denyClick(player, npc)
		end
	end

	if (player.mapTitle == "Nagnang") then
		if ((player.x == 9 or player.x == 10) and player.y == 49) then
			if player.baseClass ~= 1 or player:hasLegend("nagnang_warrior_trial") then
				player:warp(player.m, player.x, player.y + 2)

				-- reject
			else
				-- accept
				if player.level >= 10 and player.level <= 24 then
					player:warp(2545, math.random(5, 6), 10)
				elseif player.level >= 25 and player.level <= 39 then
					player:warp(2550, math.random(5, 6), 10)
				elseif player.level >= 40 and player.level <= 74 then
					player:warp(2555, math.random(5, 6), 10)
				elseif player.level >= 75 and player.level <= 98 then
					player:warp(2560, math.random(5, 6), 10)
				elseif player.level >= 99 then
					player:warp(2565, math.random(5, 6), 10)
				end
			end
		end
	end

	if player.mapTitle == "Objective" then
		-- gauntlet fr check

		if player.x >= 5 and player.x <= 11 and player.y >= 2 and player.y <= 6 then
			-- 1 tile perim around statue
			nagnangWarriorShieldTotem.onClick(player)
		end
	end

	if (player.mapTitle == "Buya") then
		if ((player.x == 103 or player.x == 104) and player.y == 22) then
			-- Sute's Cave
			if player.registry["sute_quest_dye"] == 1 then
				player.armorColor = 0
				player.registry["sute_quest_dye"] = 0
				player:updateState()
				player:sendMinitext("The powder disappears as you pass the portal.")
				player:warp(446, math.random(10, 11), 22)
			else
				player:warp(player.m, player.x, player.y + 1)
				player:sendMinitext("You are missing something.")
			end
		end
	end

	if (player.mapTitle == "Guol Tiger Pass") then
		local item = Item("young_ginseng")
		local tginseng = {graphic = item.icon, color = item.iconC}

		local npc = player:getObjectsInSameMap(BL_NPC)
		local tigerFound = false

		for i = 1, #npc do
			if npc[i].name == "Tiger" then
				tigerFound = true
			end
		end

		if (player.x == 5 or player.x == 6) and (player.y == 2 or player.y == 3 or player.y == 4) then
			if (tigerFound == true) then
				player:dialogSeq(
					{
						tginseng,
						"You see a strange root in the rocks here. But with the tiger nearby, it is too dangerous to try to climb up to it."
					},
					1
				)
				return
			end

			if (player:hasItem("young_ginseng", 1) ~= true) then
				player:addItem("young_ginseng", 1)
				player:dialogSeq(
					{
						tginseng,
						"Snuggled between the rocks is a young root of ginseng. Was this what Chu Rua meant?"
					},
					0
				)
			end
		end
	end

	if player.mapTitle == "Northeast Koguryo" then
		if ((player.x == 29 or player.x == 30) and (player.y == 15 or player.y == 16)) then
			-- lava crossing
			if (player:hasItem("traveling_shoes", 1)) ~= true then
				player:sendMinitext("You'll burn your feet if you walk there!")
				if player.side == 0 then
					-- up
					player:warp(player.m, player.x, player.y + 2)
				elseif player.side == 2 then
					-- down
					player:warp(player.m, player.x, player.y - 2)
				end
				return
			else
				player:sendMinitext("Your shoes protect your feet as you cross.")
			end
		end

		if ((player.x == 29 or player.x == 30) and (player.y >= 14 and player.y <= 16)) then
			if player:hasItem("ice_heart", 1) == true then
				player:removeItem("traveling_shoes", 1)
				player:warp(player.m, 30, 17)
				return
			end
		end
	end

	if player.mapTitle == "Northern Shore" then
		local t = {graphic = convertGraphic(86, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color

		local cost = (player.level + 1) + (100 * player.mark)

		if (player.x == 30 and (player.y == 29 or player.y == 30 or player.y == 35 or player.y == 36)) then
			local choice = player:menuSeq(
				"Greetings, land lover. I see that you seek passage to Hausson. I will take you there for " .. cost .." gold. Will you pay?",
				{"Yes, I will pay for my passage.", "No, I will not pay."},
				{}
			)

			if choice == 1 then
				if player.money < cost then
					player:dialogSeq(
						{t, "Come back when you have more gold."},
						0
					)
					return
				end

				player.money = player.money - cost
				player:sendStatus()

				if player.y == 29 then
					player:warp(1023, 23, 34)
				elseif player.y == 30 then
					player:warp(1023, 23, 35)
				elseif player.y == 35 then
					player:warp(1023, 23, 58)
				elseif player.y == 36 then
					player:warp(1023, 23, 59)
				end
			end
		end
	end

	if player.mapTitle == "Worn path" or player.mapTitle == "Worn trail" then
		local npc = NPC("Fox spirit")

		local rand = math.random(1, 10)

		if rand == 1 then
			FoxSpiritNpc.click(player, npc)
		end
	end

	if player.mapTitle == "Leviathan Hermit" then
		if ((player.x == 22 or player.x == 23) and player.y == 8) then
			if not player:hasLegend("leviathan_freed") then
				player:warp(player.m, player.x, player.y + 4)
				player:sendMinitext("Go AWAY!")
			else
				player:warp(2540, 6, 10)
			end
		end
	end

	if player.mapTitle == "Blight pen" then
		if ((player.x == 4 or player.x == 9 or player.x == 14 or player.x == 19) and player.y == 3) then
			if player:hasItem("leviathan_talisman", 1) ~= true then
				player:sendMinitext("You do not have the talisman.")
				return
			end

			local mobs = player:getObjectsInCell(
				player.m,
				player.x,
				player.y - 1,
				BL_MOB
			)

			if not player:hasLegend("leviathan_sworn_enemy") and not player:hasLegend("leviathan_freed") then
				if mobs ~= nil then
					for i = 1, #mobs do
						if mobs[i].yname == "captured_leviathan" then
							player:removeItem("leviathan_talisman", 1)
							player:sendMinitext("You cast Release leviathan.")
							mobs[i]:talk(
								0,
								"Captured leviathan: Thank you puny one."
							)
							mobs[i].attacker = player.ID
							mobs[i]:removeHealthExtend(9999999, 0, 0, 0, 0, 0)
							player.quest["leviathan"] = 2
						end
					end
				end
			end
		end
	end
end)
