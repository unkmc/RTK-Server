ninja_disguise = {
	cast = function(player, target)
		local duration = 30000
		local anim = 292

		if target.blType == BL_PC then
			if target.state ~= 4 then
				clone.playerToPlayer(player, target)
			else
				player.disguise = target.disguise
				player.disguiseColor = target.lookColor
				player.state = 4
				player:updateState()
			end
		else
			player.disguise = target.look
			player.disguiseColor = target.lookColor
			player.state = 4
			player:updateState()
		end

		player:sendAnimation(anim)
		player:setDuration("ninja_disguise", 30000)
	end,

	uncast = function(player)
		local anim = 292

		if player.state == 4 then
			player.state = 0
			player:updateState()
		end
		clone.wipe(player)
		player:sendAnimation(anim)
	end
}

ninja_swap = {
	cast = function(player, target)
		local duration = 30000
		local anim = 292

		player:sendAnimation(anim)
		target:sendAnimation(anim)

		if target:hasDuration("ninja_swap") and player:hasDuration("ninja_swap") then
			player:setDuration("ninja_swap", 0)
			target:setDuration("ninja_swap", 0)
			return
		end

		clone.playerSwap(player, target)

		player:setDuration("ninja_swap", 30000)
		target:setDuration("ninja_swap", 30000)
	end,

	uncast = function(player)
		local anim = 292

		clone.wipe(player)
		player:sendAnimation(anim)
	end
}
