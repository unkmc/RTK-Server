huge_swirl = {
	cast = function(player)
		local animation = 0
		local x = 0
		local y = 0
		local len = math.random(16, 29)

		for i = 1, len do
			--animation = math.random(40,43) --lava bursts
			animation = 135

			--spotlights
			x = math.random(player.x - 8, player.x + 8)
			y = math.random(player.y - 7, player.y + 7)
			player:sendAnimationXY(animation, x, y)
		end
	end
}
