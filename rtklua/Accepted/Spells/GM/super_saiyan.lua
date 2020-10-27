super_saiyan = {
	cast = function(player)
		if player:hasDuration("super_saiyan") then
			player:setDuration("super_saiyan", 1)
		else
			player:setDuration("super_saiyan", 600000)
		end

		--	player:sendAnimation(241, 599)
		--	player:sendAnimation(242, 599)

		clone.equip(player, player)
		player.gfxCrown = 273
		player.gfxCrownC = 8
		player.gfxFaceATC = 26
		player:updateState()
	end,

	while_cast = function(player)
		player:sendAnimation(349)
	end,

	while_cast_250 = function(player)
		player:sendAnimation(509)
	end,

	uncast = function(player)
		player.gfxClone = 0
		player:updateState()
	end
}
