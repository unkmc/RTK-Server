GlothNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["gloth_override"] == 1 then
			player:dialogSeq({t, "Be well, honorable one."}, 0)
			return
		end

		if player.quest["gloth_clicked"] == 0 then
			player:dialogSeq(
				{
					t,
					"Who is there? Why do you come here?",
					"You shall not pass by me without permission, for I am the guardian of the secret.",
					"Only those who shine of virtue shall pass this way.",
					"You show a glimmer of hope young one. While your time on this world may be but a fraction of mine you show potential.",
					"Seek the answers from ones who placed me here to guard this path, the two great ones."
				},
				1
			)
			player.quest["gloth_clicked"] = 1
			return
		end

		if player.quest["gloth_override"] == 0 then
			local weap = player:getEquippedItem(EQ_WEAP)

			if weap.yname == "star_sword" then
				player.quest["gloth_override"] = 1
				player:dialogSeq(
					{t, "You have the sword! You are now free to pass."},
					0
				)
				return
			else
				player:warp(player.m, player.x, player.y - 2)
				player:dialogSeq(
					{t, "Without showing me the sword I will not let you pass."},
					0
				)
			end
			return
		end
	end),

	denyClick = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.quest["gloth_override"] == 0 then
			if player.x >= 14 and player.x <= 16 and player.y >= 13 then
				local weap = player:getEquippedItem(EQ_WEAP)

				if weap.yname ~= "star_sword" then
					player:warp(player.m, player.x, player.y - 2)
					return
				end

				if weap.yname == "star_sword" then
					player.quest["gloth_override"] = 1
					player:dialogSeq(
						{t, "You have the sword! You are now free to pass."},
						0
					)
					return
				end

				return
			end
		end
	end
}
