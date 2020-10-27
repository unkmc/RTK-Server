carnages = {
	init = function(eventid)
		core.gameRegistry["minigameEventId"] = eventid
		broadcast(
			-1,
			"" .. minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors opening. Tower Arena (184,31 Kugnae)"
		)

		core.gameRegistry["carnageState"] = 1
		core.gameRegistry["carnageStart"] = os.time()
		core.gameRegistry["carnageDye"] = 0
		core.gameRegistry["carnagePoetDone"] = 0
		core.gameRegistry["carnageRogueDone"] = 0
		core.gameRegistry["carnageMageDone"] = 0
		core.gameRegistry["carnageMap"] = 0
		core.gameRegistry["carnageRedScore"] = 0
		core.gameRegistry["carnageBlackScore"] = 0
		core.gameRegistry["carnageWhiteScore"] = 0
		core.gameRegistry["carnageBlueScore"] = 0
		core.gameRegistry["carnageRoundWinner"] = 0
		core.gameRegistry["carnageTopMagePicked"] = 0

		core.gameRegistry["carnageMaxHealth"] = 160000
		core.gameRegistry["carnageMaxMagic"] = 80000

		setMapRegistry(33, "maxHealth", core.gameRegistry["carnageMaxHealth"])
		setMapRegistry(33, "maxMagic", core.gameRegistry["carnageMaxMagic"])

		setMapRegistry(3017, "maxHealth", core.gameRegistry["carnageMaxHealth"])
		setMapRegistry(3017, "maxMagic", core.gameRegistry["carnageMaxMagic"])

		setMapRegistry(3010, "maxHealth", core.gameRegistry["carnageMaxHealth"])
		setMapRegistry(3010, "maxMagic", core.gameRegistry["carnageMaxMagic"])

		setMapRegistry(3011, "maxHealth", core.gameRegistry["carnageMaxHealth"])
		setMapRegistry(3011, "maxMagic", core.gameRegistry["carnageMaxMagic"])

		setObject(3010, 2, 10, 352)
		setObject(3010, 3, 10, 353)

		setObject(3010, 5, 10, 352)
		setObject(3010, 6, 10, 353)

		setObject(3010, 10, 10, 352)
		setObject(3010, 11, 10, 353)

		setObject(3010, 13, 10, 352)
		setObject(3010, 14, 10, 353)

		setObject(3010, 18, 10, 352)
		setObject(3010, 19, 10, 353)

		setObject(3010, 21, 10, 352)
		setObject(3010, 22, 10, 353)

		setObject(3010, 26, 10, 352)
		setObject(3010, 27, 10, 353)

		setObject(3010, 29, 10, 352)
		setObject(3010, 30, 10, 353)

		setObject(3010, 2, 32, 352)
		setObject(3010, 3, 32, 353)

		setObject(3010, 5, 32, 352)
		setObject(3010, 6, 32, 353)

		setObject(3010, 10, 32, 352)
		setObject(3010, 11, 32, 353)

		setObject(3010, 13, 32, 352)
		setObject(3010, 14, 32, 353)

		setObject(3010, 18, 32, 352)
		setObject(3010, 19, 32, 353)

		setObject(3010, 21, 32, 352)
		setObject(3010, 22, 32, 353)

		setObject(3010, 26, 32, 352)
		setObject(3010, 27, 32, 353)

		setObject(3010, 29, 32, 352)
		setObject(3010, 30, 32, 353)

		carnages.openCarnageDoors()
	end,
	openCarnageDoors = function()
		local m = 31
		local obj = getObject(m, 10, 2)
		setObject(m, 10, 2, obj + 18)
		local obj = getObject(m, 11, 2)
		setObject(m, 11, 2, obj + 18)
	end,
	closeCarnageDoors = function()
		local m = 31
		local obj = getObject(m, 10, 2)
		setObject(m, 10, 2, obj - 18)
		local obj = getObject(m, 11, 2)
		setObject(m, 11, 2, obj - 18)
	end,

	closeGame = function()
		if core.gameRegistry["carnageMap"] > 0 then
			local pcs = core:getObjectsInMap(
				core.gameRegistry["carnageMap"],
				BL_PC
			)
			if #pcs ~= nil then
				for i = 1, #pcs do
					clone.wipe(pcs[i])
					pcs[i].registry["carnageTeam"] = 0
					pcs[i]:returnToInn()
				end
			end
		end

		core.gameRegistry["carnageState"] = 0
		core.gameRegistry["carnageStart"] = 0
		core.gameRegistry["minigameEventId"] = 0
		core.gameRegistry["carnageDye"] = 0
		core.gameRegistry["carnagePoetDone"] = 0
		core.gameRegistry["carnageRogueDone"] = 0
		core.gameRegistry["carnageMageDone"] = 0
		core.gameRegistry["carnageMap"] = 0
		core.gameRegistry["carnageRedScore"] = 0
		core.gameRegistry["carnageBlackScore"] = 0
		core.gameRegistry["carnageWhiteScore"] = 0
		core.gameRegistry["carnageBlueScore"] = 0
		core.gameRegistry["carnageRoundWinner"] = 0
		core.gameRegistry["carnageTopMagePicked"] = 0
		core.gameRegistry["carnageRound"] = 0
		core.gameRegistry["carnageRoundTimer"] = 0
		carnages.closeCarnageDoors()
		carnages.clearTeams()
	end,

	timer = function(eventid)
		local maps = {3011, 3010, 33, 3017}
		if (core.gameRegistry["carnageState"] == 1) then
			if (os.time() == core.gameRegistry["carnageStart"] + 600) then
				broadcast(
					-1,
					"" .. minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors closing in 5 minutes. Tower Arena (184,31 Kugnae)"
				)
			end
			if (os.time() == core.gameRegistry["carnageStart"] + 900) then
				if not minigames.minimumPlayerCheck("carnage", 6) then
					broadcast(-1, minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " cancelled due to too few participants.")
					carnages.closeGame()
					return
				end

				broadcast(
					-1,
					"" .. minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " doors closed."
				)
				carnages.closeCarnageDoors()
				for i = 1, #carnageTeams do
					carnageTeams[i] = nil
				end
				core.gameRegistry["carnageState"] = 2
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 2) then
			--broadcast(-1,"letting people enter")
			if (os.time() > core.gameRegistry["carnageStart"] + 60) then
				core.gameRegistry["carnageState"] = 3
			end
		end

		if (core.gameRegistry["carnageState"] == 3) then
			broadcast2(
				maps,
				"[Host Monty]: Please be patient while I setup the teams!"
			)
			local players = core:getObjectsInMap(3010, BL_PC)

			carnageTeams = {}
			local warriors = {}
			local rogues = {}
			local mages = {}
			local poets = {}

			for z = 1, #players do
				if (players[z].baseClass == 1) then
					table.insert(warriors, {
						id = players[z].id,
						stats = players[z].baseMagic + players[z].baseHealth
					})
					carnages.teamDye(players[z], 0)
				end
				if (players[z].baseClass == 2) then
					table.insert(rogues, {
						id = players[z].id,
						stats = players[z].baseMagic + players[z].baseHealth
					})
					carnages.teamDye(players[z], 0)
				end
				if (players[z].baseClass == 3) then
					table.insert(mages, {
						id = players[z].id,
						stats = players[z].baseMagic + players[z].baseHealth
					})
					carnages.teamDye(players[z], 0)
				end
				if (players[z].baseClass == 4) then
					table.insert(poets, {
						id = players[z].id,
						stats = players[z].baseMagic + players[z].baseHealth
					})
					carnages.teamDye(players[z], 0)
				end

				players[z]:calcStat()
			end

			table.sort(warriors, function(a, b)
				return tonumber(a.stats) > tonumber(b.stats)
			end)
			table.sort(rogues, function(a, b)
				return tonumber(a.stats) > tonumber(b.stats)
			end)
			table.sort(mages, function(a, b)
				return tonumber(a.stats) > tonumber(b.stats)
			end)
			table.sort(poets, function(a, b)
				return tonumber(a.stats) > tonumber(b.stats)
			end)

			table.insert(carnageTeams, warriors)
			table.insert(carnageTeams, rogues)
			table.insert(carnageTeams, mages)
			table.insert(carnageTeams, poets)

			core.gameRegistry["carnageState"] = 4
		end

		if (core.gameRegistry["carnageState"] == 4) then
			if (os.time() % 2 == 0) then
				if (#carnageTeams[4] == 0 and core.gameRegistry["carnagePoetDone"] == 0) then
					core.gameRegistry["carnageDye"] = 1
					core.gameRegistry["carnagePoetDone"] = 1
				end

				if (#carnageTeams[3] == 0 and core.gameRegistry["carnageMageDone"] == 0) then
					core.gameRegistry["carnageDye"] = 1
					core.gameRegistry["carnageMageDone"] = 1
				end

				if (#carnageTeams[2] == 0 and core.gameRegistry["carnageRogueDone"] == 0) then
					core.gameRegistry["carnageDye"] = 0
					core.gameRegistry["carnageRogueDone"] = 1
				end

				if (#carnageTeams[4] > 0) then
					carnages.teamDye(
						Player(carnageTeams[4][1].id),
						core.gameRegistry["carnageDye"] % 2 + 1
					)
					core.gameRegistry["carnageDye"] = core.gameRegistry[
						"carnageDye"
					] + 1
					table.remove(carnageTeams[4], 1)
				elseif (#carnageTeams[2] > 0) then
					carnages.teamDye(
						Player(carnageTeams[2][1].id),
						core.gameRegistry["carnageDye"] % 2 + 1
					)
					core.gameRegistry["carnageDye"] = core.gameRegistry[
						"carnageDye"
					] + 1
					table.remove(carnageTeams[2], 1)
				elseif (#carnageTeams[3] > 0) then
					carnages.teamDye(
						Player(carnageTeams[3][1].id),
						core.gameRegistry["carnageDye"] % 2 + 1
					)
					core.gameRegistry["carnageDye"] = core.gameRegistry[
						"carnageDye"
					] + 1
					table.remove(carnageTeams[3], 1)
				elseif (#carnageTeams[1] > 0) then
					carnages.teamDye(
						Player(carnageTeams[1][1].id),
						core.gameRegistry["carnageDye"] % 2 + 1
					)
					core.gameRegistry["carnageDye"] = core.gameRegistry[
						"carnageDye"
					] + 1
					table.remove(carnageTeams[1], 1)
				else
					broadcast2(
						maps,
						"[Host Monty]: Alright teams are setup, get ready to enter!"
					)
					core.gameRegistry["carnageState"] = 5
					core.gameRegistry["carnageStart"] = os.time()
				end
			end
		end

		if (core.gameRegistry["carnageState"] == 5) then
			if (os.time() > core.gameRegistry["carnageStart"] + 5) then
				core.gameRegistry["carnageState"] = 6
			end
		end

		if (core.gameRegistry["carnageState"] == 6) then
			local players = core:getObjectsInMap(3010, BL_PC)
			for z = 1, #players do
				if (players[z].gfxDye == 63) then
					players[z]:warp(3010, 4, 20)
					players[z].registry["carnageDye"] = 63
				elseif (players[z].gfxDye == 60) then
					players[z]:warp(3010, 20, 20)
					players[z].registry["carnageDye"] = 60
				elseif (players[z].gfxDye == 61) then
					players[z]:warp(3010, 12, 20)
					players[z].registry["carnageDye"] = 61
				elseif (players[z].gfxDye == 66) then
					players[z]:warp(3010, 28, 20)
					players[z].registry["carnageDye"] = 66
				end
			end
			core.gameRegistry["carnageState"] = 7
			core.gameRegistry["carnageStart"] = os.time()
		end

		if (core.gameRegistry["carnageState"] == 7) then
			if (os.time() > core.gameRegistry["carnageStart"] + 5) then
				core.gameRegistry["carnageState"] = 8
			end
		end

		if (core.gameRegistry["carnageState"] == 8) then
			if (core.gameRegistry["carnageBlackScore"] < 2 and core.gameRegistry[
				"carnageRedScore"
			] < 2 and core.gameRegistry["carnageWhiteScore"] < 2 and core.gameRegistry[
				"carnageBlueScore"
			] < 2) then
				local players = core:getObjectsInMap(3010, BL_PC)
				if (#players <= 100) then
					--core.gameRegistry["carnageMap"] = 3011
					--core.gameRegistry["carnageMap"] = 33
					core.gameRegistry["carnageMap"] = 3017
					carnages.setBarricade()
				end
				setObject(3010, 2, 10, 370)
				setObject(3010, 3, 10, 371)
				setObject(3010, 5, 10, 370)
				setObject(3010, 6, 10, 371)
				setObject(3010, 10, 10, 370)
				setObject(3010, 11, 10, 371)
				setObject(3010, 13, 10, 370)
				setObject(3010, 14, 10, 371)
				setObject(3010, 18, 10, 370)
				setObject(3010, 19, 10, 371)
				setObject(3010, 21, 10, 370)
				setObject(3010, 22, 10, 371)
				setObject(3010, 26, 10, 370)
				setObject(3010, 27, 10, 371)
				setObject(3010, 29, 10, 370)
				setObject(3010, 30, 10, 371)
				broadcast2(
					maps,
					"[Host Monty]: Doors are open, please enter the arena!"
				)
				core.gameRegistry["carnageState"] = 9
				core.gameRegistry["carnageStart"] = os.time()
			else
				core.gameRegistry["carnageState"] = 100
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 9) then
			if (os.time() > core.gameRegistry["carnageStart"] + 30) then
				broadcast2(
					maps,
					"[Host Monty]: Round is starting in 30 seconds."
				)
				core.gameRegistry["carnageState"] = 10
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 10) then
			if (os.time() > core.gameRegistry["carnageStart"] + 15) then
				broadcast2(
					maps,
					"[Host Monty]: Round is starting in 15 seconds."
				)
				core.gameRegistry["carnageState"] = 11
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 11) then
			if (os.time() > core.gameRegistry["carnageStart"] + 10) then
				broadcast2(
					maps,
					"[Host Monty]: Round is starting in 5 seconds. Get ready!"
				)
				local traps = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_NPC
				)
				if (#traps > 0) then
					for z = 1, #traps do
						if (traps[z].type == 2) then
							traps[z].delete()
						end
					end
				end
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				if (#players > 0) then
					for z = 1, #players do
						players[z]:talkSelf(2, "All traps have been removed!")
					end
				end
				setObject(3010, 2, 10, 352)
				setObject(3010, 3, 10, 353)
				setObject(3010, 5, 10, 352)
				setObject(3010, 6, 10, 353)
				setObject(3010, 10, 10, 352)
				setObject(3010, 11, 10, 353)
				setObject(3010, 13, 10, 352)
				setObject(3010, 14, 10, 353)
				setObject(3010, 18, 10, 352)
				setObject(3010, 19, 10, 353)
				setObject(3010, 21, 10, 352)
				setObject(3010, 22, 10, 353)
				setObject(3010, 26, 10, 352)
				setObject(3010, 27, 10, 353)
				setObject(3010, 29, 10, 352)
				setObject(3010, 30, 10, 353)
				core.gameRegistry["carnageState"] = 12
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 12) then
			if (os.time() > core.gameRegistry["carnageStart"] + 5) then
				broadcast2(maps, "[Host Monty]: Fight!")
				core.gameRegistry["carnageState"] = 13
				carnages.removeBarricade()
				core.gameRegistry["carnageStart"] = os.time()
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				if (#players > 0) then
					for z = 1, #players do
						players[z]:setTimer(2, 10 * 60)
					end
				end
				setObject(3010, 2, 10, 352)
				setObject(3010, 3, 10, 353)
				setObject(3010, 5, 10, 352)
				setObject(3010, 6, 10, 353)
				setObject(3010, 10, 10, 352)
				setObject(3010, 11, 10, 353)
				setObject(3010, 13, 10, 352)
				setObject(3010, 14, 10, 353)
				setObject(3010, 18, 10, 352)
				setObject(3010, 19, 10, 353)
				setObject(3010, 21, 10, 352)
				setObject(3010, 22, 10, 353)
				setObject(3010, 26, 10, 352)
				setObject(3010, 27, 10, 353)
				setObject(3010, 29, 10, 352)
				setObject(3010, 30, 10, 353)
			end
		end

		if (core.gameRegistry["carnageState"] == 13) then
			if (os.time() % 3 == 0) then
				local black = 0
				local red = 0
				local blue = 0
				local white = 0
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					if (players[z].gfxDye == 60 and players[z].state ~= 1) then
						black = black + 1
					end
					if (players[z].gfxDye == 61 and players[z].state ~= 1) then
						white = white + 1
					end
					if (players[z].gfxDye == 63 and players[z].state ~= 1) then
						red = red + 1
					end
					if (players[z].gfxDye == 66 and players[z].state ~= 1) then
						blue = blue + 1
					end
				end

				if (red == 0 and blue == 0 and white == 0 and black > 0) then
					--black wins
					core.gameRegistry["carnageBlackScore"] = core.gameRegistry[
						"carnageBlackScore"
					] + 1
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageRoundWinner"] = 1
				end
				if (black == 0 and blue == 0 and white == 0 and red > 0) then
					-- red wins
					core.gameRegistry["carnageRedScore"] = core.gameRegistry[
						"carnageRedScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 2
				end
				if (black == 0 and blue == 0 and red == 0 and white > 0) then
					-- white wins
					core.gameRegistry["carnageWhiteScore"] = core.gameRegistry[
						"carnageWhiteScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 3
				end
				if (black == 0 and white == 0 and red == 0 and blue > 0) then
					-- blue wins
					core.gameRegistry["carnageBlueScore"] = core.gameRegistry[
						"carnageBlueScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 4
				end
			end
			if (os.time() > core.gameRegistry["carnageStart"] + 600) then
				broadcast2(
					maps,
					"[Host Monty]: Stop fighting! We will begin circle shortly."
				)
				broadcast2(
					maps,
					"[Host Monty]: Players will have 5 minutes to kill as many as possible!"
				)
				broadcast2(
					maps,
					"[Host Monty]: The team with the most alive at the end will win the round!"
				)
				core.gameRegistry["carnageState"] = 1000
				core.gameRegistry["carnageStart"] = os.time()
				setMapPvP(core.gameRegistry["carnageMap"], 0)
			end
		end

		if (core.gameRegistry["carnageState"] == 14) then
			if (os.time() > core.gameRegistry["carnageStart"] + 10) then
				if (core.gameRegistry["carnageRoundWinner"] == 1) then
					broadcast2(maps, "[Host Monty]: Black wins the round! ")
				end
				if (core.gameRegistry["carnageRoundWinner"] == 2) then
					broadcast2(maps, "[Host Monty]: Red wins the round! ")
				end
				if (core.gameRegistry["carnageRoundWinner"] == 3) then
					broadcast2(maps, "[Host Monty]: White wins the round! ")
				end
				if (core.gameRegistry["carnageRoundWinner"] == 4) then
					broadcast2(maps, "[Host Monty]: Blue wins the round! ")
				end

				core.gameRegistry["carnageState"] = 15
				core.gameRegistry["carnageStart"] = os.time()

				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					players[z]:setTimer(2, 0)
				end
			end
		end

		if (core.gameRegistry["carnageState"] == 15) then
			-- warp players back and start next round
			local players = core:getObjectsInMap(
				core.gameRegistry["carnageMap"],
				BL_PC
			)
			for z = 1, #players do
				players[z].state = 0
				players[z].disguise = 0
				players[z].speed = 90
				players[z]:calcStat()
				players[z].health = players[z].maxHealth
				players[z].magic = players[z].maxMagic
				players[z]:flushDuration(1)
				players[z]:updateState()
				if (players[z].gfxDye == 63) then
					players[z]:warp(3010, 4, 20)
				elseif (players[z].gfxDye == 60) then
					players[z]:warp(3010, 20, 20)
				elseif (players[z].gfxDye == 61) then
					players[z]:warp(3010, 12, 20)
				elseif (players[z].gfxDye == 66) then
					players[z]:warp(3010, 28, 20)
				end
			end
			broadcast2(maps, "[Host Monty]: Current score is...")
			broadcast2(maps, "- Red: " .. core.gameRegistry["carnageRedScore"])
			broadcast2(
				maps,
				"- Black: " .. core.gameRegistry["carnageBlackScore"]
			)
			broadcast2(
				maps,
				"- Blue: " .. core.gameRegistry["carnageBlueScore"]
			)
			broadcast2(
				maps,
				"- White: " .. core.gameRegistry["carnageWhiteScore"]
			)
			core.gameRegistry["carnageState"] = 16
			core.gameRegistry["carnageStart"] = os.time()
		end

		if (core.gameRegistry["carnageState"] == 16) then
			if (os.time() > core.gameRegistry["carnageStart"] + 30) then
				-- changing to 30s to let aethers clear a little bit not adding flushAether()
				core.gameRegistry["carnageState"] = 8
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 100) then
			local players = core:getObjectsInMap(3010, BL_PC)

			if (core.gameRegistry["carnageBlackScore"] >= 2) then
				broadcast2(
					maps,
					"[Host Monty]: Congratulations to the Black team. Please exit through the doors at the bottom."
				)
				setObject(3010, 18, 32, 370)
				setObject(3010, 19, 32, 371)
			else
				setObject(3010, 21, 32, 370)
				setObject(3010, 22, 32, 371)
			end

			if (core.gameRegistry["carnageWhiteScore"] >= 2) then
				broadcast2(
					maps,
					"[Host Monty]: Congratulations to the White team. Please exit through the doors at the bottom."
				)
				setObject(3010, 10, 32, 370)
				setObject(3010, 11, 32, 371)
			else
				setObject(3010, 13, 32, 370)
				setObject(3010, 14, 32, 371)
			end

			if (core.gameRegistry["carnageRedScore"] >= 2) then
				broadcast2(
					maps,
					"[Host Monty]: Congratulations to the Red team. Please exit through the doors at the bottom."
				)
				setObject(3010, 2, 32, 370)
				setObject(3010, 3, 32, 371)
			else
				setObject(3010, 5, 32, 370)
				setObject(3010, 6, 32, 371)
			end

			if (core.gameRegistry["carnageBlueScore"] >= 2) then
				broadcast2(
					maps,
					"[Host Monty]: Congratulations to the Blue team. Please exit through the doors at the bottom."
				)
				setObject(3010, 26, 32, 370)
				setObject(3010, 27, 32, 371)
			else
				setObject(3010, 29, 32, 370)
				setObject(3010, 30, 32, 371)
			end

			setObject(3010, 2, 10, 352)
			setObject(3010, 3, 10, 353)
			setObject(3010, 5, 10, 352)
			setObject(3010, 6, 10, 353)
			setObject(3010, 10, 10, 352)
			setObject(3010, 11, 10, 353)
			setObject(3010, 13, 10, 352)
			setObject(3010, 14, 10, 353)
			setObject(3010, 18, 10, 352)
			setObject(3010, 19, 10, 353)
			setObject(3010, 21, 10, 352)
			setObject(3010, 22, 10, 353)
			setObject(3010, 26, 10, 352)
			setObject(3010, 27, 10, 353)
			setObject(3010, 29, 10, 352)
			setObject(3010, 30, 10, 353)

			core.gameRegistry["carnageState"] = 101
		end

		--------------------- Circle Scripts

		if (core.gameRegistry["carnageState"] == 1000) then
			if (os.time() > core.gameRegistry["carnageStart"] + 5) then
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					players[z]:flushDuration(1)
				end
				carnages.setCircleBarricade()
				carnages.summonCircle()
				core.gameRegistry["carnageState"] = 1001
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 1001) then
			if (os.time() > core.gameRegistry["carnageStart"] + 5) then
				broadcast2(
					maps,
					"[Host Monty]: Circle round will begin in 15 seconds."
				)
				core.gameRegistry["carnageState"] = 1002
				core.gameRegistry["carnageStart"] = os.time()
			end
		end

		if (core.gameRegistry["carnageState"] == 1002) then
			if (os.time() > core.gameRegistry["carnageStart"] + 15) then
				broadcast2(maps, "[Host Monty]: Circle Fight!")
				core.gameRegistry["carnageState"] = 1003
				core.gameRegistry["carnageStart"] = os.time()
				setMapPvP(core.gameRegistry["carnageMap"], 1)
				carnages.startCircle()
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					players[z]:setTimer(2, 5 * 60)
				end
			end
		end
		if (core.gameRegistry["carnageState"] == 1003) then
			if (os.time() % 3 == 0) then
				local black = 0
				local red = 0
				local white = 0
				local blue = 0
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					if (players[z].gfxDye == 60 and players[z].state ~= 1) then
						black = black + 1
					end
					if (players[z].gfxDye == 61 and players[z].state ~= 1) then
						white = white + 1
					end
					if (players[z].gfxDye == 63 and players[z].state ~= 1) then
						red = red + 1
					end
					if (players[z].gfxDye == 66 and players[z].state ~= 1) then
						blue = blue + 1
					end
				end

				if (red == 0 and blue == 0 and white == 0 and black > 0) then
					--black wins
					core.gameRegistry["carnageBlackScore"] = core.gameRegistry[
						"carnageBlackScore"
					] + 1
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageRoundWinner"] = 1
					carnages.removeCircleBarricade()
				end
				if (black == 0 and blue == 0 and white == 0 and red > 0) then
					-- red wins
					core.gameRegistry["carnageRedScore"] = core.gameRegistry[
						"carnageRedScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 2
					carnages.removeCircleBarricade()
				end
				if (black == 0 and blue == 0 and red == 0 and white > 0) then
					-- white wins
					core.gameRegistry["carnageWhiteScore"] = core.gameRegistry[
						"carnageWhiteScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 3
					carnages.removeCircleBarricade()
				end
				if (black == 0 and white == 0 and red == 0 and blue > 0) then
					-- blue wins
					core.gameRegistry["carnageBlueScore"] = core.gameRegistry[
						"carnageBlueScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 4
					carnages.removeCircleBarricade()
				end
			end

			if (os.time() > core.gameRegistry["carnageStart"] + 300) then
				local black = 0
				local red = 0
				local white = 0
				local blue = 0
				local players = core:getObjectsInMap(
					core.gameRegistry["carnageMap"],
					BL_PC
				)
				for z = 1, #players do
					if (players[z].gfxDye == 60 and players[z].state ~= 1) then
						black = black + 1
					end
					if (players[z].gfxDye == 61 and players[z].state ~= 1) then
						white = white + 1
					end
					if (players[z].gfxDye == 63 and players[z].state ~= 1) then
						red = red + 1
					end
					if (players[z].gfxDye == 66 and players[z].state ~= 1) then
						blue = blue + 1
					end
				end

				if (black > red and black > blue and black > white) then
					core.gameRegistry["carnageBlackScore"] = core.gameRegistry[
						"carnageBlackScore"
					] + 1
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageRoundWinner"] = 1
					carnages.removeCircleBarricade()
				elseif (red > black and red > blue and red > white) then
					core.gameRegistry["carnageRedScore"] = core.gameRegistry[
						"carnageRedScore"
					] + 1
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageRoundWinner"] = 2
					carnages.removeCircleBarricade()
				elseif (white > red and white > blue and white > black) then
					core.gameRegistry["carnageWhiteScore"] = core.gameRegistry[
						"carnageWhiteScore"
					] + 1
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageRoundWinner"] = 3
					carnages.removeCircleBarricade()
				elseif (blue > red and blue > white and blue > black) then
					core.gameRegistry["carnageBlueScore"] = core.gameRegistry[
						"carnageBlueScore"
					] + 1
					core.gameRegistry["carnageStart"] = os.time()
					core.gameRegistry["carnageState"] = 14
					core.gameRegistry["carnageRoundWinner"] = 4
					carnages.removeCircleBarricade()
				else
					broadcast2(maps, "[Host Monty]: Time's up! Nobody wins.")
					core.gameRegistry["carnageState"] = 15
					core.gameRegistry["carnageStart"] = os.time()
					carnages.removeCircleBarricade()
				end
			end
		end

		--[[
	if core.gameRegistry["carnagePreSession"] == 1 and os.time() % 5 == 0 then
		carnages.chooseMap()
		carnages.autoTeamBalance()
	end
	if core.gameRegistry["carnageBeginSession"] == 1 then
		carnages.gameStartBroadcast()
		carnages.scoreBroadcast()

		if core.gameRegistry["carnageRoundTimer"] == 0 then
			carnages.setBarricade()
			core.gameRegistry["carnageRoundTimer"] = os.time() + 120
		end

		if os.time() == core.gameRegistry["carnageRoundTimer"] - 90 then
			carnages.setDoors("close")
		end

		local m = core.gameRegistry["carnageMap"]

		if os.time() < core.gameRegistry["carnageRoundTimer"] then

			local timeRemaining = math.abs(core.gameRegistry["carnageRoundTimer"] - os.time())

			local players = core:getObjectsInMap(m,BL_PC)

			if players ~= nil then
				for i = 1, #players do
				 	players[i]:setTimer(2, timeRemaining)
				end
			end

			local maxRounds = 0

			if core.gameRegistry["carnage4team"] == 0 then
					maxRounds = 3
			elseif core.gameRegistry["carnage4team"] == 1 then
					maxRounds = 5
			end

			if timeRemaining % 30 == 0 or timeRemaining == 15 then
				broadcast(m,"Round "..core.gameRegistry["carnageRound"].." of "..maxRounds.." will begin in "..timeRemaining.." seconds")
			elseif timeRemaining == 10 or timeRemaining == 5 then
				broadcast(m,"The round will begin in "..timeRemaining.." seconds. Get ready!")
			end

		end

		if os.time() == core.gameRegistry["carnageRoundTimer"] then
			broadcast(m,"FIGHT!")
			carnages.removeBarricade()
		end

		if os.time() >= core.gameRegistry["carnageRoundTimer"] then

			local startMiniRound = carnages.playerCountCheck()

			if startMiniRound == true and core.gameRegistry["carnageRoundMiniTimer"] == 0 then
				core.gameRegistry["carnageRoundMiniTimer"] = os.time() + 60

				local timeRemaining = math.abs(core.gameRegistry["carnageRoundMiniTimer"] - os.time())
				local m = core.gameRegistry["carnageMap"]

				local players = core:getObjectsInMap(m,BL_PC)

				if players ~= nil then
					for i = 1, #players do
					 	players[i]:setTimer(2, timeRemaining)
					end
				end

				broadcast(m, "Beginning Mini Round Fight. Get Ready!")
				carnages.setMiniBarricade()
				carnages.warpPlayersMini()

			end

			if os.time() == core.gameRegistry["carnageRoundMiniTimer"] then
				carnages.removeMiniBarricade()
			end

			carnages.scoreCheck()

		end

	end
	]]
		--
	end,

	scoreCheck = function()
		local redTeam = carnages.getAlivePlayers(1)
		local blueTeam = carnages.getAlivePlayers(2)
		local blackTeam = carnages.getAlivePlayers(3)
		local whiteTeam = carnages.getAlivePlayers(4)

		local winner = false

		if core.gameRegistry["carnage4team"] == 0 then
			-- 2 team

			if redTeam == 0 then
				broadcast(-1, "Blue team wins the round.")
				core.gameRegistry["carnageBlueTeamWins"] = core.gameRegistry[
					"carnageTeamBlueWins"
				] + 1
				winner = true
			elseif blueTeam == 0 then
				broadcast(-1, "Red team wins the round.")
				core.gameRegistry["carnageRedTeamWins"] = core.gameRegistry[
					"carnageTeamRedWins"
				] + 1
				winner = true
			end
		elseif core.gameRegistry["carnage4team"] == 1 then
			-- 4 team
			local alivePlayers = {redTeam, blueTeam, blackTeam, whiteTeam}
			local count = 0
			local winningTeam = 0
			for i = 1, #alivePlayers do
				if alivePlayers[i] == 0 then
					count = count + 1
				end
			end

			if count == 3 then
				-- one team remains
				local winningTeam = 0

				for i = 1, #alivePlayers do
					if alivePlayers[i] ~= 0 then
						-- find the winning team
						winningTeam = i
						break
					end
				end

				if winningTeam == 1 then
					-- red team
					broadcast(-1, "Red team wins the round.")
					core.gameRegistry["carnageRedTeamWins"] = core.gameRegistry[
						"carnageRedTeamWins"
					] + 1
					winner = true
				elseif winningTeam == 2 then
					-- blue team
					broadcast(-1, "Blue team wins the round.")
					core.gameRegistry["carnageBlueTeamWins"] = core.gameRegistry[
						"carnageBlueTeamWins"
					] + 1
					winner = true
				elseif winningTeam == 3 then
					-- black team
					broadcast(-1, "Black team wins the round.")
					core.gameRegistry["carnageBlackTeamWins"] = core.gameRegistry[
						"carnageBlackTeamWins"
					] + 1
					winner = true
				elseif winningTeam == 4 then
					-- white team
					broadcast(-1, "White team wins the round.")
					core.gameRegistry["carnageWhiteTeamWins"] = core.gameRegistry[
						"carnageWhiteTeamWins"
					] + 1
					winner = true
				end
			end
		end

		if winner == true then
			core.gameRegistry["carnageRound"] = core.gameRegistry[
				"carnageRound"
			] + 1

			carnages.roomResurrect()

			if core.gameRegistry["carnageRound"] < 3 then
				carnages.resetRound()
			elseif core.gameRegistry["carnageRound"] >= 4 then
				carnages.endGameWarp()
			end
		end
	end,

	scoreBroadcast = function()
		local m = core.gameRegistry["carnageMap"]

		local players = core:getObjectsInMap(m, BL_PC)
		local aliveText = ""
		aliveText = aliveText .. "Red alive: " .. carnages.getAlivePlayers(1) .. "\n"
		aliveText = aliveText .. "Blue alive: " .. carnages.getAlivePlayers(2) .. "\n"

		if core.gameRegistry["carnage4team"] == 1 then
			aliveText = aliveText .. "Black alive: " .. carnages.getAlivePlayers(3) .. "\n"
			aliveText = aliveText .. "White alive: " .. carnages.getAlivePlayers(4) .. "\n"
		end

		if players ~= nil then
			for i = 1, #players do
				for j = 1, #carnageTeams do
					if carnageTeams[j].ID == players[i].ID then
						local text = ""
						text = text .. "Kills: " .. carnageTeams[j].kills .. " | Deaths: " .. carnageTeams[
							j
						].deaths .. "\n"
						text = text .. "\n" .. aliveText

						players[i]:guitext(text)
						break
					end
				end
			end
		end
	end,

	warpPlayersMini = function()
		local m = core.gameRegistry["carnageMap"]

		local pcs = core:getObjectsInMap(m, BL_PC)

		if pcs == nil then
			return
		end

		local team1x, team1y, team2x, team2y, team3x, team3y, team4x, team4y

		if m == 33 then
			team1x = math.random(17, 23)
			team1y = math.random(4, 9)
			team2x = math.random(26, 32)
			team2y = math.random(4, 9)
			team3x = math.random(17, 23)
			team3y = math.random(11, 16)
			team4x = math.random(26, 32)
			team4y = math.random(11, 16)
		end

		for i = 1, #pcs do
			for j = 1, #carnageTeams do
				if pcs[i].ID == carnageTeams[j].ID then
					local team = carnageTeams[j].team

					if team == 1 then
						pcs[i]:warp(m, team1x, team1y)
					elseif team == 2 then
						pcs[i]:warp(m, team2x, team2y)
					elseif team == 3 then
						pcs[i]:warp(m, team3x, team3y)
					elseif team == 4 then
						pcs[i]:warp(m, team4x, team4y)
					end
				end
			end
		end
	end,

	playerCountCheck = function()
		local val = false
		local alive = 0

		local m = core.gameRegistry["carnageMap"]

		local players = core:getObjectsInMap(m, BL_PC)

		if players == nil then
			return false
		end

		for i = 1, #players do
			if players[i].state ~= 1 then
				--alive
				alive = alive + 1
			end
		end

		if core.gameRegistry["carnage4team"] == 0 then
			-- 2 team
			if alive < 8 then
				val = true
			end
		elseif core.gameRegistry["carnage4team"] == 1 then
			-- 4 team
			if alive < 16 then
				val = true
			end
		end

		return val
	end,

	getAlivePlayers = function(team)
		local alive = 0

		for j = 1, #carnageTeams do
			if Player(carnageTeams[j].ID) ~= nil then
				if Player(carnageTeams[j].ID).state ~= 1 and carnageTeams[j].team == team then
					alive = alive + 1
				end
			end
		end

		return alive
	end,

	gameStartBroadcast = function()
		local pcs = core:getObjectsInMap(3010, BL_PC)

		if pcs == nil then
			return
		end

		for i = 1, #pcs do
			pcs[i]:guitext("Pre carnage session has ended. Teams balanced.\nProceed through the doors.")
		end
	end,

	resetRound = function()
		core.gameRegistry["carnageRoundTimer"] = 0
	end,

	roomResurrect = function()
		local m = core.gameRegistry["carnageMap"]

		local players = core:getObjectsInMap(m, BL_PC)

		if players == nil then
			return
		end

		for z = 1, #players do
			if players[z].state == 1 then
				--dead
				players[z].state = 0
				players[z].disguise = 0
				players[z].speed = 90
				players[z]:calcStat()
				players[z].health = players[z].maxHealth
				players[z].magic = players[z].maxMagic
				players[z]:flushDuration(1)
				players[z]:updateState()
			end
		end
	end,
	dropBarricade = function(m, x, y)
		core:dropItemXY("barricade", 1, 0, 0, m, x, y)
		setPass(m, x, y, 1)
	end,
	deleteBarricade = function(m, x, y)
		local items = core:getObjectsInCell(m, x, y, BL_ITEM)
		if (#items > 0) then
			for z = 1, #items do
				if items[z].yname == "barricade" then
					items[z]:delete()
				end
			end
		end
		setPass(m, x, y, 0)
	end,
	chooseMap = function()
		if core.gameRegistry["carnageMap"] == 0 then
			local carnageMaps = {31, 3009, 3011, 3016, 3017}
			core.gameRegistry["carnageMap"] = carnageMaps[
				math.random(1, #carnageMaps)
			]
		end
	end,
	summonCircle = function()
		local m = core.gameRegistry["carnageMap"]
		local players = core:getObjectsInMap(
			core.gameRegistry["carnageMap"],
			BL_PC
		)

		if m == 3011 then
			for z = 1, #players do
				if (players[z].state == 0) then
					players[z].health = players[z].maxHealth
					if (players[z].gfxDye == 63) then
						players[z]:warp(m, 12, 14)
					elseif (players[z].gfxDye == 60) then
						players[z]:warp(m, 19, 17)
					end
				end
			end
		end

		if m == 33 then
			for z = 1, #players do
				if (players[z].state == 0) then
					players[z].health = players[z].maxHealth
					if (players[z].gfxDye == 63) then
						players[z]:warp(m, 20, 21)
					elseif (players[z].gfxDye == 60) then
						players[z]:warp(m, 28, 29)
					elseif (players[z].gfxDye == 61) then
						players[z]:warp(m, 20, 29)
					elseif (players[z].gfxDye == 66) then
						players[z]:warp(m, 28, 21)
					end
				end
			end
		end
		if m == 3017 then
			for z = 1, #players do
				if (players[z].state == 0) then
					players[z].health = players[z].maxHealth
					players[z].magic = players[z].maxMagic
					if (players[z].gfxDye == 63) then
						players[z]:warp(m, 23, 22)
					elseif (players[z].gfxDye == 60) then
						players[z]:warp(m, 17, 16)
					elseif (players[z].gfxDye == 61) then
						players[z]:warp(m, 17, 22)
					elseif (players[z].gfxDye == 66) then
						players[z]:warp(m, 23, 16)
					end
				end
			end
		end
	end,
	setCircleBarricade = function()
		local m = core.gameRegistry["carnageMap"]
		if m == 3011 then
			carnages.dropBarricade(m, 11, 13)
			carnages.dropBarricade(m, 12, 13)
			carnages.dropBarricade(m, 13, 13)
			carnages.dropBarricade(m, 14, 13)
			carnages.dropBarricade(m, 15, 13)
			carnages.dropBarricade(m, 16, 13)
			carnages.dropBarricade(m, 17, 13)
			carnages.dropBarricade(m, 18, 13)
			carnages.dropBarricade(m, 19, 13)
			carnages.dropBarricade(m, 20, 13)
			carnages.dropBarricade(m, 11, 18)
			carnages.dropBarricade(m, 12, 18)
			carnages.dropBarricade(m, 13, 18)
			carnages.dropBarricade(m, 14, 18)
			carnages.dropBarricade(m, 15, 18)
			carnages.dropBarricade(m, 16, 18)
			carnages.dropBarricade(m, 17, 18)
			carnages.dropBarricade(m, 18, 18)
			carnages.dropBarricade(m, 19, 18)
			carnages.dropBarricade(m, 20, 18)
			carnages.dropBarricade(m, 11, 14)
			carnages.dropBarricade(m, 11, 15)
			carnages.dropBarricade(m, 11, 16)
			carnages.dropBarricade(m, 11, 17)
			carnages.dropBarricade(m, 20, 14)
			carnages.dropBarricade(m, 20, 15)
			carnages.dropBarricade(m, 20, 16)
			carnages.dropBarricade(m, 20, 17)

			carnages.dropBarricade(m, 15, 14)
			carnages.dropBarricade(m, 15, 15)
			carnages.dropBarricade(m, 15, 16)
			carnages.dropBarricade(m, 15, 17)

			carnages.dropBarricade(m, 16, 14)
			carnages.dropBarricade(m, 16, 15)
			carnages.dropBarricade(m, 16, 16)
			carnages.dropBarricade(m, 16, 17)
		end
		if m == 3017 then
			for x = 16, 24 do
				carnages.dropBarricade(m, x, 15)
				carnages.dropBarricade(m, x, 23)
			end
			for y = 16, 22 do
				carnages.dropBarricade(m, 16, y)
				carnages.dropBarricade(m, 20, y)
				carnages.dropBarricade(m, 24, y)
			end
			carnages.dropBarricade(m, 17, 19)
			carnages.dropBarricade(m, 18, 19)
			carnages.dropBarricade(m, 19, 19)
			carnages.dropBarricade(m, 21, 19)
			carnages.dropBarricade(m, 22, 19)
			carnages.dropBarricade(m, 23, 19)
		end
		if m == 33 then
			carnages.dropBarricade(m, 19, 20)
			carnages.dropBarricade(m, 20, 20)
			carnages.dropBarricade(m, 21, 20)
			carnages.dropBarricade(m, 22, 20)
			carnages.dropBarricade(m, 23, 20)
			carnages.dropBarricade(m, 24, 20)
			carnages.dropBarricade(m, 25, 20)
			carnages.dropBarricade(m, 26, 20)
			carnages.dropBarricade(m, 27, 20)
			carnages.dropBarricade(m, 28, 20)
			carnages.dropBarricade(m, 29, 20)

			carnages.dropBarricade(m, 19, 30)
			carnages.dropBarricade(m, 20, 30)
			carnages.dropBarricade(m, 21, 30)
			carnages.dropBarricade(m, 22, 30)
			carnages.dropBarricade(m, 23, 30)
			carnages.dropBarricade(m, 24, 30)
			carnages.dropBarricade(m, 25, 30)
			carnages.dropBarricade(m, 26, 30)
			carnages.dropBarricade(m, 27, 30)
			carnages.dropBarricade(m, 28, 30)
			carnages.dropBarricade(m, 29, 30)

			carnages.dropBarricade(m, 19, 21)
			carnages.dropBarricade(m, 19, 22)
			carnages.dropBarricade(m, 19, 23)
			carnages.dropBarricade(m, 19, 24)
			carnages.dropBarricade(m, 19, 25)
			carnages.dropBarricade(m, 19, 26)
			carnages.dropBarricade(m, 19, 27)
			carnages.dropBarricade(m, 19, 28)
			carnages.dropBarricade(m, 19, 29)

			carnages.dropBarricade(m, 29, 21)
			carnages.dropBarricade(m, 29, 22)
			carnages.dropBarricade(m, 29, 23)
			carnages.dropBarricade(m, 29, 24)
			carnages.dropBarricade(m, 29, 25)
			carnages.dropBarricade(m, 29, 26)
			carnages.dropBarricade(m, 29, 27)
			carnages.dropBarricade(m, 29, 28)
			carnages.dropBarricade(m, 29, 29)

			---
			carnages.dropBarricade(m, 24, 25)

			carnages.dropBarricade(m, 20, 25)
			carnages.dropBarricade(m, 21, 25)
			carnages.dropBarricade(m, 22, 25)
			carnages.dropBarricade(m, 23, 25)

			carnages.dropBarricade(m, 25, 25)
			carnages.dropBarricade(m, 26, 25)
			carnages.dropBarricade(m, 27, 25)
			carnages.dropBarricade(m, 28, 25)

			carnages.dropBarricade(m, 24, 21)
			carnages.dropBarricade(m, 24, 22)
			carnages.dropBarricade(m, 24, 23)
			carnages.dropBarricade(m, 24, 24)

			carnages.dropBarricade(m, 24, 26)
			carnages.dropBarricade(m, 24, 27)
			carnages.dropBarricade(m, 24, 28)
			carnages.dropBarricade(m, 24, 29)

			---
		end
	end,
	removeCircleBarricade = function()
		local m = core.gameRegistry["carnageMap"]
		if m == 3011 then
			carnages.deleteBarricade(m, 11, 13)
			carnages.deleteBarricade(m, 12, 13)
			carnages.deleteBarricade(m, 13, 13)
			carnages.deleteBarricade(m, 14, 13)
			carnages.deleteBarricade(m, 15, 13)
			carnages.deleteBarricade(m, 16, 13)
			carnages.deleteBarricade(m, 17, 13)
			carnages.deleteBarricade(m, 18, 13)
			carnages.deleteBarricade(m, 19, 13)
			carnages.deleteBarricade(m, 20, 13)
			carnages.deleteBarricade(m, 11, 18)
			carnages.deleteBarricade(m, 12, 18)
			carnages.deleteBarricade(m, 13, 18)
			carnages.deleteBarricade(m, 14, 18)
			carnages.deleteBarricade(m, 15, 18)
			carnages.deleteBarricade(m, 16, 18)
			carnages.deleteBarricade(m, 17, 18)
			carnages.deleteBarricade(m, 18, 18)
			carnages.deleteBarricade(m, 19, 18)
			carnages.deleteBarricade(m, 20, 18)
			carnages.deleteBarricade(m, 11, 14)
			carnages.deleteBarricade(m, 11, 15)
			carnages.deleteBarricade(m, 11, 16)
			carnages.deleteBarricade(m, 11, 17)
			carnages.deleteBarricade(m, 20, 14)
			carnages.deleteBarricade(m, 20, 15)
			carnages.deleteBarricade(m, 20, 16)
			carnages.deleteBarricade(m, 20, 17)

			carnages.deleteBarricade(m, 15, 14)
			carnages.deleteBarricade(m, 15, 15)
			carnages.deleteBarricade(m, 15, 16)
			carnages.deleteBarricade(m, 15, 17)

			carnages.deleteBarricade(m, 16, 14)
			carnages.deleteBarricade(m, 16, 15)
			carnages.deleteBarricade(m, 16, 16)
			carnages.deleteBarricade(m, 16, 17)
		end
		if m == 3017 then
			for x = 16, 24 do
				carnages.deleteBarricade(m, x, 15)
				carnages.deleteBarricade(m, x, 23)
			end
			for y = 16, 22 do
				carnages.deleteBarricade(m, 16, y)
				carnages.deleteBarricade(m, 20, y)
				carnages.deleteBarricade(m, 24, y)
			end
			carnages.deleteBarricade(m, 17, 19)
			carnages.deleteBarricade(m, 18, 19)
			carnages.deleteBarricade(m, 19, 19)
			carnages.deleteBarricade(m, 21, 19)
			carnages.deleteBarricade(m, 22, 19)
			carnages.deleteBarricade(m, 23, 19)
		end
		if m == 33 then
			carnages.deleteBarricade(m, 19, 20)
			carnages.deleteBarricade(m, 20, 20)
			carnages.deleteBarricade(m, 21, 20)
			carnages.deleteBarricade(m, 22, 20)
			carnages.deleteBarricade(m, 23, 20)
			carnages.deleteBarricade(m, 24, 20)
			carnages.deleteBarricade(m, 25, 20)
			carnages.deleteBarricade(m, 26, 20)
			carnages.deleteBarricade(m, 27, 20)
			carnages.deleteBarricade(m, 28, 20)
			carnages.deleteBarricade(m, 29, 20)

			carnages.deleteBarricade(m, 19, 30)
			carnages.deleteBarricade(m, 20, 30)
			carnages.deleteBarricade(m, 21, 30)
			carnages.deleteBarricade(m, 22, 30)
			carnages.deleteBarricade(m, 23, 30)
			carnages.deleteBarricade(m, 24, 30)
			carnages.deleteBarricade(m, 25, 30)
			carnages.deleteBarricade(m, 26, 30)
			carnages.deleteBarricade(m, 27, 30)
			carnages.deleteBarricade(m, 28, 30)
			carnages.deleteBarricade(m, 29, 30)

			carnages.deleteBarricade(m, 19, 21)
			carnages.deleteBarricade(m, 19, 22)
			carnages.deleteBarricade(m, 19, 23)
			carnages.deleteBarricade(m, 19, 24)
			carnages.deleteBarricade(m, 19, 25)
			carnages.deleteBarricade(m, 19, 26)
			carnages.deleteBarricade(m, 19, 27)
			carnages.deleteBarricade(m, 19, 28)
			carnages.deleteBarricade(m, 19, 29)

			carnages.deleteBarricade(m, 29, 21)
			carnages.deleteBarricade(m, 29, 22)
			carnages.deleteBarricade(m, 29, 23)
			carnages.deleteBarricade(m, 29, 24)
			carnages.deleteBarricade(m, 29, 25)
			carnages.deleteBarricade(m, 29, 26)
			carnages.deleteBarricade(m, 29, 27)
			carnages.deleteBarricade(m, 29, 28)
			carnages.deleteBarricade(m, 29, 29)

			---
			carnages.deleteBarricade(m, 24, 25)

			carnages.deleteBarricade(m, 20, 25)
			carnages.deleteBarricade(m, 21, 25)
			carnages.deleteBarricade(m, 22, 25)
			carnages.deleteBarricade(m, 23, 25)

			carnages.deleteBarricade(m, 25, 25)
			carnages.deleteBarricade(m, 26, 25)
			carnages.deleteBarricade(m, 27, 25)
			carnages.deleteBarricade(m, 28, 25)

			carnages.deleteBarricade(m, 24, 21)
			carnages.deleteBarricade(m, 24, 22)
			carnages.deleteBarricade(m, 24, 23)
			carnages.deleteBarricade(m, 24, 24)

			carnages.deleteBarricade(m, 24, 26)
			carnages.deleteBarricade(m, 24, 27)
			carnages.deleteBarricade(m, 24, 28)
			carnages.deleteBarricade(m, 24, 29)

			---
		end
	end,
	startCircle = function()
		local m = core.gameRegistry["carnageMap"]
		if m == 3011 then
			carnages.deleteBarricade(m, 15, 14)
			carnages.deleteBarricade(m, 15, 15)
			carnages.deleteBarricade(m, 15, 16)
			carnages.deleteBarricade(m, 15, 17)
			carnages.deleteBarricade(m, 16, 14)
			carnages.deleteBarricade(m, 16, 15)
			carnages.deleteBarricade(m, 16, 16)
			carnages.deleteBarricade(m, 16, 17)
		end
		if m == 3017 then
			for y = 16, 22 do
				carnages.deleteBarricade(m, 20, y)
			end
			carnages.deleteBarricade(m, 17, 19)
			carnages.deleteBarricade(m, 18, 19)
			carnages.deleteBarricade(m, 19, 19)
			carnages.deleteBarricade(m, 21, 19)
			carnages.deleteBarricade(m, 22, 19)
			carnages.deleteBarricade(m, 23, 19)
		end
		if m == 33 then
			carnages.deleteBarricade(m, 24, 25)

			carnages.deleteBarricade(m, 20, 25)
			carnages.deleteBarricade(m, 21, 25)
			carnages.deleteBarricade(m, 22, 25)
			carnages.deleteBarricade(m, 23, 25)

			carnages.deleteBarricade(m, 25, 25)
			carnages.deleteBarricade(m, 26, 25)
			carnages.deleteBarricade(m, 27, 25)
			carnages.deleteBarricade(m, 28, 25)

			carnages.deleteBarricade(m, 24, 21)
			carnages.deleteBarricade(m, 24, 22)
			carnages.deleteBarricade(m, 24, 23)
			carnages.deleteBarricade(m, 24, 24)

			carnages.deleteBarricade(m, 24, 26)
			carnages.deleteBarricade(m, 24, 27)
			carnages.deleteBarricade(m, 24, 28)
			carnages.deleteBarricade(m, 24, 29)
		end
	end,
	setBarricade = function()
		local m = core.gameRegistry["carnageMap"]
		if m == 3011 then
			core:dropItemXY("barricade", 1, 0, 0, m, 6, 9)
			core:dropItemXY("barricade", 1, 0, 0, m, 7, 8)
			core:dropItemXY("barricade", 1, 0, 0, m, 8, 7)
			core:dropItemXY("barricade", 1, 0, 0, m, 9, 6)
			setPass(m, 6, 9, 1)
			setPass(m, 7, 8, 1)
			setPass(m, 8, 7, 1)
			setPass(m, 9, 6, 1)
			core:dropItemXY("barricade", 1, 0, 0, m, 23, 26)
			core:dropItemXY("barricade", 1, 0, 0, m, 24, 25)
			core:dropItemXY("barricade", 1, 0, 0, m, 25, 24)
			core:dropItemXY("barricade", 1, 0, 0, m, 26, 23)
			setPass(m, 23, 26, 1)
			setPass(m, 24, 25, 1)
			setPass(m, 25, 24, 1)
			setPass(m, 26, 23, 1)
		end
		if m == 3017 then
			for x = 2, 9 do
				carnages.dropBarricade(m, x, 14)
			end
			for x = 30, 37 do
				carnages.dropBarricade(m, x, 24)
			end
			for y = 4, 9 do
				carnages.dropBarricade(m, 15, y)
			end
			for y = 29, 34 do
				carnages.dropBarricade(m, 24, y)
			end
			carnages.dropBarricade(m, 25, 25)
			carnages.dropBarricade(m, 26, 24)
			carnages.dropBarricade(m, 13, 14)
			carnages.dropBarricade(m, 14, 13)
		end
		if m == 33 then
			for i = 2, 10 do
				setPass(m, i, 15, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, i, 15)
			end

			for i = 2, 12 do
				setPass(m, 15, i, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, 15, i)
			end

			for i = 39, 48 do
				setPass(m, i, 15, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, i, 15)
			end

			for i = 2, 12 do
				setPass(m, 34, i, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, 34, i)
			end

			for i = 39, 48 do
				setPass(m, i, 35, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, i, 35)
			end

			for i = 38, 47 do
				setPass(m, 34, i, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, 34, i)
			end

			for i = 2, 10 do
				setPass(m, i, 35, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, i, 35)
			end

			for i = 38, 47 do
				setPass(m, 15, i, 1)
				core:dropItemXY("barricade", 1, 0, 0, m, 15, i)
			end
		end
	end,

	removeBarricade = function()
		local m = core.gameRegistry["carnageMap"]
		if m == 3011 then
			local items = core:getObjectsInMap(m, BL_ITEM)

			if items ~= nil then
				for i = 1, #items do
					if items[i].yname == "barricade" then
						items[i]:delete()
					end
				end
			end
			setPass(m, 6, 9, 0)
			setPass(m, 7, 8, 0)
			setPass(m, 8, 7, 0)
			setPass(m, 9, 6, 0)
			setPass(m, 23, 26, 0)
			setPass(m, 24, 25, 0)
			setPass(m, 25, 24, 0)
			setPass(m, 26, 23, 0)
		end
		if m == 3017 then
			for x = 2, 9 do
				carnages.deleteBarricade(m, x, 14)
			end
			for x = 30, 37 do
				carnages.deleteBarricade(m, x, 24)
			end
			for y = 4, 9 do
				carnages.deleteBarricade(m, 15, y)
			end
			for y = 29, 34 do
				carnages.deleteBarricade(m, 24, y)
			end
			carnages.deleteBarricade(m, 25, 25)
			carnages.deleteBarricade(m, 26, 24)
			carnages.deleteBarricade(m, 13, 14)
			carnages.deleteBarricade(m, 14, 13)
		end
		if m == 33 then
			local items = core:getObjectsInMap(m, BL_ITEM)

			if items ~= nil then
				for i = 1, #items do
					if items[i].yname == "barricade" then
						items[i]:delete()
					end
				end
			end

			for i = 2, 10 do
				setPass(m, i, 15, 0)
			end

			for i = 2, 12 do
				setPass(m, 15, i, 0)
			end

			for i = 39, 48 do
				setPass(m, i, 15, 0)
			end

			for i = 2, 12 do
				setPass(m, 34, i, 0)
			end

			for i = 39, 48 do
				setPass(m, i, 35, 0)
			end

			for i = 38, 47 do
				setPass(m, 34, i, 0)
			end

			for i = 2, 10 do
				setPass(m, i, 35, 0)
			end

			for i = 38, 47 do
				setPass(m, 15, i, 0)
			end
		end
	end,

	carnageRestartRound = function()
		local players = core:getObjectsInMap(
			core.gameRegistry["carnageMap"],
			BL_PC
		)
		for z = 1, #players do
			players[z]:setTimer(2, 0)
		end
	end,

	setMiniBarricade = function()
		local m = core.gameRegistry["carnageMap"]

		if m == 33 then
			for x = 16, 33 do
				for y = 3, 17 do
					if (y == 3 or y == 10 or y == 17) then
						--Player(2):sendAnimationXY(16, x, y)
						setPass(m, x, y, 1)
						core:dropItemXY("barricade", 1, 0, 0, m, x, y)
					end

					if (x == 16 or x == 24 or x == 25 or x == 33) then
						--Player(2):sendAnimationXY(16, x, y)
						setPass(m, x, y, 1)
						core:dropItemXY("barricade", 1, 0, 0, m, x, y)
					end
				end
			end
		end
	end,

	removeMiniBarricade = function()
		local m = core.gameRegistry["carnageMap"]

		local minX, maxX, minY, maxY = 0, 0, 0, 0

		if m == 33 then
			minX = 17
			maxX = 32
			minY = 4
			maxY = 16
		end

		for x = minX, maxX do
			for y = minY, maxY do
				setPass(m, x, y, 0)

				local items = core:getObjectsInCell(m, x, y, BL_ITEM)

				if items ~= nil then
					for i = 1, #items do
						if items[i].yname == "barricade" then
							items[i]:delete()
						end
					end
				end
			end
		end
	end,

	removeOfflinePlayers = function()
		local i = 1
		while i <= #carnageTeams do
			if Player(carnageTeams[i].ID) == nil then
				table.remove(carnageTeams, i)
			else
				i = i + 1
			end
		end
	end,

	setDoors = function(state)
		--[[
	local m = 3010

	if state == "open" then
		for i = 1, getMapXMax(m) do
			local obj = getObject(m, i, 10)

			if (obj == 352) or (obj == 353) then
				setObject(m, i, 10, obj + 18)
			end
		end
	elseif state == "close" then
		for i = 1, getMapXMax(m) do
			local obj = getObject(m, i, 10)

			if (obj == 370) or (obj == 371) then
				setObject(m, i, 10, obj - 18)
			end
		end
	end
]]
		--
	end,

	autoTeamBalance = function()
		local pcs = core:getObjectsInMap(3010, BL_PC)

		local ID = 0
		local team = 0
		local kills = 0
		local deaths = 0
		local damage = 0
		local healing = 0

		if pcs == nil then
			return
		end

		---- team counts ---
		local team1 = 0
		local team2 = 0

		for i = 1, #carnageTeams do
			if carnageTeams[i].team == 1 then
				team1 = team1 + 1
			elseif carnageTeams[i].team == 2 then
				team2 = team2 + 1
			end
		end

		--[[Player(2):talk(0,"team 1 #players: "..team1)
	Player(2):talk(0,"team 2 #players: "..team2)
	Player(2):talk(0,"-------------------")]]
		--

		for i = 1, #pcs do
			pcs[i]:guitext("Carnage is in Pre session\nTeams are currently being auto balanced.\nPlease standby.")

			local found = false
			local randomTeam = math.random(1, 2)
			if #carnageTeams == 0 then
				-- empty table
				table.insert(carnageTeams, {
					ID = pcs[i].ID,
					team = randomTeam,
					kills = 0,
					deaths = 0,
					damage = 0,
					healing = 0
				})
				carnages.teamDye(pcs[i], randomTeam)
			end

			local pathCheck = carnages.pathBalance(pcs[i].baseClass)

			--Player("Marduk"):talk(0, "pathCheck for "..pcs[i].name.." returns "..pathCheck)

			for j = 1, #carnageTeams do
				if carnageTeams[j].ID == pcs[i].ID then
					found = true

					if math.abs(team1 - team2) > 1 then
						carnageTeams[j].team = pathCheck
						carnages.teamDye(pcs[i], pathCheck)
						carnages.preSessionTeamWarps(pcs[i], pathCheck)

						--return
					elseif math.abs(team2 - team1) > 1 then
						carnageTeams[j].team = pathCheck
						carnages.teamDye(pcs[i], pathCheck)
						carnages.preSessionTeamWarps(pcs[i], pathCheck)

						--return
					end
					if team1 == team2 then
						for qq = 4, 1 do
							pathCheck = carnages.pathBalance(qq)
							if pathCheck ~= 0 then
								carnageTeams[j].team = pathCheck
								carnages.teamDye(pcs[i], pathCheck)
								carnages.preSessionTeamWarps(pcs[i], pathCheck)
								break

								--return
							end
						end
					end
				end

				if j == #carnageTeams and found == false then
					if pathCheck ~= 0 then
						table.insert(carnageTeams, {
							ID = pcs[i].ID,
							team = pathCheck,
							kills = 0,
							deaths = 0,
							damage = 0,
							healing = 0
						})
						carnages.teamDye(pcs[i], pathCheck)
						carnages.preSessionTeamWarps(pcs[i], pathCheck)
					else
						local randomTeam = math.random(1, 2)
						table.insert(carnageTeams, {
							ID = pcs[i].ID,
							team = randomTeam,
							kills = 0,
							deaths = 0,
							damage = 0,
							healing = 0
						})
						carnages.teamDye(pcs[i], randomTeam)
						carnages.preSessionTeamWarps(pcs[i], randomTeam)
					end
				end
			end
		end
	end,

	preSessionTeamWarps = function(player, team)
		local m = 3010
		local x = 0
		local y = 0

		if team == 1 then
			x = math.random(1, 7)
			y = math.random(11, 17)
		elseif team == 2 then
			x = math.random(25, 31)
			y = math.random(11, 17)
		elseif team == 3 then
			x = math.random(17, 23)
			y = math.random(11, 17)
		elseif team == 4 then
			x = math.random(9, 15)
			y = math.random(11, 17)
		end

		player:warp(m, x, y)
	end,

	teamDye = function(player, team)
		local armor = {}

		local armorColor = {63, 60, 66, 61}

		-- red black blue white
		local color = {31, 10, 17, 11}

		-- red black blue white

		if player.sex == 0 then
			armor = {12, 4, 10, 21}
		elseif player.sex == 1 then
			armor = {13, 8, 11, 27}
		end

		clone.wipe(player)
		clone.equip(player, player)
		player.gfxClone = 1

		player.gfxArmor = armor[player.baseClass]
		player.gfxArmorC = color[team]
		player.gfxDye = armorColor[team]

		player:updateState()
	end,

	clearTeams = function()
		for i = 1, #carnageTeams do
			carnageTeams[i] = nil
		end
	end,

	pathBalance = function(basePath)
		local teampath = {0, 0}
		local team = {0, 0}
		local players = core:getObjectsInMap(3010, BL_PC)

		for k = 1, 4 do
			for j = 1, #players do
				for i = 1, #carnageTeams do
					if (carnageTeams[i].team == k and carnageTeams[i].ID == players[j].ID and players[
						j
					].baseClass == basePath) then
						teampath[k] = teampath[k] + 1
					end
					if (carnageTeams[i].team == k and carnageTeams[i].ID == players[j].ID) then
						team[k] = team[k] + 1
					end
				end
			end
		end

		if ((teampath[1] + teampath[2]) % 2 ~= 0 and team[1] == team[2]) then
			return 0
		end
		if (teampath[1] ~= teampath[2]) then
			if teampath[1] > teampath[2] then
				return 2
			elseif teampath[2] > teampath[1] then
				return 1
			end
		end
		if team[1] ~= team[2] then
			if team[1] > team[2] then
				return 2
			elseif team[2] > team[1] then
				return 1
			end
		end
		return 0
	end
}
