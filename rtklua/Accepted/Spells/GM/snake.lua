snake_spell = {
	cast = function(player)
		local duration = 4000

		if not target:hasDuration("snake_spell") then
			target:setDuration("snake_spell", duration)
		end
	end,

	while_cast_500 = function(player)
		local x = player.registry["snake_x"]
		local y = player.registry["snake_y"]

		if player.registry["snake_x"] == 0 then
			x = player.x
		end
		if player.registry["snake_y"] == 0 then
			y = player.y
		end

		if math.random(1, 2) == 1 then
			if math.random(1, 2) == 1 then
				x = x + 1
			elseif math.random(1, 2) == 2 then
				x = x - 1
			end
		elseif math.random(1, 2) == 2 then
			if math.random(1, 2) == 1 then
				y = y + 1
			elseif math.random(1, 2) == 2 then
				y = y - 1
			end
		end

		player.registry["snake_x"] = x
		player.registry["snake_y"] = y

		player:sendAnimationXY(228, x, y)
	end,

	uncast = function(player)
		player.registry["snake_x"] = 0
		player.registry["snake_y"] = 0
	end,
}
