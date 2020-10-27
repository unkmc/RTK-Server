ChuRuaTigerNpc = {
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

		local opts = {"Warrior's Guild", "Forest", "Town", "Mage's Guild"}

		if speech == "hello" then
			Tools.checkKarma(player)

			npc:talk(2, "Hello, Dinner!")
		end

		if speech == "ginseng" then
			Tools.checkKarma(player)

			npc:talk(2, "I'd rather eat you!")
		end

		if (speech == "rabbit") then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					t,
					"What? Rabbit? Was it that foul hopping furre that trapped me in a pit?"
				},
				1
			)

			local choice = player:menuSeq(
				"I'd love to rend his neck. Where did you see him?",
				opts,
				{}
			)

			if (choice == 1 or choice == 3) then
				player:dialogSeq(
					{
						t,
						"So far? Oh well, I guess I'll have a snack beforehand... and you look tasty!"
					},
					1
				)
			elseif (choice == 2) then
				-- correct choice
				player:dialogSeq(
					{
						t,
						"Mmm. Well then I guess I'lll return him a favor with grinning teeth."
					},
					1
				)
				player:sendMinitext("The tiger leaves to the south.")
				player:warp(1117, player.x, player.y)

				--npc:delete() -- need to work on this bit, need tiger to disappear but then respawn when player enters map
			elseif (choice == 4) then
				player:dialogSeq(
					{
						t,
						"What, did someone pull him out of a hat?",
						"So far? Oh well, I guess I'll have a snack beforehand... and you look tasty!"
					},
					1
				)
			end
		end
	end)
}
