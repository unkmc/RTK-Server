curse_protection = {
	cast = function(player)
		local duration = 285000

		player:sendAction(6, 20)
		player:sendStatus()
		player:sendAnimation(11)
		player:playSound(702)
		player:setDuration("curse_protection", duration)
	end,

	uncast = function(player)
		player:sendMinitext("End of protection")
	end
}
