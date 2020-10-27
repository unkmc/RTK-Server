change_tile = {
	cast = function(player)
		local tile = {}

		if player.side == 0 then
			tile = {m = player.m, x = player.x, y = player.y - 1}
		elseif player.side == 1 then
			tile = {m = player.m, x = player.x + 1, y = player.y}
		elseif player.side == 2 then
			tile = {m = player.m, x = player.x, y = player.y + 1}
		elseif player.side == 3 then
			tile = {m = player.m, x = player.x - 1, y = player.y}
		end

		if getTile(tile.m, tile.x, tile.y) > 0 then
			setTile(tile.m, tile.x, tile.y, 0)
			player:sendAnimationXY(235, tile.x, tile.y)
			return
		else
			setTile(tile.m, tile.x, tile.y, 43)
			player:sendAnimationXY(228, tile.x, tile.y)
		end
		player:sendAction(6, 20)
	end
}
