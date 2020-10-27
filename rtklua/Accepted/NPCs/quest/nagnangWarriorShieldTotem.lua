nagnangWarriorShieldTotem = {
	onClick = function(player)
		if player:hasLegend("nagnang_warrior_trial") then
			return
		end

		local t = {graphic = convertGraphic(165, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = 0

		local mobs = {
			"red_deer",
			"red_doe",
			"red_rabbit",
			"blue_deer",
			"blue_doe",
			"blue_rabbit"
		}

		local mobFound = false
		for i = 1, #mobs do
			if player:killCount(mobs[i]) >= 1 then
				mobFound = true
			end
		end

		if (mobFound or player.quest["needsForgiveWarriorShieldTotem"] == 1) then
			player.quest["needsForgiveWarriorShieldTotem"] = 1
			player:sendMinitext("You touch the statue several times, but nothing seems to happen. You hear a faint voice calling you a killer...")
			player:sendMinitext("Perhaps you shouldn't have killed the red and blue animals in the cave.")

			for i = 1, #mobs do
				player:flushKills(mobs[i])
			end

			player:warp(361, 18, 6)

			return
		end

		player:dialogSeq(
			{
				t,
				"As you touch the mighty statue, it seems to come to life!",
				"Ah, Mortal, you dared to enter my cave to face me? You are a brave and worthy warrior.",
				"You held your word and harmed none of the red and blue creatures. You have shown honor and skill.",
				"I shall reward you. Take this shield, and may it protect you in your upcoming battles. This is the only one I shall ever give you.",
				"The statue turns back to stone, and you see a shield on the steps, you go to pick it up."
			},
			1
		)

		player.quest["nagnang_warrior_trial"] = 0
		player:addLegend(
			"Completed Nangen Warrior Trial (" .. curT() .. ")",
			"nagnang_warrior_trial",
			9,
			128
		)
		player:addItem("tall_shield", 1, 0, player.ID)
	end
}
