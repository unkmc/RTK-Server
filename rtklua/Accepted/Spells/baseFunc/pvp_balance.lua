pvp_balance = {
	cast = function(player)
		local duration = 900000
		player:sendMinitext("You have been balanced.")
		player:setDuration("pvp_balance", duration)
		player:sendAnimation(2)
		player:calcStat()
	end,

	uncast = function(player)
	end,
}
