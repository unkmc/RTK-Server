blue_potion = {
	use = function(player)
		local health = 100

		player:sendAction(8, 25)
		player.attacker = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)
		player:removeItem("blue_potion", 1, 6)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}
