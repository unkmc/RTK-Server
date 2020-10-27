onScriptedTilesMarket = function(player)
	-- nagnang market
	if player.m == 2500 then
		if (player.x == 87 or player.x == 88 or player.x == 89) and player.y == 132 and (os.time() > player.registry["marketBan"] + (60 * 8)) then
			player:warp(2534, 39, 78)
		end
	end
end
