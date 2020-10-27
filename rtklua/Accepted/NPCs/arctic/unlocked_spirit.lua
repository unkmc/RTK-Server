UnlockedSpiritNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local questStage = player.quest["unlocked_spirit"]

		if player.quest["unlocked_spirit"] >= 9 and player.quest[
			"unlocked_spirit_timer"
		] > os.time() then
			-- finished
			player:dialogSeq(
				{t, "Your spirit is unlocked! You may proceed."},
				0
			)
			return
		elseif player.quest["unlocked_spirit"] > 0 and player.quest[
			"unlocked_spirit"
		] < 9 and player.quest["unlocked_spirit_timer"] < os.time() then
			local questions = {
				"Sit still",
				"Create",
				"Explode into activity",
				"Be soft and furious",
				"strike first",
				"supple and receiving",
				"disperse everything",
				"gather it back in again"
			}
			player:dialogSeq({t, questions[questStage]}, 0)
		elseif player.quest["unlocked_spirit"] == 0 or player.quest[
			"unlocked_spirit_timer"
		] < os.time() then
			player:dialogSeq(
				{
					t,
					"Only those with an unlocked spirit may enter.",
					"Do you understand the secrets?",
					"Listen,\n\nI shall describe each. Then hand me the key that you used to unlock yourself."
				},
				1
			)
			player.quest["unlocked_spirit_timer"] = 0
			player.quest["unlocked_spirit"] = 1
		end
	end),

	handItem = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local invItem = player:getInventoryItem(player.invSlot)
		local questStage = player.quest["unlocked_spirit"]

		keys = {
			"key_to_pond",
			"key_to_heaven",
			"key_to_fire",
			"key_to_wind",
			"key_to_thunder",
			"key_to_water",
			"key_to_earth",
			"key_to_mountain"
		}

		if invItem.yname == keys[questStage] then
			-- gave right key
			player:removeItem(keys[questStage], 1, 9)
			player.quest["unlocked_spirit"] = questStage + 1

			if player.quest["unlocked_spirit"] >= 9 then
				player.quest["unlocked_spirit_timer"] = os.time() + 28800

				-- 8 hours
			end
			player:freeAsync()
			UnlockedSpiritNpc.click(player, npc)
		else
			player:freeAsync()
			UnlockedSpiritNpc.click(player, npc)
		end
	end)
}
