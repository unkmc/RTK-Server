dragons_form = {
	cast = function(player)
		player:setDuration("dragons_form", 125000)
		player:calcStat()
	end,

	recast = function(player)
		player.disguise = 186
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		player.disguise = 0
		player.disguiseColor = 0

		if player.state == 4 then
			player.state = 0
			player:updateState()
		end
	end
}
