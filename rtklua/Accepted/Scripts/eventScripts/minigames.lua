minigames = {
	timer = function()
		SumoWarNpc.core()
		BeachWarNpc.core()

		if os.date("%A") == "Sunday" and realHour() == 5 and realMinute() == 0 and realSecond() == 0 then
			-- 5AM
			minigames.generateWeeklySchedule()
		end

		--[[if (realHour() == 15 or realHour() == 17 or realHour() == 19 or realHour() == 21 or realHour() == 23 or realHour() == 1 or realHour() == 3) then
		if realMinute() == 45 and realSecond() == 0 then -- 15 min door opening

		end

		if realMinute() == 55 and realSecond() == 0 then -- 5 miin warning

		end
	end]]
		--

		--if(realHour() == 16 or realHour() == 18 or realHour() == 20 or realHour() == 22 or realHour() == 0 or realHour() == 2 or realHour() == 4) then
		--if(realMinute() == 0 and realSecond() == 0) then

		--core.gameRegistry["weeklyeventcounter"] = core.gameRegistry["weeklyeventcounter"] + 1

		--local eventid = core.gameRegistry["event"..core.gameRegistry["weeklyeventcounter"]]
		--local eventName = minigames.eventNameLookUp(eventid)

		--broadcast(-1,"Starting event: "..eventName)

		--end
		--end

		if (os.date("%A") == "Monday" or os.date("%A") == "Friday" or os.date("%A") == "Sunday") and realHour() == 21 and realMinute() == 0 and realSecond() == 0 then
			carnages.init(18)
		end

		if (os.date("%A") == "Wednesday") and realHour() == 15 and realMinute() == 0 and realSecond() == 0 then
			carnages.init(18)
		end

		if (os.date("%A") == "Tuesday" or os.date("%A") == "Thursday" or os.date("%A") == "Saturday") and (realHour() == 19 or realHour() == 22) and realMinute() == 0 and realSecond() == 0 then
			elixir.init(30)
		end

		--[[if ( os.date("%A") == "Wednesday" ) and realHour() == 20 and realMinute() == 0 and realSecond() == 0 then
		carnages.init(18)
	end]]
		--

		elixir.timer(eventid)
		carnages.timer(eventid)

		BomberWarNpc.core()
	end,

	giveMinigameExp = function(player, win) -- 1 == win, 2 == loss
		if (player.level < 99) then
			local totalExpForNextLevel = getXPforLevel(player.baseClass, player.level)
			local totalExpForCurrentLevel = getXPforLevel(player.baseClass, player.level - 1)
			local expBonus = totalExpForNextLevel - totalExpForCurrentLevel
			
			expBonus = math.ceil(expBonus * 0.75)
			expBonus = math.max(expBonus, 300)
			expBonus = math.ceil(expBonus / win)

			player:giveXPStacked(expBonus)
		else
			local expBonus = 0

			for i = 0, 9 do
				expBonus = expBonus + ExpSellerNpc.getVitaCost(player.baseHealth + 100 * i)
				expBonus = expBonus + ExpSellerNpc.getManaCost(player.baseMagic + 100 * i)
			end

			expBonus = math.floor(expBonus / win)
			expBonus = math.min(expBonus, 4294967295)

			player:giveXPStacked(expBonus)
		end
	end,

	determineEventSchedule = function()
		local eventType = {}

		table.insert(eventType, 5)
		table.insert(eventType, 2)
		table.insert(eventType, 1)
		table.insert(eventType, 3)
		table.insert(eventType, 1)
		table.insert(eventType, 4)
		table.insert(eventType, 5)

		function randomizeEvents()
			for k = 1, 50 do
				local first = math.random(2, 6)
				local second = math.random(2, 6)

				if (first == second) then
					first = math.random(4, 6)
					second = math.random(2, 3)
				end

				local temp = eventType[first]
				local temp2 = eventType[second]

				eventType[first] = temp2
				eventType[second] = temp
			end
		end

		local carnageCounter = core.gameRegistry["carnagecounter"]
		local carnageCounter2 = core.gameRegistry["carnagecounter2"]
		local carnageCounter3 = core.gameRegistry["carnagecounter3"]

		-- 10 = carnage, 20 = bloodlust, 30 = elixir, 40 = foxhunt, 50 = randomEvents
		-- carnage format XY, x = event, y = type of event
		-- example, 15 == 1 carnage + 5 ancients
		-- example, 11 == 1 carnage + 1 adventure
		local counter = 0
		for i = 1, 7 do
			randomizeEvents()
			for k = 1, 7 do
				counter = counter + 1
				if (eventType[k] == 1) then
					local rand = math.random(1, 3)
					if (rand == 1) then
						core.gameRegistry["event" .. counter] = 10 + core.gameRegistry[
							"carnagecounter"
						]
						core.gameRegistry["carnagecounter"] = core.gameRegistry[
							"carnagecounter"
						] + 1
						if (core.gameRegistry["carnagecounter"] > 7) then
							-- hardcoded 7 is the length of the array in generate weekly schedule, if we pass the array here we can change it
							core.gameRegistry["carnagecounter"] = 1
						end
					elseif (rand == 2) then
						core.gameRegistry["event" .. counter] = 10 + core.gameRegistry[
							"carnagecounter2"
						]
						core.gameRegistry["carnagecounter2"] = core.gameRegistry[
							"carnagecounter2"
						] + 1
						if (core.gameRegistry["carnagecounter2"] > 7) then
							core.gameRegistry["carnagecounter2"] = 1
						end
					else
						core.gameRegistry["event" .. counter] = 10 + core.gameRegistry[
							"carnagecounter3"
						]
						core.gameRegistry["carnagecounter3"] = core.gameRegistry[
							"carnagecounter3"
						] + 1
						if (core.gameRegistry["carnagecounter3"] > 7) then
							core.gameRegistry["carnagecounter3"] = 1
							core.gameRegistry["carnagecounter3"] = core.gameRegistry[
								"carnagecounter3"
							]
						end
					end
				elseif (eventType[k] == 2) then
					core.gameRegistry["event" .. counter] = 20 + math.random(
						1,
						3
					)
				elseif (eventType[k] == 3) then
					core.gameRegistry["event" .. counter] = 30
				elseif (eventType[k] == 4) then
					core.gameRegistry["event" .. counter] = 40
				elseif (eventType[k] == 5) then
					core.gameRegistry["event" .. counter] = 50 + math.random(
						1,
						5
					)
				end
			end
		end
	end,

	generateWeeklySchedule = function()
		local foxHunts = {
			"Fox hunt: Hectic horses",
			"Fox hunt: Luminous leaders",
			"Fox hunt: Recurring Eclipse",
			"Fox hunt: Equestrian equality",
			"Fox hunt: Magnificent mounts",
			"Fox hunt: The great horse strike",
			"Fox hunt: Conquering quantity"
		}
		local bloodlust = {"Bloodlust: 2 team", "Bloodlust: 4 team"}
		local elixir = {"Elixir: Elixir war"}
		local carnage = {
			"Carnage: Adventure (6-35)",
			"Carnage: Heroes (36-65)",
			"Carnage: Glory (66-85)",
			"Carnage: Legends (86-95)",
			"Carnage: Ancients (99 to non-Wasabi)",
			"Carnage: Avatars (Wasabi to 160k/80k)",
			"Carnage: Celestial (160k/80k +)",
			"Carnage: Mythic (All Levels)"
		}
		local randomEvents = {
			"Sumo War",
			"Freeze tag",
			"Beach War",
			"Bomberman",
			"Zombie War"
		}

		minigames.determineEventSchedule()
		core.gameRegistry["weeklyeventcounter"] = 1

		local title = "Week of " .. os.date("%A") .. ": " .. os.date("%B") .. " " .. os.date("%d")
		local post = "<b>All times are in Eastern (ET)\n"

		local tomorrow = 0
		local counter = 0

		for i = 1, 7 do
			-- day
			if i == 1 then
				tomorrow = os.time()

				--sunday 5am
			else
				tomorrow = os.time() + (3600 * 24 * i)

				-- 5am
			end

			post = post .. "\n\n"
			post = post .. "<b>" .. os.date("%A %B %d", tomorrow) .. "\n"

			local eventStart = tomorrow + 39600

			--4pm

			for k = 1, 7 do
				-- event
				counter = counter + 1
				post = post .. "\n"
				post = post .. os.date("%I%p", eventStart + (7200 * (k - 1))) .. "      " .. minigames.eventNameLookUp(core.gameRegistry["event" .. counter])
			end

			post = post .. "\n\n------------------------------------------------------\n"
		end

		addToBoard(18, title, post)
	end,

	eventList = function()
		local foxHunts = {
			"Fox hunt: Hectic horses",
			"Fox hunt: Luminous leaders",
			"Fox hunt: Recurring Eclipse",
			"Fox hunt: Equestrian equality",
			"Fox hunt: Magnificent mounts",
			"Fox hunt: The great horse strike",
			"Fox hunt: Conquering quantity"
		}
		local bloodlust = {"Bloodlust: 2 team", "Bloodlust: 4 team"}
		local elixir = {"Elixir: Elixir war"}
		local carnage = {
			"Carnage: Adventure (6-35)",
			"Carnage: Heroes (36-65)",
			"Carnage: Glory (66-85)",
			"Carnage: Legends (86-98)",
			"Carnage: Ancients (99 to non-Wasabi)",
			"Carnage: Avatars (Wasabi to 160k/80k)",
			"Carnage: Celestial (160k/80k +)",
			"Carnage: Mythic (All Levels)"
		}
		local randomEvents = {
			"Sumo War",
			"Freeze tag",
			"Beach War",
			"Bomberman",
			"Zombie War"
		}

		local eventNames = {}

		for i = 1, #foxHunts do
			table.insert(eventNames, foxHunts[i])
		end
		for i = 1, #bloodlust do
			table.insert(eventNames, bloodlust[i])
		end
		for i = 1, #elixir do
			table.insert(eventNames, elixir[i])
		end
		for i = 1, #carnage do
			table.insert(eventNames, carnage[i])
		end
		for i = 1, #randomEvents do
			table.insert(eventNames, randomEvents[i])
		end

		return eventNames
	end,

	eventIdLookUp = function(eventname)
		local eventNames = minigames.eventList()
		local eventid = 0

		for i = 1, #eventNames do
			if eventname == eventNames[i] then
				eventid = i
			end
		end

		return eventid
	end,

	eventNameLookUp = function(eventid)
		local eventName = ""

		if (eventid == 11) then
			eventName = "Carnage: Adventure (6-35)"
		elseif (eventid == 12) then
			eventName = "Carnage: Heroes (36-65)"
		elseif (eventid == 13) then
			eventName = "Carnage: Glory (66-85)"
		elseif (eventid == 14) then
			eventName = "Carnage: Legends (86-98)"
		elseif (eventid == 15) then
			eventName = "Carnage: Ancients (99 to non-Wasabi[49,999/24,999])"
		elseif (eventid == 16) then
			eventName = "Carnage: Avatars (Wasabi [50,000/25,000] to 160k/80k)"
		elseif (eventid == 17) then
			eventName = "Carnage: Celestial (160k/80k +)"
		elseif (eventid == 18) then
			eventName = "Carnage: Mythic (All Levels)"
		elseif (eventid == 21) then
			eventName = "Bloodlust: Massacre (1-98)"
		elseif (eventid == 22) then
			eventName = "Bloodlust: Insanity (all levels)"
		elseif (eventid == 23) then
			eventName = "Bloodlust: Chaos (99+)"
		elseif (eventid == 30) then
			eventName = "Elixir War"
		elseif (eventid == 40) then
			eventName = "Fox Hunt"
		elseif (eventid == 51) then
			eventName = "Sumo War"
		elseif (eventid == 52) then
			eventName = "Freeze Tag"
		elseif (eventid == 53) then
			eventName = "Beach War"
		elseif (eventid == 54) then
			eventName = "Bomberman"
		elseif (eventid == 55) then
			eventName = "Zombie War"
		else
			eventName = eventid
		end

		return eventName
	end,

	minimumPlayerCheck = function(game, numPlayers)
		local map = 0
		local refund = 0

		if game == "elixir" then
			map = 3042
		elseif game == "carnage" then
			map = 3010
		end

		local pcs = core:getObjectsInMap(map, BL_PC)

		if #pcs < numPlayers then
			for i = 1, #pcs do
				if game == "carnage" then
					if (pcs[i].level >= 6 and pcs[i].level <= 35) then
						refund = 200

						-- "Carnage: Adventure (6-35)"
					elseif (pcs[i].level >= 36 and pcs[i].level <= 65) then
						refund = 500

						-- "Carnage: Heroes (36-65)"
					elseif (pcs[i].level >= 66 and pcs[i].level <= 85) then
						refund = 1000

						-- "Carnage: Glory (66-85)"
					elseif (pcs[i].level >= 86 and pcs[i].level <= 98) then
						refund = 5000

						-- "Carnage: Legends (86-98)"
					elseif (pcs[i].level >= 99) then
						refund = 8000
						if (pcs[i].baseHealth >= 50000 or pcs[i].baseMagic >= 25000) then
							refund = 12500
						end
						if (pcs[i].baseHealth >= 160000 or pcs[i].baseMagic >= 80000) then
							refund = 16000
						end
					end
					pcs[i].registry["carnagePart"] = pcs[i].registry[
						"carnagePart"
					] - 1
					pcs[i]:removeLegendbyName("carnagePart")

					if pcs[i].registry["carnagePart"] > 0 then
						pcs[i]:addLegend(
							"Participated in " .. pcs[i].registry["carnagePart"] .. " Carnages",
							"carnagePart",
							1,
							128
						)
					end
				end

				if game == "elixir" then
					pcs[i]:removeLegendbyName("participated_in_elixir_wars")
					pcs[i].registry["participated_in_elixir_wars"] = pcs[i].registry[
						"participated_in_elixir_wars"
					] - 1

					if pcs[i].registry["participated_in_elixir_wars"] > 0 then
						pcs[i]:addLegend(
							"Participated in " .. pcs[i].registry[
								"participated_in_elixir_wars"
							] .. " Elixir Wars",
							"participated_in_elixir_wars",
							1,
							128
						)
					end
					refund = 500
				end

				pcs[i]:addGold(refund)
				pcs[i]:returnInn()
				pcs[i]:msg(
					4,
					refund .. " gold has been refunded to you.",
					pcs[i].ID
				)
			end

			broadcast(
				map,
				minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. " cancelled due to lack of players"
			)
			return false
		end

		return true
	end
}
