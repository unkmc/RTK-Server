snake_meat = {
	use = function(player)
		local health = 100

		player:sendAction(8, 25)
		player.attacker = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}

fine_snake_meat = {
	use = function(player)
		local health = 320

		player:sendAction(8, 25)
		player.healer = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}
