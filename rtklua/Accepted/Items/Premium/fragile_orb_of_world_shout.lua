fragile_orb_of_world_shout = {
	use = async(function(player)
		local item = player:getInventoryItem(player.invSlot)

		local t = {graphic = convertGraphic(771, "item"), color = 21}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		if player.spell == 0 then
			-- map spells disabled
			player:sendMinitext("That doesn't work here.")
			return
		end

		if os.time() < player.registry["orb_world_shout_timer"] then
			player:dialogSeq(
				{
					t,
					"You have " .. playerTimerValues(
						player,
						"orb_world_shout_timer"
					) .. " remaining until you can shout again."
				},
				0
			)
			return
		end

		local message = ""
		local message2 = ""

		message = player:inputSeq(
			"Please type what you would like to say to the world. ((If your meessage is longer than 42 characters, you can type an additional 38 characters after you click \"OK\"))",
			"",
			"",
			{},
			{}
		)

		if string.len(message) == 0 then
			player:dialogSeq({t, "You have not entered anything."}, 0)
			return
		end

		if string.len(message) >= 42 then
			message2 = player:inputSeq(
				"You can continue with your message here up to 38 characters.",
				"",
				"",
				{},
				{}
			)
		end

		if string.len(message2) > 38 then
			player:dialogSeq(
				{t, "Your second part of your message is too long."},
				0
			)
			return
		end

		player.registry["orb_world_shout_timer"] = os.time() + 3600

		-- one hour timer

		broadcast(-1, "[" .. player.name .. "]: " .. message)
		if message2 ~= "" then
			broadcast(-1, "[" .. player.name .. "]: " .. message2)
		end
	end)
}
