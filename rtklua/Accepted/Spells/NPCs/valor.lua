valor = {
	cast = function(player)
		local duration = 300000

		if (player.blType == BL_PC and player:canPK(player)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player:checkIfCast(mights) then
			return
		end

		player:sendMinitext("Your muscles develop.")
		player:sendAction(6, 35)
		player:setDuration("valor", duration)
		player:playSound(12)
		player:sendAnimation(11)
		player:calcStat()
	end,

	recast = function(player)
		player.might = player.might + 3
		player:sendStatus()
	end,

	uncast = function(player)
		player.might = player.might - 3
		player:sendStatus()
	end
}
