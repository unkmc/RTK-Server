clear_water_song = {
	use = function(player)
		if player:canCast(1, 1, 0) then
			purge.cast(player)
			player:removeItem("clear_water_song", 1)
		end
	end
}
