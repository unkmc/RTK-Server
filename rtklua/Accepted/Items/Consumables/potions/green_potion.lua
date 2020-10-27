green_potion = {
	use = function(player)
		if player:checkIfCast(sanctuaries) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:setDuration("sanctuary", 300000)
		player:sendAction(8, 25)
		player:calcStat()
		player:removeItem("green_potion", 1, 6)
	end
}
