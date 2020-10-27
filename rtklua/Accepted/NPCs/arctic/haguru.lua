HaguruNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		--if player.registry["tutorial_quest"] == 11 and player:killCount("mountain_wolf") >= 3 then
		if player:killCount("mountain_wolf") >= 3 then
			player.quest["helped_haguru"] = 1

			player:dialogSeq(
				{
					t,
					"You were great! Thank you so much! Now I can save my friends up there, once I get them out of hiding.",
					"My name is Haguru, I am the brother of the tutors of the great city.",
					"Why do you look so surprised? Don't tell me he sent you to look for me! You can go back and tell him that I am fine, and not to worry about me.",
					"Oh, and thanks again for all your help here today."
				},
				1
			)

			return
		end

		player:dialogSeq(
			{
				t,
				"You just came from my town I see. Did you come to help me with the dark forces?",
				"Of course you are! What other reason would you have to be in such a place.",
				"Well, you can help me if you want, but it could be dangerous.",
				"A few levels up this mountain you will find a pack of wolves. They have trapped my hunting party up there.",
				"If you can kill a few of them then I can start saving the people. Be very careful, they do a lot of damage to you."
			},
			1
		)
	end)
}
