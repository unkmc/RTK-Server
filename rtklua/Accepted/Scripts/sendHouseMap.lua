sendHouseMap = function(player, origin)
	local worldMap = "clanban1"

	local x0 = {0}
	local y0 = {0}
	local name = {"Test"}
	local m = {0}
	local x1 = {0}
	local y1 = {0}

	player:mapSelection(worldMap, x0, y0, name, m, x1, y1)
end
