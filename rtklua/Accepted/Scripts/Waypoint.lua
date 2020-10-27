local _waypointsRegistry = "waypoints"
local _defaultWaypoints = "|kugnae|buya|nagnang|mythic_nexus|"

local _waypoints = {
    {
		id = "clan",
		label = "Clan",
		description = "Your clan is an awesome clan.",
        keywords = {"clan"},
		includeOnMaps = {}, -- Include this waypoint when the player is on one of these maps (high priority)
		excludeOnMap = -1, -- Exclude this waypoint when the player is on this map (medium priority)
        excludeInRegion = -1, -- Exclude this waypoint when the player is in this region (low priority)
		costFactor = 1,
        map = 0,
        x = 50,
        y = 150
    },
	{
		id = "kugnae",
        label = "Kugnae",
        description = "Kugnae is rustic and wonderful.",
        keywords = {"kugnae", "koguryo"},
		includeOnMaps = {1013, 1027, 1025},
		excludeOnMap = -1,
        excludeInRegion = 0,
		costFactor = 1,
        map = 0,
        x = 50,
        y = 150
    },
	{
		id = "buya",
		label = "Buya",
        description = "Buya is great and powerful.",
		keywords = {"buya"},
        includeOnMaps = {1122, 1031, 522},
		excludeOnMap = -1,
        excludeInRegion = 1,
		costFactor = 1,
        map = 330,
        x = 39,
        y = 105
	},
    {
		id = "nagnang",
		label = "Nagnang",
		description = "Nagnang is powerful and rich.",
		keywords = {"nagnang"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = 3,
		costFactor = 1,
		map = 2500,
		x = 122,
		y = 133
	},
    {
		id = "mythic_nexus",
		label = "Mythic Nexus",
		description = "Powerful creatures dwell in the Mythic Nexus.",
		keywords = {"mythic"},
        includeOnMaps = {},
		excludeOnMap = 41,
		excludeInRegion = -1,
		costFactor = 2,
		map = 41,
		x = 30,
		y = 11
	},
    {
		id = "hamgyong_nam_do",
		label = "Hamgyong Nam-Do",
		description = "Hamgyong Nam-Do is home to the ogres.",
		keywords = {"hamgyong", "hamgyong nam-do", "nogh", "ogre"},
        includeOnMaps = {},
		excludeOnMap = 114,
		excludeInRegion = -1,
		costFactor = 3,
		map = 114,
		x = 13,
		y = 7
	},
    {
		id = "forest_crossroads",
		label = "Forest Crossroads",
		description = "The Forest Crossroads are infested with chittering insects.",
		keywords = {"forest", "crossroads", "forest crossroads", "mantis"},
        includeOnMaps = {},
		excludeOnMap = 522,
		excludeInRegion = -1,
		costFactor = 4,
		map = 521,
		x = 15,
		y = 16
	},
    {
		id = "islets",
		label = "Islets",
		description = "The Islets are quiet and peaceful.",
		keywords = {"islets", "noxhil"},
        includeOnMaps = {},
		excludeOnMap = 1008,
		excludeInRegion = -1,
		costFactor = 2,
		map = 1008,
		x = 17,
		y = 147
	},
    {
		id = "hausson",
		label = "Hausson",
		description = "Hausson is a remote island village.",
		keywords = {"hausson"},
        includeOnMaps = {},
		excludeOnMap = 1027,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1023,
		x = 64,
		y = 46
	},
    {
		id = "dae_shore",
		label = "Dae Shore",
		description = "Dae Shore is an idyllic shoreline.",
		keywords = {"dae", "dae shore"},
        includeOnMaps = {},
		excludeOnMap = 1025,
		excludeInRegion = -1,
		costFactor = 2,
		map = 1028,
		x = 16,
		y = 30
	},
    {
		id = "kamings_encampment",
		label = "KaMing's Encampment",
		description = "KaMing's Encampment is the refuge of the Sonhi.",
		keywords = {"kaming", "kaming's encampment", "sonhi"},
        includeOnMaps = {},
		excludeOnMap = 3800,
		excludeInRegion = -1,
		costFactor = 2,
		map = 3800,
		x = 30,
		y = 46
	},
    {
		id = "northern_pass",
		label = "Northern Pass",
		description = "The Northern Pass connects distant regions.",
		keywords = {"north", "northern pass"},
        includeOnMaps = {},
		excludeOnMap = 1013,
		excludeInRegion = -1,
		costFactor = 2,
		map = 1003,
		x = 44,
		y = 10
	},
    {
		id = "arctic_village",
		label = "Arctic Village",
		description = "The Arctic Village is frozen and desolate.",
		keywords = {"arctic", "arctic village"},
        includeOnMaps = {},
		excludeOnMap = 3812,
		excludeInRegion = -1,
		costFactor = 4,
		map = 3811,
		x = 24,
		y = 20
	},
    {
		id = "sanhae",
		label = "Sanhae",
		description = "Sanhae is quiet and peaceful.",
		keywords = {"sanhae"},
        includeOnMaps = {},
		excludeOnMap = 1122,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1121,
		x = 24,
		y = 31
	},
    {
		id = "wilderness",
		label = "Wilderness",
		description = "The Wilderness is expansive and full of resources.",
		keywords = {"wild", "wilderness", "rotah"},
        includeOnMaps = {},
		excludeOnMap = 1002,
		excludeInRegion = -1,
		costFactor = 2,
		map = 1002,
		x = 207,
		y = 141
	},
    {
		id = "sel",
		label = "Sel",
		description = "Sel is a master of gemcutting and jewelry.",
		keywords = {"sel", "gem"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1002,
		x = 46,
		y = 42
	},
    {
		id = "splinter",
		label = "Splinter",
		description = "Splinter is a master of woodwork.",
		keywords = {"splinter", "wood"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1002,
		x = 136,
		y = 189
	},
    {
		id = "thane",
		label = "Thane",
		description = "Thane is a master of mining.",
		keywords = {"thane", "mine", "mining"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1002,
		x = 185,
		y = 22
	},
    {
		id = "yon",
		label = "Yon",
		description = "Yon is a master of weaving.",
		keywords = {"yon", "weave"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 3,
		map = 1002,
		x = 44,
		y = 32
	},
    {
		id = "zephyr",
		label = "Zephyr",
		description = "Zephyr scribes atop a great mountain.",
		keywords = {"zephyr", "scribe"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 5,
		map = 1455,
		x = 9,
		y = 8
	},
    {
		id = "museum",
		label = "Museum",
		description = "Yon is a master of weaving.",
		keywords = {"museum"},
        includeOnMaps = {},
		excludeOnMap = -1,
		excludeInRegion = -1,
		costFactor = 2,
		map = 1002,
		x = 45,
		y = 42
	}
}

local _animate = function(player)
	player:playSound(29)
	player:sendAnimation(11)
end

local _shouldIncludeWaypoint = function(player, waypoint)
	if (not waypoint) then
		return false
	end

	local map = player.m
	local includeOnMaps = waypoint.includeOnMaps

    for i = 1, #includeOnMaps do
		if (map == waypoint.includeOnMaps[i]) then
            return true
        end
    end

	if (map == waypoint.excludeOnMap) then
        return false
    end

	if (player.region == waypoint.excludeInRegion) then
        return false
	end

    return true
end

local _getWaypoints = function(player)
    local waypointsString = player.registryString[_waypointsRegistry]

    if (waypointsString == "") then
        waypointsString = _defaultWaypoints
        player.registryString[_waypointsRegistry] = _defaultWaypoints
        player:forceSave()
    end

    local waypoints = {}

	-- @TODO: Add clan waypoint

	for i = 1, #_waypoints do
		local waypoint = _waypoints[i]
		local id = waypoint.id

		if (Waypoint.isEnabled(player, id) and _shouldIncludeWaypoint(player, waypoint)) then
			table.insert(waypoints, waypoint)
		end
	end

    return waypoints
end

local _getFare = function(player, waypoint)
	local fare = ((player.level + 1) + (100 * player.mark)) * waypoint.costFactor
	return fare
end

local _transport = function(player, waypoint)
	local fare = _getFare(player, waypoint)

	if (player.money < fare) then
		player:dialogSeq({"You need " .. Tools.formatNumber(fare) .. " coins to travel there."}, 0)
		return
	end

	local choice = player:menuSeq(
		waypoint.description .. "\n\nThe fare is " .. Tools.formatNumber(fare) .. " coins.\nDo you wish to travel there?",
		{"Yes!", "No"},
		{}
	)

	if (choice == 1) then
		player:removeGold(fare)
		player:warp(waypoint.map, waypoint.x, waypoint.y)
		_animate(player)
	end
end

Waypoint = {
	add = function(player, npc, waypointId)
		Tools.configureDialog(player, npc)
		local waypoint

		for i = 1, #_waypoints do
			if (_waypoints[i].id == waypointId) then
				waypoint = _waypoints[i]
				break
			end
		end

		local cost = 11000 + 1875 * (waypoint.costFactor - 1) * (1 + waypoint.costFactor / 10)

		player:dialogSeq({"Waypoints allow you to quickly travel across great distances. A small fee is required for each use of this service."}, 1)

		local choice = player:menuSeq(
			Tools.formatNumber(cost) .. " coins are required to establish a waypoint here.\n\nDo you wish to proceed?",
			{"Yes", "No"},
			{}
		)

		if (choice ~= 1) then
			player:dialogSeq({"So be it. Return to me if you change your mind."}, 0)
			return
		end

		if (player.money < cost) then
			player:dialogSeq({"Return to me when you have more gold."}, 0)
			return
		end

		-- Do not remove. This ensures that you have the default waypoints on the off
		-- chance that you buy a waypoint before ever using the transport feature
		_getWaypoints(player)

		_animate(player)
		player:removeGold(cost)
		player.registryString[_waypointsRegistry] = player.registryString[_waypointsRegistry] .. waypointId .. "|"
		player:forceSave()

		player:dialogSeq({"It is done. Say 'transport' or '" .. waypoint.keywords[1] .. "' to any innkeeper whenever you would like to return here."}, 0)
	end,

	click = function(player, npc)
		Tools.configureDialog(player, npc)
		local waypoints = _getWaypoints(player)
		local waypointLabels = {}

		for i = 1, #waypoints do
			table.insert(waypointLabels, waypoints[i].label)
		end

		local choice = player:menuSeq(
			"Where do you wish to travel?",
			waypointLabels,
			{}
		)

		local waypoint = waypoints[choice]

		_transport(player, waypoint)
	end,

	isEnabled = function(player, waypointId)
		local enabledWaypoints = player.registryString[_waypointsRegistry]

		if (enabledWaypoints == "") then
			enabledWaypoints = _defaultWaypoints
		end

		if (string.match(enabledWaypoints, "|" .. waypointId .. "|")) then
			return true
		end

		return false
	end,

	onSayClick = function(player, npc)
		-- Prevent duplicate processing in rooms that contain two NPCs with the Transport function
		if (npc.yname ~= "InnNpc2") then
			local npcs = npc:getObjectsInSameMap(BL_NPC)

			for i = 1, #npcs do
				if (npcs[i].yname == "InnNpc2") then
					return
				end
			end
		end

		Tools.configureDialog(player, npc)
		local speech = player.speech:lower()

		if (speech == "transport") then
			Waypoint.click(player, npc)
			return
		end

		local waypoints = _getWaypoints(player)

		for i = 1, #waypoints do
			local waypoint = waypoints[i]
			local keywords = waypoint.keywords

			for j = 1, #keywords do
				if (speech == keywords[j]) then
					_transport(player, waypoint)
					return
				end
			end
		end
	end
}
