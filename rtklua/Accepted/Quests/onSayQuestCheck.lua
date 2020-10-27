Player.onSayQuestCheck = async(function(player, speech)
	-- This file is used for quests where you need to say certain things on certain maps but no npc is present

	player.npcGraphic = 0
	player.npcColor = 0
	player.dialogType = 0
	player.lastClick = 0

	speech = string.lower(speech)

	if player.mapTitle == "Office" and player.m >= 5800 and player.m <= 5996 then
		-- Nagnag office
		local t = {
			graphic = Item("lockpick").icon,
			color = Item("lockpick").iconC
		}
		if speech == "hello" then
			player:dialogSeq(
				{
					t,
					"You hear the rustling of a person locked away",
					"\"Hello! Can you please help me?  I was locked away and there is no key. Can you please get a lockpick?\""
				},
				0
			)
		end
		if speech == "lockpick" then
			if player.quest["maso_lockpick"] == 0 then
				player.quest["maso_lockpick"] = 1
				player:dialogSeq(
					{
						t,
						"\"Ah yes, a lockpick. My old friend Maso may be able to help you make one. You might be able to access the east gate, which you can use to get around the impenetrable gate.\""
					},
					0
				)
			end
		end
	end
end)
