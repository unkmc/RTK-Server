fireworks = {
	use = function(player)
		if player:hasDuration("fireworks") then
			return
		else
			player:setDuration("fireworks", 5000)
		end
	end,

	while_cast = function(player)
		local r = math.random(1, 2)

		player:playSound(739)
		player:playSound(123)

		if r == 1 then
			player:sendAnimationXY(278, player.x - r, player.y - 2)
			player:sendAnimationXY(278, player.x - 1, player.y - r)
		elseif r == 2 then
			player:sendAnimationXY(278, player.x + r, player.y)
			player:sendAnimationXY(278, player.x - 1, player.y + r)
		end
		player:sendAnimationXY(278, player.x, player.y + 2)
		player:sendAnimationXY(278, player.x + 1, player.y - r)
		player:sendAnimationXY(278, player.x + r, player.y)
		player:sendAnimationXY(278, player.x + 1, player.y - 1)
	end,

	while_cast_250 = function(player)
		local r = math.random(1, 4)

		player:sendAnimationXY(331, player.x - r, player.y - r)
		player:sendAnimationXY(331, player.x + r, player.y + r)
		player:sendAnimationXY(331, player.x - r, player.y + r)
		player:sendAnimationXY(331, player.x + r, player.y - r)
	end,

	while_cast_125 = function(player)
		local r = math.random(1, 4)

		player:sendAnimationXY(331, player.x - r, player.y - r)
		player:sendAnimationXY(331, player.x + r, player.y + r)
		player:sendAnimationXY(331, player.x - r, player.y + r)
		player:sendAnimationXY(331, player.x + r, player.y - r)
	end
}
