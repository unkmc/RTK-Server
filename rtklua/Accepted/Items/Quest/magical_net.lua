magical_net = {
	on_drop = async(function(player)
		if player.mapTitle == "Windy Summit" and player.quest["wind_armor"] ~= 0 and player.quest[
			"min_kawlana"
		] == 1 then
			if player:hasDuration("kawlanas_guard") then
				player:addItem("captured_wind", 1)
				player:removeItem("magical_net", 1, 1)
				player.fakeDrop = 1
				player.quest["kawlana_used"] = 0
				player.quest["kawlana_dropped"] = 0

				player:dialogSeq(
					{
						t,
						"The winds scream as you throw the net over them, but with the protection of your Kawlana they do little damage.",
						"You quickly bundle up the wind in the net. Now to find somebody to weave this into a great armor!"
					},
					0
				)
			end
		end
	end),
}
