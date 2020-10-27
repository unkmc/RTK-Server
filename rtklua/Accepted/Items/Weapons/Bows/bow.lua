bow = {
	thrown = function(player, target)
		local multiTargetDamageMod = 9

		--player.damage = player.damage * ((mod - x + 1) / mod) x = targetNumber
		local arrow = 6
		local bowRange = 5

		--max range of bow
		local maxTargets = 3

		--max targets to acquire and hit, will not exceed bowRange
		local mobList = {}

		--list of mobs, only the first is taken
		local pcList = {}

		--list of players, only the first is taken
		local targetList = {}

		--final target list
		local pass = 1

		--boolean passcheck
		local i = 0

		--counter

		--no ammo

		--cannot shoot

		--1 and 2 for PK
		repeat
			i = i + 1

			if (player.side == 0) then
				pass = getPass(player.m, player.x, player.y - i)
				mobList = player:getObjectsInCell(
					player.m,
					player.x,
					player.y - i,
					BL_MOB
				)
				if (player.pvp > 0) then
					pcList = player:getObjectsInCell(
						player.m,
						player.x,
						player.y - i,
						BL_PC
					)
				end
			elseif (player.side == 1) then
				pass = getPass(player.m, player.x + i, player.y)
				mobList = player:getObjectsInCell(
					player.m,
					player.x + i,
					player.y,
					BL_MOB
				)
				if (player.pvp > 0) then
					pcList = player:getObjectsInCell(
						player.m,
						player.x + i,
						player.y,
						BL_PC
					)
				end
			elseif (player.side == 2) then
				pass = getPass(player.m, player.x, player.y + i)
				mobList = player:getObjectsInCell(
					player.m,
					player.x,
					player.y + i,
					BL_MOB
				)
				if (player.pvp > 0) then
					pcList = player:getObjectsInCell(
						player.m,
						player.x,
						player.y + i,
						BL_PC
					)
				end
			elseif (player.side == 3) then
				pass = getPass(player.m, player.x - i, player.y)
				mobList = player:getObjectsInCell(
					player.m,
					player.x - i,
					player.y,
					BL_MOB
				)
				if (player.pvp > 0) then
					pcList = player:getObjectsInCell(
						player.m,
						player.x - i,
						player.y,
						BL_PC
					)
				end
			end
		until (#mobList > 0 or #pcList > 0 or i > bowRange or pass == 1)

		local numTargets = bowRange - i + 1

		if (numTargets > maxTargets) then
			numTargets = maxTargets
		end

		if (numTargets <= 0) then
			if (player.side == 0) then
				player:throw(player.x, player.y - bowRange, 6, 0, 1)
			elseif (player.side == 1) then
				player:throw(player.x + bowRange, player.y, 7, 0, 1)
			elseif (player.side == 2) then
				player:throw(player.x, player.y + bowRange, 8, 0, 1)
			elseif (player.side == 3) then
				player:throw(player.x - bowRange, player.y, 9, 0, 1)
			end

			--player:sendMinitext("You did not hit anything.")
			return
		else
			if (#pcList > 0) then
				table.insert(targetList, pcList[1])

				for x = 1, numTargets - 1 do
					if (player.side == 0) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y - x,
							BL_MOB
						)
						pcList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y - x,
							BL_PC
						)

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 1) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x + x,
							targetList[1].y,
							BL_MOB
						)
						pcList = player:getObjectsInCell(
							player.m,
							targetList[1].x + x,
							targetList[1].y,
							BL_PC
						)

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 2) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y + x,
							BL_MOB
						)
						pcList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y + x,
							BL_PC
						)

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 3) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x - x,
							targetList[1].y,
							BL_MOB
						)
						pcList = player:getObjectsInCell(
							player.m,
							targetList[1].x - x,
							targetList[1].y,
							BL_PC
						)

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					end
				end
			elseif (#mobList > 0) then
				table.insert(targetList, mobList[1])

				for x = 1, numTargets - 1 do
					if (player.side == 0) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y - x,
							BL_MOB
						)
						if (player.pvp > 0) then
							pcList = player:getObjectsInCell(
								player.m,
								targetList[1].x,
								targetList[1].y - x,
								BL_PC
							)
						end

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 1) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x + x,
							targetList[1].y,
							BL_MOB
						)
						if (player.pvp > 0) then
							pcList = player:getObjectsInCell(
								player.m,
								targetList[1].x + x,
								targetList[1].y,
								BL_PC
							)
						end

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 2) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x,
							targetList[1].y + x,
							BL_MOB
						)
						if (player.pvp > 0) then
							pcList = player:getObjectsInCell(
								player.m,
								targetList[1].x,
								targetList[1].y + x,
								BL_PC
							)
						end

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					elseif (player.side == 3) then
						mobList = player:getObjectsInCell(
							player.m,
							targetList[1].x - x,
							targetList[1].y,
							BL_MOB
						)
						if (player.pvp > 0) then
							pcList = player:getObjectsInCell(
								player.m,
								targetList[1].x - x,
								targetList[1].y,
								BL_PC
							)
						end

						if (#pcList > 0) then
							table.insert(targetList, pcList[1])
						elseif (#mobList > 0) then
							table.insert(targetList, mobList[1])
						else
							table.insert(targetList, nil)
						end
					end
				end
			end
		end

		if (#targetList > 0) then
			for x = 1, #targetList do
				if (targetList[x] ~= nil) then
					hitCritChance(player, targetList[x])

					if (player.critChance > 0) then
						local spells = player:getSpellYName()
						local durations = player:getAllDurations()

						for i = 0, 14 do
							local equip = player:getEquippedItem(i)

							if (equip ~= nil) then
								local script = rawget(_G, equip.yname)
								local funcOnHit

								if (script ~= nil) then
									funcOnHit = rawget(script, "on_hit")
								end

								if (funcOnHit ~= nil) then
									funcOnHit(player, targetList[x])
								end
							end
						end

						if (#spells > 0) then
							for i = 1, #spells do
								local script = rawget(_G, spells[i])
								local funcPassiveOnHit

								if (script ~= nil) then
									funcPassiveOnHit = rawget(
										script,
										"passive_on_hit"
									)
								end

								if (funcPassiveOnHit ~= nil) then
									funcPassiveOnHit(player, targetList[x])
								end
							end
						end

						if (#durations > 0) then
							for i = 1, #durations do
								local script = rawget(_G, durations[i])
								local funcOnHitWhileCast

								if (script ~= nil) then
									funcOnHitWhileCast = rawget(
										script,
										"on_hit_while_cast"
									)
								end

								if (funcOnHitWhileCast ~= nil) then
									funcOnHitWhileCast(player, targetList[x])
								end
							end
						end

						swingDamage(player)
						swingDamage(player, targetList[x])
						player.damage = player.damage * ((multiTargetDamageMod - x + 1) / multiTargetDamageMod)

						if (targetList[x].blType == BL_PC) then
							player_combat.on_attacked(targetList[x], player)
						else
							mob_ai_basic.on_attacked(targetList[x], player)
						end
					end
				end
			end

			player:throw(
				targetList[#targetList].x,
				targetList[#targetList].y,
				arrow + player.side,
				0,
				1
			)
		else
			if (i ~= 1) then
				if (player.side == 0) then
					player:throw(player.x, player.y - i + 1, 6, 0, 1)
				elseif (player.side == 1) then
					player:throw(player.x + i - 1, player.y, 7, 0, 1)
				elseif (player.side == 2) then
					player:throw(player.x, player.y + i - 1, 8, 0, 1)
				elseif (player.side == 3) then
					player:throw(player.x - i + 1, player.y, 9, 0, 1)
				end

				--player:sendMinitext("You did not hit anything.")
			else
				--player:sendMinitext("You cannot shoot so close to a wall.")
			end
		end
	end
}
