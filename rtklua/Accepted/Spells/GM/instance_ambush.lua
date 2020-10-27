instance_ambush = {
	cast = function(player)
		player:talk(0, "test")
		if player.x % 2 == 0 then
			player:warp(player.m, player.x - 1, player.y)
		else
			player:warp(player.m, player.x + 1, player.y)
		end
	end,
}
