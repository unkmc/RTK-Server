metalworking = {
	secondChance = function(player, npc, item)
	end,

	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "metal" then
			t = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}
			local dagger = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}
			local sword = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}
			dagger.graphic = Item("steel_dagger").icon
			dagger.color = Item("steel_dagger").iconC
			sword.graphic = Item("steel_sword").icon
			sword.color = Item("steel_sword").iconC
			local metalamt = 1
			local opts = {"Steel dagger"}

			if crafting.getSkillValue(player, "metalworking") >= 2 then
				table.insert(opts, "Steel saber")
			end
			if crafting.getSkillValue(player, "metalworking") >= 4 then
				table.insert(opts, "Steel sword")
			end
			if crafting.getSkillValue(player, "metalworking") >= 6 then
				table.insert(opts, "Steel blade")
			end

			--table.insert(opts, "Darts")

			local metalMenu = player:menuString(
				"Which type of weapon would you like to craft?",
				opts
			)

			if metalMenu == "Steel dagger" then
				if player:hasItem("metal", 2) == true or player:hasItem("fine_metal", 2) == true then
					local rand = math.random(1, 100)
					local fine = math.random(
						1,
						(15 - crafting.getSkillValue(player, "metalworking"))
					)
					local secondchance = math.random(1, 2)
					if player:hasItem("metal", 2) == true then
						player:removeItem("metal", 2)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (rand <= (10 + (crafting.getSkillValue(player, "metalworking") * 10))) then
							if (fine == 1) then
								player:addItem("fine_steel_dagger", 1)
								player:dialogSeq(
									{dagger, "You have succeeded masterfully!"},
									1
								)
							else
								player:addItem("steel_dagger", 1)
								player:dialogSeq(
									{dagger, "Your efforts are successful!"},
									1
								)
							end
						elseif (rand > (10 + (crafting.getSkillValue(player, "metalworking") * 10))) then
							if (secondchance == 1) then
								local seconds = player:menuString(
									"Your work shows some progress, but you need more materials. Continue your efforts?",
									{"Yes", "No"}
								)
								if (seconds == "Yes") then
									player:removeItem("metal", 1)
									crafting.skillChanceIncrease(
										player,
										npc,
										"metalworking"
									)
									secondChance = math.random(1, 2)
									if (secondChance == 1) then
										player:addItem("steel_dagger", 1)
										player:dialogSeq(
											{
												dagger,
												"Your efforts are successful!"
											},
											1
										)
									else
										t.graphic = Item("metal").icon
										t.color = Item("metal").iconC
										player:addItem("spent_metal", 1)
										player:dialogSeq(
											{
												t,
												"Your feeble efforts have destroyed that which you meant to enhance."
											},
											1
										)
									end
								end
							else
								t.graphic = Item("metal").icon
								t.color = Item("metal").iconC
								player:addItem("spent_metal", 1)
								player:dialogSeq(
									{
										t,
										"Your feeble efforts have destroyed that which you meant to enhance."
									},
									1
								)
							end
						end
					elseif player:hasItem("fine_metal", 2) == true then
						player:removeItem("fine_metal", 2)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (fine == 1) then
							player:addItem("fine_steel_dagger", 1)
							player:dialogSeq(
								{dagger, "You have succeeded masterfully!"},
								1
							)
						else
							player:addItem("steel_dagger", 1)
							player:dialogSeq(
								{dagger, "Your efforts are successful!"},
								1
							)
						end
					end
				else
					t.graphic = Item("metal").icon
					t.color = Item("metal").iconC
					player:dialogSeq(
						{
							t,
							"You need two units of metal to craft a Steel dagger."
						},
						1
					)
				end
			end

			if metalMenu == "Steel saber" then
				if player:hasItem("metal", 3) == true or player:hasItem("fine_metal", 3) == true then
					local rand = math.random(1, 100)
					local fine = math.random(
						1,
						(15 - crafting.getSkillValue(player, "metalworking"))
					)
					local secondchance = math.random(1, 2)
					if player:hasItem("metal", 3) == true then
						player:removeItem("metal", 3)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (rand <= (10 + (crafting.getSkillValue(player, "metalworking") * 9))) then
							if (fine == 1) then
								player:addItem("fine_steel_saber", 1)
								player:dialogSeq(
									{dagger, "You have succeeded masterfully!"},
									1
								)
							else
								player:addItem("steel_saber", 1)
								player:dialogSeq(
									{dagger, "Your efforts are successful!"},
									1
								)
							end
						elseif (rand > (10 + (crafting.getSkillValue(player, "metalworking") * 9))) then
							if (secondchance == 1) then
								local seconds = player:menuString(
									"Your work shows some progress, but you need more materials. Continue your efforts?",
									{"Yes", "No"}
								)
								if (seconds == "Yes") then
									player:removeItem("metal", 1)
									crafting.skillChanceIncrease(
										player,
										npc,
										"metalworking"
									)
									secondChance = math.random(1, 2)
									if (secondChance == 1) then
										player:addItem("steel_saber", 1)
										player:dialogSeq(
											{
												dagger,
												"Your efforts are successful!"
											},
											1
										)
									else
										t.graphic = Item("metal").icon
										t.color = Item("metal").iconC
										player:addItem("spent_metal", 1)
										player:dialogSeq(
											{
												t,
												"Your feeble efforts have destroyed that which you meant to enhance."
											},
											1
										)
									end
								end
							else
								t.graphic = Item("metal").icon
								t.color = Item("metal").iconC
								player:addItem("spent_metal", 1)
								player:dialogSeq(
									{
										t,
										"Your feeble efforts have destroyed that which you meant to enhance."
									},
									1
								)
							end
						end
					elseif player:hasItem("fine_metal", 3) == true then
						player:removeItem("fine_metal", 3)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (fine == 1) then
							player:addItem("fine_steel_saber", 1)
							player:dialogSeq(
								{dagger, "You have succeeded masterfully!"},
								1
							)
						else
							player:addItem("steel_saber", 1)
							player:dialogSeq(
								{dagger, "Your efforts are successful!"},
								1
							)
						end
					end
				else
					t.graphic = Item("metal").icon
					t.color = Item("metal").iconC
					player:dialogSeq(
						{
							t,
							"You need three units of metal to craft a Steel saber."
						},
						1
					)
				end
			end

			if metalMenu == "Steel sword" then
				if player:hasItem("metal", 4) == true or player:hasItem("fine_metal", 4) == true then
					local rand = math.random(1, 100)
					local fine = math.random(
						1,
						(15 - crafting.getSkillValue(player, "metalworking"))
					)
					local secondchance = math.random(1, 2)
					if player:hasItem("metal", 4) == true then
						player:removeItem("metal", 4)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (rand <= (10 + (crafting.getSkillValue(player, "metalworking") * 8))) then
							if (fine == 1) then
								player:addItem("fine_steel_sword", 1)
								player:dialogSeq(
									{sword, "You have succeeded masterfully!"},
									1
								)
							else
								player:addItem("steel_sword", 1)
								player:dialogSeq(
									{sword, "Your efforts are successful!"},
									1
								)
							end
						elseif (rand > (10 + (crafting.getSkillValue(player, "metalworking") * 8))) then
							if (secondchance == 1) then
								local seconds = player:menuString(
									"Your work shows some progress, but you need more materials. Continue your efforts?",
									{"Yes", "No"}
								)
								if (seconds == "Yes") then
									player:removeItem("metal", 1)
									crafting.skillChanceIncrease(
										player,
										npc,
										"metalworking"
									)
									secondChance = math.random(1, 2)
									if (secondChance == 1) then
										player:addItem("steel_sword", 1)
										player:dialogSeq(
											{
												sword,
												"Your efforts are successful!"
											},
											1
										)
									else
										t.graphic = Item("metal").icon
										t.color = Item("metal").iconC
										player:addItem("spent_metal", 1)
										player:dialogSeq(
											{
												t,
												"Your feeble efforts have destroyed that which you meant to enhance."
											},
											1
										)
									end
								end
							else
								t.graphic = Item("metal").icon
								t.color = Item("metal").iconC
								player:addItem("spent_metal", 1)
								player:dialogSeq(
									{
										t,
										"Your feeble efforts have destroyed that which you meant to enhance."
									},
									1
								)
							end
						end
					elseif player:hasItem("fine_metal", 4) == true then
						player:removeItem("fine_metal", 4)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (fine == 1) then
							player:addItem("fine_steel_sword", 1)
							player:dialogSeq(
								{sword, "You have succeeded masterfully!"},
								1
							)
						else
							player:addItem("steel_sword", 1)
							player:dialogSeq(
								{sword, "Your efforts are successful!"},
								1
							)
						end
					end
				else
					t.graphic = Item("metal").icon
					t.color = Item("metal").iconC
					player:dialogSeq(
						{
							t,
							"You need four units of metal to craft a Steel sword."
						},
						1
					)
				end
			end

			if metalMenu == "Steel blade" then
				if player:hasItem("metal", 5) == true or player:hasItem("fine_metal", 5) == true then
					local rand = math.random(1, 100)
					local fine = math.random(
						1,
						(15 - crafting.getSkillValue(player, "metalworking"))
					)
					local secondchance = math.random(1, 2)
					if player:hasItem("metal", 5) == true then
						player:removeItem("metal", 5)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (rand <= (10 + (crafting.getSkillValue(player, "metalworking") * 7))) then
							if (fine == 1) then
								player:addItem("fine_steel_blade", 1)
								player:dialogSeq(
									{sword, "You have succeeded masterfully!"},
									1
								)
							else
								player:addItem("steel_blade", 1)
								player:dialogSeq(
									{sword, "Your efforts are successful!"},
									1
								)
							end
						elseif (rand > (10 + (crafting.getSkillValue(player, "metalworking") * 7))) then
							if (secondchance == 1) then
								local seconds = player:menuString(
									"Your work shows some progress, but you need more materials. Continue your efforts?",
									{"Yes", "No"}
								)
								if (seconds == "Yes") then
									player:removeItem("metal", 1)
									crafting.skillChanceIncrease(
										player,
										npc,
										"metalworking"
									)
									secondChance = math.random(1, 2)
									if (secondChance == 1) then
										player:addItem("steel_blade", 1)
										player:dialogSeq(
											{
												sword,
												"Your efforts are successful!"
											},
											1
										)
									else
										t.graphic = Item("metal").icon
										t.color = Item("metal").iconC
										player:addItem("spent_metal", 1)
										player:dialogSeq(
											{
												t,
												"Your feeble efforts have destroyed that which you meant to enhance."
											},
											1
										)
									end
								end
							else
								t.graphic = Item("metal").icon
								t.color = Item("metal").iconC
								player:addItem("spent_metal", 1)
								player:dialogSeq(
									{
										t,
										"Your feeble efforts have destroyed that which you meant to enhance."
									},
									1
								)
							end
						end
					elseif player:hasItem("fine_metal", 5) == true then
						player:removeItem("fine_metal", 5)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						crafting.skillChanceIncrease(
							player,
							npc,
							"metalworking"
						)
						if (fine == 1) then
							player:addItem("fine_steel_blade", 1)
							player:dialogSeq(
								{sword, "You have succeeded masterfully!"},
								1
							)
						else
							player:addItem("steel_blade", 1)
							player:dialogSeq(
								{sword, "Your efforts are successful!"},
								1
							)
						end
					end
				else
					t.graphic = Item("metal").icon
					t.color = Item("metal").iconC
					player:dialogSeq(
						{
							t,
							"You need five units of metal to craft a Steel blade."
						},
						1
					)
				end
			end
			return
		elseif speech == "smith armor" then
			if os.time() > player.quest["smith_metal_prepared"] then
				player:dialogSeq(
					{t, "You need to prepare three units of metal."},
					0
				)
				return
			end

			local input = player:inputLetterCheck(player:inputSeq(
				"You will need the assistance of a tailor to make armor.",
				"The good",
				"will be working to help make this armor.",
				{},
				{}
			))

			local target = Player(input)

			if target == nil then
				player:dialogSeq(
					{t, "The person you entered cannot be found."},
					0
				)
				return
			end

			if player.m ~= target.m then
				player:dialogSeq(
					{t, "Your tailor needs to be with you in this same room."},
					0
				)
				return
			end

			if os.time() > target.quest["tailor_cloth_prepared"] then
				player:dialogSeq(
					{
						t,
						"Your tailor needs to prepare cloth still or too much time has elapsed"
					},
					0
				)
				return
			end

			local opts = {
				"Scalemail",
				"War platemail",
				"Mail dress",
				"War dress",
				"Armor",
				"Armor dress"
			}
			local choice = player:menuString(
				"What type of armor are you trying to fashion?",
				opts
			)

			if target == nil then
				player:dialogSeq({t, "Your tailor has logged off."}, 0)
				return
			end
			if player.m ~= target.m then
				player:dialogSeq(
					{
						t,
						"Your tailor needs to stay with you in this room during this process."
					},
					0
				)
				return
			end

			local armors = {}

			-- can only craft up to star
			if choice == "Scalemail" then
				armors = {
					"jade_scale_mail",
					"royal_scale_mail",
					"sky_scale_mail",
					"ancient_scale_mail",
					"blood_scale_mail",
					"earth_scale_mail",
					"star_scale_mail"
				}
			elseif choice == "War platemail" then
				armors = {
					"jade_war_platemail",
					"royal_war_platemail",
					"sky_war_platemail",
					"ancient_war_platemail",
					"blood_war_platemail",
					"earth_war_platemail",
					"star_war_platemail"
				}
			elseif choice == "Mail dress" then
				armors = {
					"summer_mail_dress",
					"autumn_mail_dress",
					"winter_mail_dress",
					"ancient_mail_dress",
					"blood_mail_dress",
					"earth_mail_dress",
					"star_mail_dress"
				}
			elseif choice == "War dress" then
				armors = {
					"summer_war_dress",
					"autumn_war_dress",
					"winter_war_dress",
					"ancient_war_dress",
					"blood_war_dress",
					"earth_war_dress",
					"star_war_dress"
				}
			elseif choice == "Armor" then
				armors = {
					"farmer_armor",
					"royal_armor",
					"sky_armor",
					"ancient_armor",
					"blood_armor",
					"earth_armor",
					"star_armor"
				}
			elseif choice == "Armor dress" then
				armors = {
					"summer_armor_dress",
					"autumn_armor_dress",
					"winter_armor_dress",
					"ancient_armor_dress",
					"blood_armor_dress",
					"earth_armor_dress",
					"star_armor_dress"
				}
			end

			local finalarmors = {}

			if crafting.getSkillValue(player, "metalworking") >= 0 and crafting.getSkillValue(
				player,
				"metalworking"
			) < 3 then
				table.insert(finalarmors, armors[1])
			end
			if crafting.getSkillValue(player, "metalworking") >= 2 and crafting.getSkillValue(
				player,
				"metalworking"
			) < 5 then
				table.insert(finalarmors, armors[2])
			end
			if crafting.getSkillValue(player, "metalworking") >= 3 and crafting.getSkillValue(
				player,
				"metalworking"
			) < 7 then
				table.insert(finalarmors, armors[3])
			end
			if crafting.getSkillValue(player, "metalworking") >= 4 then
				table.insert(finalarmors, armors[4])
			end
			if crafting.getSkillValue(player, "metalworking") >= 5 then
				table.insert(finalarmors, armors[5])
			end
			if crafting.getSkillValue(player, "metalworking") >= 7 then
				table.insert(finalarmors, armors[6])
			end

			if math.random(1, 25) == 1 then
				table.insert(finalarmors, armors[7])
			end

			player.quest["smith_metal_prepared"] = 0
			target.quest["tailor_cloth_prepared"] = 0

			crafting.skillChanceIncrease(player, npc, "metalworking")

			local rand = math.random(1, 4)

			if rand == 1 then
				-- successful
				local randArmor = math.random(1, #finalarmors)

				player:addItem(finalarmors[randArmor], 1)
				player:sendMinitext("You were successful!")
			else
				player:sendMinitext("You were unsuccessful.")
				return
			end
		end
	end
}
