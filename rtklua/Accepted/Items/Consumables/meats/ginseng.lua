ginseng = {
	use = function(player)
		local health = 2000

		player:sendAction(8, 25)
		player.attacker = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}

young_ginseng = {
	use = function(player)
		local health = 40

		player:sendAction(8, 25)
		player.healer = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}

ginseng_piece = {
	use = function(player)
		local health = 60

		player:sendAction(8, 25)
		player.healer = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}

mountain_ginseng = {
	use = function(player)
		local health = 10000

		player:sendAction(8, 25)
		player.healer = player.ID
		player:addHealthExtend(health, 0, 0, 0, 0, 0)

		if player.health == player.maxHealth then
			player:sendMinitext("You feel satiated.")
		end
	end
}
