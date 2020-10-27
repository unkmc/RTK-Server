woodworking = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "wood" then
			local choices = {
				"Melee Weapons",
				"Arrows",
				"Weaving Tools",
				"Water jug"
			}

			local titem = {graphic = convertGraphic(723, "item"), color = 0}

			local choice = player:menuSeq(
				"What would you like to craft?",
				choices,
				{}
			)

			local woodlevel = crafting.getSkillLevel(player, "woodworking")
			local rand = math.random(1, 10)
			if choice == 1 then
				local craftable = {}

				if crafting.checkSkillLevel(player, "woodworking", "novice") then
					table.insert(craftable, "Wooden sword")
				end

				if crafting.checkSkillLevel(player, "woodworking", "apprentice") then
					table.insert(craftable, "Viperhead woodsaber")
				end

				if crafting.checkSkillLevel(player, "woodworking", "accomplished") then
					table.insert(craftable, "Viperhead woodsword")
				end

				if crafting.checkSkillLevel(player, "woodworking", "adept") then
					table.insert(craftable, "Oaken sword")
				end

				if crafting.checkSkillLevel(player, "woodworking", "talented") then
					table.insert(craftable, "Oaken blade")
				end

				if crafting.checkSkillLevel(player, "woodworking", "expert") then
					table.insert(craftable, "Juk-do")
				end

				if crafting.checkSkillLevel(player, "woodworking", "grandmaster") then
					table.insert(craftable, "Wooden blade")
				end

				if woodlevel == "novice" then
					if player:hasItem("ginko_wood", 2) == true then
						player:removeItem("ginko_wood", 2)
						crafting.skillChanceIncrease(
							player,
							NPC("Splinter"),
							"woodworking"
						)
						crafting.skillChanceIncrease(
							player,
							NPC("Splinter"),
							"woodworking"
						)
						if (rand == 1) then
							player:addItem("supple_wooden_sword", 1)
							player:dialogSeq(
								{
									{
										graphic = convertGraphic(2, "item"),
										color = 0
									},
									"Your efforts were successful!"
								},
								0
							)
						elseif (rand == 2) then
							player:addItem("wood_scraps", 1)
							player:dialogSeq(
								{
									{
										graphic = convertGraphic(2, "item"),
										color = 0
									},
									"Your efforts were unsuccessful."
								},
								0
							)
						else
							player:addItem("wooden_sword", 1)
							player:dialogSeq(
								{
									{
										graphic = convertGraphic(2, "item"),
										color = 0
									},
									"Your efforts were successful!"
								},
								0
							)
						end
					else
						player:dialogSeq(
							{
								titem,
								"You need 2 units of Ginko Wood to make this."
							},
							0
						)
						return
					end
				else
					local weaponChoice = player:menuSeq(
						"What would you like to craft?",
						craftable,
						{}
					)

					if weaponChoice == 1 then
						if player:hasItem("ginko_wood", 2) == true then
							player:removeItem("ginko_wood", 2)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_wooden_sword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("wooden_sword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 2 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 2 then
						if player:hasItem("ginko_wood", 2) == true then
							player:removeItem("ginko_wood", 2)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_viperhead_woodsaber", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("viperhead_woodsaber", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 2 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 3 then
						if player:hasItem("ginko_wood", 3) == true then
							player:removeItem("ginko_wood", 3)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_viperhead_woodsword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("viperhead_woodsword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 3 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 4 then
						if player:hasItem("ginko_wood", 3) == true then
							player:removeItem("ginko_wood", 3)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_oaken_sword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("oaken_sword", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 3 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 5 then
						if player:hasItem("ginko_wood", 4) == true then
							player:removeItem("ginko_wood", 4)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_oaken_blade", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("oaken_blade", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 4 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 6 then
						if player.registry["juk_do_cooldown"] > os.time() then
							player:dialogSeq(
								{
									t,
									"Ah, the Juk-do! This is a masterful weapon that takes TIME to create! You need to wait a while before you can attempt another. ((6 hour cooldown))"
								},
								1
							)
							return
						end
						if player:hasItem("ginko_wood", 20) == true then
							player:removeItem("ginko_wood", 20)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player.registry["juk_do_cooldown"] = os.time() + 21600

								-- 6 hours
								player:addItem("elegant_juk_do", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player.registry["juk_do_cooldown"] = os.time() + 21600

								-- 6 hours
								player:addItem("juk_do", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 20 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
					if weaponChoice == 7 then
						if player:hasItem("ginko_wood", 6) == true then
							player:removeItem("ginko_wood", 6)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							crafting.skillChanceIncrease(
								player,
								NPC("Splinter"),
								"woodworking"
							)
							if (rand == 1) then
								player:addItem("supple_wooden_blade", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							elseif (rand == 2) then
								player:addItem("wood_scraps", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were unsuccessful."
									},
									0
								)
							else
								player:addItem("wooden_blade", 1)
								player:dialogSeq(
									{
										{
											graphic = convertGraphic(2, "item"),
											color = 0
										},
										"Your efforts were successful!"
									},
									0
								)
							end
						else
							player:dialogSeq(
								{
									titem,
									"You need 6 units of Ginko Wood to make this."
								},
								0
							)
							return
						end
					end
				end
			elseif choice == 2 then
				local craftable = {}

				if crafting.checkSkillLevel(player, "woodworking", "novice") then
					table.insert(craftable, "spring_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "apprentice") then
					table.insert(craftable, "summer_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "accomplished") then
					table.insert(craftable, "autumn_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "adept") then
					table.insert(craftable, "winter_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "talented") then
					table.insert(craftable, "ancient_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "skilled") then
					table.insert(craftable, "blood_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "expert") then
					table.insert(craftable, "earth_quiver")
				end

				if crafting.checkSkillLevel(player, "woodworking", "master") then
					table.insert(craftable, "star_quiver")
				end

				if player:hasItem("ginko_wood", 5) == true then
					player:removeItem("ginko_wood", 5)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					if (rand == 1) then
						player:addItem("wood_scraps", 1)
						player:dialogSeq(
							{
								{
									graphic = convertGraphic(312, "item"),
									color = 0
								},
								"Your efforts were unsuccessful."
							},
							0
						)
						return
					else
						player:addItem(craftable[math.random(1, #craftable)], 1)
						player:dialogSeq(
							{
								{
									graphic = convertGraphic(312, "item"),
									color = 0
								},
								"Your efforts were successful!"
							},
							0
						)
						return
					end
				else
					player:dialogSeq(
						{titem, "You need 5 units of Ginko Wood to make this."},
						0
					)
					return
				end
			elseif choice == 3 then
				local success = false
				if woodlevel == "novice" then
					local rand = math.random(1, 100)
					if rand > 50 then
						success = true
					end
				end

				if woodlevel == "apprentice" then
					local rand = math.random(1, 100)
					if rand > 46 then
						success = true
					end
				end

				if woodlevel == "accomplished" then
					local rand = math.random(1, 100)
					if rand > 42 then
						success = true
					end
				end

				if woodlevel == "adept" then
					local rand = math.random(1, 100)
					if rand > 38 then
						success = true
					end
				end

				if woodlevel == "talented" then
					local rand = math.random(1, 100)
					if rand > 34 then
						success = true
					end
				end

				if woodlevel == "skilled" then
					local rand = math.random(1, 100)
					if rand > 30 then
						success = true
					end
				end

				if woodlevel == "expert" then
					local rand = math.random(1, 100)
					if rand > 26 then
						success = true
					end
				end

				if woodlevel == "master" then
					local rand = math.random(1, 100)
					if rand > 22 then
						success = true
					end
				end

				if woodlevel == "grandmaster" then
					local rand = math.random(1, 100)
					if rand > 18 then
						success = true
					end
				end

				if woodlevel == "champion" then
					local rand = math.random(1, 100)
					if rand > 15 then
						success = true
					end
				end

				if woodlevel == "legend" then
					local rand = math.random(1, 100)
					if rand > 12 then
						success = true
					end
				end

				if player:hasItem("ginko_wood", 1) == true then
					player:removeItem("ginko_wood", 1)
					crafting.skillChanceIncrease(
						player,
						NPC("Splinter"),
						"woodworking"
					)
					if (success == true) then
						local rand = math.random(1, 10)

						if rand == 1 then
							player:addItem("fine_weaving_tools", 1)
							player:dialogSeq(
								{
									{
										graphic = convertGraphic(36, "item"),
										color = 0
									},
									"Your efforts were successful!"
								},
								0
							)
						else
							player:addItem("weaving_tools", 1)
							player:dialogSeq(
								{
									{
										graphic = convertGraphic(36, "item"),
										color = 0
									},
									"Your efforts were successful!"
								},
								0
							)
						end
					else
						player:addItem("wood_scraps", 1)
						player:dialogSeq(
							{
								{
									graphic = convertGraphic(36, "item"),
									color = 0
								},
								"Your efforts were unsuccessful."
							},
							0
						)
						return
					end
				else
					player:dialogSeq(
						{titem, "You need 1 units of Ginko Wood to make this."},
						0
					)
					return
				end

				--[[
		elseif choice == 4 then
			itemSuccess = {"empty_water_jug","empty_water_jug"}
			matsAmts = 2
			]]
				--
			end

			return
		elseif speech == "scraps" or speech == "scrap" then
			local titem = {graphic = convertGraphic(723, "item"), color = 0}
			if player:hasItem("wood_scraps", 4) ~= true then
				player:dialogSeq(
					{
						titem,
						"Had you enough scraps, you might be able to salvage something."
					},
					0
				)
				return
			end

			local roll = math.random(1, 3)

			player:removeItem("wood_scraps", 4)
			if roll ~= 1 then
				player:dialogSeq({titem, "No luck this time."}, 0)
				return
			end

			player:addItem("ginko_wood", 1)

			return
		end
	end
}
