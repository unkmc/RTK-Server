swing = function(player)
	local rand = math.random(0, 1)
	local mobUp = player:getObjectsInCell(
		player.m,
		player.x,
		player.y - 1,
		BL_MOB
	)
	local mobLeft = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y,
		BL_MOB
	)
	local mobRight = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y,
		BL_MOB
	)
	local mobDown = player:getObjectsInCell(
		player.m,
		player.x,
		player.y + 1,
		BL_MOB
	)
	local mobUpExtend = player:getObjectsInCell(
		player.m,
		player.x,
		player.y - 2,
		BL_MOB
	)
	local mobLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 2,
		player.y,
		BL_MOB
	)
	local mobRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 2,
		player.y,
		BL_MOB
	)
	local mobDownExtend = player:getObjectsInCell(
		player.m,
		player.x,
		player.y + 2,
		BL_MOB
	)
	local mobUpLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y - 1,
		BL_MOB
	)
	local mobUpRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y - 1,
		BL_MOB
	)
	local mobDownLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y + 1,
		BL_MOB
	)
	local mobDownRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y + 1,
		BL_MOB
	)
	local pcUp = player:getObjectsInCell(
		player.m,
		player.x,
		player.y - 1,
		BL_PC
	)
	local pcLeft = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y,
		BL_PC
	)
	local pcRight = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y,
		BL_PC
	)
	local pcDown = player:getObjectsInCell(
		player.m,
		player.x,
		player.y + 1,
		BL_PC
	)
	local pcUpExtend = player:getObjectsInCell(
		player.m,
		player.x,
		player.y - 2,
		BL_PC
	)
	local pcLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 2,
		player.y,
		BL_PC
	)
	local pcRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 2,
		player.y,
		BL_PC
	)
	local pcDownExtend = player:getObjectsInCell(
		player.m,
		player.x,
		player.y + 2,
		BL_PC
	)
	local pcUpLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y - 1,
		BL_PC
	)
	local pcUpRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y - 1,
		BL_PC
	)
	local pcDownLeftExtend = player:getObjectsInCell(
		player.m,
		player.x - 1,
		player.y + 1,
		BL_PC
	)
	local pcDownRightExtend = player:getObjectsInCell(
		player.m,
		player.x + 1,
		player.y + 1,
		BL_PC
	)
	local extendHit = player.extendHit

	local objRight = getObject(player.m, player.x + 1, player.y)
	local objLeft = getObject(player.m, player.x - 1, player.y)
	local objUp = getObject(player.m, player.x, player.y - 1)
	local objDown = getObject(player.m, player.x, player.y + 1)

	if (player.side == 0) then
		if (#mobUp > 0) then
			for i = 1, #mobUp do
				player:swingTarget(mobUp[i])
			end
		end

		if (#pcUp > 0) then
			for i = 1, #pcUp do
				if (player:canPK(pcUp[i])) then
					player:swingTarget(pcUp[i])
				end
			end
		end

		if (extendHit) then
			if (#mobUp > 0) then
				if (#mobUpExtend > 0) then
					for i = 1, #mobUpExtend do
						player:swingTarget(mobUpExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end
			end

			if (#mobLeft > 0 and player.flank) then
				if (#mobLeftExtend > 0) then
					for i = 1, #mobLeftExtend do
						player:swingTarget(mobLeftExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end
			end

			if (#mobRight > 0 and player.flank) then
				if (#mobRightExtend > 0) then
					for i = 1, #mobRightExtend do
						player:swingTarget(mobRightExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobDown > 0 and player.backstab) then
				if (#mobDownExtend > 0) then
					for i = 1, #mobDownExtend do
						player:swingTarget(mobDownExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#pcUp > 0) then
				if (#pcUpExtend > 0) then
					for i = 1, #pcUpExtend do
						if (player:canPK(pcUpExtend[i])) then
							player:swingTarget(pcUpExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end
			end

			if (#pcLeft > 0 and player.flank) then
				if (#pcLeftExtend > 0) then
					for i = 1, #pcLeftExtend do
						if (player:canPK(pcLeftExtend[i])) then
							player:swingTarget(pcLeftExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end
			end

			if (#pcRight > 0 and player.flank) then
				if (#pcRightExtend > 0) then
					for i = 1, #pcRightExtend do
						if (player:canPK(pcRightExtend[i])) then
							player:swingTarget(pcRightExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcDown > 0 and player.backstab) then
				if (#pcDownExtend > 0) then
					for i = 1, #pcDownExtend do
						if (player:canPK(pcDownExtend[i])) then
							player:swingTarget(pcDownExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end
		end

		if (#mobLeft > 0 and player.flank and rand == 0) then
			for i = 1, #mobLeft do
				player:swingTarget(mobLeft[i])
			end
		end

		if (#mobRight > 0 and player.flank and rand == 1) then
			for i = 1, #mobRight do
				player:swingTarget(mobRight[i])
			end
		end

		if (#mobDown > 0 and player.backstab) then
			for i = 1, #mobDown do
				player:swingTarget(mobDown[i])
			end
		end

		if (#pcLeft > 0 and player.flank and rand == 0) then
			for i = 1, #pcLeft do
				if (player:canPK(pcLeft[i])) then
					player:swingTarget(pcLeft[i])
				end
			end
		end

		if (#pcRight > 0 and player.flank and rand == 1) then
			for i = 1, #pcRight do
				if (player:canPK(pcRight[i])) then
					player:swingTarget(pcRight[i])
				end
			end
		end

		if (#pcDown > 0 and player.backstab) then
			for i = 1, #pcDown do
				if (player:canPK(pcDown[i])) then
					player:swingTarget(pcDown[i])
				end
			end
		end
	elseif (player.side == 1) then
		if (#mobRight > 0) then
			for i = 1, #mobRight do
				player:swingTarget(mobRight[i])
			end
		end

		if (#pcRight > 0) then
			for i = 1, #pcRight do
				if (player:canPK(pcRight[i])) then
					player:swingTarget(pcRight[i])
				end
			end
		end
		if (extendHit) then
			if (#mobRight > 0) then
				if (#mobRightExtend > 0) then
					for i = 1, #mobRightExtend do
						player:swingTarget(mobRightExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobUp > 0 and player.flank) then
				if (#mobUpExtend > 0) then
					for i = 1, #mobUpExtend do
						player:swingTarget(mobUpExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end
			end

			if (#mobDown > 0 and player.flank) then
				if (#mobDownExtend > 0) then
					for i = 1, #mobDownExtend do
						player:swingTarget(mobDownExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobLeft > 0 and player.backstab) then
				if (#mobLeftExtend > 0) then
					for i = 1, #mobLeftExtend do
						player:swingTarget(mobLeftExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end
			end

			if (#pcRight > 0) then
				if (#pcRightExtend > 0) then
					for i = 1, #pcRightExtend do
						if (player:canPK(pcRightExtend[i])) then
							player:swingTarget(pcRightExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcUp > 0 and player.flank) then
				if (#pcUpExtend > 0) then
					for i = 1, #pcUpExtend do
						if (player:canPK(pcUpExtend[i])) then
							player:swingTarget(pcUpExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end
			end

			if (#pcDown > 0 and player.flank) then
				if (#pcDownExtend > 0) then
					for i = 1, #pcDownExtend do
						if (player:canPK(pcDownExtend[i])) then
							player:swingTarget(pcDownExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcLeft > 0 and player.backstab) then
				if (#pcLeftExtend > 0) then
					for i = 1, #pcLeftExtend do
						if (player:canPK(pcLeftExtend[i])) then
							player:swingTarget(pcLeftExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end
			end
		end

		if (#mobUp > 0 and player.flank and rand == 0) then
			for i = 1, #mobUp do
				player:swingTarget(mobUp[i])
			end
		end

		if (#mobDown > 0 and player.flank and rand == 1) then
			for i = 1, #mobDown do
				player:swingTarget(mobDown[i])
			end
		end

		if (#mobLeft > 0 and player.backstab) then
			for i = 1, #mobLeft do
				player:swingTarget(mobLeft[i])
			end
		end

		if (#pcUp > 0 and player.flank and rand == 0) then
			for i = 1, #pcUp do
				if (player:canPK(pcUp[i])) then
					player:swingTarget(pcUp[i])
				end
			end
		end

		if (#pcDown > 0 and player.flank and rand == 1) then
			for i = 1, #pcDown do
				if (player:canPK(pcDown[i])) then
					player:swingTarget(pcDown[i])
				end
			end
		end

		if (#pcLeft > 0 and player.backstab) then
			for i = 1, #pcLeft do
				if (player:canPK(pcLeft[i])) then
					player:swingTarget(pcLeft[i])
				end
			end
		end
	elseif (player.side == 2) then
		if (#mobDown > 0) then
			for i = 1, #mobDown do
				player:swingTarget(mobDown[i])
			end
		end

		if (#pcDown > 0) then
			for i = 1, #pcDown do
				if (player:canPK(pcDown[i])) then
					player:swingTarget(pcDown[i])
				end
			end
		end
		if (extendHit) then
			if (#mobDown > 0) then
				if (#mobDownExtend > 0) then
					for i = 1, #mobDownExtend do
						player:swingTarget(mobDownExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobLeft > 0 and player.flank) then
				if (#mobLeftExtend > 0) then
					for i = 1, #mobLeftExtend do
						player:swingTarget(mobLeftExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end
			end

			if (#mobRight > 0 and player.flank) then
				if (#mobRightExtend > 0) then
					for i = 1, #mobRightExtend do
						player:swingTarget(mobRightExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobUp > 0 and player.backstab) then
				if (#mobUpExtend > 0) then
					for i = 1, #mobUpExtend do
						player:swingTarget(mobUpExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end
			end

			if (#pcDown > 0) then
				if (#pcDownExtend > 0) then
					for i = 1, #pcDownExtend do
						if (player:canPK(pcDownExtend[i])) then
							player:swingTarget(pcDownExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcLeft > 0 and player.flank) then
				if (#pcLeftExtend > 0) then
					for i = 1, #pcLeftExtend do
						if (player:canPK(pcLeftExtend[i])) then
							player:swingTarget(pcLeftExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end
			end

			if (#pcRight > 0 and player.flank) then
				if (#pcRightExtend > 0) then
					for i = 1, #pcRightExtend do
						if (player:canPK(pcRightExtend[i])) then
							player:swingTarget(pcRightExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcUp > 0 and player.backstab) then
				if (#pcUpExtend > 0) then
					for i = 1, #pcUpExtend do
						if (player:canPK(pcUpExtend[i])) then
							player:swingTarget(pcUpExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end
			end
		end

		if (#mobLeft > 0 and player.flank and rand == 0) then
			for i = 1, #mobLeft do
				player:swingTarget(mobLeft[i])
			end
		end

		if (#mobRight > 0 and player.flank and rand == 1) then
			for i = 1, #mobRight do
				player:swingTarget(mobRight[i])
			end
		end

		if (#mobUp > 0 and player.backstab) then
			for i = 1, #mobUp do
				player:swingTarget(mobUp[i])
			end
		end

		if (#pcLeft > 0 and player.flank and rand == 0) then
			for i = 1, #pcLeft do
				if (player:canPK(pcLeft[i])) then
					player:swingTarget(pcLeft[i])
				end
			end
		end

		if (#pcRight > 0 and player.flank and rand == 1) then
			for i = 1, #pcRight do
				if (player:canPK(pcRight[i])) then
					player:swingTarget(pcRight[i])
				end
			end
		end

		if (#pcUp > 0 and player.backstab) then
			for i = 1, #pcUp do
				if (player:canPK(pcUp[i])) then
					player:swingTarget(pcUp[i])
				end
			end
		end
	elseif (player.side == 3) then
		if (#mobLeft > 0) then
			for i = 1, #mobLeft do
				player:swingTarget(mobLeft[i])
			end
		end

		if (#pcLeft > 0) then
			for i = 1, #pcLeft do
				if (player:canPK(pcLeft[i])) then
					player:swingTarget(pcLeft[i])
				end
			end
		end
		if (extendHit) then
			if (#mobLeft > 0) then
				if (#mobLeftExtend > 0) then
					for i = 1, #mobLeftExtend do
						player:swingTarget(mobLeftExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end
			end

			if (#mobUp > 0 and player.flank) then
				if (#mobUpExtend > 0) then
					for i = 1, #mobUpExtend do
						player:swingTarget(mobUpExtend[i])
					end
				end

				if (#mobUpLeftExtend > 0) then
					for i = 1, #mobUpLeftExtend do
						player:swingTarget(mobUpLeftExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end
			end

			if (#mobDown > 0 and player.flank) then
				if (#mobDownExtend > 0) then
					for i = 1, #mobDownExtend do
						player:swingTarget(mobDownExtend[i])
					end
				end

				if (#mobDownLeftExtend > 0) then
					for i = 1, #mobDownLeftExtend do
						player:swingTarget(mobDownLeftExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#mobRight > 0 and player.backstab) then
				if (#mobRightExtend > 0) then
					for i = 1, #mobRightExtend do
						player:swingTarget(mobRightExtend[i])
					end
				end

				if (#mobUpRightExtend > 0) then
					for i = 1, #mobUpRightExtend do
						player:swingTarget(mobUpRightExtend[i])
					end
				end

				if (#mobDownRightExtend > 0) then
					for i = 1, #mobDownRightExtend do
						player:swingTarget(mobDownRightExtend[i])
					end
				end
			end

			if (#pcLeft > 0) then
				if (#pcLeftExtend > 0) then
					for i = 1, #pcLeftExtend do
						if (player:canPK(pcLeftExtend[i])) then
							player:swingTarget(pcLeftExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end
			end

			if (#pcUp > 0 and player.flank) then
				if (#pcUpExtend > 0) then
					for i = 1, #pcUpExtend do
						if (player:canPK(pcUpExtend[i])) then
							player:swingTarget(pcUpExtend[i])
						end
					end
				end

				if (#pcUpLeftExtend > 0) then
					for i = 1, #pcUpLeftExtend do
						if (player:canPK(pcUpLeftExtend[i])) then
							player:swingTarget(pcUpLeftExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end
			end

			if (#pcDown > 0 and player.flank) then
				if (#pcDownExtend > 0) then
					for i = 1, #pcDownExtend do
						if (player:canPK(pcDownExtend[i])) then
							player:swingTarget(pcDownExtend[i])
						end
					end
				end

				if (#pcDownLeftExtend > 0) then
					for i = 1, #pcDownLeftExtend do
						if (player:canPK(pcDownLeftExtend[i])) then
							player:swingTarget(pcDownLeftExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end

			if (#pcRight > 0 and player.backstab) then
				if (#pcRightExtend > 0) then
					for i = 1, #pcRightExtend do
						if (player:canPK(pcRightExtend[i])) then
							player:swingTarget(pcRightExtend[i])
						end
					end
				end

				if (#pcUpRightExtend > 0) then
					for i = 1, #pcUpRightExtend do
						if (player:canPK(pcUpRightExtend[i])) then
							player:swingTarget(pcUpRightExtend[i])
						end
					end
				end

				if (#pcDownRightExtend > 0) then
					for i = 1, #pcDownRightExtend do
						if (player:canPK(pcDownRightExtend[i])) then
							player:swingTarget(pcDownRightExtend[i])
						end
					end
				end
			end
		end

		if (#mobUp > 0 and player.flank and rand == 0) then
			for i = 1, #mobUp do
				player:swingTarget(mobUp[i])
			end
		end

		if (#mobDown > 0 and player.flank and rand == 1) then
			for i = 1, #mobDown do
				player:swingTarget(mobDown[i])
			end
		end

		if (#mobRight > 0 and player.backstab) then
			for i = 1, #mobRight do
				player:swingTarget(mobRight[i])
			end
		end

		if (#pcUp > 0 and player.flank and rand == 0) then
			for i = 1, #pcUp do
				if (player:canPK(pcUp[i])) then
					player:swingTarget(pcUp[i])
				end
			end
		end

		if (#pcDown > 0 and player.flank and rand == 1) then
			for i = 1, #pcDown do
				if (player:canPK(pcDown[i])) then
					player:swingTarget(pcDown[i])
				end
			end
		end

		if (#pcRight > 0 and player.backstab) then
			for i = 1, #pcRight do
				if (player:canPK(pcRight[i])) then
					player:swingTarget(pcRight[i])
				end
			end
		end
	end
end

shootArrow = function(player)
	local onElixirMap = false
	for z = 1, #elixirMaps do
		if player.m == elixirMaps[z] then
			onElixirMap = true
		end
	end
	if onElixirMap == false then
		local weapon = player:getEquippedItem(EQ_WEAP)

		if player.class == 15 then
			bowAttack(player)
		end
	end
end

bowAttack = function(player)
	local Ingr = player.enchant
	local Dam = player.dam
	local Mgt = player.might
	local Rage = player.rage
	local Inv = 3
	local Crit = 1

	if (not player:canCast(1, 1, 0)) then
		return
	end
	local S = math.random(player.minSDam, player.maxSDam)
	damage = ((S / 2) * Ingr + Dam * 2.5 + Mgt / 8 + 7.5) * (Rage * Inv)
	if (math.random(1, 100) <= 2) then
		damage = damage * 3
	end
	player:playSound(12)

	local hit = {}
	local blocked = {}

	if (player.side == 0) then
		for y = 1, 7 do
			for x = 0, y do
				if (getPass(player.m, player.x + x, player.y - y) == 1) then
					table.insert(blocked, x)
				end
				if (getPass(player.m, player.x - x, player.y - y) == 1) then
					table.insert(blocked, -x)
				end
				if not tableContains(player, blocked, x) then
					table.insert(hit, {x, y})
				end
				if not tableContains(player, blocked, -x) then
					table.insert(hit, {-x, y})
				end
			end
		end
	end

	if (player.side == 1) then
		for x = 1, 7 do
			for y = 0, x do
				if (getPass(player.m, player.x + x, player.y + y) == 1) then
					table.insert(blocked, y)
				end
				if (getPass(player.m, player.x + x, player.y - y) == 1) then
					table.insert(blocked, -y)
				end
				if not tableContains(player, blocked, y) then
					table.insert(hit, {x, y})
				end
				if not tableContains(player, blocked, -y) then
					table.insert(hit, {x, -y})
				end
			end
		end
	end

	if (player.side == 2) then
		for y = 1, 7 do
			for x = 0, y do
				if (getPass(player.m, player.x + x, player.y + y) == 1) then
					table.insert(blocked, x)
				end
				if (getPass(player.m, player.x - x, player.y + y) == 1) then
					table.insert(blocked, -x)
				end
				if not tableContains(player, blocked, x) then
					table.insert(hit, {x, y})
				end
				if not tableContains(player, blocked, -x) then
					table.insert(hit, {-x, y})
				end
			end
		end
	end

	if (player.side == 3) then
		for x = 1, 7 do
			for y = 0, x do
				if (getPass(player.m, player.x - x, player.y + y) == 1) then
					table.insert(blocked, y)
				end
				if (getPass(player.m, player.x - x, player.y - y) == 1) then
					table.insert(blocked, -y)
				end
				if not tableContains(player, blocked, y) then
					table.insert(hit, {x, y})
				end
				if not tableContains(player, blocked, -y) then
					table.insert(hit, {x, -y})
				end
			end
		end
	end

	--[[ debug
	for z=1,#hit do
		if player.side == 0 then player:sendAnimationXY(228, player.x + hit[z][1], player.y - hit[z][2], 1) end
		if player.side == 1 then player:sendAnimationXY(228, player.x + hit[z][1], player.y + hit[z][2], 1) end
		if player.side == 2 then player:sendAnimationXY(228, player.x + hit[z][1], player.y + hit[z][2], 1) end
		if player.side == 3 then player:sendAnimationXY(228, player.x - hit[z][1], player.y + hit[z][2], 1) end
	end
	]]
	--
	for z = 1, #hit do
		local xhit = 0
		local yhit = 0
		if player.side == 0 then
			xhit = player.x + hit[z][1]
			yhit = player.y - hit[z][2]
		end
		if player.side == 1 then
			xhit = player.x + hit[z][1]
			yhit = player.y + hit[z][2]
		end
		if player.side == 2 then
			xhit = player.x + hit[z][1]
			yhit = player.y + hit[z][2]
		end
		if player.side == 3 then
			xhit = player.x - hit[z][1]
			yhit = player.y + hit[z][2]
		end

		local check = player:getObjectsInCell(player.m, xhit, yhit, BL_PC)
		local check2 = player:getObjectsInCell(player.m, xhit, yhit, BL_MOB)

		if #check > 0 or #check2 > 0 then
			if player.side == 0 then
				player:throw(xhit, yhit, 6, 0, 1)
			end
			if player.side == 1 then
				player:throw(xhit, yhit, 7, 0, 1)
			end
			if player.side == 2 then
				player:throw(xhit, yhit, 8, 0, 1)
			end
			if player.side == 3 then
				player:throw(xhit, yhit, 9, 0, 1)
			end

			if #check > 0 then
				if player:canPK(check[1]) then
					check[1].attacker = player.ID
					check[1]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
					check[1]:sendMinitext(player.name .. " hit you with an arrow.")
				end
			end
			if #check2 > 0 then
				check2[1].attacker = player.ID
				check2[1]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				player:addThreat(check2[1].ID, damage)
			end
			player:sendStatus()
			return
		end
	end
end

tableContains = function(player, theTable, value)
	local found = false
	for z = 1, #theTable do
		if value >= 0 and theTable[z] >= 0 then
			if value >= theTable[z] then
				found = true
			end
		end
		if value <= 0 and theTable[z] <= 0 then
			if value <= theTable[z] then
				found = true
			end
		end
	end
	return found
end
