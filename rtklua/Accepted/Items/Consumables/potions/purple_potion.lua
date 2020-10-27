purple_potion = {
	use = function(player)
		if player:hasDuration("purple_potion") then
			player:sendMinitext("This spell is already active.")
			return
		end
		player:setDuration("purple_potion", 300000)
		player:removeItem("purple_potion", 1)
	end
}
