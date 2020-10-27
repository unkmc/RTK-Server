FoxSpiritNpc = {
	click = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:sendMinitext("A fox spirit finds you!")

		if player:hasItem("fox_charm", 1) == true then
			player:dialogSeq(
				{
					t,
					"Ah, I see you have met my kind and have bested us. Perhaps in the future we will be able to do business... Do not lose that talisman, for I never remember a face."
				},
				0
			)
			return
		end

		local questions = {
			"Within a room of green is a room of white, and within that, one of red. In there, thousands reside. What am I?",
			"I have fingers but no bone, a palm but no blood. What am I?",
			"In a chest without locks or hinges, a golden treasure awaits. What am I?",
			"Within ten, there are three of me. Within three, there are five. What am I?"
		}
		local answers = {"watermelon", "glove", "egg", "letters"}

		local randomNumber = math.random(1, #questions)

		local question = questions[randomNumber]
		local answer = answers[randomNumber]

		local givenAnswer = player:inputLetterCheck(player:inputSeq(question, "", "My honorable trickster", {}, {}))

		if string.lower(givenAnswer) == answer then
			-- correct answer
			if player:hasItem("fox_charm", 1) ~= true then
				player:addItem("fox_charm", 1)
				player:sendMinitext("Craftily done!")
			end
		else
			player:warp(2500, 110, 141)
		end
	end
}
