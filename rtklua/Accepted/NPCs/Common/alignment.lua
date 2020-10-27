AlignmentNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local shrine = ""
		local alignCheck = 0

		if npc.mapTitle == "Kwi-sin Shrine" then
			shrine = "Kwi-Sin"
			alignCheck = 1
		elseif npc.mapTitle == "Ming-ken Shrine" then
			shrine = "Ming-ken"
			alignCheck = 2
		elseif npc.mapTitle == "Ohaeng Shrine" then
			shrine = "Ohaeng"
			alignCheck = 3
		end

		if player.level < 50 then
			player:dialogSeq(
				{t, "You are not ready to make this choice. Return later."},
				0
			)
			return
		end

		if player.alignment ~= 0 then
			if player.alignment ~= alignCheck then
				player:dialogSeq(
					{t, "You are not " .. shrine .. ", I can not help you."},
					0
				)
				return
			elseif player.alignment == alignCheck then
				player:dialogSeq(
					{
						t,
						"Go now young one, and tell your guild master of your choice to be " .. shrine
					},
					0
				)
				return
			end
		end

		player:dialogSeq(
			{
				t,
				"Greetings, magic user.",
				"You seek to find your true nature?",
				"First I must know that you understand the nature of your soul."
			},
			1
		)

		local choice
		if shrine == "Kwi-Sin" then
			choice = player:menuSeq(
				"How many natures are there to choose from?",
				{
					"Only one, and that is you.",
					"Two, you and Ming-Ken",
					"Three, you, Ming-Ken, and Ohaeng."
				},
				{}
			)
		elseif shrine == "Ming-ken" then
			choice = player:menuSeq(
				"How many natures are there to choose from?",
				{
					"Only one, and that is you.",
					"Two, you and Ming-Ken",
					"Three, you, Ohaeng, and Kwi-Sin."
				},
				{}
			)
		elseif shrine == "Ohaeng" then
			choice = player:menuSeq(
				"How many natures are there to choose from?",
				{
					"Only one, and that is you.",
					"Two, you and Ming-Ken",
					"Three, you, Ming-Ken, and Kwi-Sin."
				},
				{}
			)
		end

		if choice == 1 or choice == 2 then
			player:dialogSeq(
				{
					t,
					"You are incorrect, there are three. Learn about yourself, and of the natures before you go too far. You may only choose once, ever!"
				},
				0
			)
			return
		elseif choice == 3 then
			player:dialogSeq(
				{
					t,
					"Yes, yes. Wise one, you are learning about the natures. But there is more to know before you dedicate to one for life."
				},
				1
			)

			local subChoice = player:menuSeq(
				"Each nature represents a different aspect of power, which does " .. shrine .. " represent?",
				{
					shrine .. " is the nature of living.",
					shrine .. " is the balance of all.",
					shrine .. " is the nature of the afterlife."
				},
				{}
			)
			local correctChoice

			if shrine == "Kwi-Sin" then
				correctChoice = 3
			elseif shrine == "Ming-ken" then
				correctChoice = 1
			elseif shrine == "Ohaeng" then
				correctChoice = 2
			end

			if subChoice ~= correctChoice then
				player:dialogSeq(
					{
						t,
						"You are incorrect, you need to learn of the natures.",
						"Ming-Ken is the nature of the living.",
						"Ohaeng is the balance of all.",
						"Kwi-Sin is the nature of the afterlife.",
						"Go and study more before you take this step."
					},
					0
				)
				return
			elseif subChoice == correctChoice then
				player:dialogSeq(
					{
						t,
						"Yes, you do understand. You are on your way to becoming " .. shrine
					},
					1
				)

				local subSubChoice = player:menuSeq(
					"This is your last chance, from here there is no turning back, you may only choose once in your life.",
					{
						"I do not wish to be " .. shrine,
						"I need to think first.",
						"I want another nature.",
						"I will dedicate for life."
					},
					{}
				)

				if subSubChoice >= 1 and subSubChoice <= 3 then
					player:dialogSeq(
						{
							t,
							"It is wise that you do not leap into something that will affect you for the rest of your life."
						},
						0
					)
					return
				elseif subSubChoice == 4 then
					local alignment = 0

					if shrine == "Kwi-Sin" then
						alignment = 1
					elseif shrine == "Ming-ken" then
						alignment = 2
					elseif shrine == "Ohaeng" then
						alignment = 3
					end

					player:swapAlignment(alignment)
					player:dialogSeq(
						{
							t,
							"You are now devoted to the nature of " .. shrine .. ", tell your Guildmaster of your decision."
						},
						0
					)
					return
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
	end
}
