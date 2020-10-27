muddy_potion = {
	use = function(player)
		if player:checkIfCast(hardarmors) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:setDuration("harden_armor_poet", 300000)
		player:sendAction(8, 25)
		player:calcStat()
		player:removeItem("muddy_potion", 1, 6)
	end
}
