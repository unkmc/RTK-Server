sage_5_reward = {
	use = async(function(player)
		local item = player:getInventoryItem(player.invSlot)

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if not player:canCast(1, 1, 0) then
			player:sendMinitext("You can't use this.")
			return
		end

		if player:hasSpell("sages_wisdom") then
			player:dialogSeq({t, "You already have Sages Wisdom (Sage 5)."}, 0)
			return
		end

		local confirm = player:menuSeq(
			"Are you sure you want to add Sages Wisdom (Sage 5) to your character? This will replace all previous versions of sage.",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if player:hasItem("sage_5_reward", 1) ~= true then
				player:dialogSeq(
					{t, "You are missing the Sage 5 Reward item."},
					0
				)
				return
			end

			player:removeItem("sage_5_reward", 1)

			player:addSpell("sages_wisdom")
		end
	end)
}
