ValleyFarmGhostNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["valley_farm_ghost_can_hear"] == 1 then
			player.quest["majhum_told_about_bridge"] = 1
			player:dialogSeq(
				{
					t,
					"Hello?",
					"Can you hear me?",
					"Oh my! Finally somebody who can understand me, do you know how hard it is to find somebody to talk to while you're a ghost?",
					"I have been stuck here ever since that horrible army attacked, and killed everything in sight.",
					"Now I am stuck here, unwilling to leave my post given to me by King Yuri himself.",
					"Why are you here? You don't look like you're part of a large army.",
					"Besides, they blocked off the bridge, and laid traps all over it! Only way across would be to use another bridge, or make your own."
				},
				0
			)
			return
		end

		player.quest["valley_farm_ghost_clicked"] = 1
		player:dialogSeq(
			{
				t,
				"",
				"",
				"",
				"",
				"((The ghost seems to be trying to talk, but you can't hear anything.))"
			},
			0
		)
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

		if speech == "bridge" then
			Tools.checkKarma(player)

			if player.quest["majhum_told_about_bridge"] == 2 then
				if player:hasItem("ginko_wood", 10) ~= true then
					player:dialogSeq(
						{
							t,
							"I need the wood, without it you can't make any stilts."
						},
						0
					)
					return
				end

				if player:hasItem("wool_twine", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"I need the twine as well, without it I can't tell you how to make stilts."
						},
						0
					)
					return
				end

				player:dialogSeq(
					{
						t,
						"Ah, you have everything you need. Great! Now take the twine and bind the sticks together like this..."
					},
					1
				)

				player:removeItem("ginko_wood", 10, 9)
				player:removeItem("wool_twine", 1, 9)
				player:addItem("stilts", 1)

				player:dialogSeq(
					{
						t,
						"There you go, you got it!",
						"Now just try them on, and go for the water there, the best part is just to left of the house."
					},
					0
				)

				return
			end

			if player.quest["majhum_told_about_bridge"] == 1 then
				player.quest["majhum_told_about_bridge"] = 2
				player:dialogSeq(
					{
						t,
						"Make a new bridge? I don't think you could by yourself, it takes months of work.",
						"The first thing you need to do is get over the other side, and start with ropes, then place the beams, and...",
						"Hmmm, if you just need to get across yourself, then you could use a bridge builder's trick.",
						"This river is pretty deep, and getting a boat through the forest and mountains is impossible.",
						"We had to use stilts to get across, if you were to make some yourself then you could get over.",
						"Stilts are pretty easy to make, just need a couple pieces of wood, and some twine to bind them together.",
						"Bring me 10 ginko wood, and some strong wool twine. Wool twine is the best if you're gonna get it wet, real strong stuff."
					},
					0
				)
			end
		end

		if speech == "dusk shaman" and player.quest["majhum_told_about_bridge"] >= 1 then
			if player.registry["majhum_karma_bonus"] == 0 then
				player.registry["majhum_karma_bonus"] = 1
				player:addKarma(1.0)
				player:dialogSeq(
					{
						t,
						"Oh my, how nice of you to pass on the message, thank you."
					},
					0
				)
			else
				player:dialogSeq(
					{t, "Thank you again, for giving me the message."},
					0
				)
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
