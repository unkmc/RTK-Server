dispell = {
	cast = function(player)
		player:flushDuration()
		player:sendStatus()
		player:sendAnimation(10)
		player:playSound(34)
	end
}
