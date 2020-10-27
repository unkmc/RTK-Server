meat_scrap = {
	use = function(player)
		local health = 5

		player:sendAction(8, 25)
		player.attacker = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You still feel hungry.")
		end
	end
}
