push = {
	cast = function(player)
		local magicCost = 600

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local target = getTargetFacing(player, BL_PC)

		if target ~= nil then
			player.magic = player.magic - magicCost
			player:sendStatus()

			target:sendAnimation(10, 25)
			player:sendAction(2, 20)
			player:playSound(10)
			local targetM = target.m
			local targetX = 0
			local targetY = 0

			if player.side == 0 then
				targetX = target.x
				targetY = target.y - 1
			elseif player.side == 1 then
				targetX = target.x + 1
				targetY = target.y
			elseif player.side == 2 then
				targetX = target.x
				targetY = target.y + 1
			elseif player.side == 3 then
				targetX = target.x - 1
				targetY = target.y
			end

			local objCheck = getObject(targetM, targetX, targetY)
			local passCheck = getPass(targetM, targetX, targetY)
			local warpCheck = getWarp(targetM, targetX, targetY)

			local blockCheck = player:getObjectsInCell(
				targetM,
				targetX,
				targetY,
				BL_ALL
			)

			local maxX = getMapXMax(targetM)
			local maxY = getMapYMax(targetM)

			if objCheck == 0 and passCheck == 0 and not warpCheck and #blockCheck == 0 and targetX >= 0 and targetX < maxX and targetY >= 0 and targetY < maxY then
				target:warp(targetM, targetX, targetY)
				target:sendAnimation(10, 25)
				player:sendMinitext("You cast Push.")
				target:sendMinitext(player.name .. " casts Push spell on you.")
				return
			else
				if player.side == 0 then
					targetY = targetY - 1
				elseif player.side == 1 then
					targetX = targetX + 1
				elseif player.side == 2 then
					targetY = targetY + 1
				elseif player.side == 3 then
					targetX = targetX - 1
				end

				objCheck = getObject(targetM, targetX, targetY)
				passCheck = getPass(targetM, targetX, targetY)
				warpCheck = getWarp(targetM, targetX, targetY)
				blockCheck = player:getObjectsInCell(
					targetM,
					targetX,
					targetY,
					BL_ALL
				)

				if objCheck == 0 and passCheck == 0 and not warpCheck and #blockCheck == 0 and targetX >= 0 and targetX < maxX and targetY >= 0 and targetY < maxY then
					target:warp(targetM, targetX, targetY)
					target:sendAnimation(10, 25)
					player:sendMinitext("You cast Push.")
					target:sendMinitext(player.name .. " casts Push spell on you.")
					return
				else
					player:sendMinitext("You can't push it.")
				end
			end
		end
	end,
}
