harden_armor = {
	cast = function(player)
		local duration = 300000
		if (player.blType == BL_PC and player:canPK(player)) then
			duration = 185000
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.state == 1) then
			return
		end

		if player:checkIfCast(hardarmors) then
			return
		end

		player:sendMinitext("Your armor is strengthened.")
		if (player.blType == BL_MOB) then
			return
		elseif (player.blType == BL_PC) then
			player:playSound(5)
			player:sendMinitext("You cast Harden Armor.")
			player:setDuration("harden_armor", duration)
			player:sendAnimation(2)
			player:calcStat()
		end
	end,

	recast = function(player)
		player.armor = player.armor - 10
		player:sendStatus()
	end,
	uncast = function(player)
		player.armor = player.armor + 10
		player:sendStatus()
	end
}
