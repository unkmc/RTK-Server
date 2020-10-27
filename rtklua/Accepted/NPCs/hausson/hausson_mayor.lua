HaussonMayorNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.country ~= 1 then
			player:dialogSeq(
				{
					t,
					"Greetings, I would love to let you live here, but only people who are Koguryan may live in this town."
				},
				1
			)
		else
			if player.registry["home"] == 11 then
				local confirm = player:menuSeq(
					"You already live in my towns tavern... do you wish to leave already?",
					{"Yes, I do.", "No, I wish to stay."},
					{}
				)

				if confirm == 1 then
					-- leave
					player.registry["home"] = 0
					player:dialogSeq(
						{
							t,
							"Well, nothing lasts forever. Good luck in the future."
						},
						0
					)
					return
				elseif confirm == 2 then
					player:dialogSeq(
						{
							t,
							"Ah, that is good to hear. I hope you like my service here."
						},
						0
					)
					return
				end
			else
				player:dialogSeq(
					{
						t,
						"So you wish to live in my humble tavern, eh? Well, I can spare you some room. But remember, you will always return here, and not the taverns in the city if you do this."
					},
					1
				)
				local confirm = player:menuSeq(
					"Are you sure you want to do this?",
					{"Yes, I wish to.", "No, I do not."},
					{}
				)

				if confirm == 1 then
					player.registry["home"] = 11
					player:dialogSeq(
						{
							t,
							"Welcome to my tavern, I hope you enjoy your time here."
						},
						0
					)
					return
				elseif confirm == 2 then
					player:dialogSeq(
						{
							t,
							"That is your choice, plenty of room if you wish to come back later."
						},
						0
					)
					return
				end
			end

			return
		end
	end)
}
