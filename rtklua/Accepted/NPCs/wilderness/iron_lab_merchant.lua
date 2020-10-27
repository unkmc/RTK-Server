IronLabMerchantNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{
				t,
				"Hail Adventurer, welcome to the depths of this cavern.",
				"You can find many treasures inside these boxes if you open them with your Iron Key."
			},
			1
		)
		if player:hasItem("iron_key", 1) == true then
			local opts = {
				"Yes, I am willing to sell you the key.",
				"No, I wish to keep my key."
			}
			local menu = player:menuString(
				"Do you want to sell me the key you have for 300 gold?",
				opts
			)

			if menu == opts[1] then
				player:removeItem("iron_key", 1, 9)
				player.money = player.money + 300
				player:sendStatus()
				player:dialogSeq({t, "Thank you, here you go."}, 0)
			else
				player:dialogSeq(
					{
						t,
						"Farewell then my friend, good luck on your adventures."
					},
					0
				)
			end
		else
			player:dialogSeq(
				{
					t,
					"You can find them spread out amongst the creatures that live here."
				},
				0
			)
		end
	end)
}
