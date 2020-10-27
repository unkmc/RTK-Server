kawlana_potion = {
	use = async(function(player)
		if player.mapTitle ~= "Windy Summit" then
			local health = 200

			player:sendAction(8, 25)
			player.attacker = player.ID
			player:addHealthExtend(health, 0, 0, 0, 0, 0)
			player:removeItem("kawlana_potion", 1, 1)

			player:sendMinitext("The life force in your kawlana potion has dissipated.")

			if player.health == player.maxHealth then
				player:sendMinitext("You feel satiated.")
			end
		end

		if player.mapTitle == "Windy Summit" and player.quest["wind_armor"] ~= 0 and player.quest[
			"min_kawlana"
		] == 1 and player.quest["kawlana_dropped"] == 1 then
			player:removeItem("kawlana_potion", 1)
			player.quest["kawlana_used"] = 1
			player:setDuration("kawlanas_guard", 15000)
			player:dialogSeq(
				{
					t,
					"You quickly drink the Kawlana, and your body strengthens against the wind. Now is your chance!"
				},
				0
			)
		end
	end),

	on_drop = async(function(player)
		if player.mapTitle == "Windy Summit" and player.quest["wind_armor"] ~= 0 and player.quest[
			"min_kawlana"
		] == 1 then
			player.quest["kawlana_dropped"] = 1
			player:removeItem("kawlana_potion", 1, 6)
			player.fakeDrop = 1
			player:dialogSeq(
				{
					t,
					"You drop the kawlana on the ground, and you feel the winds grow stronger as they approach.",
					"They grow stronger, and the winds start to lash at your skin. Without protection you will not survive."
				},
				0
			)
		end
	end)
}
