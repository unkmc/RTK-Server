scroll_of_protection = {
	use = function(player)
		if not player:canCast(0, 1, 0) then
			return
		end

		if player:checkIfCast(protections) then
			player:sendMinitext("You are already protected.")
			return
		end

		player:setDuration("curse_protection", 250000)
		player:removeItem("scroll_of_protection", 1, 6)
	end
}
