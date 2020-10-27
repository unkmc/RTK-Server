MageStoneProphetsNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local mobName = ""

		--attacker.quest["zapped_"..mob.yname]

		if npc.mapTitle == "Prophet Yin" then
			mobName = "yin_mouse"
		elseif npc.mapTitle == "Prophet Yang" then
			mobName = "yang_mouse"
		elseif npc.mapTitle == "Prophet Void" then
			mobName = "void_mouse"
		end

		if player.quest["zapped_" .. mobName] == 0 then
			player:dialogSeq(
				{
					t,
					"You have not shown me an offering. I will not chat with you."
				},
				0
			)
			return
		end

		if npc.mapTitle == "Prophet Yin" then
			player:dialogSeq(
				{
					t,
					"Ah, someone who shows great wisdom and follows simple directions. That speaks well of you.",
					"You wish to become one of the Nagnang Mages, eh? Well it is more about being a mage at heart than of a town.",
					"Magic is not about killing and destroying. It is also about compassion and beauty. This is the quest that I bestow upon you.",
					"Find a rose. That is the simplicity and beauty of my request. Keep that rose with you and give it to Wand when you have done the other's bidding."
				},
				0
			)
		end

		if npc.mapTitle == "Prophet Yang" then
			player:dialogSeq(
				{
					t,
					"I see that you have learned your lesson as to how to greet us in the caves. Good. Good.",
					"So you want the power that comes with the Mages of Nagnang, do you? Well power is what we are about.",
					"Magic has its soft side but it has the strength and poweer to destroy and conquer. It can be stronger than any weapon or blade.",
					"To show this, get yourself a piece of high Ore, and keep it with you until you complete all the other's quests and return to Wand."
				},
				0
			)
		end

		if npc.mapTitle == "Prophet Void" then
			player:dialogSeq(
				{
					t,
					"Ah, you had the clarity of mind to follow that which Wand told you. That is good.",
					"Understanding the void, the absence of everything, is the most important part of being a mage of Nagnang.",
					"The person who understands the Void better than anyone are the dead. Walk throuogh the graves in the Crypts of the Cemetery and glean their knowledge.",
					"Afterwards, return to Wand with whatever thee others have you find and you will be rewarded with the stone."
				},
				0
			)
		end
	end)
}
