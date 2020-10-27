gm_push = {
	cast = function(player)
		local pc, mob = getTargetFacing(player, BL_PC), getTargetFacing(
			player,
			BL_MOB
		)

		player:sendAction(3, 20)
		player:sendFrontAnimation(191, player.side, 1)
		player:playSound(10)

		if pc ~= nil then
			gm_push.canCast(player, pc)
		elseif mob ~= nil then
			if mob.owner == 0 then
				gm_push.canCast(player, mob)
			end
		end
	end,

	canCast = function(player, block)
		if block.registry["can_be_push"] > 0 then
			if player.ID ~= 2 then
				anim(player)
				pushBack(player)
				player:sendMinitext("Do not disturb!")
			end
			return
		else
			if block:hasDuration("gm_push") then
				return
			else
				for i = 0, 3 do
					block.registry["gm_push" .. i] = 0
				end
				block.registry["gm_push" .. player.side] = 1
				block:setDuration("gm_push", 8000)
			end
		end
	end,

	while_cast_fast = function(player)
		player:sendAnimationXY(397, player.x, player.y)

		--	player:sendAnimationXY(15, player.x, player.y)
		player:sendAnimationXY(86, player.x, player.y)
		player:playSound(94)

		if player.registry["gm_push0"] == 1 then
			if getPass(player.m, player.x, player.y - 1) == 1 then
				player:setDuration("gm_push", 0)
				player:sendAnimation(153)
				player:playSound(59)
				return
			else
				player:warp(player.m, player.x, player.y - 1)
			end
		elseif player.registry["gm_push1"] == 1 then
			if getPass(player.m, player.x + 1, player.y) == 1 then
				player:setDuration("gm_push", 0)
				player:sendAnimation(153)
				player:playSound(59)
				return
			else
				player:warp(player.m, player.x + 1, player.y)
			end
		elseif player.registry["gm_push2"] == 1 then
			if getPass(player.m, player.x, player.y + 1) == 1 then
				player:setDuration("gm_push", 0)
				player:sendAnimation(153)
				player:playSound(59)
				return
			else
				player:warp(player.m, player.x, player.y + 1)
			end
		elseif player.registry["gm_push3"] == 1 then
			if getPass(player.m, player.x - 1, player.y) == 1 then
				player:setDuration("gm_push", 0)
				player:sendAnimation(153)
				player:playSound(59)
				return
			else
				player:warp(player.m, player.x - 1, player.y)
			end
		end
	end,

	while_cast_250 = function(player)
		gm_push.while_cast_fast(player)
	end,

	uncast = function(player)
		for i = 0, 3 do
			player.registry["gm_push" .. i] = 0
		end
		player:calcStat()
	end
}
