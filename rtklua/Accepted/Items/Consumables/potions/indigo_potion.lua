indigo_potion = {
	use = function(player)
		player:sendAction(8, 25)

		player:removeDuras(venoms)

		player:removeItem("indigo_potion", 1, 6)
	end
}
