ExorcistLaylaNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		if player.quest["reeves_quest"] == 6 then
			player:dialogSeq(
				{
					t,
					"Fascinating, these crystals are absolutely captivating...",
					"If only Spoon was able to get me some samples..."
				},
				1
			)
		end
		if player.quest["reeves_quest"] == 8 then
			player:dialogSeq(
				{
					t,
					"I never would have believed something so evil could latch itself onto our world. The crystal you have provided me has given me an idea as to how we can break the hold Calamity has on the statue. I just need some more time.",
					"If only Spoon wasn't so aloof this could probably be done faster..."
				},
				1
			)
		end

		if player.quest["reeves_quest"] == 6 then
			player.quest["reeves_quest"] = 7
		end
		if player.quest["reeves_quest"] == 7 then
			if player:hasItem("crystal_shard", 1) ~= true then
				return
			end

			local choice = player:menuString(
				"Unbelievable! I won't even ask how you were able to obtain this shard! May I have it to study please?",
				{"Yes", "No way!"}
			)
			if choice == "Yes" then
				player:dialogSeq(
					{
						t,
						"Beautiful, so beautiful! I will begin my investigation right away. I will inform Spoon we can begin the ritual to seal Calamity within the statue for good."
					},
					1
				)
				if player:hasItem("crystal_shard", 1) ~= true then
					return
				end
				player:removeItem("crystal_shard", 1)
				player.quest["reeves_quest"] = 8
			end
			if choice == "No way!" then
				player:dialogSeq(
					{
						t,
						"Oh alright then... Not sure what you plan on doing with it... genius."
					},
					1
				)
			end
		end
	end)
}
