AssistantYanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		player:dialogSeq({t, "H-h-hello? H-h-how can I help you?"}, 1)
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
		if player.quest["reeves_quest"] >= 3 then
			if player.quest["reeves_quest"] == 3 then
				player.quest["reeves_quest"] = 4
			end
			if speech == "the calamity" then
				player:dialogSeq(
					{
						t,
						"T-t-that book is going to be the death of m-m-me! I spent hours researching this with Sp-p-poon the last few nights. What w-w-we found in this book f-f-foret-t-told of the end of the w-w-world at the hands of a d-d-demon named 'Calamity'.After h-h-he read that he took off in a p-p-puff of s-s-smoke after shouting 'MYTHIC'."
					},
					0
				)
			end
		end
	end)
}
