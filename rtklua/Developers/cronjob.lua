cronJobSec = function()
	boss_spawn.spawn()

	minigames.timer()

	--[[if ((realMinute()%15==0) and (realSecond()%30 == 0)) then
		broadcast(-1, "Day: "..realDay().." hour: "..realHour().." minute: "..realMinute().." second: "..realSecond()..".")
	end]]
	--
end

cronJobMin = function()
	mapLight()

	processKanDonations()

	--[[if (realMinute()%15 == 0) then
		local timestamp = realHour()..":"..realMinute()
		--broadcast(-1, "Day: "..realDay().." hour: "..realHour().." minute: "..realMinute().." second: "..realSecond()..".")
			end

	if (realMinute()%30 == 0) then
		clearInstanceMaps(block)
	end]]
	--
end

cronJob5Min = function()
	itemspawner()
end

cronJob30Min = function()
	if core.gameRegistry["msg1"] == 1 then
		core.gameRegistry["msg1"] = 0
		broadcast(
			-1,
			"If you encounter a bug, please post it to the ingame Bug board."
		)

		--broadcast(-1, "For other issues, please visit www.tkreborn.com/helpdesk")
		return
	end

	if core.gameRegistry["msg1"] == 0 then
		core.gameRegistry["msg1"] = 1
		broadcast(
			-1,
			"We appreciate all the help to make this server possible."
		)

		--broadcast(-1, "If you would like to contribute, please visit https://www.tkreborn.com/donate")
		return
	end
end

cronJobHour = function()
end

cronJobDay = function()
	--broadcast(-1, "Day: "..realDay().." hour: "..realHour().." minute: "..realMinute().." second: "..realSecond()..".")
end

clearInstanceMaps = function(block)
	local i

	if (#instances > 0) then
		i = 0
		clearInstances(block, i)
	end

	block:warp(0, 0, 0)
end

clearOpeningScene = function(block, i)
	repeat
		i = i + 1

		local openingPlayers = #block:getObjectsInMap(
			openingSceneUsedMaps[i],
			BL_PC
		)

		if (openingPlayers == 0) then
			table.remove(openingSceneUsedMaps, i)
			i = i - 1
		end
	until (i == #openingSceneUsedMaps)
end

clearInstances = function(block, i)
	repeat
		i = i + 1

		block:warp(instances[i], 0, 0)

		--[[if (block.mapTitle == "Ruins") then
			i = clearRuins(block)
		elseif (block.mapTitle == "Merry Forest") then
			i = clearCanidae(block)
		end]]
		--
	until (i == #instances)
end

clearRuins = function(block)
	local room1Players = #block:getObjectsInMap(instances[i], BL_PC)
	local room2Players = #block:getObjectsInMap(instances[i + 1], BL_PC)
	local room3Players = #block:getObjectsInMap(instances[i + 2], BL_PC)
	local room4Players = #block:getObjectsInMap(instances[i + 3], BL_PC)
	local room5Players = #block:getObjectsInMap(instances[i + 4], BL_PC)

	if (room1Players + room2Players + room3Players + room4Players + room5Players == 0) then
		unloadInstance(instances[i], 5)
		return 0
	end
end

clearCanidae = function(block)
	local room1Players = #block:getObjectsInMap(instances[i], BL_PC)
	local room2Players = #block:getObjectsInMap(instances[i + 1], BL_PC)
	local room3Players = #block:getObjectsInMap(instances[i + 2], BL_PC)
	local room4Players = #block:getObjectsInMap(instances[i + 3], BL_PC)
	local room5Players = #block:getObjectsInMap(instances[i + 4], BL_PC)
	local room6Players = #block:getObjectsInMap(instances[i + 5], BL_PC)

	if (room1Players + room2Players + room3Players + room4Players + room5Players + room6Players == 0) then
		unloadInstance(instances[i], 6)
		return 0
	end
end
