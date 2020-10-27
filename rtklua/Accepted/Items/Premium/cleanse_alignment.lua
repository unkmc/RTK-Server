cleanse_alignment = {
	use = async(function(player)
		local item = player:getInventoryItem(player.invSlot)

		local t = {graphic = item.icon, color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local alignments = {"Natural", "Kwi-Sin", "Ming-Ken", "Ohaeng"}
		local currentAlignment = alignments[player.alignment + 1]

		local choice = player:menuSeq(
			"This potion will allow you to change your alignment to a new alignment as well as unalign without vita/mana penalties otherwise normally incurred.\nCurrent alignment: " .. currentAlignment,
			alignments,
			{}
		)

		if choice - 1 == player.alignment then
			player:dialogSeq(
				{
					t,
					"Using this potion to change your alignment to the same alignment you already have would be a waste."
				},
				0
			)
			return
		end

		local confirm = player:menuSeq(
			"Are you sure you wish to align to " .. alignments[choice] .. "?",
			{"Yes, change my alignment.", "No, nevermind."},
			{}
		)

		if player:hasItem("cleanse_alignment", 1) ~= true then
			return
		end

		if confirm == 1 then
			player:removeItem("cleanse_alignment", 1, 6)
			player:swapAlignment(choice - 1)

			if choice == 1 then
				player:dialogSeq(
					{t, "You are returned to natural alignment"},
					0
				)
			else
				player:dialogSeq(
					{t, "You are now aligned to " .. alignments[choice]},
					0
				)
			end
		elseif confirm == 2 then
			return
		end
	end)
}
