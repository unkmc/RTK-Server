forest_cover = {
	cast = function(player)
		local duration = 150000
		local aethers = 200000
		local magic = 750

		local anim = 16

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magic
		player:sendStatus()

		local target = getTargetFacing(player, BL_ALL)

		if target.blType == BL_PC then
			if target.state ~= 4 then
				clone.playerToPlayer(player, target)
			else
				player.disguise = target.disguise
				player.disguiseColor = target.lookColor
				player.state = 4
				player:updateState()
			end
		elseif target.blType == BL_MOB then
			player.disguise = target.look
			player.disguiseColor = target.lookColor
			player.state = 4
			player:updateState()
		end

		player:sendAnimation(anim)
		player:setDuration("forest_cover", duration)
		player:setAether("forest_cover", aethers)
	end,

	uncast = function(player)
		local anim = 16

		if player.state == 4 then
			player.state = 0
			player:updateState()
		end
		clone.wipe(player)
		player:sendAnimation(anim)
	end
}
