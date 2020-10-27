onScriptedTilesKanShop = function(player)
	local mapTitle = player.mapTitle
	local x = player.x
	local y = player.y

	local destm = 0
	local destx = 0
	local desty = 0

	if mapTitle == "Buya Kan Shop" or mapTitle == "Kugnae Kan Shop" then
		if mapTitle == "Buya Kan Shop" then
			destm = 330
			destx = 105 + x
			desty = 134
		end

		if mapTitle == "Kugnae Kan Shop" then
			destm = 0
			destx = 0
			desty = 0
		end

		if y == getMapYMax(player.m) then
			player.state = 0
			player.speed = 90
			clone.wipe(player)

			player:warp(destm, destx, desty)
		end
	end
end
