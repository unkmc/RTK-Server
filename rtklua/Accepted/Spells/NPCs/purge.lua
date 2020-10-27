purge = {
	cast = function(player)
		player:removeDuras(venoms)
		player:sendMinitext("You cast Purge.")

		player:sendAction(6, 35)

		player:playSound(10)
		player:sendAnimation(10)
	end
}
