ShamanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		local choice

		if player.state == 1 then
			choice = player:menuString(
				"Ah, another of the fallen come for my aid. Are you ready to return to the world of the living?",
				{"Yes", "No"},
				{}
			)
		end

		if choice == "Yes" then
			player.state = 0
			player.health = player.maxHealth
			player.magic = player.maxMagic
			player:sendStatus()
			player:updateState()
			player:menuString(
				"So shall it be! Keep yourself safe, and free from harm.",
				{},
				{}
			)
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

		if npc.mapTitle == "Dusk Shaman" and speech == "majhum" then
			Tools.checkKarma(player)

			if player.quest["valley_farm_ghost_clicked"] == 0 then
				return
			end

			player.quest["valley_farm_ghost_can_hear"] = 1
			player:dialogSeq(
				{
					t,
					"Majhum? You know him? I do miss my cousin.",
					"Oh no! He died? He was such a devoted man, never once did he question his orders, and stayed out there for so long.",
					"I wish I could go visit him, I would like to talk with him once again.",
					"Oh? You can't hear him? Well, only one used to talking to the dead would ever hear waht he had to say.",
					"Every soul has it's own... it's own... I don't know how to describe it, but if you knew it you would be eable to talk to him.",
					"Actually, I suppose I could show you how to talk to him as I know his soul very well.",
					"Let me see now...",
					"((The old lady places her hands over your ears, nothing seems to happen until you hear a loud POP))",
					"There you go, you should be able to talk to him now. Please give him my regards, I do miss him."
				},
				0
			)
		end

		if npc.mapTitle == "Storm Shaman" then
			if speech == "wilderness life" and player.quest["forgotten_path"] == 2 or player.quest[
				"forgotten_path"
			] == 3 then
				player:dialogSeq(
					{
						t,
						"Bah, I hate the wilderness.\n\nI would rather stay here and help others.",
						"There was never anyone I could help out there.",
						"The only reason I was living in the wilderness is because I was studying under a Geomancer."
					},
					1
				)
				player.quest["forgotten_path"] = 4
			end

			if speech == "geomancer" and player.quest["forgotten_path"] == 4 then
				player:dialogSeq(
					{
						t,
						"Yes, I studied under a Geomancer... my mind fails me, I think his name might have been Rotah.",
						"What is the reason you ask me about my past life though?"
					},
					1
				)
				player.quest["forgotten_path"] = 5
			end
			if speech == "elemental orb" and player.quest["forgotten_path"] == 5 then
				player:dialogSeq(
					{
						t,
						"What did you say!?",
						"Were you able to forge the element of metal into an orb?",
						"If you could find a way to forge the element of metal into an orb, I bet that old man Rotah would tell you the way to forge the others.",
						"He would never tell me, thats why I came back here!",
						"Oahh, and you might want to ask a smith for help."
					},
					1
				)
				player.quest["forgotten_path"] = 6
			end
		end
	end)
}
