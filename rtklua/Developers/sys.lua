_errhandler = function(str)
	return debug.traceback(str)
end

async = function(func)
	return function(player, ...)
		local args = {...}
		_async(player, function()
			func(player, unpack(args))
			_asyncDone(player)
		end)
	end
end

convertGraphic = function(value, class)
	if class == "monster" then
		return 128 * 256 + value
	elseif class == "item" then
		return 192 * 256 + value
	end
	return value
end

getDialog = function(player, dialog)
	if (player.registry["languageSelection"] == 0) then
		return dialogs.english[dialog]
	elseif (player.registry["languageSelection"] == 1) then
		return dialogs.spanish[dialog]
	elseif (player.registry["languageSelection"] == 2) then
		return dialogs.french[dialog]
	elseif (player.registry["languageSelection"] == 3) then
		return dialogs.chinese[dialog]
	elseif (player.registry["languageSelection"] == 4) then
		return dialogs.portuguese[dialog]
	elseif (player.registry["languageSelection"] == 5) then
		return dialogs.indonesian[dialog]
	else
		return dialogs.english[dialog]
	end
end

checkBoard = function(player)
	local del = player.registry["board" .. player.board .. "del"]
	local write = player.registry["board" .. player.board .. "write"]
	player.boardDel = del
	player.boardWrite = write
end

sleep = function(n)
	os.execute("sleep " .. tonumber(n))
end

core = NPC(4294967295)

second = realSecond()
minute = realMinute()
hour = realHour()
day = realDay()

mt_2D = {
	__index = function(t, k)
		local inner = {}
		rawset(t, k, inner)
		return inner
	end
}

spawnTable = setmetatable({}, mt_2D)

instance_members = setmetatable({}, mt_2D)

-------- Carnage ---------

carnageTeams = {}

-----------------------------
rabbit_invasion_queue = {}

instances = {}

openingSceneUsedMaps = {}

openingSceneQueue = {}

advice = {
	"First time in RetroTK? Visit www.retroTK.com or check out the boards",
	"Your legend is the history of your character from experiences to accomplishments and more.",
	"Press 'F1' to gather information about character.",
	"Visit a trainer today to learn new spells. At level 5, you may choose your destiny.",
	"Be courteous and mindful to your fellow players and obey the laws.",
	"Subpaths are chosen at level 99 by visiting the leader of your subpath choice.",
	"Be sure to visit the neighboring towns and cities to learn how to craft better gear.",
	"Find a bug/error? Press 'b to open boards and post or /report the issue"
}

getCurSeason = function()
	local season = "Fall"

	if curSeason() == 1 then
		return "Spring"
	end
	if curSeason() == 2 then
		return "Summer"
	end
	if curSeason() == 3 then
		return "Fall"
	end
	if curSeason() == 4 then
		return "Winter"
	end

	return season
end

secondsToClock = function(totalSeconds)
	local hours, minutes, seconds

	if totalSeconds == 0 then
		return "00:00:00"
	else
		hours = string.format("%02.f", math.floor(totalSeconds / 3600))
		minutes = string.format(
			"%02.f",
			math.floor(totalSeconds / 60 - (hours * 60))
		)
		seconds = string.format(
			"%02.f",
			math.floor(totalSeconds - hours * 3600 - minutes * 60)
		)
		return hours .. ":" .. minutes .. ":" .. seconds
	end
end
