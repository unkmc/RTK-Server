WoodlandAngelNpc = {
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
				"There you are at last.\n\nThis marks the end of your training with us. The great tutors of the cities will now continue your training.",
				"Remember that there is a great deal more that you have yet to learn. Make sure you read the laws of this land and follow them. Also learn all that tutors have to offer you.",
				"If you should die out there press Shift + <F1> and selecting 'Silver Thread' you can choose to travel to one of the Shamans that shall give life once more.\n\nShould you need any other help use <F1>",
				"The last thing I have to teach you is how to talk and whisper to other people. To talk to all the people around you type ' (this is the \" key without pressing shift).\n\nTo whisper to another person, press \" and type in that person's name.",
				"To exit this area, use the ' key and say the word 'Finish'."
			},
			{}
		)
		player.registry["basic_tutorial_complete"] = 1
	end),

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		if speech == "finish" then
			local t = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}
			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = npc.ID

			Tools.checkKarma(player)

			if player.registry["basic_tutorial_complete"] == 0 then
				player.registry["basic_tutorial_complete"] = 1
			end

			if not player:hasSpell("gateway") then
				player:addSpell("gateway")
			end

			player:dialogSeq(
				{
					t,
					"Good luck, I now leave you in the hands of the tutors from the town, JadeSpear and Ironheart.",
					"Now it's time to choose your nation. Do not worry if you are not familiar with the nations. You can always change it later."
				},
				1
			)

			local choice = player:menuSeq(
				"Where do you wish to live?",
				{"Neutral", "Koguryo", "Buya", "I don't know yet"},
				{}
			)

			--local choice = player:menuSeq("Where do you wish to live?",{"Koguryo","Buya","I don't know yet"},{})

			if choice ~= nil then
				player.registry["mignokexp"] = 0
				player.registry["tominaru1exp"] = 0
				player.registry["tominaru2exp"] = 0
				player.registry["tominaru3exp"] = 0
				player.registry["tominaru4exp"] = 0
				player.registry["tominaru5exp"] = 0
				player.registry["tutorialnpcexp"] = 0

				player:dialogSeq(
					{
						t,
						"We will now send you to the town tutor and give you a special spell to get you around the Kingdoms. Good luck."
					},
					1
				)
			end

			if choice == 2 or choice == 3 then
				player:updateCountry(choice - 1)
			elseif choice == 5 then
				player:dialogSeq(
					{
						t,
						"I understand that you don't want to leave here, yet. Come back to me if you change your mind."
					},
					0
				)
				return
			else
				player:dialogSeq(
					{t, "You must choose Koguryo or Buya currently."},
					0
				)
				return
			end

			if player.country == 1 then
				-- Koguryo
				player:warp(36, 3, 7)
			elseif player.country == 2 then
				-- Buya
				player:warp(351, 6, 9)
			end
		end
	end)
}
