ChuRuaRabbitNpc = {
	action = function(npc)
		npc.side = math.random(0, 3)
		npc:sendSide()
		npc:move()
	end,

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

		if (speech == "hello") then
			Tools.checkKarma(player)

			player:dialogSeq({t, "Hmmm..", "What is it you want?"}, 1)
		end

		if (speech == "tiger") then
			Tools.checkKarma(player)

			npc:talk(2, "Fool was I to go north for ginseng. He almost ate me!")
		end

		if (speech == "ginseng") then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					t,
					"What a bitter root! It's as bad tasting as the mountains in which it grows.",
					"Some trickster cousin told me I should go up the left path and have some of the delicious root.",
					"Fool was I to go into the awful mountains. I followed this stream up to those horrid mountain's foot, and hopped up a dangerous path."
				},
				1
			)
		end
	end)
}
