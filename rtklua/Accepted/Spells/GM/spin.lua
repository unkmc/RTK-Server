spin = {
	cast = function(player, target)
		local duration = 15000

		if not target:hasDuration("spin") then
			target:setDuration("spin", duration)
		end
	end,

	while_cast_500 = function(player)
		player.side = player.side + 1

		if player.side > 3 then
			player.side = 0
		end

		player:sendSide()
	end,
}
