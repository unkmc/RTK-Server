black_potion = {
	use = function(player)
		player:setDuration("chin_baek_ho_ryung", 10000)
		player:sendAction(8, 25)
		player:calcStat()
		player:removeItem("black_potion", 1, 6)
	end
}
