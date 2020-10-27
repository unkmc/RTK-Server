yellow_scroll = {
	use = function(player)
		if player.warpOut == 0 then
			player:sendMinitext("Unable to warp out.")
			return
		end

		if player:canPK(player) then
			-- pvp maps
			player:sendMinitext("Unable to warp out.")
			return
		end

		if player.m == 666 then
			return
		end

		if player.state == 1 then
			player:sendMinitext("You need a physical body in order to use this yellow scroll.")
			return
		end

		player:removeItem("yellow_scroll", 1)
		player:returnFunc()
	end
}
