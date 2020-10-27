warpGlow = function(player)
	local m = player.m
	local xm, ym = player.xmax, player.ymax

	for x = 0, xm do
		for y = 0, ym do
			if getWarp(m, x, y) == true then
				player:selfAnimationXY(player.ID, 529, x, y)
			end
		end
	end
end
