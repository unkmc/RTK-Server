RandomMerchantNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local choices = {"Follow him", "Attack him", "Ignore him"}

		local choice = player:menuSeq(
			"A scraggly dressed fellow subtly motions for you to follow him.",
			choices,
			{}
		)

		if choice == 1 then
			player:dialogSeq({t, "You follow him into a quiet alley."}, 1)

			local chance = math.random(1, 100)
			if chance >= 1 and chance < 50 then
				--attack/evade
				player.attacker = player.ID
				player:sendAnimation(6, 30)
				player:sendMinitext("THUD!")
				player:removeHealthExtend(
					math.floor(player.baseHealth * 0.25),
					0,
					0,
					0,
					0,
					0
				)
				player:dialogSeq({t, "The thief ducks into the shadows."}, 0)
				return
			elseif chance >= 50 then
				RandomMerchantNpc.presentDeal(player, npc)
			end
		elseif choice == 2 then
			--attack
			player:dialogSeq(
				{
					t,
					"As you move aggressively towards him, he ducks into the shadows and vanishes from sight."
				},
				1
			)
			return
		elseif choice == 3 then
			--ignore
			player:dialogSeq({t, "He vanishes as suddenly as he appeared."}, 0)
			return
		end
	end),

	presentDeal = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local goldChoices = {}

		for i = 1, 6 do
			table.insert(goldChoices, 1000)
		end
		for i = 1, 4 do
			table.insert(goldChoices, 5000)
		end
		for i = 1, 2 do
			table.insert(goldChoices, 8000)
		end
		for i = 1, 1 do
			table.insert(goldChoices, 50000)
		end

		local goldChoice = goldChoices[math.random(1, #goldChoices)]

		if player.ID == 2 then
			goldChoice = 1000
		end

		local choice = 0

		if goldChoice == 1000 then
			-- message
			choice = player:menuSeq(
				"He looks at you eagerly, 'I got some information you might be interested in. Give me " .. Tools.formatNumber(goldChoice) .. " gold for it?'",
				{"Yes, I'll pay.", "No thanks."},
				{}
			)
		else
			choice = player:menuSeq(
				"The thief takes a shiny object from his pocket. 'I got some information you might be interested in. Give me " .. Tools.formatNumber(goldChoice) .. " gold for it?'",
				{"Yes, I'll pay.", "No thanks."},
				{}
			)
		end

		if choice == 1 then
			-- yes
			if player.money < goldChoice then
				-- not enough money
				player:dialogSeq({t, "You don't have enough gold."}, 0)
				return
			end

			player:removeGold(goldChoice)

			if math.random(1, 3) <= 2 then
				-- get hussled   50% chance to have the thief take your money
				player:dialogSeq(
					{
						t,
						"'Thanks for the money, sucker!' The merchant disappears with your gold."
					},
					0
				)
				return
			else
				-- give item or message

				local item = ""

				if goldChoice == 1000 then
					local messages = {}
					table.insert(
						messages,
						"There is some old sewers that are beneath the library in Buya."
					)

					local bosses = {"Horse", "Ox", "Pig"}
					local i = math.random(3)
					local boss = bosses[i]
					table.insert(messages, boss .. " Avenger may drop something special.")

					-- check for strange thing spawn
					local mobs = player:getObjectsInMap(2500, BL_MOB)
					local mobs2 = player:getObjectsInMap(1009, BL_MOB)

					if #mobs > 0 then
						for i = 1, #mobs do
							if mobs[i].yname == "strange_thing" then
								table.insert(
									messages,
									"I recently spotted a strange creature in Nagnang around coordinates X: " .. mobs[
										i
									].x .. " Y: " .. mobs[i].y
								)
								break
							end
						end
					end

					if #mobs2 > 0 then
						for i = 1, #mobs2 do
							if mobs2[i].yname == "strange_thing" then
								table.insert(
									messages,
									"I recently spotted a strange creature in Southern Koguryo around coordinates X: " .. mobs2[
										i
									].x .. " Y: " .. mobs2[i].y
								)
								break
							end
						end
					end

					player:dialogSeq(
						{t, messages[math.random(1, #messages)]},
						0
					)
					return
				elseif goldChoice == 5000 then
					item = "sea_poems"

					-- gives sea poem
				elseif goldChoice == 8000 then
					local weaps = {"electra", "titanium_lance", "steelthorn", "star_staff"}
					item = weaps[math.random(1, #weaps)]
				elseif goldChoice == 50000 then
					if math.random(1, 250) == 1 then
						item = Item("chaos_blade")
						local tfb = {
							graphic = item.icon,
							color = item.iconColor
						}

						player:addItem("chaos_blade", 1)
						broadcast(
							-1,
							"[SYSTEM]: " .. player.name .. " has just received a Chaos blade from the Random Merchant!"
						)
						player:dialogSeq(
							{
								tfb,
								"He holds up the shiny object and begins to twirl it around. The merchant decides to be generous and hands you the blade before disappearing."
							},
							0
						)

						return
					else
						local elements = {
							"Earth",
							"Fire",
							"Metal",
							"Water",
							"Wood"
						}
						local animals = {
							"Dragon",
							"Tiger",
							"Ox",
							"Snake",
							"Horse",
							"Rabbit",
							"Rat",
							"Monkey",
							"Sheep",
							"Pig",
							"Dog",
							"Rooster"
						}

						local elementChoice = math.random(1, #elements)
						local animalChoice = math.random(1, #animals)

						if player.quest["soe_elementChoice"] == 0 then
							-- only set these if people have not did it before
							player.quest["soe_elementChoice"] = elementChoice
							player.quest["soe_animalChoice"] = animalChoice
						end

						player:dialogSeq(
							{
								t,
								"He holds up the shiny object and begins to twirl it around. Its softly twinkling lights lull you into a gentle, peaceful trance. A vision of a " .. elements[
									elementChoice
								] .. " " .. animals[animalChoice] .. " appears before you and says, 'Do not be afraid my child. I am here to protect you.'",
								"You snap out of the trance as the thief puts the object away. He seems disappointed. 'Seems that damn gypsy sold me a dud! Well thanks for the money, sucker!' He vanishes as suddenly as he had appeared."
							},
							0
						)
						return
					end
				end

				if item ~= "" then
					player:addItem(item, 1)
					player:dialogSeq(
						{t, "You receive a " .. Item(item).name .. "!"},
						1
					)
					player:dialogSeq(
						{t, "The merchant vanishes as quickly as he appeared."},
						0
					)
					return
				end
			end
		elseif choice == 2 then
			-- no
			player:dialogSeq(
				{t, "'Suit yourself.' He vanishes as suddenly as he appeared."},
				0
			)
			return
		end
	end
}
