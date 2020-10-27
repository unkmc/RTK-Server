BomberWarNpc = {
	redWin = function()
		local pc = core:getObjectsInMap(15050, BL_PC)
		core.gameRegistry["bomber_war_playing"] = 0
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(15050, "Red Team Wins!")
		broadcast(15050, "You will return to the Arena in 5 seconds")
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		core.gameRegistry["bomber_war_end_timer"] = os.time() + 5
	end,

	wallCore = function()
		BomberWarNpc.wall()
	end,

	wall = function()
		local x = 0
		local y = 0
		local m = 15050
		local players = core:getObjectsInMap(m, BL_PC)

		if (core.gameRegistry["bomber_war_playing"] == 1) then
			core.gameRegistry["bomber_war_wall_timer"] = core.gameRegistry[
				"bomber_war_wall_timer"
			] + 1

			if (core.gameRegistry["bomber_war_wall_timer"] == 55 or core.gameRegistry[
				"bomber_war_wall_timer"
			] == 115 or core.gameRegistry["bomber_war_wall_timer"] == 175 or core.gameRegistry[
				"bomber_war_wall_timer"
			] == 235 or core.gameRegistry["bomber_war_wall_timer"] == 295) then
				broadcast(
					15050,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					15050,
					"WARNING - Play Area Reduction in 5 Seconds. Get Ready!"
				)
				broadcast(
					15050,
					"-----------------------------------------------------------------------------------------------------"
				)
			end

			if (core.gameRegistry["bomber_war_wall_timer"] == 60) then
				-- First set outside wall x 4
				for x = 1, 34 do
					--- horizontal walls
					for y = 4, 5 do
						BomberWarNpc.drawWall(x, y)
					end
					for y = 36, 37 do
						BomberWarNpc.drawWall(x, y)
					end
				end

				for y = 4, 37 do
					--- vertical walls
					for x = 1, 2 do
						BomberWarNpc.drawWall(x, y)
					end
					for x = 33, 34 do
						BomberWarNpc.drawWall(x, y)
					end
				end
			elseif (core.gameRegistry["bomber_war_wall_timer"] == 120) then
				-- second outside wall x 4
				for x = 3, 32 do
					for y = 6, 7 do
						BomberWarNpc.drawWall(x, y)
					end
					for y = 34, 35 do
						BomberWarNpc.drawWall(x, y)
					end
				end
				for y = 6, 35 do
					for x = 3, 4 do
						BomberWarNpc.drawWall(x, y)
					end

					for x = 31, 32 do
						BomberWarNpc.drawWall(x, y)
					end
				end
			elseif (core.gameRegistry["bomber_war_wall_timer"] == 180) then
				-- third outside wall x 4
				for x = 5, 30 do
					--- horizontal walls
					for y = 8, 9 do
						BomberWarNpc.drawWall(x, y)
					end
					for y = 32, 33 do
						BomberWarNpc.drawWall(x, y)
					end
				end
				for y = 8, 33 do
					--- vertical walls
					for x = 5, 6 do
						BomberWarNpc.drawWall(x, y)
					end

					for x = 29, 30 do
						BomberWarNpc.drawWall(x, y)
					end
				end
			elseif (core.gameRegistry["bomber_war_wall_timer"] == 240) then
				-- fourth outside wall x 4
				for x = 7, 28 do
					--- horizontal walls
					for y = 10, 11 do
						BomberWarNpc.drawWall(x, y)
					end
					for y = 30, 31 do
						BomberWarNpc.drawWall(x, y)
					end
				end
				for y = 10, 31 do
					--- vertical walls
					for x = 7, 8 do
						BomberWarNpc.drawWall(x, y)
					end

					for x = 27, 28 do
						BomberWarNpc.drawWall(x, y)
					end
				end
			elseif (core.gameRegistry["bomber_war_wall_timer"] == 300) then
				-- fifth outside wall x 4
				for x = 9, 26 do
					--- horizontal walls
					for y = 12, 13 do
						BomberWarNpc.drawWall(x, y)
					end
					for y = 28, 29 do
						BomberWarNpc.drawWall(x, y)
					end
				end
				for y = 12, 29 do
					--- vertical walls
					for x = 9, 10 do
						BomberWarNpc.drawWall(x, y)
					end

					for x = 25, 26 do
						BomberWarNpc.drawWall(x, y)
					end
				end
			end

			for i = 1, #players do
				players[i]:sendStatus()
				players[i]:updateState()
			end
		end

		-- end if playing
	end,

	drawWall = function(x, y)
		local m = 15050
		local lavaTile = 29259

		local players = core:getObjectsInCell(m, x, y, BL_PC)

		local items = core:getObjectsInCell(m, x, y, BL_ITEM)
		local object = getObject(m, x, y)

		if (#players > 0) then
			for i = 1, #players do
				if players[i].state == 0 then
					players[i].health = 0
					players[i].state = 1
					players[i].optFlags = 128
					players[i]:sendStatus()
					players[i]:updateState()
					players[i]:sendAnimationXY(94, players[i].x, players[i].y)

					if players[i].registry["bomber_war_team"] == 1 then
						players[i]:warp(
							m,
							math.random(1, 34),
							math.random(1, 2)
						)
					elseif players[i].registry["bomber_war_team"] == 2 then
						players[i]:warp(
							m,
							math.random(1, 34),
							math.random(39, 40)
						)
					end

					BomberWarNpc.winnerCheck()
				end
			end
		end

		if (#items > 0) then
			for i = 1, #items do
				items[i]:delete()
			end
		end

		if (object) then
			setObject(m, x, y, 0)
		end

		setTile(m, x, y, lavaTile)
		setPass(m, x, y, 0)
	end,

	blueWin = function()
		local pc = core:getObjectsInMap(15050, BL_PC)
		core.gameRegistry["bomber_war_playing"] = 0
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(15050, "Blue Team Wins!")
		broadcast(15050, "You will return to the Arena in 5 seconds")
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		core.gameRegistry["bomber_war_end_timer"] = os.time() + 5
	end,

	winnerCheck = function()
		local pc = core:getObjectsInMap(15050, BL_PC)
		local livingRed = {}
		local livingBlue = {}
		local winner = {}

		for i = 1, #pc do
			if pc[i].state == 0 then
				if pc[i].registry["bomber_war_team"] == 1 then
					table.insert(livingRed, pc[i].ID)
				elseif pc[i].registry["bomber_war_team"] == 2 then
					table.insert(livingBlue, pc[i].ID)
				end
			end
		end

		--Player(4):talk(0,"r: "..#livingRed)
		--Player(4):talk(0,"b: "..#livingBlue)

		if core.gameRegistry["bomber_war_playing"] == 1 then
			if #livingRed > 0 and #livingBlue > 0 then
				return
			elseif #livingRed > 0 and #livingBlue == 0 then
				core.gameRegistry["bomber_war_winner"] = 1
				return BomberWarNpc.redWin()
			elseif #livingRed == 0 and #livingBlue > 0 then
				core.gameRegistry["bomber_war_winner"] = 2
				return BomberWarNpc.blueWin()
			end
		end
	end,

	getStartTimer = function()
		local hour, minute, second = 0, 0, 0

		if core.gameRegistry["bomber_war_start"] < os.time() then
			return "00:00:00"
		else
			dif = core.gameRegistry["bomber_war_start"] - os.time()
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
		local total = {}

		local pc = player:getObjectsInMap(player.m, BL_PC)
		local n = "<b>[Bomber War]\n\n"
		local t = {g = convertGraphic(npc.look, "monster"), c = npc.lookColor}
		player.npcGraphic = t.g
		player.npcColor = t.c
		player.dialogType = 0

		local str, par = "", ""
		local time = BomberWarNpc.getStartTimer()

		if #pc > 0 then
			for i = 1, #pc do
				if pc[i].registry["bomber_war_registered"] > 0 then
					table.insert(total, pc[i].ID)
				end
			end
		end
		local opts = {}
		table.insert(opts, "How To Play?")
		if core.gameRegistry["bomber_war"] == 1 then
			if player.registry["bomber_war_registered"] == 0 then
				table.insert(opts, "Register For Bomber War")
			else
				par = " participant."
			end

			if player.registry["bomber_war_registered"] > 0 or player.registry[
				"bomber_war_team"
			] > 0 then
				table.insert(opts, "I can't register!")
			end
		end

		table.insert(opts, "Exit")

		if core.gameRegistry["bomber_war_start"] > os.time() then
			str = "Waiting time: " .. BomberWarNpc.getStartTimer()
		end

		menu = player:menuString(
			n .. "Hello," .. par .. " The game will start in few minutes.\n" .. str .. "\nTotal players: " .. #total,
			opts
		)

		if menu == "How To Play?" then
			player:dialogSeq(
				{
					t,
					n .. "Bomber War is an explosive team-based game!",
					n .. "Your attacks will drop bombs on the ground that will explode in a few seconds. The blast goes 1 tile in 4 directions, so make sure you stay out of the way!",
					n .. "The explosions will destroy boxes around the map and open up paths. Sometimes, a magic symbol will be left on the ground after a box is destroyed.",
					n .. "If you walk over one of these symbols, you'll get a powerup! Some will make you move faster, others will make your explosions bigger or let you drop more bombs at once.",
					n .. "If you're caught in an explosion, you're dead. The team with a living player is the winner."
				},
				1
			)
			player:freeAsync()
			BomberWarNpc.click(player, npc)
		elseif menu == "Register For Bomber War" then
			if os.time() < player.registry["minigameBan"] then
				--Check if player is banned from minigames
				player:popUp("You are currently banned from minigames! Try again later maybe.")
				return
			end
			if player.registry["bomber_war_team"] == 0 then
				player.registry["bomber_war_registered"] = 1
				player.registry["bomber_war_team"] = math.random(1, 2)
				core.gameRegistry["bomber_war_players"] = core.gameRegistry[
					"bomber_war_players"
				] + 1
				player:warp(15051, math.random(2, 14), math.random(2, 12))
				player:sendAnimation(16)
				player:playSound(29)
				player:dialogSeq(
					{
						t,
						n .. "Allright, your character is registered for Bomber War.\nPlease wait until the game starts!"
					},
					1
				)
			else
				player:dialogSeq(
					{
						t,
						n .. "Please be patient!\n\n<b>Waiting time: " .. time .. ""
					},
					1
				)
				BomberWarNpc.click(player, npc)
			end
		elseif menu == "I can't register!" then
			player.registry["bomber_war_registered"] = 0
			player.registry["bomber_war_team"] = 0
			player:dialogSeq(
				{
					t,
					n .. "Looks like a simple paperwork mixup. You should be all set to register now, have fun at the game!"
				},
				1
			)
			player:freeAsync()
			BomberWarNpc.click(player, npc)
		end
	end),

	core = function()
		BomberWarNpc.closed()
		BomberWarNpc.begin(core)
		BomberWarNpc.balancing(core)
		BomberWarNpc.endGame()
	end,

	open = function()
		core.gameRegistry["bomber_war"] = 1
		core.gameRegistry["bomber_war_start"] = os.time() + 900
		broadcast(
			-1,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			-1,
			"                                Bomber War is now open in Kugnae Arena!"
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
		--	core.gameRegistry["bomber_war"] = 1
		--	core.gameRegistry["bomber_war_start"] = os.time()+120
		--	broadcast(-1, "-----------------------------------------------------------------------------------------------------")
		--	broadcast(-1, "                                 Another chance to play! Get ready!")
		--	broadcast(-1, "                                Bomber War is now open in Hon Arena!")
		--	broadcast(-1, "                                    Entry is closing in 2 minutes!")
		--	broadcast(-1, "-----------------------------------------------------------------------------------------------------")
	end,

	closed = function()
		local diff = core.gameRegistry["bomber_war_start"] - os.time()

		if core.gameRegistry["bomber_war"] == 1 then
			if core.gameRegistry["bomber_war_start"] > 0 then
				if core.gameRegistry["bomber_war_start"] > os.time() then
					if diff == 300 then
						broadcast(
							-1,
							"-----------------------------------------------------------------------------------------------------"
						)
						broadcast(
							-1,
							"                                 Bomber War entry is closing in 5 minute!"
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
							"                                 Bomber War entry is closing in 10 minutes!"
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
							"                                 Bomber War entry is closing in 1 minute!"
						)
						broadcast(
							-1,
							"-----------------------------------------------------------------------------------------------------"
						)
					elseif diff == 10 then
						broadcast(
							15051,
							"                                    Bomber War Starts in 10 seconds!"
						)
					elseif diff <= 3 then
						broadcast(
							15051,
							"                                    Bomber War Starts in " .. diff .. " seconds!"
						)
					end
				elseif core.gameRegistry["bomber_war_start"] < os.time() then
					--core.gameRegistry["bomber_war"] = 0
					core.gameRegistry["bomber_war_start"] = 0
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					broadcast(
						-1,
						"                                 Bomber War entry is closed!"
					)
					broadcast(
						-1,
						"-----------------------------------------------------------------------------------------------------"
					)
					BomberWarNpc.start()
				end
			end
		end
	end,

	endGame = function()
		local pc = core:getObjectsInMap(15050, BL_PC)
		local arenaPC = core:getObjectsInMap(31, BL_PC)

		if core.gameRegistry["bomber_war_end_timer"] > 0 and core.gameRegistry[
			"bomber_war_end_timer"
		] < os.time() then
			core.gameRegistry["bomber_war_end_timer"] = 0
			core.gameRegistry["bomber_war_players"] = 0
			core.gameRegistry["bomber_war"] = 0

			core.gameRegistry["bomber_war_playing"] = 0
			core.gameRegistry["bomber_war_wall_timer"] = 0

			if #pc > 0 then
				for i = 1, #pc do
					pc[i].state = 0
					pc[i].health = pc[i].maxHealth
					pc[i].gfxClone = 0
					pc[i].optFlags = 0
					pc[i]:updateState()

					if pc[i].registry["bomber_war_team"] == core.gameRegistry["bomber_war_winner"] then
						BomberWarNpc.victoryLegend(pc[i])
						minigames.giveMinigameExp(pc[i], 1)
					else
						minigames.giveMinigameExp(pc[i], 2)
					end
					pc[i].registry["bomber_war_registered"] = 0
					pc[i].registry["speed_boost"] = 0
					pc[i].registry["bomb_max"] = 0
					pc[i].registry["bomb_distance"] = 0
					pc[i].registry["bomber_war_team"] = 0

					pc[i]:warp(31, math.random(6, 15), math.random(9, 13))
					pc[i]:sendAnimation(16)
					pc[i]:playSound(29)
					pc[i]:calcStat()
				end
			end

			core.gameRegistry["bomber_war_winner"] = 0

			if #arenaPC > 0 then
				for i = 1, #arenaPC do
					arenaPC[i].gfxClone = 0
					arenaPC[i]:updateState()
				end
			end
			BomberWarNpc.mapReset()

			if core.gameRegistry["bomber_war_round_2"] == 0 then
				core.gameRegistry["bomber_war_round_2"] = 1
				BomberWarNpc.roundTwo()
			elseif core.gameRegistry["bomber_war_round_2"] == 1 then
				core.gameRegistry["bomber_war_round_2"] = 0
				return
			end
		end
	end,

	stop = function()
		local pc = core:getObjectsInMap(15050, BL_PC)

		core.gameRegistry["bomber_war_end_timer"] = 0
		core.gameRegistry["bomber_war_players"] = 0
		core.gameRegistry["bomber_war"] = 0
		core.gameRegistry["bomber_war_winner"] = 0
		core.gameRegistry["bomber_war_playing"] = 0
		core.gameRegistry["bomber_war_wall_timer"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				pc[i].registry["bomber_war_registered"] = 0
				pc[i].registry["bomber_war_team"] = 0
				pc[i].registry["speed_boost"] = 0
				pc[i].registry["bomb_max"] = 0
				pc[i].registry["bomb_distance"] = 0
				pc[i].health = pc[i].maxHealth
				pc[i].state = 0
				pc[i].gfxClone = 0
				pc[i].optFlags = 0
				pc[i]:updateState()
				pc[i]:warp(31, math.random(6, 15), math.random(9, 13))
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:calcStat()
			end
		end
		BomberWarNpc.mapReset()
	end,

	cancel = function()
		local pc = core:getObjectsInMap(15051, BL_PC)

		core.gameRegistry["bomber_war_end_timer"] = 0
		core.gameRegistry["bomber_war_players"] = 0
		core.gameRegistry["bomber_war"] = 0
		core.gameRegistry["bomber_war_winner"] = 0
		core.gameRegistry["bomber_war_playing"] = 0
		core.gameRegistry["bomber_war_wall_timer"] = 0

		if #pc > 0 then
			for i = 1, #pc do
				pc[i].registry["bomber_war_registered"] = 0
				pc[i].registry["bomber_war_team"] = 0
				pc[i].registry["speed_boost"] = 0
				pc[i].registry["bomb_max"] = 0
				pc[i].registry["bomb_distance"] = 0
				pc[i].health = pc[i].maxHealth
				pc[i].state = 0
				pc[i].gfxClone = 0
				pc[i].optFlags = 0
				pc[i]:updateState()
				pc[i]:warp(31, math.random(6, 15), math.random(9, 13))
				pc[i]:sendAnimation(16)
				pc[i]:playSound(29)
				pc[i]:calcStat()
			end
		end
		BomberWarNpc.mapReset()
	end,

	entryLegend = function(player)
		local reg = player.registry["bomber_war_entries"]

		if player:hasLegend("bomber_war_entries") then
			player:removeLegendbyName("bomber_war_entries")
		end

		if reg > 0 then
			player.registry["bomber_war_entries"] = player.registry[
				"bomber_war_entries"
			] + 1
			player:addLegend(
				"Played in " .. player.registry["bomber_war_entries"] .. " Bomber Wars",
				"bomber_war_entries",
				76,
				16
			)
		else
			player.registry["bomber_war_entries"] = 1
			player:addLegend(
				"Played in 1 Bomber War",
				"bomber_war_entries",
				76,
				16
			)
		end
	end,

	victoryLegend = function(player)
		local reg = player.registry["bomber_war_wins"]

		if player:hasLegend("bomber_war_wins") then
			player:removeLegendbyName("bomber_war_wins")
		end

		if reg > 0 then
			player.registry["bomber_war_wins"] = player.registry[
				"bomber_war_wins"
			] + 1
			player:addLegend(
				"Won " .. player.registry["bomber_war_wins"] .. " Bomber Wars",
				"bomber_war_wins",
				76,
				16
			)
		else
			player.registry["bomber_war_wins"] = 1
			player:addLegend("Won 1 Bomber War", "bomber_war_wins", 76, 16)
		end

		--player:addMinigamePoint(player)
	end,

	start = function()
		local pc = core:getObjectsInMap(15051, BL_PC)
		if core.gameRegistry["bomber_war_players"] >= 2 then
			if #pc > 0 then
				for i = 1, #pc do
					pc[i].state = 0
					pc[i].speed = 90
					pc[i]:updateState()

					BomberWarNpc.entryLegend(pc[i])
					BomberWarNpc.costume(pc[i])
					BomberWarNpc.enterArena(pc[i])
				end
				BomberWarNpc.wait()
			end
		else
			broadcast(
				-1,
				"-----------------------------------------------------------------------------------------------------"
			)
			broadcast(
				-1,
				"                             Not enough players. Bomber War cancelled!"
			)
			broadcast(
				-1,
				"-----------------------------------------------------------------------------------------------------"
			)
			BomberWarNpc.cancel()
		end
	end,

	enterArena = function(player)
		local map = 15050
		local x = math.random(1, 34)
		local y = math.random(4, 37)
		local pc = core:getObjectsInCell(map, x, y, BL_PC)
		local nearbypc
		local nearbypcfound = {}

		if player.registry["bomber_war_team"] == 1 then
			if getPass(map, x, y) == 0 then
				if getObject(map, x, y) == 0 then
					if #pc == 0 then
						player.paralyzed = true
						player:warp(map, x, y)
					else
						return BomberWarNpc.enterArena(player)
					end
				else
					return BomberWarNpc.enterArena(player)
				end
			else
				return BomberWarNpc.enterArena(player)
			end
		elseif player.registry["bomber_war_team"] == 2 then
			if getPass(map, x, y) == 0 then
				if getObject(map, x, y) == 0 then
					if #pc == 0 then
						player.paralyzed = true
						player:warp(map, x, y)
					else
						return BomberWarNpc.enterArena(player)
					end
				else
					return BomberWarNpc.enterArena(player)
				end
			else
				return BomberWarNpc.enterArena(player)
			end
		end

		nearbypc = player:getObjectsInArea(BL_PC)

		for i = 1, #nearbypc do
			if (distanceSquare(player, nearbypc[i], 1) and nearbypc[i].ID ~= player.ID) then
				table.insert(nearbypcfound, nearbypc[i].ID)
			end
		end

		if #nearbypcfound > 0 then
			return BomberWarNpc.enterArena(player)
		end
	end,

	wait = function()
		local pc = core:getObjectsInMap(15050, BL_PC)
		core.gameRegistry["bomber_war_wait_time"] = os.time() + 30

		local time = math.abs(os.time() - core.gameRegistry["bomber_war_wait_time"])

		for i = 1, #pc do
			pc[i]:setTimer(2, time)
		end

		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(
			15050,
			"                                    Get Ready! Bomber War starts in 30 seconds!"
		)
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
	end,

	begin = function(npc)
		local pc = core:getObjectsInMap(15050, BL_PC)

		if core.gameRegistry["bomber_war_wait_time"] > 0 and core.gameRegistry[
			"bomber_war_wait_time"
		] < os.time() then
			if #pc >= 2 then
				broadcast(
					15050,
					"-----------------------------------------------------------------------------------------------------"
				)
				broadcast(
					15050,
					"                                   The Bomber War has begun!"
				)
				broadcast(
					15050,
					"-----------------------------------------------------------------------------------------------------"
				)

				for i = 1, #pc do
					pc[i].paralyzed = false
				end
			else
				--broadcast(-1, "-----------------------------------------------------------------------------------------------------")
				--broadcast(-1, "                             Not enough players. Bomber War cancelled!")
				--broadcast(-1, "-----------------------------------------------------------------------------------------------------")
				BomberWarNpc.stop()
			end
			core.gameRegistry["bomber_war_playing"] = 1
			core.gameRegistry["bomber_war_wait_time"] = 0
		end
	end,

	balancing = function(npc)
		local red, blue = {}, {}
		local pc = npc:getObjectsInMap(15051, BL_PC)

		if #pc > 0 then
			for i = 1, #pc do
				if pc[i].registry["bomber_war_team"] == 1 then
					table.insert(red, pc[i].ID)
				elseif pc[i].registry["bomber_war_team"] == 2 then
					table.insert(blue, pc[i].ID)
				end
			end
		end
		if #pc > 0 then
			for i = 1, #pc do
				if #red > #blue then
					if (#red - #blue) ~= 1 then
						pc[math.random(#pc)].registry["bomber_war_team"] = 2
						break
					end
				end
				if #red < #blue then
					if #blue - #red ~= 1 then
						pc[math.random(#pc)].registry["bomber_war_team"] = 1
						break
					end
				end
			end
		end
	end,

	costume = function(player)
		local team = player.registry["bomber_war_team"]
		local dye, str = 0, ""

		clone.equip(player, player)

		if team == 1 then
			dye = 31
		elseif team == 2 then
			dye = 17
		end
		if player.sex == 0 then
			armor = 4
		elseif player.sex == 1 then
			armor = 8
		end

		player.gfxShield = -1
		player.gfxShieldC = 0
		player.gfxMantle = -1
		player.gfxMantleC = 0
		player.gfxArmor = armor
		player.gfxDye = dye
		player.gfxWeap = 65535
		player.gfxClone = 1
		player:updateState()
	end,

	draw = function()
		BomberWarNpc.wait()
		BomberWarNpc.mapReset()
		BomberWarNpc.playerReset()
	end,

	win = function(player)
		local pc = core:getObjectsInMap(15050, BL_PC)

		player.registry["bomber_war_winner"] = 1
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		broadcast(15050, "" .. player.name .. " Wins!")
		broadcast(15050, "You will return to the Arena in 5 seconds")
		broadcast(
			15050,
			"-----------------------------------------------------------------------------------------------------"
		)
		core.gameRegistry["bomber_war_end_timer"] = os.time() + 5
	end,

	bomb = function(player)
		local m = player.m
		local x = player.x
		local y = player.y
		local bomb = player:getObjectsInMap(m, BL_NPC)
		local ownBomb = {}
		local maxBombs = player.registry["bomb_max"] + 1
		local tileBombs = player:getObjectsInCell(m, x, y, BL_ITEM)

		if core.gameRegistry["bomber_war_playing"] == 0 then
			player:sendMinitext("The game isn't playing now!")
			return
		end

		if #tileBombs > 0 then
			player:sendMinitext("There is already a bomb here!")
			return
		end

		if #bomb > 0 then
			for i = 1, #bomb do
				if bomb[i].owner == player.ID then
					table.insert(ownBomb, bomb[i].ID)
				end
			end
		end

		if m == 15050 then
			if player.registry["bomber_war_registered"] > 0 then
				if #ownBomb < maxBombs then
					player:sendAction(5, 30)
					player:playSound(406)
					player:dropItemXY(65004, 1, 0, 0, m, x, y)
					player:addNPC(
						"bomber_war_bomb",
						m,
						x,
						y,
						0,
						1000,
						3000,
						player.ID
					)
				else
					player:sendMinitext("You have too many bombs active to place another one.")
				end
			end
		end
	end,

	pickups = function(player)
		local m = 15050
		local x = player.x
		local y = player.y

		local power = {31154}
		local speed = {31123}
		local count = {29745}
		local lava = {29259}

		if m == 15050 then
			if player.state ~= 1 then
				if x >= 1 and x <= 34 then
					if y >= 4 and y <= 37 then
						for i = 1, #power do
							if getTile(m, x, y) == power[i] then
								if player.registry["bomb_distance"] <= 2 then
									player.registry["bomb_distance"] = player.registry[
										"bomb_distance"
									] + 1
									setTile(m, x, y, 297)
									player:playSound(503)
									player:sendAnimation(296)
									player:talk(2, "BOMB POWER +1")
								elseif player.registry["bomb_distance"] == 3 then
									setTile(m, x, y, 297)
									player:playSound(503)
									player:sendAnimation(296)
									player:talk(2, "BOMB POWER MAX")
								end
							end
						end
						for i = 1, #speed do
							if getTile(m, x, y) == speed[i] then
								if player.registry["speed_boost"] <= 4 then
									player.registry["speed_boost"] = player.registry[
										"speed_boost"
									] + 1
									player.speed = player.speed - 10
									player:updateState()
									setTile(m, x, y, 297)
									player:playSound(504)
									player:sendAnimation(251)
									player:talk(2, "RUN SPEED +1")
								elseif player.registry["speed_boost"] == 5 then
									setTile(m, x, y, 297)
									player:playSound(504)
									player:sendAnimation(251)
									player:talk(2, "RUN SPEED MAX")
								end
							end
						end
						for i = 1, #count do
							if getTile(m, x, y) == count[i] then
								if player.registry["bomb_max"] <= 3 then
									player.registry["bomb_max"] = player.registry[
										"bomb_max"
									] + 1
									setTile(m, x, y, 297)
									player:playSound(505)
									player:sendAnimation(295)
									player:talk(2, "BOMB COUNT +1")
								elseif player.registry["bomb_max"] == 4 then
									setTile(m, x, y, 297)
									player:playSound(505)
									player:sendAnimation(295)
									player:talk(2, "BOMB COUNT MAX")
								end
							end
						end
						for i = 1, #lava do
							if getTile(m, x, y) == lava[i] then
								if player.state == 0 then
									player.health = 0
									player.state = 1
									player.optFlags = 128
									player:sendStatus()
									player:updateState()
									player:sendAnimationXY(
										94,
										player.x,
										player.y
									)

									if player.registry["bomber_war_team"] == 1 then
										player:warp(
											m,
											math.random(1, 34),
											math.random(1, 2)
										)
									elseif player.registry["bomber_war_team"] == 2 then
										player:warp(
											m,
											math.random(1, 34),
											math.random(39, 40)
										)
									end

									BomberWarNpc.winnerCheck()
								end
							end
						end
					end
				end
			end
		end
	end,

	mapReset = function()
		for x = 1, 34 do
			for y = 4, 37 do
				if getTile(15050, x, y) == 31154 or getTile(15050, x, y) == 31123 or getTile(
					15050,
					x,
					y
				) == 29745 or getTile(15050, x, y) == 29259 then
					setTile(15050, x, y, 297)
				end

				if getTile(15050, x, y) == 297 then
					setObject(15050, x, y, 15802)
				end

				if getObject(15050, x, y) ~= 1585 then
					setPass(15050, x, y, 0)
				end

				bomb = core:getObjectsInCell(15050, x, y, BL_ITEM)
				for i = 1, #bomb do
					bomb[i]:delete()
				end
			end
		end
	end,

	playerReset = function()
		local pc = core:getObjectsInMap(15050, BL_PC)

		for i = 1, #pc do
			--pc[i].registry["bomb_game_registered"] = 0
			pc[i].registry["speed_boost"] = 0
			pc[i].registry["bomb_max"] = 0
			pc[i].registry["bomb_distance"] = 0
			pc[i].health = pc[i].maxHealth
			pc[i].state = 0
			pc[i]:updateState()
			pc[i]:calcStat()
			pc[i]:sendStatus()
			BomberWarNpc.enterArena(pc[i])
		end
	end
}
