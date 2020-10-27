elixirTeams = {}
elixirMaps = {3042, 3035, 3036, 3037, 3038, 3039, 3014}

elixir = {
	init = function(eventid)
		core.gameRegistry["minigameEventId"] = eventid
		broadcast(
			-1,
			"" .. minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors opening. Nagnang Arena (74,103 Nagnang)"
		)
		broadcast(-1, "Elixir starting in 15 minutes.")
		core.gameRegistry["elixirState"] = 1
		core.gameRegistry["elixirStart"] = os.time()
		core.gameRegistry["elixirDye"] = 0
		core.gameRegistry["elixirMap"] = 0
		core.gameRegistry["elixirRedScore"] = 0
		core.gameRegistry["elixirBlueScore"] = 0
		core.gameRegistry["elixirRound"] = 1
		core.gameRegistry["elixirRoundWinner"] = 0

		elixir.setArenaDoors("open")
		elixir.setGameDoors("close")
		elixir.removePrizeNPC()
	end,

	closeGame = function()
		elixir.removePrizeNPC()

		if core.gameRegistry["elixirMap"] > 0 then
			local pcs = core:getObjectsInMap(
				core.gameRegistry["elixirMap"],
				BL_PC
			)
			if #pcs ~= nil then
				for i = 1, #pcs do
					clone.wipe(pcs[i])
					pcs[i].registry["elixirTeam"] = 0
					pcs[i]:returnToInn()
				end
			end
		end

		core.gameRegistry["elixirState"] = 0
		core.gameRegistry["elixirStart"] = 0
		core.gameRegistry["minigameEventId"] = 0
		core.gameRegistry["elixirDye"] = 0
		core.gameRegistry["elixirMap"] = 0
		core.gameRegistry["elixirRedScore"] = 0
		core.gameRegistry["elixirBlueScore"] = 0
		core.gameRegistry["elixirRoundWinner"] = 0
		core.gameRegistry["elixirGameClose"] = 0
		core.gameRegistry["elixirWinner"] = 0
		core.gameRegistry["elixirRound"] = 1
		elixir.setArenaDoors("close")
		elixir.setGameDoors("close")

		elixir.clearTeams()
	end,

	setArenaDoors = function(state)
		local m = 2590
		if state == "open" then
			for i = 1, getMapXMax(m) do
				local obj = getObject(m, i, 2)

				if (obj == 2265) or (obj == 2266) then
					setObject(m, i, 2, obj + 18)
				end
			end
		elseif state == "close" then
			for i = 1, getMapXMax(m) do
				local obj = getObject(m, i, 2)

				if (obj == 2283) or (obj == 2284) then
					setObject(m, i, 2, obj - 18)
				end
			end
		end
	end,

	setGameDoors = function(state)
		local m = 3042
		if state == "open" then
			for i = 1, getMapXMax(m) do
				local obj = getObject(m, i, 6)

				if (obj == 2263) or (obj == 2264) then
					setObject(m, i, 6, obj + 18)
				end
			end
		elseif state == "close" then
			for i = 1, getMapXMax(m) do
				local obj = getObject(m, i, 6)

				if (obj == 2281) or (obj == 2282) then
					setObject(m, i, 6, obj - 18)
				end
			end
		end
	end,

	removePrizeNPC = function()
		for i = 1, #elixirMaps do
			local npcs = core:getObjectsInMap(elixirMaps[i], BL_NPC)

			if npcs ~= nil then
				for j = 1, #npcs do
					if npcs[j].yname == "elixirPrizeNPC" then
						npcs[j]:delete()
					end
				end
			end
		end
	end,

	getElixirTeam = function(team)
		local rteam = {}

		for i = 1, #elixirTeams do
			if Player(elixirTeams[i].id) ~= nil then
				if Player(elixirTeams[i].id).registry["elixirTeam"] == team then
					table.insert(rteam, {id = elixirTeams[i].id})
				end
			end
		end

		return rteam
	end,

	timer = function(eventid)
		elixir.walkTimer()

		if (core.gameRegistry["elixirState"] == 1) then
			if (os.time() == core.gameRegistry["elixirStart"] + 300) then
				broadcast(
					-1,
					minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors closing in 10 minutes. Nagnang Arena (74,103 Nagnang)"
				)
			end
			if (os.time() == core.gameRegistry["elixirStart"] + 600) then
				broadcast(
					-1,
					minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors closing in 5 minutes. Nagnang Arena (74,103 Nagnang)"
				)
			end
			if (os.time() == core.gameRegistry["elixirStart"] + 900) then
				if not minigames.minimumPlayerCheck("elixir", 6) then
					elixir.closeGame()
					return
				end

				broadcast(
					-1,
					minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors closed."
				)
				elixir.setArenaDoors("close")
				elixir.clearTeams()
				core.gameRegistry["elixirState"] = 2
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 2) then
			elixir.setArenaDoors("close")
			elixir.clearTeams()

			if (os.time() > core.gameRegistry["elixirStart"] + 60) then
				core.gameRegistry["elixirState"] = 3
			end
		end

		if (core.gameRegistry["elixirState"] == 3) then
			broadcast(
				3042,
				"[Host Monty]: Please be patient while I setup the teams!"
			)
			core.gameRegistry["elixirState"] = 4
		end

		if (core.gameRegistry["elixirState"] == 4) then
			-- auto balance
			if (os.time() % 5 == 0) then
				local players = core:getObjectsInMap(3042, BL_PC)

				if #elixirTeams < #players then
					for i = 1, #players do
						local red = elixir.getElixirTeam(1)
						local blue = elixir.getElixirTeam(2)
						local found = false

						if #elixirTeams > 0 then
							for j = 1, #elixirTeams do
								if players[i].id == elixirTeams[j].id then
									-- player found
									found = true
								end
							end
						end

						if not found then
							if (#blue == #red) then
								local random = math.random(1, 2)
								if random == 1 then
									table.insert(
										elixirTeams,
										{id = players[i].id}
									)
									elixir.teamDye(players[i], 1)
									players[i].registry["elixirTeam"] = 1
								elseif random == 2 then
									table.insert(
										elixirTeams,
										{id = players[i].id}
									)
									elixir.teamDye(players[i], 2)
									players[i].registry["elixirTeam"] = 2
								end
							end

							if (#red > #blue) then
								table.insert(elixirTeams, {id = players[i].id})
								elixir.teamDye(players[i], 2)
								players[i].registry["elixirTeam"] = 2
							end

							if (#blue > #red) then
								table.insert(elixirTeams, {id = players[i].id})
								elixir.teamDye(players[i], 1)
								players[i].registry["elixirTeam"] = 1
							end
						end
					end
				else
					broadcast(
						3042,
						"[Host Monty]: Alright teams are setup, get ready to enter!"
					)
					core.gameRegistry["elixirState"] = 5
					core.gameRegistry["elixirStart"] = os.time()
				end
			end
		end

		if (core.gameRegistry["elixirState"] == 5) then
			if (os.time() > core.gameRegistry["elixirStart"] + 5) then
				core.gameRegistry["elixirState"] = 6
			end
		end

		if (core.gameRegistry["elixirState"] == 6) then
			core.gameRegistry["elixirState"] = 7
			core.gameRegistry["elixirStart"] = os.time()
		end

		if (core.gameRegistry["elixirState"] == 7) then
			if (os.time() > core.gameRegistry["elixirStart"] + 5) then
				core.gameRegistry["elixirState"] = 8
			end
		end

		if (core.gameRegistry["elixirState"] == 8) then
			if (core.gameRegistry["elixirRedScore"] < 2 and core.gameRegistry[
				"elixirBlueScore"
			] < 2) then
				local players = core:getObjectsInMap(3042, BL_PC)

				if core.gameRegistry["elixirMap"] == 0 then
					--core.gameRegistry["elixirMap"] = elixir.chooseMap()
					core.gameRegistry["elixirMap"] = 3036
				end

				elixir.setBarricade()
				elixir.removeSidelinesBarricade()

				elixir.setGameDoors("open")

				core.gameRegistry["elixirRoundWinner"] = 0

				broadcast2(
					elixirMaps,
					"[Host Monty]: Alright arena is setup. Go ahead and enter!"
				)
				core.gameRegistry["elixirState"] = 9
				core.gameRegistry["elixirStart"] = os.time()
			else
				core.gameRegistry["elixirState"] = 100
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 9) then
			local round = core.gameRegistry["elixirRound"]
			if (os.time() > core.gameRegistry["elixirStart"] + 30) then
				broadcast2(
					elixirMaps,
					"[Host Monty]: Round " .. round .. " is starting in 30 seconds."
				)
				core.gameRegistry["elixirState"] = 10
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 10) then
			local round = core.gameRegistry["elixirRound"]
			if (os.time() > core.gameRegistry["elixirStart"] + 15) then
				broadcast2(
					elixirMaps,
					"[Host Monty]: Round " .. round .. " is starting in 15 seconds."
				)
				core.gameRegistry["elixirState"] = 11
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 11) then
			local round = core.gameRegistry["elixirRound"]
			if (os.time() > core.gameRegistry["elixirStart"] + 10) then
				broadcast2(
					elixirMaps,
					"[Host Monty]: Round " .. round .. " is starting in 5 seconds. Get ready!"
				)

				elixir.setGameDoors("close")
				elixir.loadArrows()
				core.gameRegistry["elixirState"] = 12
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 12) then
			if (os.time() > core.gameRegistry["elixirStart"] + 5) then
				elixir.setSidelinesBarricade()
				broadcast2(elixirMaps, "[Host Monty]: Fight!")
				core.gameRegistry["elixirState"] = 13
				elixir.removeBarricade()
				elixir.setSidelinesBarricade()
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 13) then
			local m = core.gameRegistry["elixirMap"]
			local players = core:getObjectsInMap(m, BL_PC)

			local onlyDyed = true

			if players ~= nil then
				for i = 1, #players do
					if players[i].x >= 1 and players[i].x <= 30 and players[i].y >= 6 and players[i].y <= 35 then
						if players[i].gfxDye == 63 or players[i].gfxDye == 66 then
							-- original red blue
							onlyDyed = false
						end
					end
				end
			end

			if not onlyDyed then
				core.gameRegistry["stalemateCounter"] = 0
			end

			if onlyDyed then
				if core.gameRegistry["stalemateCounter"] == 0 then
					broadcast2(elixirMaps, "Stalemate in 30 seconds.")
				end
				if core.gameRegistry["stalemateCounter"] == 10 then
					broadcast2(elixirMaps, "Stalemate in 20 seconds.")
				end
				if core.gameRegistry["stalemateCounter"] == 20 then
					broadcast2(elixirMaps, "Stalemate in 10 seconds.")
				end
				if core.gameRegistry["stalemateCounter"] == 25 then
					broadcast2(elixirMaps, "Stalemate imminent.")
				end

				core.gameRegistry["stalemateCounter"] = core.gameRegistry[
					"stalemateCounter"
				] + 1

				if core.gameRegistry["stalemateCounter"] >= 30 then
					core.gameRegistry["elixirStart"] = os.time()
					core.gameRegistry["elixirState"] = 14
					core.gameRegistry["stalemateCounter"] = 0
				end
			end
		end

		if (core.gameRegistry["elixirState"] == 14) then
			if (os.time() >= core.gameRegistry["elixirStart"]) then
				if (core.gameRegistry["elixirRoundWinner"] == 1) then
					broadcast2(elixirMaps, "[Host Monty]: Red wins the round! ")
				end

				if (core.gameRegistry["elixirRoundWinner"] == 2) then
					broadcast2(
						elixirMaps,
						"[Host Monty]: Blue wins the round! "
					)
				end

				if (core.gameRegistry["elixirRoundWinner"] == 0) then
					broadcast2(
						elixirMaps,
						"[Host Monty]: Stalemate! Round " .. core.gameRegistry[
							"elixirRound"
						] .. " restarting."
					)
				end

				local m = core.gameRegistry["elixirMap"]
				local players = core:getObjectsInMap(m, BL_PC)

				local x, y = 0, 0

				if players ~= nil then
					for i = 1, #players do
						elixir.warpToSidelines(players[i])
					end
				end

				core.gameRegistry["elixirState"] = 15
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 15) then
			-- warp players back and start next round
			local m = core.gameRegistry["elixirMap"]
			local players = core:getObjectsInMap(m, BL_PC)

			elixir.sweepGameArea()

			local x, y = 0, 0

			for z = 1, #players do
				players[z].state = 0
				players[z].disguise = 0
				players[z].speed = 90
				players[z].health = players[z].maxHealth
				players[z].magic = players[z].maxMagic
				players[z]:flushDuration(1)
				players[z]:updateState()
				players[z]:sendStatus()
			end
			broadcast2(elixirMaps, "[Host Monty]: Current score is...")
			broadcast2(
				elixirMaps,
				"- Red: " .. core.gameRegistry["elixirRedScore"]
			)
			broadcast2(
				elixirMaps,
				"- Blue: " .. core.gameRegistry["elixirBlueScore"]
			)
			core.gameRegistry["elixirState"] = 16
			core.gameRegistry["elixirStart"] = os.time()
		end

		if (core.gameRegistry["elixirState"] == 16) then
			if (os.time() > core.gameRegistry["elixirStart"] + 15) then
				core.gameRegistry["elixirState"] = 8
				core.gameRegistry["elixirStart"] = os.time()
			end
		end

		if (core.gameRegistry["elixirState"] == 100) then
			local m = core.gameRegistry["elixirMap"]
			local pcs = core:getObjectsInMap(m, BL_PC)

			if pcs ~= nil then
				for i = 1, #pcs do
					elixir.warpToSidelines(pcs[i])
				end
			end

			if (core.gameRegistry["elixirRedScore"] >= 2) then
				core.gameRegistry["elixirWinner"] = 1
				core:addNPC("elixirPrizeNPC", m, 15, 6)
				broadcast2(
					elixirMaps,
					"[Host Monty]: Congratulations to the Red team. Please collect your prize from the merchant."
				)
			else
			end

			if (core.gameRegistry["elixirBlueScore"] >= 2) then
				core.gameRegistry["elixirWinner"] = 2
				core:addNPC("elixirPrizeNPC", m, 15, 35)
				broadcast2(
					elixirMaps,
					"[Host Monty]: Congratulations to the Blue team. Please collect your prize from the merchant."
				)
			else
			end

			core.gameRegistry["elixirState"] = 101
		end

		if (core.gameRegistry["elixirState"] == 101) then
			if core.gameRegistry["elixirGameClose"] == 0 then
				broadcast2(
					elixirMaps,
					"Elixir prize option closing in 5 minutes. Choose your prize."
				)
			end
			core.gameRegistry["elixirGameClose"] = core.gameRegistry[
				"elixirGameClose"
			] + 1

			local m = core.gameRegistry["elixirMap"]
			local pcs = core:getObjectsInMap(m, BL_PC)

			if core.gameRegistry["elixirGameClose"] == 240 then
				broadcast2(elixirMaps, "Elixir game closes in 60 seconds.")
			end

			if core.gameRegistry["elixirGameClose"] >= 300 or #pcs == 0 then
				broadcast2(elixirMaps, "Elixir game closed.")
				elixir.closeGame()
			end
		end
	end,

	loadArrows = function()
		local m = core.gameRegistry["elixirMap"]

		local pcs = core:getObjectsInMap(m, BL_PC)

		for i = 1, #pcs do
			pcs[i].gfxWeap = 20000
			pcs[i].registry["elixir_flag"] = 0
			pcs[i].registry["elixir_arrows"] = 36
			pcs[i]:sendMinitext("You have been loaded with 36 arrows.")
			pcs[i]:updateState()
			pcs[i]:sendMinitext("Good luck!")
		end
	end,

	shoot = function(player)
		--elixir--
		if player.gfxWeap == 20000 then
			local m, x, y, side = player.m, player.x, player.y, player.side
			local icon = side + 6
			local pc

			local onElixirMap = false
			for i = 1, #elixirMaps do
				if player.m == elixirMaps[i] then
					onElixirMap = true
					break
				end
			end

			if onElixirMap and player.gfxClone == 1 then
				if player.registry["elixir_arrows"] > 0 then
					player:playSound(709)
					player:sendAction(1, 20)
					player.registry["elixir_arrows"] = player.registry[
						"elixir_arrows"
					] - 1
					player:sendMinitext("Arrows remaining: " .. player.registry["elixir_arrows"])

					for i = 1, 12 do
						pc = getTargetFacing(player, BL_PC, 0, i)
						npc = getTargetFacing(player, BL_NPC, 0, i)
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

						if npc ~= nil then
							return
						end

						if pc ~= nil and pc.registry["elixirTeam"] > 0 then
							if math.random(1, 100) > 75 then
								return
							end
							elixir.hit(player, pc)
							return
						end

						if side == 0 then
							player:throw(x, y - i, icon, 0, 1)
						elseif side == 1 then
							player:throw(x + i, y, icon, 0, 1)
						elseif side == 2 then
							player:throw(x, y + i, icon, 0, 1)
						elseif side == 3 then
							player:throw(x - i, y, icon, 0, 1)
						end
					end
				else
					player:sendMinitext("You are out of arrows!")
				end
			end
		end
	end,

	hit = function(player, target)
		-- 66 blue
		-- 50 light blue
		-- 63 red
		-- 21 light red
		target.attacker = player.ID
		target:removeHealthExtend(0, 0, 0, 0, 0, 0)

		if (player.registry["elixirTeam"] == 1) then
			target.gfxDye = 21
		end

		if (player.registry["elixirTeam"] == 2) then
			target.gfxDye = 50
		end

		target.registry["elixirHitBy"] = player.ID

		if player.registry["elixirTeam"] == target.registry["elixirTeam"] then
			-- rescue, reset hit registry
			target.registry["elixirHitBy"] = 0
		end

		target:updateState()
	end,

	sweepGameArea = function()
		local m = core.gameRegistry["elixirMap"]
		if m == 0 then
			return
		end

		local items = core:getObjectsInMap(m, BL_ITEM)

		if #items > 0 then
			for i = 1, #items do
				if items[i].x >= 1 and items[i].x <= 30 and items[i].y >= 6 and items[i].y <= 35 and items[
					i
				].yname ~= "barricade" then
					--Player(2):talk(0,""..items[i].x.." "..items[i].y)
					items[i]:delete()
				end
			end
		end
	end,

	walkTimer = function()
		if core.gameRegistry["elixirState"] < 13 then
			return
		end

		-- play state

		local m = core.gameRegistry["elixirMap"]
		local x = 0
		local y = 0
		for y = 8, 10 do
			-- RED MAT    --- changed back to insta warp... on NTK if you get caught walking in your own base, host warps you if you are there for more than just a second or two.
			for x = 3, 5 do
				local pc = core:getObjectsInCell(m, x, y, BL_PC)

				if #pc > 0 then
					if pc[1].registry["elixirTeam"] == 1 then
						-- red team
						pc[1].registry["elixirHitBy"] = 0
						elixir.warpToSidelines(pc[1])

						--[[if pc[1].registry["elixirWalkTime"] == 0 then
						pc[1].registry["elixirWalkTime"] = os.time() + 3
					else
						if os.time() < pc[1].registry["elixirWalkTime"] then
							local diff = pc[1].registry["elixirWalkTime"] - os.time()

							if diff == 5 then pc[1]:talkSelf(0,"You must move within 3 seconds or be warped to sidelines.")
							end
						else
							pc[1].registry["elixirHitBy"] = 0
							elixir.warpToSidelines(pc[1])
						end

					end]]
						--
					end
				end
			end
		end

		for y = 31, 33 do
			-- BLUE MAT
			for x = 26, 28 do
				local pc = core:getObjectsInCell(m, x, y, BL_PC)

				if #pc > 0 then
					if pc[1].registry["elixirTeam"] == 2 then
						-- blue team --- changed back to insta warp... on NTK if you get caught walking in your own base, host warps you if you are there for more than just a second or two.
						pc[1].registry["elixirHitBy"] = 0
						elixir.warpToSidelines(pc[1])

						--[[if pc[1].registry["elixirWalkTime"] == 0 then
						pc[1].registry["elixirWalkTime"] = os.time() + 3
					else
						if os.time() < pc[1].registry["elixirWalkTime"] then
							local diff = pc[1].registry["elixirWalkTime"] - os.time()

							if diff == 5 then pc[1]:talkSelf(0,"You must move within 3 seconds or be warped to sidelines.")
							end
						else
							pc[1].registry["elixirHitBy"] = 0
							elixir.warpToSidelines(pc[1])
						end

					end]]
						--
					end
				end
			end
		end

		for y = 19, 23 do
			-- center auto warp (hosts auto warp you on NTK)
			for x = 13, 17 do
				local pc = core:getObjectsInCell(m, x, y, BL_PC)

				if #pc > 0 then
					if pc[1]:hasItem("red_elixir", 1) ~= true and pc[1]:hasItem("blue_elixir", 1) ~= true then
						-- either team
						pc[1].registry["elixirHitBy"] = 0
						elixir.warpToSidelines(pc[1])
					end
				end
			end
		end
	end,

	warpToSidelines = function(player)
		local m = core.gameRegistry["elixirMap"]

		if player:hasItem("elixir_trophy", 1) == true then
			player:removeItem("elixir_trophy", 1)
		end
		if player:hasItem("red_elixir", 1) == true then
			player:removeItem("red_elixir", 1)
		end
		if player:hasItem("blue_elixir", 1) == true then
			player:removeItem("blue_elixir", 1)
		end

		if player.registry["elixirTeam"] == 1 then
			player:warp(m, 14, 2)
		end
		if player.registry["elixirTeam"] == 2 then
			player:warp(m, 15, 40)
		end

		elixir.teamDye(player, player.registry["elixirTeam"])
		player.gfxWeap = 20000
		player.registry["elixir_arrows"] = 0
		player:sendMinitext("You have been warped to sidelines.")

		if player.registry["elixirHitBy"] > 0 then
			if (core.gameRegistry["elixirState"] == 13) then
				broadcast2(
					elixirMaps,
					player.name .. " has fallen in battle to " .. getOfflineID(player.registry["elixirHitBy"])
				)
			end
		end
	end,

	walk = function(player)
		local onElixirMap = false
		for i = 1, #elixirMaps do
			if player.m == elixirMaps[i] then
				onElixirMap = true
				break
			end
		end

		if not onElixirMap then
			return
		end

		player.registry["elixirWalkTime"] = 0

		if player.x >= 14 and player.x <= 16 and (player.y == 0 or player.y == 41) then
			-- exits
			local npc = NPC("Elixir NPC")
			local t = {
				graphic = convertGraphic(npc.look, "monster"),
				color = npc.lookColor
			}

			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = npc.ID

			if core.gameRegistry["elixirState"] ~= 101 then
				-- end state
				local confirm = player:menuSeq(
					"Are you sure you wish to abandon your team?",
					{"Yes", "No"},
					{}
				)
				if confirm == 1 then
					--abandon
					clone.wipe(player)
					player.registry["elixirTeam"] = 0
					player:returnToInn()
				end
			else
				minigames.giveMinigameExp(player, 2)
				clone.wipe(player)
				player.registry["elixirTeam"] = 0
				player:returnToInn()
			end
		end

		if core.gameRegistry["elixirState"] >= 9 and core.gameRegistry["elixirState"] <= 12 then
			local m = core.gameRegistry["elixirMap"]
			local x, y = 0, 0
			if (player.x == 2 or player.x == 29) and player.y >= 1 and player.y <= 3 then
				x = 6
				y = 10
				player:warp(m, x, y)
				return
			end
			if (player.x == 2 or player.x == 29) and player.y >= 38 and player.y <= 41 then
				x = 26
				y = 30
				player:warp(m, x, y)
				return
			end
		end

		if player.y >= 6 and player.y <= 35 then
			if player.registry["elixirTeam"] == 1 and player.gfxDye ~= 21 and player.gfxDye ~= 63 then
				-- fucked
				player.gfxDye = 63
				player:updateState()
				elixir.warpToSidelines(player)
				return
			elseif player.registry["elixirTeam"] == 2 and player.gfxDye ~= 50 and player.gfxDye ~= 66 then
				-- fucked
				player.gfxDye = 66
				player:updateState()
				elixir.warpToSidelines(player)
				return
			elseif player.registry["elixirTeam"] == 1 and player.gfxDye == 21 then
				--dyed
				elixir.teamDye(player, player.registry["elixirTeam"])
				player.gfxWeap = 20000
				player:updateState()
			elseif player.registry["elixirTeam"] == 2 and player.gfxDye == 50 then
				elixir.teamDye(player, player.registry["elixirTeam"])
				player.gfxWeap = 20000
				player:updateState()
			end
		end

		if player.x >= 3 and player.x <= 5 and player.y >= 8 and player.y <= 10 then
			-- red base
			if player.registry["elixirTeam"] == 2 then
				-- blue team
				if player:hasItem("red_elixir", 1) ~= true then
					player:addItem("red_elixir", 1)
				else
					player:talkSelf(0, "You already have the Red elixir")
				end
				return
			end
		elseif player.x >= 26 and player.x <= 28 and player.y >= 31 and player.y <= 33 then
			-- blue base
			if player.registry["elixirTeam"] == 1 then
				-- red team
				if player:hasItem("blue_elixir", 1) ~= true then
					player:addItem("blue_elixir", 1)
				else
					player:talkSelf(0, "You already have the Blue elixir")
				end
				return
			end
		end
	end,

	blueMsg = function(msg)
		local m = core.gameRegistry["elixirMap"]
		local pcs = core:getObjectsInMap(m, BL_PC)

		for i = 1, #pcs do
			pcs[i]:talk(2, msg)
		end
	end,

	gameStartBroadcast = function()
		local pcs = core:getObjectsInMap(3042, BL_PC)

		if pcs == nil then
			return
		end

		for i = 1, #pcs do
			pcs[i]:guitext("Pre elixir session has ended. Teams balanced.\nProceed through the doors.")
		end
	end,

	resetRound = function()
		core.gameRegistry["elixirRoundTimer"] = 0
	end,

	chooseMap = function()
		return elixirMaps[math.random(1, #elixirMaps)]
	end,

	setSidelinesBarricade = function()
		local m = core.gameRegistry["elixirMap"]
		local x = 2
		local x2 = 29

		--- TOP ---
		for y = 1, 3 do
			core:dropItemXY("barricade", 1, 0, 0, m, x, y)
			setPass(m, x, y, 1)
		end
		for y = 1, 3 do
			core:dropItemXY("barricade", 1, 0, 0, m, x2, y)
			setPass(m, x2, y, 1)
		end

		------------------------------

		--- BOTTOM---
		for y = 38, 40 do
			core:dropItemXY("barricade", 1, 0, 0, m, x, y)
			setPass(m, x, y, 1)
		end
		for y = 38, 40 do
			core:dropItemXY("barricade", 1, 0, 0, m, x2, y)
			setPass(m, x2, y, 1)
		end

		------------------------------
	end,

	removeSidelinesBarricade = function()
		local m = core.gameRegistry["elixirMap"]
		local x = 2
		local x2 = 29

		--- TOP ---
		for y = 1, 3 do
			local items = core:getObjectsInCell(m, x, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
				setPass(m, x, y, 0)
			end
		end

		for y = 1, 3 do
			local items = core:getObjectsInCell(m, x2, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
				setPass(m, x2, y, 0)
			end
		end

		------------------------------

		--- BOTTOM---
		for y = 38, 40 do
			local items = core:getObjectsInCell(m, x, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
				setPass(m, x, y, 0)
			end
		end

		for y = 38, 40 do
			local items = core:getObjectsInCell(m, x2, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
				setPass(m, x2, y, 0)
			end
		end

		------------------------------
	end,

	setBarricade = function()
		local m = core.gameRegistry["elixirMap"]

		local y = 20

		-- top left
		for x = 1, 15 do
			core:dropItemXY("barricade", 1, 0, 0, m, x, y)
			setPass(m, x, y, 1)
			y = y - 1
		end

		local y = 35

		-- bottom right
		for x = 16, 30 do
			core:dropItemXY("barricade", 1, 0, 0, m, x, y)
			setPass(m, x, y, 1)
			y = y - 1
		end
	end,

	removeBarricade = function()
		local m = core.gameRegistry["elixirMap"]

		local y = 20

		-- top left
		for x = 1, 15 do
			local items = core:getObjectsInCell(m, x, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
			end
			setPass(m, x, y, 0)
			y = y - 1
		end

		local y = 35

		-- bottom right
		for x = 16, 30 do
			local items = core:getObjectsInCell(m, x, y, BL_ITEM)
			for i = 1, #items do
				if items[i].yname == "barricade" then
					items[i]:delete()
				end
			end
			setPass(m, x, y, 0)
			y = y - 1
		end
	end,

	removeOfflinePlayers = function()
		local i = 1
		while i <= #elixirTeams do
			if Player(elixirTeams[i].ID) == nil then
				table.remove(elixirTeams, i)
			else
				i = i + 1
			end
		end
	end,

	teamDye = function(player, team)
		local armor = {}

		local armorColor = {63, 66}

		-- red blue
		local color = {31, 17}

		-- red black blue white

		if player.sex == 0 then
			armor = {12, 4, 10, 21}
		elseif player.sex == 1 then
			armor = {13, 8, 11, 27}
		end

		clone.wipe(player)
		clone.equip(player, player)

		player.gfxShield = -1
		player.gfxShieldC = 0
		player.gfxMantle = -1
		player.gfxMantleC = 0

		player.gfxArmor = armor[player.baseClass]
		player.gfxArmorC = color[team]
		player.gfxDye = armorColor[team]

		player.gfxClone = 1

		player:updateState()
	end,

	clearTeams = function()
		for i = 1, #elixirTeams do
			elixirTeams[i] = nil
		end
	end
}
