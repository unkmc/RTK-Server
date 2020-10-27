BlackbirdNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["dagger_blue_rooster"] == 2 and player.quest[
			"crow_took_silvery_acorn"
		] == 1 then
			if player.quest["crow_took_silvery_acorn2"] == 1 then
				local smallboy = {
					graphic = convertGraphic(208, "monster"),
					color = 21
				}

				if player:hasItem("stardrop", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"\"I had asked an old furtune teller if he knew what I needed but all he said was that the answer would drop from the stars. If you could help me, I would return the acorn to you.\""
						},
						0
					)
					return
				end

				player:removeItem("stardrop", 1)
				player:addItem("silvered_acorn", 1)
				player.quest["crow_took_silvery_acorn"] = 0
				player.quest["crow_took_silvery_acorn2"] = 0
				player:dialogSeq(
					{
						t,
						"The crow's eyes widen. \"GIMME THAT!\" he squawks and plucks a Stardrop from you."
					},
					1
				)

				player:dialogSeq(
					{
						smallboy,
						"\"Thank you! My mom must be so worried. Here's your Acorn back. Oh, and don't mind the other crow, he's just a good friend.\""
					},
					0
				)

				return
			end

			player.quest["crow_took_silvery_acorn2"] = 1

			player:dialogSeq(
				{
					t,
					"The crow sits there watching you approach. When you get close enough it squawks, \"Please don't harm me!\"",
					"\"I am actually a small boy who once thought he was smarter than a Tiger,\" the crow says. \"But the Tiger turned out to be an evil spirit.\"",
					"\"'So you think you are smarter than me?'\" said the Tiger and he changed into this bird. \"'There! Now you'll remain this dull bird until you find something bright enough to free you!'\"",
					"\"I have been searching for something bright enough and hoped that the acorn would work. But alas, I am still a Crow. I do not know what I need!\"",
					"\"I had asked an old furtune teller if he knew what I needed but all he said was that the answer would drop from the stars. If you could help me, I would return the acorn to you.\""
				},
				0
			)
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
			if (checkmove >= 3) then
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
