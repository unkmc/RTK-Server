--BeachWarNpc.open() - opens minigame
--BeachWarNpc.cancel() - cancels opened minigame before start
--BeachWarNpc.stop() - stops game in progress, returns all players to arena with clean registry

BeachWarNpc = {
	playerCore = function(player)
		BeachWarNpc.guiText(player)
		BeachWarNpc.refill(player)
	end,

	core = function()
		BeachWarNpc.closed()
		BeachWarNpc.enterArena()
		BeachWarNpc.begin()
		BeachWarNpc.endGame()
	end,

	open = function()
		local style = ""

		core.gameRegistry["beach_war_open"] = 1

		--Registry for game open

		if core.gameRegistry["beach_war_hits_to_kill"] == 1 then
			--
			core.gameRegistry["beach_war_hits_to_kill"] = 2
			style = "Classic"
		else
			core.gameRegistry["beach_war_hits_to_kill"] = 1
			style = "Headshot"
		end

		if core.gameRegistry["beach_war_hits_to_kill"] == 0 then
			core.gameRegistry["beach_war_hits_to_kill"] = 2
			style = "Classic"
		end

		core.gameRegistry["beach_war_start_time"] = os.time() + 900

		--15 minute timer
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			-1,
			"                                " .. style .. " Beach War is now open in Kugnae Arena!"
		)
		broadcast(
			-1,
			"                                Registration will close in 15 minutes!"
		)
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	click = async(function(player, npc)
		----------Variable Declarations-----------------------------------

		local pc = player:getObjectsInMap(15021, BL_PC)

		--waiting room map
		local n = "<b>[Beach War]\n\n"
		local t = {g = convertGraphic(npc.look, "monster"), c = npc.lookColor}
		player.npcGraphic = t.g
		player.npcColor = t.c
		player.dialogType = 0

		local str = ""
		local time = BeachWarNpc.getStartTimer()
		local goldCost = 1000
		local opts = {}
		local diff

		---------------Table Inserts-----------------------------
		table.insert(opts, "How To Play?")

		if core.gameRegistry["beach_war_open"] == 1 then
			if player.registry["beach_war_team"] == 0 and core.gameRegistry[
				"beach_war_open"
			] == 1 then
				table.insert(opts, "Register For Beach War")
			end
			if player.registry["beach_war_team"] > 0 then
				table.insert(opts, "I can't register!")
			end
		end
		table.insert(opts, "Exit")

		if core.gameRegistry["beach_war_start_time"] > os.time() then
			--if the game is open, get timer string
			str = "Waiting time: " .. BeachWarNpc.getStartTimer()
		end

		----------------------------------------------------------

		local menu = player:menuString(
			n .. "Hello, the game will start in few minutes.\n" .. str .. "\nIn the waiting room: " .. #pc,
			opts
		)

		--Display the menu

		-----------------Menu Options-------------------------
		if menu == "How To Play?" then
			player:dialogSeq(
				{
					t,
					n .. "Beach War is a game where you use your water gun to soak members of the opposing team.",
					n .. "A player can get soaked once and stay in the game, but a second shot will send you to the sidelines for a short time.",
					n .. "Your gun can only hold 10 shots worth of water, but it will be slowly refilled if you stand by the pool at the center of the map.",
					n .. "The game ends when one team reaches a target score, based on the number of players."
				},
				1
			)
			player:freeAsync()
			BeachWarNpc.click(player, npc)
		elseif menu == "Register For Beach War" then
			if os.time() < player.registry["minigameBan"] then
				--Check if player is banned from minigames
				player:popUp("You are currently banned from minigames! Try again later maybe.")
				return
			end

			local confirm = player:menuSeq(
				"It will cost 5,000 gold to play. Do you agree?",
				{"Yes, pay 5,000 gold.", "Nevermind."},
				{}
			)

			if confirm == 1 then
				if player.money < 5000 then
					player:dialogSeq(
						{t, "You don't have enough gold to play."},
						0
					)
					return
				end
				player:removeGold(5000)
				player.registry["beach_war_team"] = math.random(1, 2)
				player:warp(15021, math.random(2, 14), math.random(2, 12))
				player:sendAnimation(16)
				player:playSound(29)
				player:dialogSeq(
					{
						t,
						n .. "Alright, your character is registered for Beach War.\nPlease wait until the game starts!"
					},
					1
				)
			end
		elseif menu == "I can't register!" then
			player.registry["beach_war_times_hit"] = 0
			player.registry["beach_war_gun_pct"] = 0
			player.registry["beach_war_flag"] = 0
			player.registry["beach_war_team"] = 0
			player.registry["beach_war_kills"] = 0
			player:dialogSeq(
				{
					t,
					n .. "Looks like a simple paperwork mixup. You should be all set to register now, have fun at the game!"
				},
				1
			)
			player:freeAsync()
			BeachWarNpc.click(player, npc)
		end
	end),

	guiText = function(player)
		local diff = core.gameRegistry["beach_war_start_time"] - os.time()
		local diffwait = core.gameRegistry["beach_war_wait_time"] - os.time()

		if core.gameRegistry["beach_war_started"] == 0 and player.m == 15021 then
			if diff > 0 then
				player:guitext("\nBeach War registration will close in: " .. getTimerValues("beach_war_start_time") .. "    ")
			elseif diffwait > 0 then
				player:guitext("\nBeach War will begin in: " .. getTimerValues("beach_war_wait_time") .. "    ")
			else
				player:guitext("")
			end
		elseif core.gameRegistry["beach_war_started"] == 1 and player.m == 15020 then
			if diffwait > 0 then
				player:guitext("\nBeach War will begin in: " .. getTimerValues("beach_war_wait_time") .. "    ")
			else
				player:guitext("\nRED: " .. core.gameRegistry["beach_war_red_point"] .. " | BLUE: " .. core.gameRegistry[
					"beach_war_blue_point"
				] .. "  \nYour kills: " .. player.registry["beach_war_kills"])
			end
		end

		if player.gmLevel > 0 and player.m == 15020 then
			player:guitext("\nRED: " .. core.gameRegistry["beach_war_red_point"] .. " | BLUE: " .. core.gameRegistry[
				"beach_war_blue_point"
			] .. "  \nYour kills: " .. player.registry["beach_war_kills"])
		end
	end,

	getStartTimer = function()
		local hour, minute, second = 0, 0, 0

		if core.gameRegistry["beach_war_start_time"] < os.time() then
			return "00:00:00"
		else
			dif = core.gameRegistry["beach_war_start_time"] - os.time()
			hour = string.format("%02.f", math.floor(dif / 3600))
			minute = string.format("%02.f", math.floor(dif / 60 - (hour * 60)))
			second = string.format(
				"%02.f",
				math.floor(dif - hour * 3600 - minute * 60)
			)
			return hour .. ":" .. minute .. ":" .. second
		end
	end,

	closed = function()
		local diff = core.gameRegistry["beach_war_start_time"] - os.time()

		if core.gameRegistry["beach_war_open"] == 1 then
			if core.gameRegistry["beach_war_start_time"] > os.time() then
				if diff == 300 then
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					broadcast(
						-1,
						"                                 Beach War entry is closing in 5 minute!"
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
						"                                 Beach War entry is closing in 10 minutes!"
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
						"                                 Beach War entry is closing in 1 minute!"
					)
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
				elseif diff == 10 then
					broadcast(
						15021,
						"                                    Beach War Starts in 10 seconds!"
					)
				elseif diff <= 3 then
					broadcast(
						15021,
						"                                    Beach War Starts in " .. diff .. " seconds!"
					)
				end
			elseif core.gameRegistry["beach_war_start_time"] < os.time() then
				core.gameRegistry["beach_war_open"] = 0
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					-1,
					"                                 Beach War entry is closed!"
				)
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				BeachWarNpc.start()
			end
		end
	end,

	getRandomMap = function()
		local allBeachWarMaps = {15020}
		local randomMap = allBeachWarMaps[math.random(1, #allBeachWarMaps)]

		core.gameRegistry["beach_war_current_map"] = randomMap
	end,

	setMapBlockers = function(mapID)
		local blocker = 12447
		local noPass = 1

		if mapID == 15020 then
			setObject(mapID, 11, 9, blocker)
			setObject(mapID, 11, 10, blocker)
			setObject(mapID, 4, 16, blocker)
			setObject(mapID, 5, 16, blocker)
			setObject(mapID, 34, 33, blocker)
			setObject(mapID, 35, 33, blocker)
			setObject(mapID, 28, 39, blocker)
			setObject(mapID, 28, 40, blocker)

			setPass(mapID, 11, 9, noPass)
			setPass(mapID, 11, 10, noPass)
			setPass(mapID, 4, 16, noPass)
			setPass(mapID, 5, 16, noPass)
			setPass(mapID, 34, 33, noPass)
			setPass(mapID, 35, 33, noPass)
			setPass(mapID, 28, 39, noPass)
			setPass(mapID, 28, 40, noPass)
		end
	end,

	removeMapBlockers = function(mapID)
		local noBlocker = 0
		local pass = 0

		if mapID == 15020 then
			setObject(mapID, 11, 9, noBlocker)
			setObject(mapID, 11, 10, noBlocker)
			setObject(mapID, 4, 16, noBlocker)
			setObject(mapID, 5, 16, noBlocker)
			setObject(mapID, 34, 33, noBlocker)
			setObject(mapID, 35, 33, noBlocker)
			setObject(mapID, 28, 39, noBlocker)
			setObject(mapID, 28, 40, noBlocker)

			setPass(mapID, 11, 9, pass)
			setPass(mapID, 11, 10, pass)
			setPass(mapID, 4, 16, pass)
			setPass(mapID, 5, 16, pass)
			setPass(mapID, 34, 33, pass)
			setPass(mapID, 35, 33, pass)
			setPass(mapID, 28, 39, pass)
			setPass(mapID, 28, 40, pass)
		end
	end,

	start = function()
		BeachWarNpc.assignTeams()
		BeachWarNpc.getRandomMap()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(15021, BL_PC)

		if core.gameRegistry["beach_war_warped_players"] == 0 then
			core.gameRegistry["beach_war_warped_players"] = 1
			if #pc > 6 then
				for i = 1, #pc do
					if pc[i].registry["beach_war_team"] > 0 and pc[i].state ~= 0 then
						pc[i].state = 0
						pc[i].speed = 80
						pc[i].registry["mounted"] = 0
						pc[i]:updateState()
					end

					BeachWarNpc.costume(pc[i])
					BeachWarNpc.entryLegend(pc[i])

					if pc[i].registry["beach_war_team"] == 1 then
						--red team
						pc[i]:warp(map, 3, 2)
					end

					if pc[i].registry["beach_war_team"] == 2 then
						--blue team
						pc[i]:warp(map, 36, 47)
					end
				end

				BeachWarNpc.wait()
			else
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					-1,
					"                             Not enough players. Beach War canceled!"
				)
				broadcast(
					-1,
					"-----------------------------------------------------------------------------------------------------"
				)
				BeachWarNpc.cancel()
			end
		end
	end,

	costume = function(player)
		local team = player.registry["beach_war_team"]
		local dye, str = 0, ""
		local gunColor = 0
		local armor = 0

		player:flushDuration()
		if team == 1 then
			dye = 31
			gunColor = 30
		elseif team == 2 then
			dye = 17
			gunColor = 16
		end

		if player.sex == 0 then
			armor = 57
		elseif player.sex == 1 then
			armor = 58
		end

		clone.wipe(player)
		clone.equip(player, player)

		player.gfxArmor = armor
		player.gfxArmorC = dye
		player.gfxDye = dye

		player.gfxCrown = 65535
		player.gfxShield = 65535

		player.gfxWeap = 20109
		player.gfxWeapC = gunColor

		player.gfxNeck = 65535
		player.gfxFaceA = 65535
		player.gfxHelm = 65535
		player.gfxNeck = 65535
		player.gfxMantle = 65535
		player.gfxMantleC = 0

		player.gfxClone = 1
		player.attackSpeed = 50
		player:updateState()
	end,

	assignTeams = function()
		local red, blue = 0, 0
		local pc = core:getObjectsInMap(15021, BL_PC)
		local randomTeam

		if #pc > 0 then
			for i = 1, #pc do
				if pc[i].registry["beach_war_team"] == 0 then
					if red == blue then
						randomTeam = math.random(1, 2)
						pc[i].registry["beach_war_team"] = randomTeam
						if randomTeam == 1 then
							red = red + 1
						elseif randomTeam == 2 then
							blue = blue + 1
						end
					elseif blue > red then
						pc[i].registry["beach_war_team"] = 1
						red = red + 1
					elseif red > blue then
						pc[i].registry["beach_war_team"] = 2
						blue = blue + 1
					end
				end
			end
		end

		if #pc > 0 then
			for i = 1, #pc do
				if red > blue then
					if (red - blue) ~= 1 then
						pc[math.random(#pc)].registry["beach_war_team"] = 2
						break
					end
				end
				if red < blue then
					if blue - red ~= 1 then
						pc[math.random(#pc)].registry["beach_war_team"] = 1
						break
					end
				end
			end
		end
	end,

	wait = function()
		local map = core.gameRegistry["beach_war_current_map"]

		local pc = core:getObjectsInMap(map, BL_PC)
		core.gameRegistry["beach_war_wait_time"] = os.time() + 60
		BeachWarNpc.setMapBlockers(map)

		broadcast(
			map,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			map,
			"                                    Get Ready! The round starts in 60 seconds!"
		)
		broadcast(
			map,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	enterArena = function()
		local diff = core.gameRegistry["beach_war_wait_time"] - os.time()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)

		if diff == 30 then
			for i = 1, #pc do
				pc[i].registry["beach_war_gun_pct"] = 100
				pc[i].registry["beach_war_kills"] = 0

				if pc[i].registry["beach_war_team"] == 1 then
					pc[i]:warp(map, 3, 8)
				elseif pc[i].registry["beach_war_team"] == 2 then
					pc[i]:warp(map, 36, 41)
				end
			end
			broadcast(
				map,
				"                                    Beach War starts in 30 seconds!"
			)
		end
	end,

	begin = function()
		local diff = core.gameRegistry["beach_war_wait_time"] - os.time()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)

		if diff == 0 then
			core.gameRegistry["beach_war_started"] = 1
			BeachWarNpc.removeMapBlockers(map)

			broadcast(
				map,
				"-----------------------------------------------------------------------------------------------------"
			)
			broadcast(
				map,
				"                                   The Beach War has begun!"
			)
			broadcast(
				map,
				"-----------------------------------------------------------------------------------------------------"
			)
		end
	end,

	stop = function()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)

		core.gameRegistry["beach_war_end_timer"] = 0
		core.gameRegistry["beach_war_open"] = 0
		core.gameRegistry["beach_war_winner"] = 0
		core.gameRegistry["beach_war_started"] = 0
		core.gameRegistry["beach_war_red_point"] = 0
		core.gameRegistry["beach_war_blue_point"] = 0
		core.gameRegistry["beach_war_current_map"] = 0
		core.gameRegistry["beach_war_red_wins"] = 0
		core.gameRegistry["beach_war_blue_wins"] = 0
		core.gameRegistry["beach_war_warped_players"] = 0
		core.gameRegistry["beach_war_round"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				pc[i].registry["beach_war_times_hit"] = 0
				pc[i].registry["beach_war_gun_pct"] = 0
				pc[i].registry["beach_war_flag"] = 0
				pc[i].registry["beach_war_team"] = 0
				pc[i].registry["beach_war_kills"] = 0

				pc[i].gfxClone = 0
				pc[i].attackSpeed = 80
				pc[i]:updateState()
				pc[i]:calcStat()
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
			end
		end
	end,

	cancel = function()
		local map = 15021
		local pc = core:getObjectsInMap(map, BL_PC)

		core.gameRegistry["beach_war_end_timer"] = 0
		core.gameRegistry["beach_war_open"] = 0
		core.gameRegistry["beach_war_winner"] = 0
		core.gameRegistry["beach_war_started"] = 0
		core.gameRegistry["beach_war_red_point"] = 0
		core.gameRegistry["beach_war_blue_point"] = 0
		core.gameRegistry["beach_war_current_map"] = 0
		core.gameRegistry["beach_war_red_wins"] = 0
		core.gameRegistry["beach_war_blue_wins"] = 0
		core.gameRegistry["beach_war_warped_players"] = 0
		core.gameRegistry["beach_war_round"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				pc[i].registry["beach_war_times_hit"] = 0
				pc[i].registry["beach_war_gun_pct"] = 0
				pc[i].registry["beach_war_flag"] = 0
				pc[i].registry["beach_war_team"] = 0
				pc[i].registry["beach_war_kills"] = 0
				pc[i].gfxClone = 0
				pc[i].attackSpeed = 80
				pc[i]:updateState()
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:calcStat()
				pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
			end
		end
	end,

	shoot = function(player)
		local team = player.registry["beach_war_team"]

		local map = core.gameRegistry["beach_war_current_map"]
		local m, x, y, side = player.m, player.x, player.y, player.side
		local icon = 1615
		local pc

		if team > 0 then
			if player.m == map and player.gfxClone == 1 then
				if player.registry["beach_war_gun_pct"] >= 10 then
					player.registry["beach_war_gun_pct"] = player.registry[
						"beach_war_gun_pct"
					] - 10
					player:playSound(709)
					player:sendMinitext("Your water tank is at " .. player.registry["beach_war_gun_pct"] .. "%")
					for i = 1, 8 do
						pc = getTargetFacing(player, BL_PC, 0, i)

						if side == 0 then
							if getPass(m, x, y - i) == 1 then
								return
							end
						elseif side == 1 then
							if getPass(m, x + i, y) == 1 then
								return
							end
						elseif side == 2 then
							if getPass(m, x, y + i) == 1 then
								return
							end
						elseif side == 3 then
							if getPass(m, x - i, y) == 1 then
								return
							end
						end
						if pc ~= nil and pc.registry["beach_war_team"] > 0 then
							if team ~= pc.registry["beach_war_team"] then
								BeachWarNpc.hit(player, pc)
							end
							return
						end
						if side == 0 then
							player:throw(x, y - i, icon, 2, 1)
						elseif side == 1 then
							player:throw(x + i, y, icon, 2, 1)
						elseif side == 2 then
							player:throw(x, y + i, icon, 2, 1)
						elseif side == 3 then
							player:throw(x - i, y, icon, 2, 1)
						end
					end
				else
					player:sendMinitext("Your gun is out of water!")
				end
			end
		end
	end,

	hit = function(player, target)
		local map = core.gameRegistry["beach_war_current_map"]
		local team = target.registry["beach_war_team"]
		local x, y

		player:playSound(739)
		player:playSound(737)
		target:sendAnimationXY(142, target.x, target.y)

		if core.gameRegistry["beach_war_hits_to_kill"] == 1 then
			if team == 1 then
				x = 3
				y = 2
				teamName = "blue"
			elseif team == 2 then
				x = 36
				y = 47
				teamName = "red"
			end

			player.registry["total_beach_war_hits"] = player.registry[
				"total_beach_war_hits"
			] + 1

			--permanent registry for stat tracking
			player.registry["total_beach_war_kills"] = player.registry[
				"total_beach_war_kills"
			] + 1

			--permanent registry for stat tracking
			target.registry["total_beach_war_deaths"] = target.registry[
				"total_beach_war_deaths"
			] + 1

			--permanent registry for stat tracking
			target.registry["total_beach_war_times_hit"] = 1

			--permanent registry for stat tracking

			core.gameRegistry["beach_war_" .. teamName .. "_point"] = core.gameRegistry[
				"beach_war_" .. teamName .. "_point"
			] + 1

			--increase current game score
			player.registry["beach_war_kills"] = player.registry[
				"beach_war_kills"
			] + 1

			target:setDuration("beach_war_respawn", 15000)
			target:warp(map, x, y)

			broadcast(
				map,
				"" .. target.name .. " was SOAKED by " .. player.name .. "!"
			)

			BeachWarNpc.winnerCheck()
		elseif core.gameRegistry["beach_war_hits_to_kill"] == 2 then
			if target.registry["beach_war_times_hit"] == 0 then
				player.registry["total_beach_war_hits"] = player.registry[
					"total_beach_war_hits"
				] + 1

				--permanent registry for stat tracking
				target.registry["total_beach_war_times_hit"] = target.registry[
					"total_beach_war_times_hit"
				] + 1

				--permanent registry for stat tracking

				target:sendMinitext("You got shot by " .. player.name .. "! Don't get hit again!")
				target.registry["beach_war_times_hit"] = target.registry[
					"beach_war_times_hit"
				] + 1

				broadcast(
					map,
					"" .. target.name .. " has been shot by " .. player.name .. "!"
				)
			elseif target.registry["beach_war_times_hit"] == 1 then
				if team == 1 then
					x = 3
					y = 2
					teamName = "blue"
				elseif team == 2 then
					x = 36
					y = 47
					teamName = "red"
				end
				player.registry["total_beach_war_hits"] = player.registry[
					"total_beach_war_hits"
				] + 1

				--permanent registry for stat tracking
				player.registry["total_beach_war_kills"] = player.registry[
					"total_beach_war_kills"
				] + 1

				--permanent registry for stat tracking
				target.registry["total_beach_war_deaths"] = target.registry[
					"total_beach_war_deaths"
				] + 1

				--permanent registry for stat tracking
				target.registry["total_beach_war_times_hit"] = 1

				--permanent registry for stat tracking

				core.gameRegistry["beach_war_" .. teamName .. "_point"] = core.gameRegistry[
					"beach_war_" .. teamName .. "_point"
				] + 1
				player.registry["beach_war_kills"] = player.registry[
					"beach_war_kills"
				] + 1

				target:setDuration("beach_war_respawn", 10000)
				target:warp(map, x, y)

				broadcast(
					map,
					"" .. target.name .. " has been SOAKED by " .. player.name .. "!"
				)
				BeachWarNpc.winnerCheck()

				target.registry["beach_war_times_hit"] = 0
			end
		end
	end,

	refill = function(player)
		local m, x, y = player.m, player.x, player.y
		local refillTile = {
			28910,
			28892,
			28893,
			28894,
			28911,
			28905,
			28903,
			28904,
			28909,
			28897,
			28896,
			28895,
			28908,
			28900,
			28899,
			28898
		}

		if m == 15020 then
			for i = 1, #refillTile do
				if getTile(m, x, y) == refillTile[i] then
					if player.registry["beach_war_gun_pct"] < 100 and player.registry[
						"beach_war_team"
					] > 0 and player.gfxClone == 1 then
						player.registry["beach_war_gun_pct"] = player.registry[
							"beach_war_gun_pct"
						] + 5
						player:sendMinitext("Refilling: Your water tank is at " .. player.registry["beach_war_gun_pct"] .. "%")
					else
						player:sendMinitext("Your gun's water tank is full!")
					end
				end
			end
		end
	end,

	winnerCheck = function()
		local pointsToWin = 50

		--[[if core.gameRegistry["beach_war_players"] < 4 then
		pointsToWin = 3
	elseif core.gameRegistry["beach_war_players"] >= 4 and core.gameRegistry["beach_war_players"] <= 9 then
		pointsToWin = 10
	elseif core.gameRegistry["beach_war_players"] >= 10 and core.gameRegistry["beach_war_players"] <= 15 then
		pointsToWin = 20
	elseif core.gameRegistry["beach_war_players"] >= 16 then
		pointsToWin = 25
	end]]
		--

		if core.gameRegistry["beach_war_red_point"] == pointsToWin then
			core.gameRegistry["beach_war_red_wins"] = core.gameRegistry[
				"beach_war_red_wins"
			] + 1
			core.gameRegistry["beach_war_round"] = core.gameRegistry[
				"beach_war_round"
			] + 1
			BeachWarNpc.roundWin("red")
			return
		elseif core.gameRegistry["beach_war_blue_point"] == pointsToWin then
			core.gameRegistry["beach_war_blue_wins"] = core.gameRegistry[
				"beach_war_blue_wins"
			] + 1
			BeachWarNpc.roundWin("blue")
			core.gameRegistry["beach_war_round"] = core.gameRegistry[
				"beach_war_round"
			] + 1
			return
		end
	end,

	roundWin = function(teamID)
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)
		local teamName = ""

		if teamID == "red" then
			teamName = "Red"
		elseif teamID == "blue" then
			teamName = "Blue"
		end

		for i = 1, #pc do
			if pc[i].registry["beach_war_team"] == 1 then
				--red team
				pc[i]:warp(map, 3, 2)
			end
			if pc[i].registry["beach_war_team"] == 2 then
				--blue team
				pc[i]:warp(map, 36, 47)
			end
		end

		if core.gameRegistry["beach_war_round"] < 3 then
			broadcast(
				map,
				"-----------------------------------------------------------------------------------------------------"
			)
			broadcast(
				map,
				"Round over! " .. teamName .. " Team has " .. core.gameRegistry[
					"beach_war_" .. teamID .. "_wins"
				] .. " of 3 wins!"
			)

			if core.gameRegistry["beach_war_blue_wins"] == 2 or core.gameRegistry[
				"beach_war_red_wins"
			] == 2 then
				BeachWarNpc.declareWinner(teamID)
				return
			end

			BeachWarNpc.nextRound()
		elseif core.gameRegistry["beach_war_round"] >= 3 then
			BeachWarNpc.declareWinner(teamID)
		end
	end,

	nextRound = function()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)

		for i = 1, #pc do
			--if pc[i]:hasDuration("beach_war_respawn") then pc[i]:setDuration("beach_war_respawn",0) end
			pc[i]:flushDurationNoUncast(10, 99)

			--flush any respawn duration
			pc[i].registry["beach_war_times_hit"] = 0

			--eliminate hit count between rounds
		end

		core.gameRegistry["beach_war_red_point"] = 0
		core.gameRegistry["beach_war_blue_point"] = 0
		BeachWarNpc.wait()
	end,

	declareWinner = function(teamID)
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)
		local teamName = ""
		local teamNum = 0

		if teamID == "red" then
			teamName = "Red"
			teamNum = 1
		elseif teamID == "blue" then
			teamName = "Blue"
			teamNum = 2
		end

		for i = 1, #pc do
			--if pc[i]:hasDuration("beach_war_respawn") then pc[i]:setDuration("beach_war_respawn",0) end
			pc[i]:flushDurationNoUncast(10, 99)

			--flush any respawn duration
		end
		core.gameRegistry["beach_war_winner"] = teamNum
		broadcast(
			map,
			"         Game Over! " .. teamName .. " Team is the winner!"
		)
		broadcast(map, "         You will exit the arena in 10 seconds!")

		core.gameRegistry["beach_war_end_timer"] = os.time() + 10
	end,

	endGame = function()
		local map = core.gameRegistry["beach_war_current_map"]
		local pc = core:getObjectsInMap(map, BL_PC)
		local arenaPC = core:getObjectsInMap(31, BL_PC)
		local x, y = 8, 10

		if core.gameRegistry["beach_war_end_timer"] > 0 and core.gameRegistry[
			"beach_war_end_timer"
		] < os.time() then
			if #pc > 0 then
				for i = 1, #pc do
					if pc[i].registry["beach_war_team"] == core.gameRegistry["beach_war_winner"] then
						BeachWarNpc.victoryLegend(pc[i])
						minigames.giveMinigameExp(pc[i], 1)
					else
						minigames.giveMinigameExp(pc[i], 2)
					end

					pc[i].registry["beach_war_times_hit"] = 0
					pc[i].registry["beach_war_gun_pct"] = 0
					pc[i].registry["beach_war_flag"] = 0
					pc[i].registry["beach_war_team"] = 0
					pc[i].registry["beach_war_kills"] = 0

					pc[i].gfxClone = 0
					pc[i].attackSpeed = 80
					pc[i]:updateState()
					pc[i]:calcStat()

					pc[i]:warp(31, math.random(6, 15), math.random(8, 15))
				end
			end
			core.gameRegistry["beach_war_end_timer"] = 0
			core.gameRegistry["beach_war_open"] = 0
			core.gameRegistry["beach_war_winner"] = 0
			core.gameRegistry["beach_war_started"] = 0
			core.gameRegistry["beach_war_red_point"] = 0
			core.gameRegistry["beach_war_blue_point"] = 0
			core.gameRegistry["beach_war_current_map"] = 0
			core.gameRegistry["beach_war_red_wins"] = 0
			core.gameRegistry["beach_war_blue_wins"] = 0
			core.gameRegistry["beach_war_round"] = 0
			core.gameRegistry["beach_war_warped_players"] = 0
			core.gameRegistry["beach_war_winner"] = 0
		end
	end,

	entryLegend = function(player)
		local reg = player.registry["beach_war_entries"]

		if player:hasLegend("beach_war_entries") then
			player:removeLegendbyName("beach_war_entries")
		end

		if reg > 0 then
			player.registry["beach_war_entries"] = player.registry[
				"beach_war_entries"
			] + 1
			player:addLegend(
				"Played in " .. player.registry["beach_war_entries"] .. " Beach Wars",
				"beach_war_entries",
				198,
				16
			)
		else
			player.registry["beach_war_entries"] = 1
			player:addLegend(
				"Played in 1 Beach War",
				"beach_war_entries",
				198,
				16
			)
		end
	end,

	victoryLegend = function(player)
		local reg = player.registry["beach_war_wins"]

		if player:hasLegend("beach_war_wins") then
			player:removeLegendbyName("beach_war_wins")
		end

		if reg > 0 then
			player.registry["beach_war_wins"] = player.registry[
				"beach_war_wins"
			] + 1
			player:addLegend(
				"Won " .. player.registry["beach_war_wins"] .. " Beach Wars",
				"beach_war_wins",
				198,
				16
			)
		else
			player.registry["beach_war_wins"] = 1
			player:addLegend("Won 1 Beach War", "beach_war_wins", 198, 16)
		end
	end
}

beach_war_respawn = {
	uncast = function(player)
		if player.m == 15020 then
			beach_war_respawn.beachWarWarpIn(player, 0)
		end
	end,

	beachWarWarpIn = function(player, tries)
		local x = math.random(1, 38)
		local y = math.random(6, 43)
		local m = core.gameRegistry["beach_war_current_map"]
		local numTries

		numTries = tries + 1

		if numTries >= 20 then
			if player.registry["beach_war_team"] == 1 then
				player:warp(m, 3, 8)
			elseif player.registry["beach_war_team"] == 2 then
				player:warp(m, 36, 41)
			end
			return
		end
		groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
		if getPass(player.m, x, y) == 0 then
			if not getWarp(player.m, x, y) then
				if getObject(player.m, x, y) == 0 then
					if #groundItem == 0 then
						player.registry["beach_war_gun_pct"] = 100
						player:warp(m, x, y)
					else
						return beach_war_respawn.beachWarWarpIn(
							player,
							numTries
						)
					end
				else
					return beach_war_respawn.beachWarWarpIn(player, numTries)
				end
			else
				return beach_war_respawn.beachWarWarpIn(player, numTries)
			end
		else
			return beach_war_respawn.beachWarWarpIn(player, numTries)
		end
	end
}
