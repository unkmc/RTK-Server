login = function(player)
	--FIRST LOGIN

	local pc = player:getUsers()
	local serverResetTimer = core.gameRegistry["server_reset_timer"]
	local offlineTime = os.time() - player.registry["last_logout"]

	if player.registry["login_count"] == 0 then
		-- initial stats
		player.baseArmor = 100
		player.baseHealth = math.random(45, 55)
		player.baseMagic = math.random(33, 38)
		player.money = 0
		player:sendStatus()
		player:calcStat()
	end

	player.registry["login_count"] = player.registry["login_count"] + 1

	player.registry["session_start_time"] = os.time()

	--added 8-7-16 for /played
	player.gfxClone = 0

	characterLog.loginLog(player)

	if serverResetTimer > os.time() then
		time = math.abs(os.time() - serverResetTimer)
		player:setTimer(2, time)
	end

	if player.registry["firstTimeLogin"] == 0 then
		player.registry["firstTimeLogin"] = os.time()
	end

	-- this stores the time when the char first logged on (used for getting Wisdom clothes)

	if (not player:hasLegend("born")) then
		player:addLegend("Born in " .. curT(), "born", 0, 80)

		welcomeNmail.send(player)
	end

	player.registry["expCounter"] = 0

	if (player.gmLevel > 50) then
		player:speak("/stealth", 0)
	end

	for i = 1, #pc do
		if pc[i].gmLevel > 0 then
			if pc[i].ID ~= player.ID then
				pc[i]:msg(
					4,
					"[LOGIN]: " .. player.name .. " has logged in ~ @" .. player.mapTitle .. "(" .. player.m .. ") | IP: " .. player.ipaddress .. " | Time: " .. os.date(),
					pc[i].ID
				)
			end
		end
	end

	--[[if (player.gmLevel == 0) then
		local friends = player:getFriends()
		if (#friends > 0) then
			for i = 1, #friends do
				player:msg(4, "[FRIEND]: "..player.name.." has logged in.", friends[i].ID)
			end
		end
	end]]
	--

	if player.m == 15020 then
		if core.gameRegistry["beach_war_started"] == 0 then
			player.registry["beach_war_flag"] = 0
			player.registry["beach_war_kills"] = 0
			player.registry["beach_war_times_hit"] = 0
			player.registry["beach_war_gun_pct"] = 0
			player.registry["beach_war_team"] = 0
			player:warp(31, math.random(6, 15), math.random(8, 15))
		end
	end

	if player.m == 666 then
		return
	end

	-- if player in jail, return

	if player.registry["basic_tutorial_complete"] == 0 then
		-- has not done welcome tutorial
		player:warp(4711, 3, 3)

		-- Welcome Map
	else
		if offlineTime >= 10800 then
			-- If player has been offline for more than 3 hours, warp them to their respective home. If not, let them stay on the map they logged in under
			player:returnFunc()
		end
	end

	if (player.m == 3010 or player.m == 3011 or player.m == 33 or player.m == 3017) then
		if player.health == 0 then
			player.state = 1
			player:updateState()
		end
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
		player.gfxArmorC = player.registry["carnageDye"]
		player.gfxDye = player.registry["carnageDye"]
	end

	if (player.m == 3036) then
		elixir.warpToSidelines(player)
	end

	if not getMapIsLoaded(player.m) then
		player:returnFunc()
	end
	if player.x > getMapXMax(player.m) then
		player:returnFunc()
	end
	if player.y > getMapYMax(player.m) then
		player:returnFunc()
	end

	--if player.m >= 59000 and player.m <= 59030 then player:returnFunc() end

	player.registry["rabbit_invasion"] = 0
	if player.m == 44175 then
		player:warp(44175, 5, 5)
	end

	local dogSpells = {
		"fissure",
		"lava_surge",
		"serpents_fury",
		"greater_blessing",
		"spirit_fury",
		"fascinate",
		"survive"
	}
	for i = 1, #dogSpells do
		if player:hasSpell(dogSpells[i]) == true then
			player.quest["dog_linguist_subpath"] = 1
		end
	end
end

logout = function(player)
	local pc = player:getUsers()
	local mapPC = player:getObjectsInMap(player.m, BL_PC)

	player.gfxClone = 0
	player.registry["ambush_timer"] = 0

	player.registry["session_end_time"] = os.time()

	--added 8-7-16 for /played, keeps causing crashes
	player.registry["session_total_time"] = os.time() - player.registry[
		"session_start_time"
	]

	--added 8-7-16 for /played, keeps causing crashes
	player.registry["total_time_played"] = player.registry["total_time_played"] + player.registry[
		"session_total_time"
	]

	--added 8-7-16 for /played
	player.registry["last_logout"] = os.time()
	player.registry["session_start_time"] = 0

	--added 8-7-16 for /played
	player.registry["session_end_time"] = 0

	--added 8-7-16 for /played
	player.registry["session_total_time"] = 0

	--added 8-7-16 for /played

	if player:hasDuration("botchecker") then
		-- go to jail for logging out during botcheck
		player:warp(666, 3, 4)
	end

	characterLog.logoutLog(player)

	if player.mapTitle == "Kugnae Kan Shop" or player.mapTitle == "Buya Kan Shop" then
		player.state = 0
		clone.wipe(player)
	end

	for i = 1, #pc do
		if pc[i].gmLevel > 0 then
			if pc[i].ID ~= player.ID then
				pc[i]:msg(
					4,
					"[LOGOUT]: " .. player.name .. " has logged out.",
					pc[i].ID
				)
			end
		end
	end

	--[[if (player.gmLevel == 0) then
		local friends = player:getFriends()
		if (#friends > 0) then
			for i = 1, #friends do
				player:msg(4, ""..player.name.." has logged out.", friends[i].ID)
			end
		end

	end]]
	--
end

mapWeather = function()
	local x, weather
	weather = math.random(1, 5)
	if (math.random(4) == 2) then
		if (weather > 3 and weather < 5 and getCurSeason() == "Spring") then
			setWeather(0, 0, 0)
		elseif (weather >= 2 and weather < 4 and getCurSeason() == "Summer") then
			setWeather(0, 0, 0)
		elseif (weather == 4 and getCurSeason() == "Fall") then
			setWeather(0, 0, 0)
		elseif (weather > 3 and getCurSeason() == "Winter") then
			setWeather(0, 0, 0)
		elseif (weather <= 3 and weather > 1 and getCurSeason() == "Spring") then
			setWeather(0, 0, 1)
		elseif (weather == 1 and getCurSeason() == "Summer") then
			setWeather(0, 0, 1)
		elseif (weather >= 2 and weather < 4 and getCurSeason() == "Fall") then
			setWeather(0, 0, 1)
		elseif (weather == 1 and (getCurSeason() == "Spring" or getCurSeason() == "Fall")) then
			setWeather(0, 0, 2)
		elseif (weather <= 3 and getCurSeason() == "Winter") then
			setWeather(0, 0, 2)
		elseif (weather == 5 and getCurSeason() == "Spring") then
			setWeather(0, 0, 3)
		elseif (weather >= 4 and getCurSeason() == "Summer") then
			setWeather(0, 0, 3)
		elseif (weather == 5 and getCurSeason() == "Fall") then
			setWeather(0, 0, 3)
		else
			setWeather(0, 0, getWeather(0, 0))
		end
	else
		setWeather(0, 0, getWeather(0, 0))
	end
end

-- Map Light --------------------------------------------------------------------------------

mapLight = function()
	local mlight = 0
	local ctime = curTime()

	if (ctime == 0) then
		mlight = 16
	elseif (ctime == 1) then
		mlight = 16
	elseif (ctime == 2) then
		mlight = 16
	elseif (ctime == 3) then
		mlight = 16
	elseif (ctime == 4) then
		mlight = 20
	elseif (ctime == 5) then
		mlight = 22
	elseif (ctime == 6) then
		mlight = 24
	elseif (ctime == 7) then
		mlight = 26
	elseif (ctime == 8) then
		mlight = 28
	elseif (ctime == 9) then
		mlight = 30
	elseif (ctime >= 10 and ctime <= 14) then
		mlight = 32
	elseif (ctime == 15) then
		mlight = 30
	elseif (ctime == 16) then
		mlight = 28
	elseif (ctime == 17) then
		mlight = 26
	elseif (ctime == 18) then
		mlight = 24
	elseif (ctime == 19) then
		mlight = 22
	elseif (ctime == 20) then
		mlight = 20
	elseif (ctime == 21) then
		mlight = 20
	elseif (ctime == 22) then
		mlight = 16
	elseif (ctime == 23) then
		mlight = 16
	elseif (ctime == 24) then
		mlight = 16
	end

	--function setLight(region,indoor,lightnumber)
	setLight(0, 0, mlight)

	--region 0
	setLight(1, 0, mlight)

	--region 1, Hon
	setLight(2, 0, mlight)

	--region 2, woods north of Hon
	setLight(3, 0, mlight)

	--region 3, Lortz
	setLight(4, 0, mlight)

	--region 4, Cathay
end

mapEnter = function(player)
	local m = player.m
	map_entry_quest_checker(player)

	--player:calcStat()
end

mapLeave = function(player)
	if player.m >= 60000 and player.m <= 65000 then
		-- added to remove gfxtoggle when they are leaving an instance
		clone.wipe(player)
	end
	if player.m == 3010 or player.m == 33 or player.m == 3017 or player.m == 3001 then
		player:calcStat()
	end
end
