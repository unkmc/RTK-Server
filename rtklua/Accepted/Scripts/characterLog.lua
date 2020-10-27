characterLog = {
	dropLog = function(mob, dropItems, dropAmounts)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/drops/drops_log_" .. os.date("%m.%d.%Y") .. ".txt", ""

		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> [" .. mob.name .. "] | @" .. mob.mapTitle .. " (M: " .. mob.m .. " X:" .. mob.x .. " Y: " .. mob.y .. ") | Dropped items: "

		for i = 1, #dropItems do
			if i ~= #dropItems then
				text = text .. " " .. Item(dropItems[i]).name .. "(" .. dropAmounts[i] .. "),"
			else
				text = text .. " " .. Item(dropItems[i]).name .. "(" .. dropAmounts[i] .. ")"
			end
		end

		text = text .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	bossKillLog = function(mob, groupMembers)
		if (not Config.loggingEnabled) then
			return
		end

		local items = mob:getObjectsInCell(mob.m, mob.x, mob.y, BL_ITEM)
		local names = {}
		local dir, text = "../rtklua/History/logs/boss_kills/boss_kill_log_" .. os.date("%m.%d.%Y") .. ".txt", ""

		local file = io.open(dir, "a+")

		if #items > 0 then
			for i = 1, #items do
				table.insert(names, items[i].amount .. " " .. items[i].name)
			end
		end

		text = text .. "<" .. os.date() .. "> [" .. mob.name .. "] killed by "

		if #groupMembers == 1 then
			text = text .. Player(groupMembers[1].id).name
		elseif #groupMembers > 1 then
			for i = 1, #groupMembers do
				text = text .. Player(groupMembers[i].id).name .. ", "
			end
		end

		text = text .. " | @" .. mob.mapTitle .. " (" .. mob.m .. ") | Dropped items: " .. table.concat(
			names,
			", "
		) .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	whisperLog = function(dstName, srcName, msg)
		if (not Config.loggingEnabled) then
			return
		end

		dstName = string.lower(dstName)
		srcName = string.lower(srcName)

		local srcPlayer = Player(srcName)

		local file1 = "../rtklua/History/logs/chatlogs/whispers/" .. dstName .. "<=>" .. srcName .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file2 = "../rtklua/History/logs/chatlogs/whispers/" .. srcName .. "<=>" .. dstName .. "_" .. os.date("%m.%d.%Y") .. ".txt"

		if io.open(file1, "r") ~= nil then
			-- checks existence of each file. if they both do not exist, then makes new file using file1 format
			file = io.open(file1, "a+")
		elseif io.open(file2, "r") ~= nil then
			file = io.open(file2, "a+")
		else
			file = io.open(file1, "a+")
		end

		local text = srcName .. ": " .. msg .. " | " .. os.date() .. " | @" .. srcPlayer.mapTitle .. " (" .. srcPlayer.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	clanChatLog = function(srcName, speech)
		if (not Config.loggingEnabled) then
			return
		end

		srcName = string.lower(srcName)
		local player = Player(srcName)

		local dir, text = "../rtklua/History/logs/chatlogs/clan/" .. getClanName(player.clan) .. "_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	groupChatLog = function(srcName, speech)
		if (not Config.loggingEnabled) then
			return
		end

		srcName = string.lower(srcName)
		local player = Player(srcName)

		local dir, text = "../rtklua/History/logs/chatlogs/groups/groupChatLog_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	noviceChatLog = function(srcName, speech)
		if (not Config.loggingEnabled) then
			return
		end

		srcName = string.lower(srcName)
		local player = Player(srcName)

		local dir, text = "../rtklua/History/logs/chatlogs/novice/noviceChatLog_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	subPathChatLog = function(srcName, speech)
		if (not Config.loggingEnabled) then
			return
		end

		srcName = string.lower(srcName)
		local player = Player(srcName)

		local dir, text = "../rtklua/History/logs/chatlogs/subpath/" .. player.className .. "_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	exchangeLogWrite = function(player1, player2)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/exchange/exchange_log_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		local items1 = {}

		-- these will go to player 2
		local gold1 = player1.exchangeMoney

		local items2 = {}

		-- these will go to player 1
		local gold2 = player2.exchangeMoney

		if player1.exchangeItemCount > 0 then
			for i = 0, player1.exchangeItemCount do
				table.insert(items1, player1:getExchangeItem(i))
			end
		end

		if player2.exchangeItemCount > 0 then
			for i = 0, player2.exchangeItemCount do
				table.insert(items2, player2:getExchangeItem(i))
			end
		end

		text = "==== [Exchange between " .. player1.name .. " and " .. player2.name .. " | " .. os.date() .. " | @" .. player1.mapTitle .. " (" .. player1.m .. ")] ==================================================================\n"
		text = text .. player1.name .. " receives " .. Tools.formatNumber(gold2) .. " gold from " .. player2.name .. "\n"
		text = text .. player2.name .. " receives " .. Tools.formatNumber(gold1) .. " gold from " .. player1.name .. "\n"

		if #items2 > 0 then
			text = text .. player1.name .. " receives items from " .. player2.name .. ":\n"
			for i = 1, #items2 do
				if items2[i].realName ~= "" then
					text = text .. i .. ". **" .. items2[i].realName .. "** (" .. items2[
						i
					].name .. ") amount: " .. Tools.formatNumber(items2[i].amount)
				else
					text = text .. i .. ". " .. items2[i].name .. " amount: " .. Tools.formatNumber(items2[i].amount)
				end

				if items2[i].owner > 0 then
					text = text .. " Owner: " .. getOfflineID(items2[i].owner)
				end

				text = text .. "\n"
			end
		else
			text = text .. player1.name .. " receives no items from " .. player2.name .. "\n"
		end

		if #items1 > 0 then
			text = text .. player2.name .. " receives items from " .. player1.name .. ":\n"
			for i = 1, #items1 do
				if items1[i].realName ~= "" then
					text = text .. i .. ". **" .. items1[i].realName .. "** (" .. items1[
						i
					].name .. ") amount: " .. Tools.formatNumber(items1[i].amount)
				else
					text = text .. i .. ". " .. items1[i].name .. " amount: " .. Tools.formatNumber(items1[i].amount)
				end

				if items1[i].owner > 0 then
					text = text .. " Owner: " .. getOfflineID(items2[i].owner)
				end

				text = text .. "\n"
			end
		else
			text = text .. player2.name .. " receives no items from " .. player1.name .. "\n"
		end

		file:write(text .. "")
		file:flush()
	end,

	massExchangeWrite = function(player1, player1gold, player1items, player2, player2gold, player2items)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/exchange/mass_exchange_log_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "==== [Mass Exchange between " .. player1.name .. " and " .. player2.name .. " | " .. os.date() .. " | @" .. player1.mapTitle .. " (" .. player1.m .. ")] ==================================================================\n"
		text = text .. player1.name .. " receives " .. Tools.formatNumber(player2gold) .. " gold from " .. player2.name .. "\n"
		text = text .. player2.name .. " receives " .. Tools.formatNumber(player1gold) .. " gold from " .. player1.name .. "\n"

		if #player2items > 0 then
			text = text .. player1.name .. " receives items from " .. player2.name .. ":\n"

			for i = 1, #player2items do
				if player2items[i].realName ~= "" then
					text = text .. i .. ". **" .. player2items[i].realName .. "** (" .. player2items[
						i
					].name .. ") amount: " .. Tools.formatNumber(player2items[i].amount)
				else
					text = text .. i .. ". " .. player2items[i].name .. " amount: " .. Tools.formatNumber(player2items[i].amount)
				end

				if player2items[i].owner > 0 then
					text = text .. " Owner: " .. getOfflineID(player2items[i].owner)
				end

				text = text .. "\n"
			end
		else
			text = text .. player1.name .. " receives no items from " .. player2.name .. "\n"
		end

		if #player1items > 0 then
			text = text .. player2.name .. " receives items from " .. player1.name .. ":\n"
			for i = 1, #player1items do
				if player1items[i].realName ~= "" then
					text = text .. i .. ". **" .. player1items[i].realName .. "** (" .. player1items[
						i
					].name .. ") amount: " .. Tools.formatNumber(player1items[i].amount)
				else
					text = text .. i .. ". " .. player1items[i].name .. " amount: " .. Tools.formatNumber(player1items[i].amount)
				end

				if player1items[i].owner > 0 then
					text = text .. " Owner: " .. getOfflineID(player1items[i].owner)
				end

				text = text .. "\n"
			end
		else
			text = text .. player2.name .. " receives no items from " .. player1.name .. "\n"
		end

		file:write(text .. "")
		file:flush()
	end,

	carnageTeamChatLog = function(text)
		if (not Config.loggingEnabled) then
			return
		end

		local dir = "../rtklua/History/logs/chatlogs/events/carnageTeamChatLog_" .. os.date("%m.%d.%Y") .. ".txt"
		local file = io.open(dir, "a+")

		text = "<" .. os.date() .. "> " .. text .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	bottingLog = function(player, inputText)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir1 = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local dir2 = "../rtklua/History/logs/botting/botting_log_" .. os.date("%m.%d.%Y") .. ".txt"

		local file1 = io.open(dir1, "a+")
		local file2 = io.open(dir2, "a+")

		local text = "<" .. os.date() .. "> " .. inputText .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file1:write(text .. "")
		file1:flush()

		file2:write(text .. "")
		file2:flush()
	end,

	wisdomStarDailyTotal = function()
		if (not Config.loggingEnabled) then
			return
		end

		local amount = getKanDonationPoints()

		local dir, text = "../rtklua/History/logs/wisdom_star/wisdomStarLog_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date("%m.%d.%Y") .. "> Total Kan spent on Wisdom Star: " .. amount .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	wisdomStar = function(player, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/wisdom_star/wisdomStarLog_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. ") spent " .. amount .. " Kan on Wisdom Star | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	sage = function(player, speech)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/chatlogs/sage/sageLog_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		if player.gmLevel ~= 0 then
			text = text .. "<" .. os.date() .. "> [GM " .. player.name .. "]: " .. speech .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"
		else
			text = text .. "<" .. os.date() .. "> [" .. player.name .. "]: " .. speech .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"
		end

		file:write(text .. "")
		file:flush()
	end,

	localChat = function(player, speech)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/chatlogs/general/chatLog_full_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	gmSpeechWrite = function(player, speech)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/chatlogs/gm/chatLog_" .. player.name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	speechWrite = function(player, speech)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/chatlogs/characters/chatLog_" .. player.name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. player.name .. "(" .. player.ID .. "): '" .. speech .. "' | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	loginLog = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "==== [Login] ==================================================================\n"
		text = text .. " " .. player.name .. " has logged in ~ @" .. player.mapTitle .. "(" .. player.m .. ")\n"
		text = text .. " " .. Tools.formatNumber(player.money) .. " gold.\n"
		text = text .. " " .. Tools.formatNumber(player.exp) .. " experience.\n"
		text = text .. " " .. player.karma .. " karma.\n"
		text = text .. " IP: " .. player.ipaddress .. "\n"
		text = text .. "Date & Time : " .. os.date() .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	logoutLog = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "==== [Logout] ==================================================================\n"
		text = text .. " " .. player.name .. " has logged out ~ @" .. player.mapTitle .. "(" .. player.m .. ")\n"
		text = text .. " " .. Tools.formatNumber(player.money) .. " gold.\n"
		text = text .. " " .. Tools.formatNumber(player.exp) .. " experience.\n"
		text = text .. " " .. player.karma .. " karma.\n"
		text = text .. " IP: " .. player.ipaddress .. "\n"
		text = text .. "Date & Time : " .. os.date() .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	xpSellWrite = function(player, stat, amount, cost)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "==== [Stat | Vita/Mana Gain] ==================================================================\n"
		text = text .. "<" .. os.date() .. "> Sold " .. Tools.formatNumber(cost) .. " experience for " .. Tools.formatNumber(amount) .. " " .. stat .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	xpSellWrite2 = function(player, stat, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> Gained " .. Tools.formatNumber(amount) .. " " .. stat .. " while training | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	xpWrite = function(player, xp, mob)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> Gained " .. Tools.formatNumber(xp) .. " from " .. mob.name .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	giveXPWrite = function(player, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> Gained " .. Tools.formatNumber(amount) .. " experience | @" .. player.mapTitle .. " (" .. player.m .. ")\n"
		file:write(text .. "")
		file:flush()
	end,

	nameChangeWrite = function(player, oldName)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir1, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file1 = io.open(dir1, "a+")

		local dir2 = "../rtklua/History/logs/nameChanges/nameChangeLog_" .. os.date("%m.%d.%Y") .. ".txt"
		local file2 = io.open(dir2, "a+")

		text = text .. "<" .. os.date() .. "> " .. oldName .. " has changed their name to " .. player.name .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file1:write(text .. "")
		file1:flush()

		file2:write(text .. "")
		file2:flush()
	end,

	genericWrite = function(player, string)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. string .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	questWrite = function(player, string)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> " .. string .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	spellDamageLog = function(player, target, damage)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/spell_log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "-[Damage Out]-\n"
		text = text .. "Date & Time     : " .. os.date() .. "\n"
		text = text .. "Target Name     : " .. target.name .. "\n"
		text = text .. "Spell Damage    : " .. damage .. "\n\n"

		file:write(text .. "")
		file:flush()
	end,

	swingDamageLog = function(player, target, damage)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/swing_log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "-[Damage Out]-\n"
		text = text .. "Date & Time     : " .. os.date() .. "\n"
		text = text .. "Target Name     : " .. target.name .. "\n"
		text = text .. "Target Armor    : " .. target.armor .. "\n"
		text = text .. "Swing Damage    : " .. damage .. "\n\n"

		file:write(text .. "")
		file:flush()
	end,

	addGoldWrite = function(player, money)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> ADDED GOLD: " .. Tools.formatNumber(money) .. "  TOTAL GOLD: " .. player.money .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	removeGoldWrite = function(player, money)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> REMOVED GOLD: " .. Tools.formatNumber(money) .. "  TOTAL GOLD: " .. player.money .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	levelUpWrite = function(player, level)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> LEVELED UP TO: " .. player.level .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	pickUpWrite = function(player, item, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local pickup = ""

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		if player.pickUpType == 0 then
			pickup = "Comma"
		elseif player.pickUpType == 1 then
			pickup = "Shift + Comma"
		elseif player.pickUpType == 3 then
			pickup = "Ctrl + Comma"
		end

		text = text .. "<" .. os.date() .. "> PICKED UP: " .. amount .. " " .. item.name .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. " | " .. pickup .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	dropWrite = function(player, item)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> DROPPED: " .. item.amount .. " " .. item.name .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	equipRestore = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local item = player:getEquippedItem(player.equipSlot)

		local name = string.lower(player.name)

		local dir = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file = io.open(dir, "a+")

		local text = ""
		local name = ""

		if item.realName ~= "" then
			name = item.realname .. " (" .. item.name .. ")"
		else
			name = item.name
		end

		text = text .. "<" .. os.date() .. "> Equipment restored: " .. name .. "      Protects remaining: " .. item.protected .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	equipBreak = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local item = player:getEquippedItem(player.equipSlot)

		local name = string.lower(player.name)

		local dir = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file = io.open(dir, "a+")

		local text = ""
		local name = ""

		if item.realName ~= "" then
			name = item.realname .. " (" .. item.name .. ")"
		else
			name = item.name
		end

		text = text .. "<" .. os.date() .. "> Equipment broken/destroyed: " .. name .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	invRestore = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local item = player:getEquippedItem(player.invSlot)

		local name = string.lower(player.name)

		local dir = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file = io.open(dir, "a+")

		local text = ""
		local name = ""

		if item.realName ~= "" then
			name = item.realname .. " (" .. item.name .. ")"
		else
			name = item.name
		end

		text = text .. "<" .. os.date() .. "> Item restored: " .. name .. "      Protects remaining: " .. item.protected .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	invBreak = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local item = player:getEquippedItem(player.invSlot)

		local name = string.lower(player.name)

		local dir = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file = io.open(dir, "a+")

		local text = ""
		local name = ""

		if item.realName ~= "" then
			name = item.realname .. " (" .. item.name .. ")"
		else
			name = item.name
		end

		text = text .. "<" .. os.date() .. "> Item broken/destroyed: " .. name .. " | @" .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"

		file:write(text .. "")
		file:flush()
	end,

	bodLog = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local items = {}

		for i = 0, player.BODItemCount do
			table.insert(items, player:getBODItem(i))
		end

		local dir, text = "../rtklua/History/logs/death/bod_log_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		local name = string.lower(player.name)

		local dir2 = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt"
		local file2 = io.open(dir2, "a+")

		text = "\n==== [Break on Death] ==================================================================\n"
		text = text .. "Player      : " .. player.name .. " (ID: " .. player.ID .. ")\n"
		text = text .. "Date & Time : " .. os.date() .. "\n"
		text = text .. "Location    : " .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"
		text = text .. "Items       : \n"

		if #items > 0 then
			for i = 1, #items do
				if items[i].realName ~= "" then
					text = text .. i .. ". **" .. items[i].realName .. "** (" .. items[
						i
					].name .. ") amount: " .. items[i].amount
				else
					text = text .. i .. ". " .. items[i].name .. " amount: " .. items[
						i
					].amount
				end

				if items[i].owner > 0 then
					text = text .. " Owner: " .. getOfflineID(items[i].owner)
				end

				text = text .. "\n"
			end
		end

		file:write(text .. "")
		file:flush()

		file2:write(text .. "")
		file2:flush()
	end,

	deathPileLog = function(player)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/death/deathpile_log_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "\n==== [Death Pile] ==================================================================\n"
		text = text .. "Player      : " .. player.name .. " (ID: " .. player.ID .. ")\n"
		text = text .. "Date & Time : " .. os.date() .. "\n"
		text = text .. "Location    : " .. player.mapTitle .. " (" .. player.m .. ") | X: " .. player.x .. " Y: " .. player.y .. "\n"
		text = text .. "Items       : \n"
		text = characterLog.getDeathPileItems(player, text)

		file:write(text .. "")
		file:flush()
	end,

	getDeathPileItems = function(player, text)
		if (not Config.loggingEnabled) then
			return
		end

		local m, x, y = player.m, player.x, player.y

		local deathPile = player:getObjectsInCell(m, x, y, BL_ITEM)

		if #deathPile > 0 then
			for i = 1, #deathPile do
				if player:isYours(deathPile[i]) then
					text = text .. "" .. i .. ": " .. deathPile[i].name .. " (" .. deathPile[
						i
					].amount .. ")\n"
				end
			end
		end

		return text
	end,

	kanLogs = function(player, item, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/kan/kan_log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		local cost = item.price * amount

		text = "==== [Kan Purchase] ==================================================================\n"
		text = text .. "Date & Time     : " .. os.date() .. "\n"
		text = text .. "Map             : " .. player.mapTitle .. "\n"
		text = text .. "Item            : " .. item.name .. "\n"
		text = text .. "Amount          : " .. amount .. "\n"
		text = text .. "Cost            : " .. Tools.formatNumber(cost) .. "\n"
		text = text .. "Beginning Kan   : " .. Tools.formatNumber(player.registry["kan"]) .. "\n"
		text = text .. "Remaining Kan   : " .. Tools.formatNumber(player.registry["kan"] - cost) .. "\n\n"

		file:write(text .. "")
		file:flush()
	end,

	kanCertificateAdd = function(player, item)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/kan/kan_log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = "==== [Kan Certificate Used] ==================================================================\n"
		text = text .. "Date & Time     : " .. os.date() .. "\n"
		text = text .. "Map             : " .. player.mapTitle .. "\n"
		text = text .. "Item            : " .. item.name .. "\n"
		text = text .. "Amount          : " .. item.price .. "\n"
		text = text .. "Beginning Kan   : " .. Tools.formatNumber(player.registry["kan"]) .. "\n"
		text = text .. "After Kan       : " .. Tools.formatNumber(player.registry["kan"] + item.price) .. "\n\n"

		file:write(text .. "")
		file:flush()
	end,

	sellItemWrite = function(player, item, amount, cost)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> SOLD: " .. item.name .. " Amount: " .. amount .. " for " .. Tools.formatNumber(cost) .. " gold. | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	buyItemWrite = function(player, item, amount, cost)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> BOUGHT: " .. item.name .. " Amount: " .. amount .. " for " .. Tools.formatNumber(cost) .. " gold. | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	withdrawItemWrite = function(player, item, engrave, amount, owner)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> "
		if engrave ~= "" then
			text = text .. "WITHDREW: " .. engrave .. " (" .. item .. ")  "
		else
			text = text .. "WITHDREW: " .. item .. "  "
		end

		text = text .. "Amount: " .. amount .. " "

		if owner > 0 then
			text = text .. "Owner: " .. getOfflineID(owner) .. " "
		end

		text = text .. "| @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	depositItemWrite = function(player, item, engrave, amount, owner)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> "
		if engrave ~= "" then
			text = text .. "DEPOSITED: " .. engrave .. " (" .. item .. ")  "
		else
			text = text .. "DEPOSITED: " .. item .. "  "
		end

		text = text .. "Amount: " .. amount .. " "

		if owner > 0 then
			text = text .. "Owner: " .. getOfflineID(owner) .. " "
		end

		text = text .. "| @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	withdrawGoldWrite = function(player, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> WITHDREW GOLD: " .. Tools.formatNumber(amount) .. "  TOTAL DEPOSITED GOLD: " .. Tools.formatNumber(player.bankMoney) .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	depositGoldWrite = function(player, amount)
		if (not Config.loggingEnabled) then
			return
		end

		local name = string.lower(player.name)

		local dir, text = "../rtklua/History/logs/characterlog/log_" .. name .. "_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = text .. "<" .. os.date() .. "> DEPOSITED GOLD: " .. Tools.formatNumber(amount) .. "  TOTAL DEPOSITED GOLD: " .. Tools.formatNumber(player.bankMoney) .. " | @" .. player.mapTitle .. " (" .. player.m .. ")\n"

		file:write(text .. "")
		file:flush()
	end,

	inputLog = function(player, string)
		if (not Config.loggingEnabled) then
			return
		end

		local dir, text = "../rtklua/History/logs/input/input_log_" .. os.date("%m.%d.%Y") .. ".txt", ""
		local file = io.open(dir, "a+")

		text = player.name .. " string: " .. string .. "\n"

		file:write(text .. "")
		file:flush()
	end
}
