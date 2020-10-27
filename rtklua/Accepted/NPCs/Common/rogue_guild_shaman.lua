RogueGuildShamanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq({t, "Don't like the way you look do you?"}, 1)

		local choices = {"Face", "Gender", "Eyes"}

		local choice = player:menuString(
			"What appearance are you dissatisfied with?",
			choices
		)

		local reject = "Ah, I see. Appear as thou wilt."

		if choice == "Face" then
			general_npc_funcs.changeFace(player, npc)
		elseif choice == "Gender" then
			general_npc_funcs.changeGender(player, npc)
		elseif choice == "Eyes" then
			general_npc_funcs.changeEyes(player, npc)
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

		if speech == "moon" and player.level >= 50 and player.baseClass == 2 then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					t,
					"Under a white moon I slew a powerful man, of the family Ju, that owed me much money",
					"Yet, still I am not satisfied."
				},
				1
			)

			if player.quest["white_moon_axe"] == 0 then
				local choice = player:menuString(
					"Are you willing to make such a commitment?",
					{"Yes, I am ready.", "I am busy. Later, perhaps."},
					{}
				)

				if choice == "Yes, I am ready." then
					player.quest["white_moon_axe"] = 1
					player:freeAsync()
					RogueGuildShamanNpc.onSayClick(player, npc, "moon")
				elseif choice == "I am busy. Later, perhaps." then
					player:dialogSeq(
						{t, "Then you were not the right person for this task."},
						0
					)
				end
			elseif player.quest["white_moon_axe"] > 0 then
				local choice
				local choice2

				if player.quest["white_moon_axe"] == 1 then
					player:dialogSeq(
						{
							t,
							"If you knew what venom and speed combined were, perhaps I would consider you."
						},
						1
					)

					if player.registry["white_moon_axe_flushed_kills"] == 0 then
						player:flushKills("pale_scorpion")
						player:flushKills("skeleton_ju")
						player.registry["white_moon_axe_flushed_kills"] = 1
					elseif player.registry["white_moon_axe_flushed_kills"] == 1 then
						if player:killCount("pale_scorpion") >= 5 then
							if player:hasItem("lucky_coin", 1) ~= true then
								player:dialogSeq(
									{
										t,
										"Your hands are empty! Had you a Lucky coin, perhaps I could trust you would survive."
									},
									0
								)
								return
							end
							player.quest["white_moon_axe"] = 2
							player.registry["white_moon_axe_flushed_kills"] = 0
							player:freeAsync()
							RogueGuildShamanNpc.onSayClick(player, npc, "moon")
						else
							player:dialogSeq(
								{
									t,
									"Had you slain at least five pale scorpions, you would know."
								},
								0
							)
						end
					end
				end

				if player.quest["white_moon_axe"] == 2 then
					if player:killCount("skeleton_ju") >= 1 then
						player.quest["white_moon_axe"] = 3
						player:freeAsync()
						RogueGuildShamanNpc.onSayClick(player, npc, "moon")
					end

					player:dialogSeq(
						{
							t,
							"Someone owes me money. Lots of it.",
							"He's dead now, but that doesn't matter. This is about honor.",
							"That night of slaying the Ju family caused the earth to shake. My weapons were filled with the power of the white moon.",
							"But I never found the money he owed me.",
							"I'm charging you to torment the family's skeletal remains. Their name in life was Ju.",
							"Destroy the skeleton of Ju, and we'll talk about you getting my money...",
							"...and the axe with which I slew the powerful man under a white moon."
						},
						0
					)
				end

				if player.quest["white_moon_axe"] == 3 then
					player:dialogSeq(
						{
							t,
							"Ah, his torment is my music.",
							"But I still must have the money he owed me, and all I have is this White moon axe.",
							"It was more than what you have. 20,000 coins in all. Should you repay me the money I am owed, I would give you this axe."
						},
						1
					)

					choice2 = player:menuString(
						"Are you willing to give me 20,000 gold to replace what I am owed?",
						{"Yes", "No"},
						{}
					)

					if choice2 == "Yes" then
						if player.money < 20000 then
							player:dialogSeq(
								{t, "You do not have enough gold to repay me."},
								0
							)
							return
						end

						player:removeGold(20000)
						player:addItem("white_moon_axe", 1, 0, player.ID)
						player.quest["white_moon_axe"] = 0
						player:dialogSeq(
							{
								t,
								"There you are rogue. May it inspire you as it has me."
							},
							1
						)
						player:dialogSeq(
							{
								t,
								"The moon is white, He's been desecrated. I have a moment of peace."
							},
							0
						)

						return
					elseif choice2 == "No" then
						player:dialogSeq(
							{
								t,
								"Then you were not the right person for this task."
							},
							0
						)
						return
					end
				end
			end
		end
	end),

	move = function(npc, owner)
		local found
		local moved = true
		local oldside = npc.side
		local checkmove = math.random(0, 10)

		if (npc.retDist <= distanceXY(npc, npc.startX, npc.startY) and npc.retDist > 1 and npc.returning == false) then
			npc.returning = true
		elseif (npc.returning == true and npc.retDist > distanceXY(npc, npc.startX, npc.startY) and npc.retDist > 1) then
			npc.returning = false
		end

		if (npc.returning == true) then
			found = toStart(npc, npc.startX, npc.startY)
		else
			if (checkmove >= 4) then
				npc.side = math.random(0, 3)
				npc:sendSide()
				if (npc.side == oldside) then
					moved = npc:move()
				end
			end
		end

		if (found == true) then
			npc.returning = false
		end
	end,
}
