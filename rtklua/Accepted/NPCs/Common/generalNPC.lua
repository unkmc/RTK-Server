generalNPC = {
	crafting_skills = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local craftingskills = {
			"General information on crafting skills.",
			"Gathering skills.",
			"Manufacturing skills.",
			"Refining skills.",
			"Thanks, nothing for now."
		}

		local choice = player:menuSeq(
			"I would be happy to tell you about crafting skills. What would you like to learn about?",
			craftingskills,
			{}
		)

		if choice == 1 then
			player:dialogSeq(
				{
					t,
					"There are three types of crafting skills: Gathering, Manufacturing, and Refining. Initially, you have no training in any skills.",
					"As you successfully use a skill, your ability in that skill will gradually increase. You will notice improvements occur faster when your skill level is still low.",
					"As you become better, it takes longer to improve your ability. Becoming a 'Master', or higher, take sa very long time.",
					"As your skill improves, you will fail less often and have positive results more often. Most skills require some tools or materials.",
					"Throughout RTK, you will find merchants who know different skills. Each merchant will explain to you the details of how his or her specific skill is performed."
				},
				1
			)
		elseif choice == 2 then
			player:dialogSeq(
				{
					t,
					"Gathering skills are the simplest of all skills to acquire. Even unskilled people can perform these fairly well. They involve getting raw materials to sell or to use for more advanced skills.",
					"Eventually, everyone can become a master at all gathering skills. Gathering skillls usually require tools.",
					"You must be at least level 8 to gather materials."
				},
				1
			)
		elseif choice == 3 then
			player:dialogSeq(
				{
					t,
					"Manufacturing skills involve turning raw materials into more valuable forms. You can reach the 'Accomplished' skill level in any manufacturing skill.",
					"You can also specialize in one specific manufacturing skill. With enough work, you can become a 'Master' or higher, in that one skill.",
					"You will find that you still sometimes fail at manufacturing skills in which you possess great experience. Overall, however, you will be making better products and earning more money as you improve.",
					"You  must be at least level 25 to perform a manufacturing skill."
				},
				1
			)
		elseif choice == 4 then
			player:dialogSeq(
				{
					t,
					"Refining skills are the most advanced of all skills. You can only learn one refining skill. These skills allow you to create useful items, like weapons and armor.",
					"You must be at least level 50 to learn a refining skill."
				},
				1
			)
		elseif choice == 5 then
		end

		generalNPC.crafting_skills(player, npc)
	end
}
