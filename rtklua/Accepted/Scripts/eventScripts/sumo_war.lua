SumoWarNpc = {
	redWin = function()
		local pc = core:getObjectsInMap(15030, BL_PC)

		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(15030, "Red Team Wins!")
		broadcast(15030, "You will return to the Arena in 5 seconds")
		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
		core.gameRegistry["sumo_war_end_timer"] = os.time() + 5
	end,

	blueWin = function()
		local pc = core:getObjectsInMap(15030, BL_PC)

		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(15030, "Blue Team Wins!")
		broadcast(15030, "You will return to the Arena in 5 seconds")
		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
		core.gameRegistry["sumo_war_end_timer"] = os.time() + 5
	end,

	getStartTimer = function()
		local hour, minute, second = 0, 0, 0

		if core.gameRegistry["sumo_war_start"] < os.time() then
			return "00:00:00"
		else
			dif = core.gameRegistry["sumo_war_start"] - os.time()
			hour = string.format("%02.f", math.floor(dif / 3600))
			minute = string.format("%02.f", math.floor(dif / 60 - (hour * 60)))
			second = string.format(
				"%02.f",
				math.floor(dif - hour * 3600 - minute * 60)
			)
			return hour .. ":" .. minute .. ":" .. second
		end
	end,

	click = async(function(player, npc)
		local pc = player:getObjectsInMap(15031, BL_PC)
		local n = "<b>[Sumo War]\n\n"
		local t = {g = convertGraphic(npc.look, "monster"), c = npc.lookColor}
		player.npcGraphic = t.g
		player.npcColor = t.c
		player.dialogType = 0

		local str, par = "", ""
		local time = SumoWarNpc.getStartTimer()

		local opts = {}
		table.insert(opts, "How To Play?")
		if core.gameRegistry["sumo_war"] == 1 then
			if player.registry["sumo_war_team"] == 0 then
				table.insert(opts, "Register For Sumo War")
			else
				par = " participant."
			end

			if player.registry["sumo_war_team"] > 0 then
				table.insert(opts, "I can't register!")
			end
		end

		table.insert(opts, "Exit")

		if core.gameRegistry["sumo_war_start"] > os.time() then
			str = "Waiting time: " .. SumoWarNpc.getStartTimer()
		end

		menu = player:menuString(
			n .. "Hello," .. par .. " The game will start in few minutes.\n" .. str .. "\nTotal players: " .. #pc,
			opts
		)

		if menu == "How To Play?" then
			player:dialogSeq(
				{
					t,
					n .. "Sumo War is a team based game about knocking oppenents into the water in order to score points.",
					n .. "Depending on the total number of players, your team may need 5, 10 or 15 points to win the game.",
					n .. "Use your attack to push enemies around, and if they splash into the water your team scores a point.",
					n .. "Anyone who gets knocked into the water will re-enter the game after a short wait.",
					n .. "Be careful of the bridges, they can be tricky."
				},
				1
			)
			player:freeAsync()
			SumoWarNpc.click(player, npc)
		elseif menu == "Register For Sumo War" then
			if os.time() < player.registry["minigameBan"] then
				--Check if player is banned from minigames
				player:popUp("You are currently banned from minigames! Try again later maybe.")
				return
			end

			local confirm = player:menuSeq(
				"It will cost 2,000 gold to play. Do you agree?",
				{"Yes, pay 2,000 gold.", "Nevermind."},
				{}
			)

			if confirm == 1 then
				if player.money < 2000 then
					player:dialogSeq(
						{t, "You don't have enough gold to play."},
						0
					)
					return
				end

				player:removeGold(2000)
				player.registry["sumo_war_team"] = math.random(1, 2)
				player:warp(15031, math.random(2, 14), math.random(2, 12))
				player:sendAnimation(16)
				player:playSound(29)
				player:dialogSeq(
					{
						t,
						n .. "Alright, your character is registered for Sumo War.\nPlease wait until the game starts!"
					},
					1
				)
			end
		elseif menu == "I can't register!" then
			player.registry["sumo_war_team"] = 0
			player:dialogSeq(
				{
					t,
					n .. "Looks like a simple paperwork mixup. You should be all set to register now, have fun at the game!"
				},
				1
			)
			player:freeAsync()
			SumoWarNpc.click(player, npc)
		end
	end),

	core = function()
		SumoWarNpc.closed()
		SumoWarNpc.balancing()
		SumoWarNpc.begin()
		SumoWarNpc.respawn()
		SumoWarNpc.endGame()
		SumoWarNpc.bridgeController()
	end,

	open = function()
		core.gameRegistry["sumo_war"] = 1
		core.gameRegistry["sumo_war_start"] = os.time() + 900
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			-1,
			"                                Sumo War is now open in Kugnae Arena!"
		)
		broadcast(
			-1,
			"                                    Entry is closing in 15 minutes!"
		)
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	roundTwo = function()
		core.gameRegistry["sumo_war"] = 1
		core.gameRegistry["sumo_war_start"] = os.time() + 120
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			-1,
			"                                 Another chance to play! Get ready!"
		)
		broadcast(
			-1,
			"                                Sumo War is now open in Kugnae Arena!"
		)
		broadcast(
			-1,
			"                                    Entry is closing in 2 minutes!"
		)
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	closed = function()
		local diff = core.gameRegistry["sumo_war_start"] - os.time()

		if core.gameRegistry["sumo_war"] == 1 then
			if core.gameRegistry["sumo_war_start"] > os.time() then
				if diff == 300 then
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					broadcast(
						-1,
						"                                 Sumo War entry is closing in 5 minute!"
					)
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
				elseif diff == 600 then
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					broadcast(
						-1,
						"                                 Sumo War entry is closing in 10 minutes!"
					)
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
				elseif diff == 60 then
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					broadcast(
						-1,
						"                                 Sumo War entry is closing in 1 minute!"
					)
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
				elseif diff == 10 then
					broadcast(
						15031,
						"                                    Sumo War Starts in 10 seconds!"
					)
				elseif diff <= 3 then
					broadcast(
						15031,
						"                                    Sumo War Starts in " .. diff .. " seconds!"
					)
				end
			elseif core.gameRegistry["sumo_war_start"] < os.time() then
				core.gameRegistry["sumo_war"] = 0
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					-1,
					"                                 Sumo War entry is closed!"
				)
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				SumoWarNpc.start()
			end
		end
	end,

	endGame = function()
		local pc = core:getObjectsInMap(15030, BL_PC)
		local arenaPC = core:getObjectsInMap(31, BL_PC)

		if core.gameRegistry["sumo_war_end_timer"] > 0 and core.gameRegistry[
			"sumo_war_end_timer"
		] < os.time() then
			core.gameRegistry["sumo_war_end_timer"] = 0
			core.gameRegistry["sumo_war"] = 0
			core.gameRegistry["sumo_war_red_point"] = 0
			core.gameRegistry["sumo_war_blue_point"] = 0
			core.gameRegistry["sumo_war_bridge_point"] = 0
			core.gameRegistry["sumo_war_wait_time"] = 0
			core.gameRegistry["sumo_war_warped_players"] = 0
			core.gameRegistry["sumo_war_playing"] = 0

			if #pc > 0 then
				for i = 1, #pc do
					pc[i].health = pc[i].maxHealth
					pc[i].state = 0
					pc[i].gfxClone = 0
					pc[i]:updateState()

					if pc[i].registry["sumo_war_team"] == core.gameRegistry["sumo_war_winner"] then
						SumoWarNpc.victoryLegend(pc[i])
						minigames.giveMinigameExp(pc[i], 1)
					else
						minigames.giveMinigameExp(pc[i], 2)
					end

					pc[i].registry["sumo_war_team"] = 0

					pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
					pc[i]:sendAnimation(16)
					pc[i]:playSound(29)
					pc[i]:calcStat()
				end
			end

			if #arenaPC > 0 then
				for i = 1, #arenaPC do
					arenaPC[i].gfxClone = 0
					arenaPC[i]:updateState()
				end
			end
			core.gameRegistry["sumo_war_winner"] = 0

			--[[if core.gameRegistry["sumo_war_round_2"] == 0 then
			core.gameRegistry["sumo_war_round_2"] = 1
			SumoWarNpc.roundTwo()
		elseif core.gameRegistry["sumo_war_round_2"] == 1 then
			core.gameRegistry["sumo_war_round_2"] = 0
			return
		end]]
			--
		end
	end,

	stop = function()
		local pc = core:getObjectsInMap(15030, BL_PC)

		core.gameRegistry["sumo_war_end_timer"] = 0

		--core.gameRegistry["sumo_war_players"] = 0
		core.gameRegistry["sumo_war"] = 0
		core.gameRegistry["sumo_war_winner"] = 0
		core.gameRegistry["sumo_war_red_point"] = 0
		core.gameRegistry["sumo_war_blue_point"] = 0
		core.gameRegistry["sumo_war_bridge_point"] = 0
		core.gameRegistry["sumo_war_wait_time"] = 0
		core.gameRegistry["sumo_war_playing"] = 0
		core.gameRegistry["sumo_war_warped_players"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				--pc[i].registry["sumo_war_registered"] = 0
				pc[i].mapRegistry["sumo_war_red_point"] = 0
				pc[i].mapRegistry["sumo_war_blue_point"] = 0
				pc[i].registry["sumo_war_team"] = 0
				pc[i].gfxClone = 0
				pc[i]:updateState()
				pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:calcStat()
			end
		end
	end,

	cancel = function()
		local pc = core:getObjectsInMap(15031, BL_PC)

		core.gameRegistry["sumo_war_winner"] = 0
		core.gameRegistry["sumo_war_end_timer"] = 0

		--core.gameRegistry["sumo_war_players"] = 0
		core.gameRegistry["sumo_war"] = 0
		core.gameRegistry["sumo_war_red_point"] = 0
		core.gameRegistry["sumo_war_blue_point"] = 0
		core.gameRegistry["sumo_war_wait_time"] = 0
		core.gameRegistry["sumo_war_playing"] = 0
		core.gameRegistry["sumo_war_warped_players"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				--pc[i].registry["sumo_war_registered"] = 0
				pc[i].mapRegistry["sumo_war_red_point"] = 0
				pc[i].mapRegistry["sumo_war_blue_point"] = 0
				pc[i].mapRegistry["sumo_war_bridge_point"] = 0
				pc[i].registry["sumo_war_team"] = 0
				pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:calcStat()
			end
		end
	end,

	entryLegend = function(player)
		local reg = player.registry["sumo_war_entries"]

		if player:hasLegend("sumo_war_entries") then
			player:removeLegendbyName("sumo_war_entries")
		end

		if reg > 0 then
			player.registry["sumo_war_entries"] = player.registry[
				"sumo_war_entries"
			] + 1
			player:addLegend(
				"Participated in " .. player.registry["sumo_war_entries"] .. " Sumo Wars",
				"sumo_war_entries",
				204,
				16
			)
		else
			player.registry["sumo_war_entries"] = 1
			player:addLegend(
				"Participated in 1 Sumo War",
				"sumo_war_entries",
				204,
				16
			)
		end
	end,

	victoryLegend = function(player)
		local reg = player.registry["sumo_war_wins"]

		if player:hasLegend("sumo_war_wins") then
			player:removeLegendbyName("sumo_war_wins")
		end

		if reg > 0 then
			player.registry["sumo_war_wins"] = player.registry["sumo_war_wins"] + 1
			player:addLegend(
				"Won " .. player.registry["sumo_war_wins"] .. " Sumo Wars",
				"sumo_war_wins",
				204,
				16
			)
		else
			player.registry["sumo_war_wins"] = 1
			player:addLegend("Won 1 Sumo War", "sumo_war_wins", 204, 16)
		end
	end,

	start = function()
		livingRedSquirt = {}
		livingBlueSquirt = {}

		if #livingRedSquirt ~= 0 then
			rawset(livingRedSquirt, #livingRedSquirt, nil)
		end
		if #livingBlueSquirt ~= 0 then
			rawset(livingBlueSquirt, #livingBlueSquirt, nil)
		end

		SumoWarNpc.balancing()
		local pc = core:getObjectsInMap(15031, BL_PC)

		if core.gameRegistry["sumo_war_warped_players"] == 0 then
			core.gameRegistry["sumo_war_warped_players"] = 1
			if #pc > 6 then
				core.gameRegistry["sumo_war_wait_time"] = (os.time() + 30)

				for i = 1, #pc do
					if pc[i].registry["sumo_war_team"] > 0 and pc[i].state ~= 0 then
						pc[i].state = 0
						pc[i].speed = 90
						pc[i].registry["mounted"] = 0
						pc[i]:updateState()
					end

					if pc[i].registry["sumo_war_team"] == 1 then
						table.insert(livingRedSquirt, pc[i].ID)
						SumoWarNpc.costume(pc[i])
					end

					if pc[i].registry["sumo_war_team"] == 2 then
						table.insert(livingBlueSquirt, pc[i].ID)
						SumoWarNpc.costume(pc[i])
					end

					pc[i]:warp(15030, math.random(11, 35), math.random(28, 40))
				end
				SumoWarNpc.wait()
			else
				broadcast(
					15031,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					15031,
					"                             Not enough players. Sumo War canceled!"
				)
				broadcast(
					15031,
					"-----------------------------------------------------------------------------------------------------"
				)
				SumoWarNpc.cancel()
			end
		end
	end,

	wait = function()
		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			15030,
			"                                    Get Ready! Sumo War starts in 30 seconds!"
		)
		broadcast(
			15030,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	begin = function()
		local pc = core:getObjectsInMap(15030, BL_PC)

		if core.gameRegistry["sumo_war_wait_time"] > 0 and core.gameRegistry[
			"sumo_war_wait_time"
		] < os.time() then
			if #pc > 6 then
				broadcast(
					15030,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					15030,
					"                                   The Sumo War has begun!"
				)
				broadcast(
					15030,
					"-----------------------------------------------------------------------------------------------------"
				)
				for i = 1, #pc do
					if pc[i].registry["sumo_war_team"] == 1 then
						pc[i]:warp(
							15030,
							math.random(52, 54),
							math.random(10, 37)
						)
						SumoWarNpc.entryLegend(pc[i])
					elseif pc[i].registry["sumo_war_team"] == 2 then
						pc[i]:warp(
							15030,
							math.random(95, 97),
							math.random(10, 37)
						)
						SumoWarNpc.entryLegend(pc[i])
					end
				end
			else
				broadcast(
					15031,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					15031,
					"                             Not enough players. Sumo War canceled!"
				)
				broadcast(
					15031,
					"-----------------------------------------------------------------------------------------------------"
				)
				SumoWarNpc.stop()
			end
			core.gameRegistry["sumo_war_playing"] = 1
			core.gameRegistry["sumo_war_wait_time"] = 0
		end
	end,

	balancing = function()
		local red, blue = {}, {}
		local pc = core:getObjectsInMap(15031, BL_PC)

		if #pc > 0 then
			for i = 1, #pc do
				if pc[i].registry["sumo_war_team"] == 1 then
					table.insert(red, pc[i].ID)
				elseif pc[i].registry["sumo_war_team"] == 2 then
					table.insert(blue, pc[i].ID)
				end
			end
		end
		if #pc > 0 then
			for i = 1, #pc do
				if #red > #blue then
					if (#red - #blue) ~= 1 then
						pc[math.random(#pc)].registry["sumo_war_team"] = 2
						break
					end
				end
				if #red < #blue then
					if #blue - #red ~= 1 then
						pc[math.random(#pc)].registry["sumo_war_team"] = 1
						break
					end
				end
			end
		end
	end,

	costume = function(player)
		local team = player.registry["sumo_war_team"]
		local dye, str = 0, ""

		if team == 1 then
			dye = 31
		elseif team == 2 then
			dye = 17
		end

		if player.sex == 0 then
			armor = 5
		elseif player.sex == 1 then
			armor = 9
		end

		clone.wipe(player)
		clone.equip(player, player)

		player.gfxWeap = 65535
		player.gfxArmor = armor
		player.gfxArmorC = dye
		player.gfxDye = dye
		player.gfxCrown = 65535
		player.gfxShield = 65535
		player.gfxNeck = 65535
		player.gfxHelm = 65535
		player.gfxMantle = 65535
		player.gfxMantleC = 0

		player.gfxClone = 1
		player:updateState()
	end,

	winnerCheck = function()
		local pointsToWin = 30

		--[[if core.gameRegistry["sumo_war_players"] <= 6 then
		pointsToWin = 5
	elseif core.gameRegistry["sumo_war_players"] >= 7 and core.gameRegistry["sumo_war_players"] <= 16 then
		pointsToWin = 10
	elseif core.gameRegistry["sumo_war_players"] >= 17 then
		pointsToWin = 15
	end]]
		--

		if core.gameRegistry["sumo_war_red_point"] == pointsToWin then
			core.gameRegistry["sumo_war_winner"] = 1
			SumoWarNpc.redWin()
			return
		elseif core.gameRegistry["sumo_war_blue_point"] == pointsToWin then
			core.gameRegistry["sumo_war_winner"] = 2
			SumoWarNpc.blueWin()
			return
		end
	end,

	push = function(player)
		local team = player.registry["sumo_war_team"]
		local tile = {
			628,
			35012,
			35013,
			17816,
			35011,
			35010,
			35009,
			35017,
			35015,
			35014,
			35025,
			35016
		}
		local target = getTargetFacing(player, BL_PC)
		local m, x, y = player.m, player.x, player.y

		if m == 15031 then
			if target ~= nil and target.state ~= 1 then
				target.attacker = player.ID
				player:sendFrontAnimation(191)
				if player.side == 0 then
					y = target.y - 1
				elseif player.side == 1 then
					x = target.x + 1
				elseif player.side == 2 then
					y = target.y + 1
				elseif player.side == 3 then
					x = target.x - 1
				end

				if getPass(m, x, y) == 1 then
					return
				else
					target:sendAnimationXY(191, target.x, target.y)
					target:warp(target.m, x, y)
				end
			end
		end

		if m == 15030 then
			if target ~= nil and target.state ~= 1 and (target.registry["sumo_war_team"] ~= player.registry["sumo_war_team"]) and core.gameRegistry[
				"sumo_war_winner"
			] == 0 then
				target.attacker = player.ID
				player:sendFrontAnimation(191)
				if player.side == 0 then
					y = target.y - 1
				elseif player.side == 1 then
					x = target.x + 1
				elseif player.side == 2 then
					y = target.y + 1
				elseif player.side == 3 then
					x = target.x - 1
				end

				if player.x < 40 then
					if getPass(m, x, y) == 1 then
						return
					else
						target:sendAnimationXY(191, target.x, target.y)
						target:warp(target.m, x, y)
					end
				else
					target:sendAnimationXY(191, target.x, target.y)
					target:warp(target.m, x, y)
					for i = 1, #tile do
						if getTile(target.m, target.x, target.y) == tile[i] then
							if player.registry["sumo_war_team"] == 1 then
								core.gameRegistry["sumo_war_red_point"] = core.gameRegistry[
									"sumo_war_red_point"
								] + 1
							elseif player.registry["sumo_war_team"] == 2 then
								core.gameRegistry["sumo_war_blue_point"] = core.gameRegistry[
									"sumo_war_blue_point"
								] + 1
							end
							target:sendAnimationXY(142, target.x, target.y)
							SumoWarNpc.splash(target)
						end
					end
				end
			end
		end
	end,

	splash = function(player)
		player.health = 0
		player.state = 1
		player:updateState()
		player:playSound(73)
		player:sendAnimationXY(142, player.x, player.y)
		player:warp(15030, math.random(11, 35), math.random(28, 40))
		broadcast(
			15030,
			"CURRENT SCORE  |  RED: " .. core.gameRegistry["sumo_war_red_point"] .. "   BLUE: " .. core.gameRegistry[
				"sumo_war_blue_point"
			] .. "   BRIDGE: " .. core.gameRegistry["sumo_war_bridge_point"]
		)
		SumoWarNpc.winnerCheck()
	end,

	respawn = function()
		local pc = core:getObjectsInMap(15030, BL_PC)

		core.gameRegistry["sumo_respawn_time"] = core.gameRegistry[
			"sumo_respawn_time"
		] + 1

		if core.gameRegistry["sumo_respawn_time"] == 15 then
			for i = 1, #pc do
				if pc[i].state == 1 then
					if pc[i].x >= 9 and pc[i].x <= 38 then
						if pc[i].y >= 26 and pc[i].y <= 42 then
							pc[i].health = pc[i].maxHealth
							pc[i].state = 0
							if pc[i].registry["sumo_war_team"] == 1 then
								pc[i]:warp(
									15030,
									math.random(52, 54),
									math.random(10, 37)
								)
							end
							if pc[i].registry["sumo_war_team"] == 2 then
								pc[i]:warp(
									15030,
									math.random(95, 97),
									math.random(10, 37)
								)
							end
						end
					end
				end
			end
			core.gameRegistry["sumo_respawn_time"] = 0
		end
	end,

	bridge = function(id)
		local x
		local y
		local map = 15030

		if id == 1 or id == 2 or id == 9 or id == 10 or id == 15 then
			if id == 1 then
				x = 65
				y = 25
			end
			if id == 2 then
				x = 65
				y = 30
			end
			if id == 9 then
				x = 84
				y = 25
			end
			if id == 10 then
				x = 84
				y = 30
			end
			if id == 15 then
				x = 58
				y = 13
			end
			if id == 16 then
				x = 91
				y = 33
			end
			if id == 17 then
				x = 91
				y = 13
			end
			if id == 18 then
				x = 58
				y = 33
			end

			tile = getTile(map, x, y)
			if tile == 628 then
				setTile(map, x, y, 218)
				setTile(map, x, y + 1, 221)
				setPass(map, x, y, 0)
				setPass(map, x, y + 1, 0)
				return
			else
				setTile(map, x, y, 628)
				setTile(map, x, y + 1, 628)
				setPass(map, x, y, 1)
				setPass(map, x, y + 1, 1)

				local splashPC1 = core:getObjectsInCell(map, x, y, BL_PC)
				local splashPC2 = core:getObjectsInCell(map, x, y + 1, BL_PC)

				if #splashPC1 > 0 then
					for i = 1, #splashPC1 do
						SumoWarNpc.splash(splashPC1[i])
						core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
							"sumo_war_bridge_point"
						] + 1
					end
				end
				if #splashPC2 > 0 then
					for i = 1, #splashPC2 do
						SumoWarNpc.splash(splashPC2[i])
						core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
							"sumo_war_bridge_point"
						] + 1
					end
				end
			end
			return
		elseif id == 3 then
			x = 71
			y = 23
		elseif id == 4 then
			x = 72
			y = 28
		elseif id == 5 then
			x = 71
			y = 33
		elseif id == 6 then
			x = 76
			y = 23
		elseif id == 7 then
			x = 77
			y = 28
		elseif id == 8 then
			x = 76
			y = 33
		elseif id == 11 then
			x = 84
			y = 36
		elseif id == 12 then
			x = 84
			y = 10
		elseif id == 13 then
			x = 64
			y = 10
		elseif id == 14 then
			x = 64
			y = 36
		end

		local tile = getTile(map, x, y)
		if tile == 628 then
			setTile(map, x, y, 218)
			setTile(map, x + 1, y, 218)
			setTile(map, x, y + 1, 221)
			setTile(map, x + 1, y + 1, 221)
			setPass(map, x, y, 0)
			setPass(map, x + 1, y, 0)
			setPass(map, x, y + 1, 0)
			setPass(map, x + 1, y + 1, 0)
			return
		else
			setTile(map, x, y, 628)
			setTile(map, x + 1, y, 628)
			setTile(map, x, y + 1, 628)
			setTile(map, x + 1, y + 1, 628)
			setPass(map, x, y, 1)
			setPass(map, x + 1, y, 1)
			setPass(map, x, y + 1, 1)
			setPass(map, x + 1, y + 1, 1)

			local splashPC3 = core:getObjectsInCell(map, x, y, BL_PC)
			local splashPC4 = core:getObjectsInCell(map, x + 1, y, BL_PC)
			local splashPC5 = core:getObjectsInCell(map, x, y + 1, BL_PC)
			local splashPC6 = core:getObjectsInCell(map, x + 1, y + 1, BL_PC)

			if #splashPC3 > 0 then
				for i = 1, #splashPC3 do
					SumoWarNpc.splash(splashPC3[i])
					core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
						"sumo_war_bridge_point"
					] + 1
				end
			end

			if #splashPC4 > 0 then
				for i = 1, #splashPC4 do
					SumoWarNpc.splash(splashPC4[i])
					core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
						"sumo_war_bridge_point"
					] + 1
				end
			end

			if #splashPC5 > 0 then
				for i = 1, #splashPC5 do
					SumoWarNpc.splash(splashPC5[i])
					core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
						"sumo_war_bridge_point"
					] + 1
				end
			end

			if #splashPC6 > 0 then
				for i = 1, #splashPC6 do
					SumoWarNpc.splash(splashPC6[i])
					core.gameRegistry["sumo_war_bridge_point"] = core.gameRegistry[
						"sumo_war_bridge_point"
					] + 1
				end
			end
		end
	end,

	bridgeController = function()
		if core.gameRegistry["sumo_war"] == 1 then
			SumoWarNpc.bridge(math.random(1, 18))
		end
	end
}
