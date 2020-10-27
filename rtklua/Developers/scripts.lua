local gameClock = os.clock

function capitalizeFirst(str)
	return (str:gsub("^%l", string.upper))
end

function sleep(seconds)
	local start = os.time()
	repeat
	until os.time() > start + seconds
end

function sleep2(seconds)
	-- seconds
	local startTime = gameClock()
	while gameClock() - startTime <= seconds do
	end
end

function sleep1(seconds)
	local endTime = os.time() + seconds
	repeat
	until os.time() >= endTime
end

function round(num, idp)
	local mult = 10 ^ (idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function format_number(amount)
	local formatted = amount

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end

	return formatted
end

--------------------------------------------------------------------------------------------------------

numTimerValues = function(num)
	local hour, minute, second = 0, 0, 0

	hour = string.format("%02.f", math.floor(num / 3600))
	minute = string.format("%02.f", math.floor(num / 60 - (hour * 60)))
	second = string.format("%02.f", math.floor(num - hour * 3600 - minute * 60))

	return hour .. ":" .. minute .. ":" .. second
end

getTimerValues = function(registry)
	local hour, minute, second = 0, 0, 0

	local days, hour, minute, second = 0, 0, 0, 0
	local remainder = 0
	local dif = 0

	if os.time() < core.gameRegistry[registry] then
		dif = core.gameRegistry[registry] - os.time()

		days = string.format("%02.f", math.floor(dif / 86400))
		remainder = (dif % 86400)
		hour = string.format("%02.f", math.floor(remainder / 3600))
		remainder = (dif % 3600)
		minute = string.format("%02.f", math.floor(remainder / 60))
		remainder = (dif % 60)
		second = string.format("%02.f", math.floor(remainder))

		return days .. " days " .. hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	else
		return "00:00:00:00"
	end
end

playerTimerValues = function(player, registry)
	local days, hour, minute, second = 0, 0, 0, 0
	local remainder = 0
	local dif = 0

	if os.time() < player.registry[registry] then
		dif = player.registry[registry] - os.time()

		days = string.format("%02.f", math.floor(dif / 86400))
		remainder = (dif % 86400)
		hour = string.format("%02.f", math.floor(remainder / 3600))
		remainder = (dif % 3600)
		minute = string.format("%02.f", math.floor(remainder / 60))
		remainder = (dif % 60)
		second = string.format("%02.f", math.floor(remainder))

		return days .. " days " .. hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	else
		return "00:00:00:00"
	end
end

playerQuestTimerValues = function(player, registry)
	local days, hour, minute, second = 0, 0, 0, 0
	local remainder = 0
	local dif = 0

	if os.time() < player.quest[registry] then
		dif = player.quest[registry] - os.time()

		days = string.format("%02.f", math.floor(dif / 86400))
		remainder = (dif % 86400)
		hour = string.format("%02.f", math.floor(remainder / 3600))
		remainder = (dif % 3600)
		minute = string.format("%02.f", math.floor(remainder / 60))
		remainder = (dif % 60)
		second = string.format("%02.f", math.floor(remainder))

		return days .. " days " .. hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	else
		return "00:00:00:00"
	end
end

function get_totem_time(player)
	local totems = {"JuJak", "Baekho", "Hyun Moo", "Chung Ryong"}

	--
	local curTotem = ""
	local time = curTime()
	local curTotemID = 0

	if (time <= 0) then
		curTotemID = 3
	elseif (time <= 3) then
		curTotemID = 2
	elseif (time <= 6) then
		curTotemID = 1
	elseif (time <= 9) then
		curTotemID = 0
	elseif (time <= 12) then
		curTotemID = 3
	elseif (time <= 15) then
		curTotemID = 2
	elseif (time <= 18) then
		curTotemID = 1
	elseif (time <= 21) then
		curTotemID = 0
	end

	player.gameRegistry["current_totem_time"] = curTotemID

	return totems[curTotemID + 1]
end

function getPathName(player)
	local pathName = player.className

	return pathName
end

getTotalTimePlayed = function(player)
	--added 8-7-16 for /played

	local hour, minute, second = 0, 0, 0

	local currentTime = (os.time() - player.registry["session_start_time"])

	if player.registry["total_time_played"] > 0 then
		dif = player.registry["total_time_played"] + currentTime
		hour = string.format("%04.f", math.floor(dif / 3600))
		minute = string.format("%02.f", math.floor(dif / 60 - (hour * 60)))
		second = string.format(
			"%02.f",
			math.floor(dif - hour * 3600 - minute * 60)
		)

		return hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	else
		dif = currentTime
		hour = string.format("%04.f", math.floor(dif / 3600))
		minute = string.format("%02.f", math.floor(dif / 60 - (hour * 60)))
		second = string.format(
			"%02.f",
			math.floor(dif - hour * 3600 - minute * 60)
		)
		return hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	end
end

getSessionTimePlayed = function(player)
	--added 8-7-16 for /played

	local hour, minute, second = 0, 0, 0
	local sessionStartTime = player.registry["session_start_time"]

	if sessionStartTime > 0 then
		dif = os.time() - sessionStartTime
		hour = string.format("%03.f", math.floor(dif / 3600))
		minute = string.format("%02.f", math.floor(dif / 60 - (hour * 60)))
		second = string.format(
			"%02.f",
			math.floor(dif - hour * 3600 - minute * 60)
		)

		return hour .. " hours " .. minute .. " minutes " .. second .. " seconds"
	else
		return "00:00:00"
	end
end

sendGUItext = function(string)
	guitext(-1, string)

	-- USAGE in functions         sendguiText("Test String")
end

pushBack = function(player)
	if (player.side == 0) then
		player:warp(player.m, player.x, player.y + 1)
	elseif (player.side == 1) then
		player:warp(player.m, player.x - 1, player.y)
	elseif (player.side == 2) then
		player:warp(player.m, player.x, player.y - 1)
	elseif (player.side == 3) then
		player:warp(player.m, player.x + 1, player.y)
	end
end

sort_relative = function(ref, t, cmp)
	local n = #ref
	assert(#t == n)
	local r = {}
	for i = 1, n do
		r[i] = i
	end
	if not cmp then
		cmp = function(a, b)
			return a < b
		end
	end
	table.sort(r, function(a, b)
		return cmp(ref[a], ref[b])
	end)
	for i = 1, n do
		r[i] = t[r[i]]
	end
	return r
end

sort_relativeDesc = function(ref, t, cmp)
	local n = #ref
	assert(#t == n)
	local r = {}
	for i = 1, n do
		r[i] = i
	end
	if not cmp then
		cmp = function(a, b)
			return a > b
		end
	end
	table.sort(r, function(a, b)
		return cmp(ref[a], ref[b])
	end)
	for i = 1, n do
		r[i] = t[r[i]]
	end
	return r
end

tableUnion = function(a, b)
	local result = {}
	for k, v in pairs(a) do
		table.insert(result, v)
	end
	for k, v in pairs(b) do
		table.insert(result, v)
	end
	return result
end

randomShuffle = function(tInput)
	math.randomseed(os.time())

	-- so that the results are always different
	local tReturn = {}
	for i = #tInput, 1, -1 do
		local j = math.random(i)
		tInput[i], tInput[j] = tInput[j], tInput[i]
		table.insert(tReturn, tInput[i])
	end
	return tReturn
end

-- Return sequence of unique values in a given sequence or table
-- ARGS:
-- t         : a seq or table or Tensor
--             if a table, only the values are considered (not the keys)
--             if a Tensor, must be 1D or 2D
-- RETURNS
-- uniqueSeq : a sequence containing just the unique values in seq

function unique(t)
	-- build set of unique values, so that uniqueElements[v] := true
	local uniqueElements = {}
	if type(t) == 'table' then
		for k, v in pairs(t) do
			if not uniqueElements[v] then
				uniqueElements[v] = true
			end
		end
	elseif type(t) == 'userdata' and t:dim() == 1 then
		for i = 1, t:size(1) do
			uniqueElements[t[i]] = true
		end
	elseif type(t) == 'userdata' and t:dim() == 2 then
		for r = 1, t:size(1) do
			for c = 1, t:size(2) do
				uniqueElements[t[r][c]] = true
			end
		end
	else
		error('bad type or dim for t; type(t) = ' .. type(t))
	end

	-- convert the set into a sequence
	local result = {}
	for k, v in pairs(uniqueElements) do
		table.insert(result, k)
	end

	return result
end

--- Sorts a table of IP addresses
--
-- An in-place sort using <code>table.sort</code> to sort by IP address.
-- Sorting non-IP addresses is likely to result in a bad sort and possibly an infinite loop.
--
-- @param ips The table of IP addresses to sort
-- @param op The comparison operation to use. Default: "lt" (ascending)
ip_sort = function(ips, op)
	op = op or "lt"
	return table.sort(ips, function(a, b)
		return compare_ip(a, op, b)
	end)
end
