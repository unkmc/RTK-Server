onSay = function(player)
	local printf = 1
	local speech = player.speech
	local p = player

	if (speech == "") then
		return
	end

	local lspeech = string.lower(player.speech)
	local online = player:getUsers()
	local talkType = player.talkType

	if player:hasDuration("dagger_to_throat") then
		player:sendMinitext("Your anxiety renders you speechless.")
		return
	end

	-- speech hotkeys -------
	if string.match(speech, "/s") and string.match(speech, "/s .+") ~= nil and player.gmLevel == 0 then
		local subString = string.sub(speech, 4)
		player.speech = subString
		speech = subString
		lspeech = string.lower(player.speech)
		talkType = 1
	end

	-- end speech hotkeys ----------

	local distance = 0

	if talkType == 0 then
		distance = 8
	elseif talkType == 1 then
		distance = 16
	end

	if (string.match(lspeech, "/roll") and string.match(lspeech, "/roll %d+") == nil) then
		local roll = math.random(0, 100)
		broadcast(player.m, player.name .. " rolled 0-100, result: " .. roll)
		printf = 0
	elseif (string.match(lspeech, "/roll %d+") ~= nil and string.match(
		lspeech,
		"/roll %d+%-%d+"
	) == nil) then
		local number = tonumber(string.match(lspeech, "/roll (%d+)"))
		local roll = math.random(0, number)
		broadcast(
			player.m,
			player.name .. " rolled 0-" .. number .. ", result: " .. roll
		)
		printf = 0
	elseif (string.match(lspeech, "/roll %d+") ~= nil and string.match(
		lspeech,
		"/roll %d+%-%d+"
	) ~= nil) then
		local number1 = tonumber(string.match(lspeech, "(%d+)"))
		local number2 = tonumber(string.match(lspeech, "%-(%d+)"))
		local roll = math.random(number1, number2)
		broadcast(
			player.m,
			player.name .. " rolled " .. number1 .. "-" .. number2 .. ", result: " .. roll
		)
		printf = 0
	end

	if lspeech == "/age" or lspeech == "how old am i" or lspeech == "how old am i?" then
		local dif = os.time() - player.registry["firstTimeLogin"]

		local days = string.format("%02.f", math.floor(dif / 86400))
		local remainder = (dif % 86400)
		local hour = string.format("%02.f", math.floor(remainder / 3600))
		remainder = (dif % 3600)
		local minute = string.format("%02.f", math.floor(remainder / 60))
		remainder = (dif % 60)
		local second = string.format("%02.f", math.floor(remainder))

		player:talk(
			0,
			player.name .. ": I am " .. days .. " days, " .. hour .. " hours, " .. minute .. " minutes, " .. second .. " seconds old."
		)

		printf = 0
	end

	--[[if (string.match(lspeech, "/random") and string.match(lspeech, "/random %d+") == nil) then
			local roll = math.random(0,100)
			broadcast(player.m,player.name.." rolled 0-100, result: "..roll)
			printf = 0
	elseif (string.match(lspeech, "/random %d+") ~= nil and string.match(lspeech, "/random %d+%-%d+") == nil) then
			local number = tonumber(string.match(lspeech, "/random (%d+)"))
			local roll = math.random(0,number)
			broadcast(player.m,player.name.." rolled 0-"..number..", result: "..roll)
			printf = 0
	elseif (string.match(lspeech, "/random %d+") ~= nil and string.match(lspeech, "/random %d+%-%d+") ~= nil) then
			local number1 = tonumber(string.match(lspeech, "(%d+)"))
			local number2 = tonumber(string.match(lspeech, "%-(%d+)"))
			local roll = math.random(number1,number2)
			broadcast(player.m,player.name.." rolled "..number1.."-"..number2..", result: "..roll)
			printf = 0
	end]]
	--

	if string.match(lspeech, "/killcount") ~= nil and player.gmLevel == 99 then
		local words = {}
		for word in lspeech:gmatch("[%w_]+") do
			table.insert(words, word)
		end

		if words[2] ~= nil then
			player:talkSelf(0, "kills: " .. player:killCount(words[2]))
		end

		printf = 0
	end

	if string.match(lspeech, "/help") ~= nil then
		player:msg(
			4,
			"/whisper <name> <message> - send a private message",
			player.ID
		)
		player:msg(
			4,
			"/clanchat <message> - send a message to your clan",
			player.ID
		)
		player:msg(
			4,
			"/subpathchat (/sp) <message> - send a message to your subpath",
			player.ID
		)
		player:msg(
			4,
			"/whisper <name> <message> - send a private message",
			player.ID
		)
		player:msg(
			4,
			"/shout <message> - shout a message to everyone around you",
			player.ID
		)
		player:msg(
			4,
			"/novice <message> - send a message to the new player channel",
			player.ID
		)
		player:msg(
			4,
			"/random <number>-<number> - rolls a random number",
			player.ID
		)
		printf = 0
	end

	if string.match(lspeech, "/score") ~= nil then
		local team = 0

		for i = 1, #carnageTeams do
			if carnageTeams[i].ID == player.ID then
				team = carnageTeams[i].team
			end
		end

		if team == 0 then
			player:msg(0, "You are not on a team.", player.ID)
			return
		end

		local text = "Team     Player      Kills      Deaths      Damage      Healing\n"

		for i = 1, 4 do
			for j = 1, #carnageTeams do
				if carnageTeams[j].team == i and Player(carnageTeams[j].ID) ~= nil then
					text = text .. i .. "        " .. Player(carnageTeams[j].ID).name .. "        " .. carnageTeams[
						j
					].kills .. "          " .. carnageTeams[j].deaths .. "            " .. carnageTeams[
						j
					].damage .. "           " .. carnageTeams[j].healing .. "\n"
				end
			end
		end

		player:paperpopup(26, 25, text)

		printf = 0
	end

	if string.match(lspeech, "/team (.+)") ~= nil then
		local text = string.match(lspeech, "/team (.+)")

		local team = 0

		for i = 1, #carnageTeams do
			if carnageTeams[i].ID == player.ID then
				team = carnageTeams[i].team
			end
		end

		if team == 0 then
			player:msg(0, "You are not on a team.", player.ID)
			return
		end

		for i = 1, #carnageTeams do
			if carnageTeams[i].team == team then
				if Player(carnageTeams[i].ID) ~= nil then
					characterLog.carnageTeamChatLog("@" .. player.mapTitle .. " (" .. player.m .. ") [Team " .. team .. "]" .. player.name .. " (" .. player.className .. ")> " .. text)
					Player(carnageTeams[i].ID):msg(
						4,
						"[Team]" .. player.name .. " (" .. player.className .. ")> " .. text,
						player.ID
					)
				end
			end
		end

		printf = 0
	end

	if lspeech == "/imstuck" then
		player:warp(0, 115, 15)
		player:sendMinitext("unstuck.")
		printf = 0
	end

	if lspeech == "/trade" then
		if player.tradeChat == 0 then
			player.tradeChat = 1
			player:sendMinitext("Trade Chat: ON")
		elseif player.tradeChat == 1 then
			player.tradeChat = 0
			player:sendMinitext("Trade Chat: OFF")
		end
		printf = 0
	end

	if lspeech == "/freeasync" then
		player:freeAsync()
		player:sendMinitext("async freed.")
		printf = 0
	end

	-- set afk message
	if (string.sub(lspeech, 1, 5) == "/afk ") then
		player.afkMessage = string.sub(lspeech, 6)
		printf = 0
	end

	-- Test connection speed
	if (lspeech == "/ping") then
		if player:hasDuration("ping") then
			player:setDuration("ping", 0)
		else
			player:setDuration("ping", 60000)
		end
		printf = 0
	end

	-- Time Played (added 8-7-16)
	if (lspeech == "/played") then
		player:msg(
			4,
			"This session: " .. getSessionTimePlayed(player),
			player.ID
		)
		player:msg(
			4,
			"Total time played: " .. getTotalTimePlayed(player),
			player.ID
		)

		printf = 0
	end

	if lspeech == "packetn" then
		player.registry["packetid"] = player.registry["packetid"] + 1
		player:sendMinitext("packet id: " .. player.registry["packetid"] .. " subtype: " .. player.registry[
			"packetsubtype"
		])
		local packet = {
			170,
			7,
			player.registry["packetid"],
			1,
			player.registry["packetsubtype"],
			2
		}
		player:testPacket(packet)
		printf = 0
	end
	if lspeech == "packetp" then
		player.registry["packetid"] = player.registry["packetid"] - 1
		player:sendMinitext("packet id: " .. player.registry["packetid"] .. " subtype: " .. player.registry[
			"packetsubtype"
		])
		local packet = {
			170,
			7,
			player.registry["packetid"],
			1,
			player.registry["packetsubtype"],
			2
		}
		player:testPacket(packet)
		printf = 0
	end

	if lspeech == "packetsubn" then
		player.registry["packetsubtype"] = player.registry["packetsubtype"] + 1
		player:sendMinitext("packet id: " .. player.registry["packetid"] .. " subtype: " .. player.registry[
			"packetsubtype"
		])
		local packet = {
			170,
			7,
			player.registry["packetid"],
			1,
			player.registry["packetsubtype"],
			2
		}
		player:testPacket(packet)
		printf = 0
	end
	if lspeech == "packetsubp" then
		player.registry["packetsubtype"] = player.registry["packetsubtype"] - 1
		player:sendMinitext("packet id: " .. player.registry["packetid"] .. " subtype: " .. player.registry[
			"packetsubtype"
		])
		local packet = {
			170,
			7,
			player.registry["packetid"],
			1,
			player.registry["packetsubtype"],
			2
		}
		player:testPacket(packet)
		printf = 0
	end

	----------------------------------------------------------------------------------------------------------------------

	if player.state == 0 then
		if lspeech == "lol" then
			player:sendAction(11, 80)
		end
	end

	-- --------------------------------------------------------------
	-- Non-GM stat editing and item spawning (for beta testing only)
	-- --------------------------------------------------------------
	if (Config.freeStatsAndItemsEnabled) then
		local exp = string.match(lspeech, "/exp (%d+)")

		if (exp ~= nil) then
			exp = tonumber(exp)
			exp = math.min(exp, 4294967295)
			player.exp = exp
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Your total exp was changed to " .. Tools.formatNumber(exp) .. "!")
			return
		end

		local vita = string.match(lspeech, "/vita (%d+)")

		if (vita ~= nil) then
			vita = tonumber(vita)

			if (vita < 53) then
				player:sendMinitext("bleh " .. vita)
				player:sendMinitext("That's a little risky. Don't you think?")
				return
			end

			if (vita > 2560000) then
				player:sendMinitext("That's awfully ambitious of you. Maybe tone it down a bit?")
				return
			end

			player.baseHealth = vita
			player.registry["baseHealth"] = vita
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Your base vita was changed to " .. Tools.formatNumber(vita) .. "!")
			return
		end

		local mana = string.match(lspeech, "/mana (%d+)")

		if (mana ~= nil) then
			mana = tonumber(mana)

			if (mana < 35) then
				player:sendMinitext("Not gonna get far like that.")
				return
			end

			if (mana > 1280000) then
				player:sendMinitext("I'm sure you'll get by without quite that much.")
				return
			end

			player.baseMagic = mana
			player.registry["baseMagic"] = mana
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Your base mana was changed to " .. Tools.formatNumber(mana) .. "!")
			return
		end

		local mark = string.match(lspeech, "/mark (%d+)")

		if (mark ~= nil) then
			mark = tonumber(mark)

			if (mark < 0) then
				player:sendMinitext("Behave now. Trying to do something nice for you here.")
				return
			end

			if (mark > 3) then
				player:sendMinitext("Sorry, not happening.")
				return
			end

			player:updatePath(player.class, mark)
			player:sendStatus()
			player:sendMinitext("Mark changed to " .. mark .. "!")
			return
		end

		local item = string.match(lspeech, "/item ([%a_+]+)")
		local amount = string.match(lspeech, "/item [%a_+]+ (%d+)")

		if (item ~= nil) then
			if (amount ~= nil) then
				amount = tonumber(amount)
				amount = math.max(amount, 1)
				amount = math.min(amount, 201)
			else
				amount = 1

			end

			player:addItem(item, amount)
			player:sendMinitext("You received " .. amount .. " " .. item .. "(s)!")
			return
		end
	end

	----------------------------------------------------------------------------------------------------------------------
	-- ===============================================================================================================
	-- ================================= GM COMMANDs =================================================================

	if player.gmLevel >= 99 and string.sub(lspeech, 1, 1) == "/" then
		if (lspeech == "/testlua" or lspeech == "/tl") then
			-- Runs Lua code specified in config.lua; used for quick testing of Lua scripts
			Tools.testLua(player)
			return
		end

		if (lspeech == "/dps") then
			player:calcDPS(500)
			return
		end

		local enchant = string.match(lspeech, "/dps (%d+%.*%d*)")

		if (enchant ~= nil) then
			player.enchant = enchant
			player:sendMinitext("Enchant set to " .. enchant .. "x damage!")
			player:calcDPS(500)
			return
		end

		enchant = string.match(lspeech, "/enchant (%d+%.*%d*)")

		if (enchant ~= nil) then
			player.enchant = enchant
			player:sendMinitext("Enchant set to " .. enchant .. "x damage!")
			return
		end

		local exp = string.match(lspeech, "/exp (%d+)")

		if (exp ~= nil) then
			player.exp = exp
			player:calcStat()
			player:sendStatus()
			return
		end

		local vita = string.match(lspeech, "/vita (%d+)")

		if (vita ~= nil) then
			player.baseHealth = vita
			player.registry["baseHealth"] = vita
			player:calcStat()
			player:sendStatus()
			return
		end

		local mana = string.match(lspeech, "/mana (%d+)")

		if (mana ~= nil) then
			player.baseMagic = mana
			player.registry["baseMagic"] = mana
			player:calcStat()
			player:sendStatus()
			return
		end

		local mark = string.match(lspeech, "/mark (%d+)")

		if (mark ~= nil) then
			player:updatePath(player.class, mark)
			player:sendStatus()
			player:sendMinitext("Mark changed to " .. mark .. "!")
			return
		end

		local might = string.match(lspeech, "/might (%d+)")

		if (might ~= nil) then
			player.baseMight = might
			player.registry["baseMight"] = might
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Might changed to " .. might .. "!")
			return
		end

		local grace = string.match(lspeech, "/grace (%d+)")

		if (grace ~= nil) then
			player.baseGrace = grace
			player.registry["baseGrace"] = grace
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Grace changed to " .. grace .. "!")
			return
		end

		local will = string.match(lspeech, "/will (%d+)")

		if (will ~= nil) then
			player.baseWill = will
			player.registry["baseWill"] = will
			player:calcStat()
			player:sendStatus()
			player:sendMinitext("Will changed to " .. will .. "!")
			return
		end

		local reload = {
			"/reloadlua",
			"/rl",
			"/reloadmaps",
			"/rm",
			"/reloadnpc",
			"/rnpc",
			"/reloadmob",
			"/rmob",
			"/reloadspawn",
			"rspawn",
			"/reloaditem",
			"/ritem",
			"/reloadmagic",
			"/rspell",
			"/reloadboard",
			"/rboard",
			"/reloadcreate",
			"/rcreate",
			"/reloadwarps",
			"/rw",
			"reloadclass",
			"/rclass"
		}
		local text = {
			"LUA Scripts",
			"LUA Scripts",
			"Maps DB",
			"Maps DB",
			"NPCs DB",
			"NPCs DB",
			"Mobs DB",
			"Mobs DB",
			"Spawns DB",
			"Spawns DB",
			"Items Data",
			"Items Data",
			"Spells & Magics",
			"Spells & Magics",
			"Boards DB",
			"Boards DB",
			"Creation Items Table",
			"Creation Items Table",
			"Warps Data",
			"Warps Data",
			"Class DB",
			"Class DB"
		}
		for i = 1, #reload do
			if lspeech == reload[i] then
				for x = 1, #online do
					if online[x].gmLevel > 0 then
						online[x]:msg(
							11,
							"[System] " .. text[i] .. " Reloaded   By: " .. player.name .. "",
							online[x].ID
						)
					end
				end
			end
		end

		if string.match(lspeech, "/gmwarp") ~= nil then
			local mapName = string.match(lspeech, "/gmwarp (.+)")
			GmWarp(player, string.match(lspeech, mapName))
			printf = 0
		end

		if string.match(lspeech, "/gm (.+)") ~= nil then
			local text = string.match(lspeech, "/gm (.+)")

			broadcast(-1, "[GM]" .. player.name .. ": " .. text)

			printf = 0
		end

		if lspeech == "/online" then
			local ipAddress = {}
			for i = 1, #online do
				table.insert(ipAddress, online[i].ipaddress)
			end

			local uniqueConnections = unique(ipAddress)
			local gmsOnline = {}

			for i = 1, #online do
				if online[i].gmLevel ~= 0 then
					table.insert(gmsOnline, online[i].name)
				end
			end

			player:sendMinitext("--GMs online: " .. #gmsOnline .. "--")

			for i = 1, #gmsOnline do
				player:sendMinitext("\a" .. gmsOnline[i])
			end

			player:sendMinitext("Total chars online: " .. #online)
			player:sendMinitext("Unique connections: " .. #uniqueConnections)

			printf = 0
		end

		if (string.match(lspeech, "/shutdown (%d+)") ~= nil and string.match(
			lspeech,
			"/shutdown %d+ (%d+)"
		) == nil) then
			local time = tonumber(string.match(lspeech, "/shutdown (%d+)")) / 1000
			core.gameRegistry["server_reset_timer"] = os.time() + time
			local allPlayers = player:getUsers()
			for i = 1, #allPlayers do
				allPlayers[i]:setTimer(2, time)
			end

			--printf = 0
		end

		if string.match(lspeech, "/warp (%d+)") ~= nil then
			id = string.match(lspeech, "/warp (%d+)")
			if string.len(id) > 5 then
				anim(player)
				player:sendMinitext("MapId not found #" .. id)
				return
			end
		end

		if lspeech == "/cspells" then
			cspells(player)
			printf = 0
		end

		if lspeech == "/gmclick" then
			if player.registry["gm_click"] == 0 then
				player.registry["gm_click"] = 1
				s = "Disabled"
			elseif player.registry["gm_click"] == 1 then
				player.registry["gm_click"] = 0
				s = "Enabled"
			end
			player:sendMinitext("GM Click: " .. s)
			printf = 0
		end

		if lspeech == "/save" then
			local pc = player:getUsers()

			if pc ~= nil then
				for i = 1, #pc do
					pc[i]:forceSave()
				end
			end
			printf = 0
		end

		if lspeech == "/map" then
			player:sendMinitext("----------")
			player:sendMinitext("Map ID: " .. player.m)
			player:sendMinitext("Map Title: " .. player.mapTitle)
			return
		end

		if lspeech == "/nmap" then
			player.registry["m"] = player.registry["m"] + 1
			if getMapIsLoaded(player.registry["m"]) then
				player:warp(player.registry["m"], 0, 0)
				player:sendMinitext("Map ID: " .. player.registry["m"])
			else
				while not getMapIsLoaded(player.registry["m"]) do
					player.registry["m"] = player.registry["m"] + 1
				end
				player:warp(player.registry["m"], 0, 0)
				player:sendMinitext("Map ID: " .. player.registry["m"])
			end
			printf = 0
		end

		if lspeech == "/pmap" then
			if player.registry["m"] >= 1 then
				player.registry["m"] = player.registry["m"] - 1
				if getMapIsLoaded(player.registry["m"]) then
					player:warp(player.registry["m"], 0, 0)
					player:sendMinitext("Map ID: " .. player.registry["m"])
				else
					while not getMapIsLoaded(player.registry["m"]) and player.registry["m"] > 0 do
						player.registry["m"] = player.registry["m"] - 1
					end

					player:warp(player.registry["m"], 0, 0)
					player:sendMinitext("Map ID: " .. player.registry["m"])
				end
			else
				player.registry["m"] = 0
			end
			printf = 0
		end

		if lspeech == "/kill" then
			mob, pc = getTargetFacing(player, BL_MOB), getTargetFacing(
				player,
				BL_PC
			)
			if mob ~= nil then
				if mob.state ~= 1 then
					mob.attacker = 0
					mob:removeHealth(mob.health)
				end
			end
			if pc ~= nil then
				if pc.state ~= 1 then
					pc.attacker = 0
					pc:removeHealth(pc.health)
				end
			end
			printf = 0
		end

		if lspeech == "/kill mob" then
			target = player:getObjectsInMap(player.m, BL_MOB)
			if #target > 0 then
				for i = 1, #target do
					if target[i].owner == 0 then
						target[i].attacker = 0
						target[i]:sendAnimation(420)
						target[i]:sendAnimation(143)
						target[i]:removeHealth(target[i].health)
						player:playSound(59)
					end
				end
			end
			printf = 0
		elseif lspeech == "/kill pc" then
			target = player:getObjectsInMap(player.m, BL_PC)
			if #target > 0 then
				for i = 1, #target do
					if target[i].gmLevel ~= 0 then
						return
					else
						-- Don't kill GMs
						target[i].attacker = 0
						target[i]:sendAnimation(420)
						target[i]:sendAnimation(143)
						target[i]:removeHealth(target[i].health)
						target[i]:sendMinitext("@#$%$#@!@#$%^%$#@")
						player:playSound(59)
					end
				end
			end
			printf = 0
		elseif lspeech == "/mapfile" then
			player:talkSelf(0, "Map File is " .. player.mapfile)
			printf = 0
		end

		-- Forget spell
		if string.match(lspeech, "/del (.+)") ~= nil then
			spell = string.match(lspeech, "/del (.+)")
			if player:hasSpell(spell) then
				player:removeSpell(spell)
				player:sendMinitext("Done!!")
			end
			printf = 0
		end

		if (string.match(lspeech, "/mon ([%a_]+)") ~= nil and string.match(
			lspeech,
			"/mon ([%a_]+) (%d+)"
		) == nil) then
			local id = string.match(lspeech, "/mon ([%a_]+)")
			local id = string.lower(id)

			player:spawn(id, player.x, player.y, 1)
			player:sendMinitext("Monster: " .. id .. " added as a temporary spawn")
			printf = 0
		elseif (string.match(lspeech, "/mon [%a_]+ (%d+)") ~= nil) then
			local id = string.match(lspeech, "/mon ([%a_]+)")
			local amount = tonumber(string.match(lspeech, "/mon [%a_]+ (%d+)"))
			if amount > 100 then
				anim(player)
				player:sendMinitext("Too many!! (Max:100)")
			else
				player:spawn(id, player.x, player.y, amount)
				player:sendMinitext("Monster: " .. id .. " Amount: " .. amount .. " added as a temporary spawn")
			end
			printf = 0
		end

		if (string.match(lspeech, "/mon (%d+)") ~= nil and string.match(
			lspeech,
			"/mon %d+ (%d+)"
		) == nil) then
			local id = tonumber(string.match(lspeech, "/mon (%d+)"))

			player:spawn(id, player.x, player.y, 1)
			player:sendMinitext("Monster: " .. id .. " added as a temporary spawn")
			printf = 0
		elseif (string.match(lspeech, "/mon %d+ (%d+)") ~= nil) then
			local id = tonumber(string.match(lspeech, "/mon (%d+)"))
			local amount = tonumber(string.match(lspeech, "/mon %d+ (%d+)"))
			if amount > 100 then
				anim(player)
				player:sendMinitext("Too many!! (Max:100)")
			else
				player:spawn(id, player.x, player.y, amount)
				player:sendMinitext("Monster: " .. id .. " Amount: " .. amount .. " added as a temporary spawn")
			end
			printf = 0
		end

		-- gfx Toggle switch on/off --
		if lspeech == "/gfxtoggle" or lspeech == "/gfx" then
			gfx_switch.cast(player)
			if player.gfxClone == 0 then
				player:sendMinitext("GFX toggle: OFF")
			elseif player.gfxClone == 1 then
				player:sendMinitext("GFX toggle: ON")
			end
			printf = 0
		end

		-- Get spells --
		if string.match(lspeech, "/s (.+)") ~= nil and string.match(
			lspeech,
			"/s (.+) %a+"
		) == nil then
			s = string.match(lspeech, "/s (.+)")
			if not player:hasSpell(s) then
				player:addSpell(s)
				player:sendMinitext("Done!!")
			else
				anim(player)
				player:sendMinitext("You already have it! / the spell not found!")
			end
			printf = 0
		elseif string.match(lspeech, "/s .+ (%a+)") ~= nil then
			s, t = string.match(lspeech, "/s (.+) %a+"), string.match(
				lspeech,
				"/s .+ (%a+)"
			)
			if Player(t) ~= nil then
				if not Player(t):hasSpell(s) then
					Player(t):addSpell(s)
					Player(t):msg(
						4,
						"[Operator] Added a new spell!",
						Player(t).ID
					)
					player:sendMinitext("Done!!")
				else
					anim(player)
					player:sendMinitext("Target already has it! / the spell not found!")
				end
			else
				anim(player)
				player:sendMinitext("User not found!")
			end
			printf = 0
		end

		if lspeech == "udis" then
			npc, pc, mob = getTargetFacing(player, BL_NPC), getTargetFacing(
				player,
				BL_PC
			), getTargetFacing(player, BL_MOB)
			if npc ~= nil then
				npc:talk(
					2,
					"Dis : " .. npc.look .. ", Color: " .. npc.lookColor
				)
			end
			if pc ~= nil then
				pc:talk(
					2,
					"Dis : " .. pc.disguise .. ", Color: " .. pc.disguiseColor
				)
			end
			if mob ~= nil then
				mob:talk(
					2,
					"Dis : " .. mob.look .. ", Color: " .. mob.lookColor
				)
			end
			printf = 0
		end

		if string.match(lspeech, "/setdis (%d+)") ~= nil then
			mob = getTargetFacing(player, BL_MOB)
			id = string.match(lspeech, "/setdis (%d+)")
			if mob ~= nil then
				mob.look = id
				mob:updateState()
			end
			printf = 0
		elseif string.match(lspeech, "/setside (%d+)") ~= nil then
			mob = getTargetFacing(player, BL_MOB)
			id = string.match(lspeech, "/setside (%d+)")
			if mob ~= nil then
				mob.side = id
				mob:sendSide()
			end
			printf = 0
		end

		if string.match(lspeech, "/pk (%d+)") ~= nil then
			value = string.match(lspeech, "/pk (%d+)")
			war.set(player.m, value)
			printf = 0
		end

		if tonumber(string.match(lspeech, "/flush (.+)")) ~= nil then
			f = tonumber(string.match(lspeech, "/flush (.+)"))
			if f == 1 then
				player:flushAether()
				player:sendMinitext("Flushed aethers!")
			elseif f == 2 then
				player:flushDuration()
				player:sendMinitext("Flushed durations!")
			else
				player:msg(
					0,
					"[INFO] /flush 1 : Aethers, 2 : Duration",
					player.ID
				)
			end
			printf = 0
		end

		if string.match(lspeech, "/jail (.+)") ~= nil then
			target = Player(tostring(string.match(lspeech, "/jail (.+)")))
			if target ~= nil then
				target:warp(666, 3, 10)
				target:sendAnimation(16)
				target:playSound(29)
				player:sendMinitext(target.name .. " has been jailed!")
				broadcast(
					-1,
					"[JUSTICE] " .. target.name .. " has been jailed !!"
				)
			else
				anim(player)
				player:sendMinitext("user not found!")
			end
			printf = 0
		end

		-- Ability to walk through the walls switch on/off for GM
		if lspeech == "/ww" then
			player.optFlags = 128
			player:refresh()
			player:updateState()
			player:sendStatus()
			player:sendMinitext("You use ww!")
			printf = 0
		end

		-- Change Totem --  Totem:  (0)JuJak, (1)Baekho, (2)Hyun Moo, (3)Chung Ryong, (4)Nothing
		for i = 0, 3 do
			if string.match(string.lower(player.speech), "/totem " .. i) then
				player.totem = i
				player:sendMinitext("Totem: " .. i)
				player:sendStatus()
				player:status()
				player:calcStat()
				player:updateState()
				printf = 0
			end
		end

		-- Switch to on/off GM chat channel
		if lspeech == "/gmc" then
			if player.registry["gm_talk2"] == 0 then
				player.registry["gm_talk2"] = 1
				stats = "On"
			else
				player.registry["gm_talk2"] = 0
				stats = "Off"
			end
			player:sendMinitext("GM Channel: " .. stats)
			return
		end

		-- test action 1,2,3,4,5,etc...
		for i = 1, 32 do
			if string.match(string.lower(player.speech), "/act " .. i) then
				player:sendAction(i, 60)
				printf = 0
			end
		end

		-- Clean floor -- remove all items around on ground
		if player.speech == "/cfloor" or player.speech == "/sweep" then
			local item = player:getObjectsInArea(BL_ITEM)
			if #item > 0 then
				for i = 1, #item do
					if distanceSquare(player, item[i], 10) then
						item[i]:delete()
						player:sendAction(6, 20)
					end
				end
			end
			printf = 0
		end
		if player.speech == "/cmapfloor" or player.speech == "/mapsweep" then
			local item = player:getObjectsInSameMap(BL_ITEM)
			if #item > 0 then
				for i = 1, #item do
					item[i]:delete()
					player:sendAction(6, 20)
				end
			end
			printf = 0
		end

		-- Add Gold
		if tonumber(string.match(lspeech, "/gold (%d+)")) ~= nil then
			if tonumber(string.match(lspeech, "/gold (%d+)")) < 0 or player.money + tonumber(string.match(lspeech, "(%d+)")) > 3000000000 then
				anim(player)
				player:sendMinitext("Over limit!")
				return
			end

			player:addGold(tonumber(string.match(lspeech, "/gold (%d+)")))
			player:sendMinitext("Added " .. Tools.formatNumber(tonumber(string.match(lspeech, "/gold (%d+)"))) .. " coins")
			printf = 0
		end
	elseif player.gmLevel ~= 99 and string.sub(lspeech, 1, 1) == "/" then
		--player:msg(5,"Invalid command",player.ID)
		--printf = 0
	end

	if player.gmLevel > 0 then
		local say = {
			"nweap",
			"pweap",
			"weap",
			"narmor",
			"parmor",
			"armor",
			"nshield",
			"pshield",
			"shield",
			"nhelm",
			"phelm",
			"helm",
			"nmantle",
			"pmantle",
			"mantle",
			"ncrown",
			"pcrown",
			"crown",
			"nface",
			"pface",
			"face",
			"nboots",
			"pboots",
			"boots",
			"nneck",
			"pneck",
			"neck",
			"nfacea",
			"pfacea",
			"facea",
			"nfaceat",
			"pfaceat",
			"faceat",
			"nhair",
			"phair",
			"hair",
			"nsdye",
			"psdye"
		}
		local name = {
			"Weapon",
			"Weapon",
			"Weapon",
			"Armor",
			"Armor",
			"Armor",
			"Shield",
			"Shield",
			"Shield",
			"Helmet",
			"Helmet",
			"Helmet",
			"Mantle",
			"Mantle",
			"Mantle",
			"Crown",
			"Crown",
			"Crown",
			"Face",
			"Face",
			"Face",
			"Boots",
			"Boots",
			"Boots",
			"Necklace",
			"Necklace",
			"Necklace",
			"Face Accessory",
			"Face Accessory",
			"Face Accessory",
			"Face AccessoryT",
			"Face AccessoryT",
			"Face AccessoryT",
			"Hair",
			"Hair",
			"Hair"
		}
		local var = {
			p.gfxWeap,
			p.gfxWeap,
			p.gfxWeap,
			p.gfxArmor,
			p.gfxArmor,
			p.gfxArmor,
			p.gfxShield,
			p.gfxShield,
			p.gfxShield,
			p.gfxHelm,
			p.gfxHelm,
			p.gfxHelm,
			p.gfxMantle,
			p.gfxMantle,
			p.gfxMantle,
			p.gfxCrown,
			p.gfxCrown,
			p.gfxCrown,
			p.gfxFace,
			p.gfxFace,
			p.gfxFace,
			p.gfxBoots,
			p.gfxBoots,
			p.gfxBoots,
			p.gfxNeck,
			p.gfxNeck,
			p.gfxNeck,
			p.gfxFaceA,
			p.gfxFaceA,
			p.gfxFaceA,
			p.gfxFaceAT,
			p.gfxFaceAT,
			p.gfxFaceAT,
			p.hair,
			p.hair,
			p.hair
		}

		local face2 = {
			"nface2",
			"pface2",
			"face2",
			"nface2c",
			"pface2c",
			"face2c"
		}
		for i = 1, #face2 do
			if lspeech == face2[i] then
				faceacc.browse(player, face2[i])
				printf = 0
			end
		end

		if string.match(lspeech, "face2 (%d+)") ~= nil then
			num = string.match(lspeech, "face2 (%d+)")
			player.faceAccessoryTwo = num
			player:updateState()
			printf = 0
		elseif string.match(lspeech, "face2c (%d+)") ~= nil then
			num = string.match(lspeech, "face2c (%d+)")
			player.faceAccessoryTwoColor = num
			player:updateState()
			printf = 0
		end

		if (speech == "nside") then
			if (player.side == -2) then
				player:sendMinitext("Skipping -1.")
				player.side = 0
				return
			end
			player.side = player.side + 1
			player:sendSide()
			printf = 0
		elseif (speech == "pside") then
			if (player.side == 0) then
				player:sendMinitext("Can't have negative side.")
				return
			end
			player.side = player.side - 1
			player:sendSide()
			printf = 0
		elseif (speech == "side") then
			player:sendMinitext("Side: " .. player.side)
			printf = 0
		elseif lspeech == "nmantlec" then
			p.gfxMantleC = p.gfxMantleC + 1
			player:sendMinitext("MantleC: " .. player.gfxMantleC)
			printf = 0
			player:updateState()
		elseif lspeech == "pmantlec" then
			if p.gfxMantleC < -1 then
				player:sendMinitext("MantleC: " .. player.gfxMantleC)
				return
			else
				p.gfxMantleC = p.gfxMantleC - 1
			end
			player:sendMinitext("MantleC: " .. player.gfxMantleC)
			printf = 0
			player:updateState()
		end

		if tonumber(string.match(lspeech, "obj (%d+)")) ~= nil then
			obj = tonumber(string.match(lspeech, "obj (%d+)"))
			object.setFacingObject(player, "set", obj)
			printf = 0
		elseif tonumber(string.match(lspeech, "tile (%d+)")) ~= nil then
			tile = tonumber(string.match(lspeech, "tile (%d+)"))
			setTile(player.m, player.x, player.y, tile)
			printf = 0
		elseif (speech == "nobj") then
			object.next_prev(player, "next")
			printf = 0
		elseif (speech == "pobj") then
			object.next_prev(player, "prev")
			printf = 0
		elseif lspeech == "cobj" then
			object.setFacingObject(player, "del", 0)
			printf = 0
		elseif (lspeech == "obj") then
			player:talk(0, "Obj: " .. getObject(player.m, player.x, player.y))
			object.getObject(player)
			printf = 0
		elseif lspeech == "tile" then
			player:talk(0, "Tile: " .. getTile(player.m, player.x, player.y))
			printf = 0
		elseif (speech == "ntile") then
			if (getTile(p.m, p.x, p.y) == 38108) then
				player:sendMinitext("You are at the last tile: 38108")
			else
				setTile(p.m, p.x, p.y, getTile(p.m, p.x, p.y) + 1)
				player:sendMinitext("Tile : " .. getTile(p.m, p.x, p.y))
			end
			printf = 0
		elseif (speech == "ptile") then
			if (getTile(p.m, p.x, p.y) == 0) then
				player:sendMinitext("You are at the first tile: 0")
			else
				setTile(p.m, p.x, p.y, getTile(p.m, p.x, p.y) - 1)
				player:sendMinitext("Tile : " .. getTile(p.m, p.x, p.y))
			end
			printf = 0
		end

		-- Summon
		if string.match(lspeech, "/sum (.+)") ~= nil then
			sum = tostring(string.match(lspeech, "/sum (.+)"))
			target = Player(sum)
			if target ~= nil then
				target:warp(player.m, player.x, player.y)
			else
				anim(player)
				player:sendMinitext("User not found!")
			end
			printf = 0
		end

		-- Approach
		if string.match(lspeech, "/app (.+)") ~= nil then
			app = tostring(string.match(lspeech, "/app (.+)"))
			target = Player(app)
			if target ~= nil then
				player:warp(target.m, target.x, target.y)
			else
				anim(player)
				player:sendMinitext("user not found!")
			end
			printf = 0
		end

		if lspeech == "nthrow" then
			if player.registry["throw_icon"] > 5450 then
				player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
				return
			else
				player.registry["throw_icon"] = player.registry["throw_icon"] + 1
				player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
			end
			printf = 0
		elseif lspeech == "pthrow" then
			if player.registry["throw_icon"] <= 0 then
				player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
				return
			else
				player.registry["throw_icon"] = player.registry["throw_icon"] - 1
				player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
			end
			printf = 0
		elseif lspeech == "throw" then
			player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
			printf = 0
		elseif string.match(lspeech, "throw (%d+)") ~= nil then
			icon = tonumber(string.match(lspeech, "throw (%d+)"))
			player.registry["throw_icon"] = icon
			player:sendMinitext("Throw Icon : " .. player.registry["throw_icon"])
			printf = 0
		end

		if lspeech == "nact" then
			local action = player.registry["action"]
			player:sendAction(action, 60)
			player:sendMinitext("action: " .. action)
			player.registry["action"] = player.registry["action"] + 1
			printf = 0
		elseif lspeech == "pact" then
			local action = player.registry["action"]
			player:sendAction(action, 60)
			player:sendMinitext("action: " .. action)
			player.registry["action"] = player.registry["action"] - 1
			printf = 0
		end

		if lspeech == "/mobs" then
			mob = player:getObjectsInMap(player.m, BL_MOB)
			player:talk(2, "#Mobs : " .. #mob)
			player:sendMinitext("#Mobs : " .. #mob)
			printf = 0
		elseif lspeech == "/items" then
			item = player:getObjectsInMap(player.m, BL_ITEM)
			player:talk(2, "#Items : " .. #item)
			player:sendMinitext("#items : " .. #item)
			printf = 0
		elseif lspeech == "/totalmobs" then
			local count = 0

			for i = 1, 65535 do
				local mob = player:getObjectsInMap(i, BL_MOB)

				if (mob ~= nil) then
					count = count + #mob
				end
			end

			player:talk(2, "Total Mobs Spawned : " .. count)
			player:sendMinitext("Total Mobs Spawned : " .. count)
			printf = 0
		elseif lspeech == "/totalitems" then
			local count = 0

			for i = 1, 65535 do
				local items = player:getObjectsInMap(i, BL_ITEM)

				if (items ~= nil) then
					count = count + #items
				end
			end

			player:talk(2, "Total Items on Ground : " .. count)
			player:sendMinitext("Total Items on Ground : " .. count)
			printf = 0
		end

		if (lspeech == "pass") then
			local pass = getPass(player.m, player.x, player.y)
			local string2
			if pass == 0 then
				string2 = "True"
			elseif pass == 1 then
				string2 = "False"
			end
			player:talk(2, "Pass: " .. string2)
			printf = 0
		end

		-- Increase Speed

		if (string.match(lspeech, "/ms %d+") ~= nil) then
			local speed = tonumber(string.match(lspeech, "%d+"))
			player.speed = speed
			player:sendMinitext("Move Speed : " .. speed)
			player:updateState()
			printf = 0
		end

		-- GFX Color
		if lspeech == "hairc" then
			player:sendMinitext("Hair color: " .. p.hairColor)
			printf = 0
		elseif lspeech == "nhairc" then
			p.hairColor = p.hairColor + 1
			player:sendMinitext("Hair color: " .. p.hairColor)
			printf = 0
			player:updateState()
		elseif lspeech == "phairc" then
			if p.hairColor <= 0 then
				player:sendMinitext("Hair color: " .. p.hairColor)
				return
			else
				p.hairColor = p.hairColor - 1
			end
			player:sendMinitext("Hair color: " .. p.hairColor)
			printf = 0
			player:updateState()
		elseif lspeech == "nhelmc" then
			p.gfxHelmC = p.gfxHelmC + 1
			player:sendMinitext("Helm Color: " .. p.gfxHelmC)
			printf = 0
			player:updateState()
		elseif lspeech == "phelmc" then
			if p.gfxHelmC <= 0 then
				player:sendMinitext("Helm Color: " .. p.gfxHelmC)
				return
			else
				p.gfxHelmC = p.gfxHelmC - 1
			end
			player:sendMinitext("Helm Color: " .. p.gfxHelmC)
			printf = 0
			player:updateState()
		elseif lspeech == "helmc" then
			player:sendMinitext("Helm Color: " .. p.gfxHelmC)
			printf = 0
		elseif lspeech == "nweapc" then
			p.gfxWeapC = p.gfxWeapC + 1
			player:sendMinitext("Weapon Color: " .. player.gfxWeapC)
			printf = 0
			player:updateState()
		elseif lspeech == "pweapc" then
			if p.gfxWeapC <= 0 then
				player:sendMinitext("Weapon Color: " .. player.gfxWeapC)
				return
			else
				p.gfxWeapC = p.gfxWeapC - 1
			end
			player:sendMinitext("Weapon Color: " .. player.gfxWeapC)
			printf = 0
			player:updateState()
		elseif lspeech == "nshieldc" then
			p.gfxShieldC = p.gfxShieldC + 1
			player:sendMinitext("Shield Color: " .. p.gfxShieldC)
			printf = 0
			player:updateState()
		elseif lspeech == "pshieldc" then
			if p.gfxShieldC <= 0 then
				p:sendMinitext("Shield Color: " .. p.gfxShieldC)
				return
			else
				p.gfxShieldC = p.gfxShieldC - 1
			end
			p:sendMinitext("Shield Color: " .. p.gfxShieldC)
			printf = 0
			player:updateState()
		elseif lspeech == "narmorc" then
			p.gfxArmorC = p.gfxArmorC + 1
			player:sendMinitext("Armor Color: " .. player.gfxArmorC)
			printf = 0
			player:updateState()
		elseif lspeech == "parmorc" then
			if p.gfxArmorC <= 0 then
				player:sendMinitext("Armor Color: " .. player.gfxArmorC)
				return
			else
				p.gfxArmorC = p.gfxArmorC - 1
			end
			player:sendMinitext("Armor Color: " .. player.gfxArmorC)
			printf = 0
			player:updateState()
		elseif lspeech == "ncrownc" then
			p.gfxCrownC = p.gfxCrownC + 1
			player:sendMinitext("Crown Color: " .. player.gfxCrownC)
			printf = 0
			player:updateState()
		elseif lspeech == "pcrownc" then
			if p.gfxCrownC <= 0 then
				player:sendMinitext("Crown Color: " .. player.gfxCrownC)
				return
			else
				p.gfxCrownC = p.gfxCrownC - 1
			end
			player:sendMinitext("Crown Color: " .. player.gfxCrownC)
			printf = 0
			player:updateState()
		elseif lspeech == "nbootsc" then
			p.gfxBootsC = p.gfxBootsC + 1
			player:sendMinitext("Boots Color: " .. player.gfxBootsC)
			printf = 0
			player:updateState()
		elseif lspeech == "pbootsc" then
			if p.gfxBootsC <= 0 then
				player:sendMinitext("Boots Color: " .. player.gfxBootsC)
				return
			else
				p.gfxBootsC = p.gfxBootsC - 1
			end
			player:sendMinitext("Boots Color: " .. player.gfxBootsC)
			printf = 0
			player:updateState()
		elseif lspeech == "crownc" then
			player:sendMinitext("Crown Color: " .. player.gfxCrownC)
			printf = 0
		elseif lspeech == "armorc" then
			player:sendMinitext("Armor Color: " .. player.gfxArmorC)
			printf = 0
		elseif lspeech == "weapc" then
			player:sendMinitext("Weapon Color: " .. player.gfxWeapC)
			printf = 0
		elseif lspeech == "shieldc" then
			player:sendMinitext("Shield Color: " .. player.gfxShieldC)
			printf = 0
		elseif lspeech == "bootsc" then
			player:sendMinitext("Boots Color: " .. player.gfxBootsC)
			printf = 0
		elseif lspeech == "nfacec" then
			if p.gfxFaceC < 0 then
				player:sendMinitext("Face Color: " .. player.gfxFaceC)
				return
			else
				p.gfxFaceC = p.gfxFaceC + 1
			end
			player:sendMinitext("Face Color: " .. player.gfxFaceC)
			printf = 0
			player:updateState()
		elseif lspeech == "pfacec" then
			if p.gfxFaceC < 0 then
				player:sendMinitext("Face Color: " .. player.gfxFaceC)
				return
			else
				p.gfxFaceC = p.gfxFaceC - 1
			end
			player:sendMinitext("Face Color: " .. player.gfxFaceC)
			printf = 0
			player:updateState()
		elseif lspeech == "facec" then
			player:sendMinitext("Face Color: " .. player.gfxFaceC)
			printf = 0
		elseif lspeech == "nfaceac" then
			if p.gfxFaceAC < 0 then
				player:sendMinitext("Face Acc Color: " .. player.gfxFaceAC)
				return
			else
				p.gfxFaceAC = p.gfxFaceAC + 1
			end
			player:sendMinitext("Face Acc Color: " .. player.gfxFaceAC)
			printf = 0
			player:updateState()
		elseif lspeech == "pfaceac" then
			if p.gfxFaceAC < 0 then
				player:sendMinitext("Face Acc Color: " .. player.gfxFaceAC)
				return
			else
				p.gfxFaceAC = p.gfxFaceAC - 1
			end
			player:sendMinitext("Face Acc Color: " .. player.gfxFaceAC)
			printf = 0
			player:updateState()
		elseif lspeech == "faceac" then
			player:sendMinitext("Face Acc Color: " .. player.gfxFaceAC)
			printf = 0
		end

		local ok = true

		if ok == true then
			for x = 1, #say do
				if (lspeech == "" .. say[x] or string.match(lspeech, "" .. say[x] .. " (%d+)") ~= nil or string.match(
					lspeech,
					"" .. say[x] .. " %d+ (%d+)"
				) ~= nil) and string.sub(lspeech, 0, string.len(say[x])) == say[
					x
				] then
					local nn = 0
					local x2 = x - 2

					if x % 3 == 0 then
						-- GFX Look
						if string.match(lspeech, "" .. say[x] .. " (%d+)") ~= nil then
							vn = tonumber(string.match(lspeech, "" .. say[x] .. " (%d+)"))
							if x == 3 then
								p.gfxWeap = vn
							elseif x == 6 then
								p.gfxArmor = vn
							elseif x == 9 then
								p.gfxShield = vn
							elseif x == 12 then
								p.gfxHelm = vn
							elseif x == 15 then
								p.gfxMantle = vn
							elseif x == 18 then
								p.gfxCrown = vn
							elseif x == 21 then
								p.gfxFace = vn
							elseif x == 24 then
								p.gfxBoots = vn
							elseif x == 27 then
								p.gfxNeck = vn
							elseif x == 30 then
								p.gfxFaceA = vn
							elseif x == 33 then
								p.gfxFaceAT = vn
							elseif x == 36 then
								p.gfxHair = vn
							end

							-- GFX Look Color
							if string.match(lspeech, "" .. say[x] .. " %d+ (%d+)") ~= nil then
								vnc = tonumber(string.match(lspeech, "" .. say[x] .. " %d+ (%d+)"))
								if x == 3 then
									p.gfxWeapC = vnc
								elseif x == 6 then
									p.gfxArmorC = vnc
								elseif x == 9 then
									p.gfxShieldC = vnc
								elseif x == 12 then
									p.gfxHelmC = vnc
								elseif x == 15 then
									p.gfxMantleC = vnc
								elseif x == 18 then
									p.gfxCrownC = vnc
								elseif x == 21 then
									p.gfxFaceC = vnc
								elseif x == 24 then
									p.gfxBootsC = vnc
								elseif x == 27 then
									p.gfxNeckC = vnc
								elseif x == 30 then
									p.gfxFaceAC = vnc
								elseif x == 33 then
									p.gfxFaceATC = vnc
								elseif x == 36 then
									p.gfxHairC = vnc
								end
							end

							player:updateState()
							player:sendMinitext("" .. name[x] .. " Number: " .. vn .. " Color: " .. vnc .. "")
						elseif lspeech == say[x] then
							player:sendMinitext("" .. name[x] .. " GFX: " .. var[x])
						end
						nn = 1
					end
					if nn == 0 then
						if x2 % 3 == 0 then
							if var[x] == 65535 then
								player:sendMinitext("You have reached the minimum of  " .. name[x] .. " GFX; -1.")
							else
								if x <= 3 then
									if var[x] == 10000 then
										p.gfxWeap = 437
									elseif var[x] == 20000 then
										p.gfxWeap = 10124
									elseif var[x] == 30000 then
										p.gfxWeap = 20131
									else
										p.gfxWeap = var[x] - 1
									end
								elseif x <= 6 then
									if var[x] == 10000 then
										p.gfxArmor = 448
									else
										p.gfxArmor = var[x] - 1
									end
								elseif x <= 9 then
									if var[x] == 10000 then
										p.gfxShield = 50
									else
										p.gfxShield = var[x] - 1
									end
								elseif x <= 12 then
									p.gfxHelm = var[x] - 1
								elseif x <= 15 then
									p.gfxMantle = var[x] - 1
								elseif x <= 18 then
									p.gfxCrown = var[x] - 1
								elseif x <= 21 then
									p.gfxFace = var[x] - 1
								elseif x <= 24 then
									p.gfxBoots = var[x] - 1
								elseif x <= 27 then
									p.gfxNeck = var[x] - 1
								elseif x <= 30 then
									p.gfxFaceA = var[x] - 1
								elseif x <= 33 then
									p.gfxFaceAT = var[x] - 1
								elseif x <= 36 then
									p.hair = var[x] - 1
								end
								player:updateState()
								player:sendMinitext("" .. name[x] .. " Number: " .. (var[x] - 1) .. "")
							end
						else
							if x <= 3 then
								if var[x] == 437 then
									p.gfxWeap = 10000
								elseif var[x] == 10124 then
									p.gfxWeap = 20000
								elseif var[x] == 20131 then
									p.gfxWeap = 30000
								else
									p.gfxWeap = var[x] + 1
								end
							elseif x <= 6 then
								if var[x] == 448 then
									p.gfxArmor = 10000
								else
									p.gfxArmor = var[x] + 1
								end
							elseif x <= 9 then
								if var[x] == 50 then
									p.gfxShield = 10000
								else
									p.gfxShield = var[x] + 1
								end
							elseif x <= 12 then
								p.gfxHelm = var[x] + 1
							elseif x <= 15 then
								p.gfxMantle = var[x] + 1
							elseif x <= 18 then
								p.gfxCrown = var[x] + 1
							elseif x <= 21 then
								p.gfxFace = var[x] + 1
							elseif x <= 24 then
								p.gfxBoots = var[x] + 1
							elseif x <= 27 then
								p.gfxNeck = var[x] + 1
							elseif x <= 30 then
								p.gfxFaceA = var[x] + 1
							elseif x <= 33 then
								p.gfxFaceAT = var[x] + 1
							elseif x <= 36 then
								p.hair = var[x] + 1
							end
							player:updateState()
							player:sendMinitext("" .. name[x] .. " Number: " .. (var[x] + 1) .. "")
						end
					end
					printf = 0
					break
				end
			end
		end

		-- Icon viewer
		if (string.match(lspeech, "/icon (%d+)") ~= nil and string.match(
			lspeech,
			"/icon %d+ (%d+)"
		) == nil) then
			local x = tonumber(string.match(lspeech, "/icon (%d+)"))
			player.registry["gfx_icons"] = x
			player.registry["gfx_icons_color"] = 0
			player:freeAsync()
			iconViewer(player, "n")
			printf = 0
		elseif (string.match(lspeech, "/icon %d+ (%d+)") ~= nil) then
			local x = tonumber(string.match(lspeech, "/icon (%d+)"))
			local y = tonumber(string.match(lspeech, "/icon %d+ (%d+)"))
			player.registry["gfx_icons"] = x
			player.registry["gfx_icons_color"] = y
			iconViewer(player, "nc")
			printf = 0
		elseif (lspeech == "nicon") then
			iconViewer(player, "n")
			printf = 0
		elseif (lspeech == "picon") then
			iconViewer(player, "p")
			printf = 0
		elseif (lspeech == "niconc") then
			iconViewer(player, "nc")
			printf = 0
		elseif (lspeech == "piconc") then
			iconViewer(player, "pc")
			printf = 0

			-- Change disguise / mob look (must on state 4)
		elseif (speech == "ndis") then
			local oldstate = player.state

			player.state = 0
			player:updateState()

			--if player.disguise == 1340 then
			--	player.disguise = player.disguise + 3
			--else
			player.disguise = player.disguise + 1

			--end
			player.state = oldstate
			player:updateState()
			player:sendMinitext("Disguise #: " .. player.disguise)
			printf = 0
		elseif (speech == "pdis") then
			if (player.disguise == 0) then
				player:sendMinitext("You may not have negative disguise.")
				return
			end
			local oldstate = player.state

			player.state = 0
			player:updateState()

			--if player.disguise == 1343 then
			--	player.disguise = player.disguise - 3
			--else
			player.disguise = player.disguise - 1

			--end
			player.state = oldstate
			player:updateState()
			player:sendMinitext("Disguise #: " .. player.disguise)
			printf = 0
		elseif (speech == "dis") then
			player:sendMinitext("Disguise #: " .. player.disguise)
			printf = 0

			--Disguise Color
		elseif (string.match(speech, "dis (%d+)") ~= nil and string.sub(speech, 0, 3) == "dis") then
			local oldstate = player.state

			player.state = 0
			player:updateState()

			if (tonumber(string.match(speech, "dis (%d+)")) < 0 or tonumber(string.match(speech, "dis (%d+)")) == 1342 or tonumber(string.match(speech, "dis (%d+)")) == 1394) then
				player:sendMinitext("Disguise not allowed.")
			else
				player.disguise = tonumber(string.match(speech, "dis (%d+)"))
			end
			player.state = oldstate
			player:updateState()
			printf = 0
		elseif (speech == "ndisc") then
			if (player.disguiseColor == 255) then
				player:sendMinitext("You may not go over 255 on disguiseColor.")
				printf = 0
			else
				player.disguiseColor = player.disguiseColor + 1
				player:updateState()
				player:sendMinitext("Disguise Color #: " .. player.disguiseColor)
				printf = 0
			end
		elseif (speech == "pdisc") then
			if player.disguiseColor <= 0 then
				player:sendMinitext("You may not have negative disguise color.")
				printf = 0
			else
				player.disguiseColor = player.disguiseColor - 1
				player:updateState()
				player:sendMinitext("Disguise Color #: " .. player.disguiseColor)
				printf = 0
			end
		elseif (speech == "disc") then
			player:sendMinitext("Disguise Color #: " .. player.disguiseColor)
			printf = 0

			-- Change armor color / dye	--
		elseif (speech == "ndye") then
			if (player.gfxClone == 1) then
				player.gfxDye = player.gfxDye + 1
				player:sendMinitext("Gfx dye: " .. player.gfxDye)
			else
				player.armorColor = player.armorColor + 1
				player:sendMinitext("Armor C: " .. player.armorColor)
			end
			player:refresh()
			printf = 0
		elseif (speech == "pdye") then
			if (player.gfxClone == 1) then
				player.gfxDye = player.gfxDye - 1
				player:sendMinitext("Gfx dye: " .. player.gfxDye)
			else
				player.armorColor = player.armorColor - 1
				player:sendMinitext("Armor C: " .. player.armorColor)
			end

			player:refresh()
			printf = 0
		elseif (speech == "nsdye") then
			if (player.gfxClone == 1) then
				player.gfxShieldC = player.gfxShieldC + 1
			else
				player.armorColor = player.armorColor + 1
			end
			player:refresh()
			printf = 0
		elseif (speech == "psdye") then
			if (player.gfxClone == 1) then
				player.gfxShieldC = player.gfxShieldC - 1
			else
				player.armorColor = player.armorColor - 1
			end
			player:refresh()
			printf = 0
		elseif (speech == "sdye") then
			--player:talk(0,"what the "..player.gfxClone)
			if (player.gfxClone == 1) then
				player:sendMinitext("gfxShieldC: " .. player.gfxShieldC)
			else
				player.armorColor = player.armorColor - 1
			end
			player:refresh()
			printf = 0
		elseif (speech == "dye") then
			if (player.gfxClone == 1) then
				player:sendMinitext("gfxDye: " .. player.gfxDye)
			else
				player:sendMinitext("Dye: " .. player.armorColor)
			end
			printf = 0
		elseif (string.match(speech, "dye (%d+)") ~= nil and string.sub(speech, 0, 3) == "dye") then
			if (player.gfxClone == 1) then
				player.gfxDye = tonumber(string.match(speech, "dye (%d+)"))
			else
				player.armorColor = tonumber(string.match(speech, "dye (%d+)"))
			end
			player:refresh()
			printf = 0

			-- Change skin color
		elseif (speech == "nskin") then
			if (player.gfxClone == 1) then
				player.gfxSkinC = player.gfxSkinC + 1
				player:sendMinitext("Skin color: " .. player.gfxSkinC)
			else
				player.skinColor = player.skinColor + 1
				player:sendMinitext("Skin color: " .. player.skinColor)
			end
			player:refresh()
			printf = 0
		elseif (speech == "pskin") then
			if (player.gfxClone == 1) then
				player.gfxSkinC = player.gfxSkinC - 1
				player:sendMinitext("Skin color: " .. player.gfxSkinC)
			else
				player.skinColor = player.skinColor - 1
				player:sendMinitext("Skin color: " .. player.skinColor)
			end
			player:refresh()
			printf = 0
		elseif (speech == "skin") then
			if (player.gfxClone == 1) then
				player:talk(0, "gfxSkinC: " .. player.gfxSkinC)
			else
				player:talk(0, "Skin color: " .. player.skinColor)
			end
			player:refresh()
			printf = 0
		elseif (string.match(speech, "skin (%d+)") ~= nil and string.sub(speech, 0, 4) == "skin") then
			if (player.gfxClone == 1) then
				player.gfxSkinC = tonumber(string.match(speech, "skin (%d+)"))
			else
				player.skinColor = tonumber(string.match(speech, "skin (%d+)"))
			end
			player:refresh()
			printf = 0

			-- Browse spells animation
		elseif (speech == "nspell") then
			if (player.registry["gfx_spell"] == 648) then
				player:sendMinitext("You may not go over 648 on spell graphics.")
			else
				player.registry["gfx_spell"] = player.registry["gfx_spell"] + 1
				player:sendAnimation(player.registry["gfx_spell"])

				--player:selfAnimation(player.ID, player.registry["gfx_spell"], 0)
				player:sendMinitext("Spell #: " .. player.registry["gfx_spell"])
			end

			printf = 0
		elseif (speech == "pspell") then
			if (player.registry["gfx_spell"] == 0) then
				player:sendMinitext("You may not have negative spell graphics.")
			else
				player.registry["gfx_spell"] = player.registry["gfx_spell"] - 1
				player:sendAnimation(player.registry["gfx_spell"])

				--	player:selfAnimation(player.ID, player.registry["gfx_spell"], 0)
				player:sendMinitext("Spell #: " .. player.registry["gfx_spell"])
			end

			player:sendAnimation(player.registry["gfx_spell"])
			printf = 0
		elseif (speech == "spell") then
			player:sendMinitext("Spell #: " .. player.registry["gfx_spell"])
			player:selfAnimation(player.ID, player.registry["gfx_spell"], 0)

			--	player:sendAnimation(player.registry["gfx_spell"])
			printf = 0
		elseif (string.match(speech, "spell (%d+)") ~= nil and string.sub(speech, 0, 5) == "spell") then
			player.registry["gfx_spell"] = tonumber(string.match(speech, "spell (%d+)"))
			player:selfAnimation(player.ID, player.registry["gfx_spell"], 0)

			--	player:sendAnimation(player.registry["gfx_spell"])
			printf = 0

			-- Browse sound effect
		elseif (speech == "nsound") then
			if (player.registry["gfx_sound"] == 750) then
				player:sendMinitext("You may not go over 750 on sound effects.")
			else
				if (player.registry["gfx_sound"] == 147) then
					player.registry["gfx_sound"] = 200
				elseif (player.registry["gfx_sound"] == 206) then
					player.registry["gfx_sound"] = 300
				elseif (player.registry["gfx_sound"] == 313) then
					player.registry["gfx_sound"] = 331
				elseif (player.registry["gfx_sound"] == 371) then
					player.registry["gfx_sound"] = 401
				elseif (player.registry["gfx_sound"] == 421) then
					player.registry["gfx_sound"] = 500
				elseif (player.registry["gfx_sound"] == 514) then
					player.registry["gfx_sound"] = 600
				elseif (player.registry["gfx_sound"] == 603) then
					player.registry["gfx_sound"] = 700
				elseif (player.registry["gfx_sound"] == 740) then
					player.registry["gfx_sound"] = 900
				elseif (player.registry["gfx_sound"] == 910) then
					player.registry["gfx_sound"] = 1001
				else
					player.registry["gfx_sound"] = player.registry["gfx_sound"] + 1
				end

				player:playSound(player.registry["gfx_sound"])
				player:sendMinitext("Sound : " .. player.registry["gfx_sound"])
			end

			printf = 0
		elseif (speech == "psound") then
			if (player.registry["gfx_sound"] == 0) then
				player:sendMinitext("You may not have negative sound effects.")
			else
				if (player.registry["gfx_sound"] == 200) then
					player.registry["gfx_sound"] = 147
				elseif (player.registry["gfx_sound"] == 300) then
					player.registry["gfx_sound"] = 206
				elseif (player.registry["gfx_sound"] == 331) then
					player.registry["gfx_sound"] = 313
				elseif (player.registry["gfx_sound"] == 401) then
					player.registry["gfx_sound"] = 371
				elseif (player.registry["gfx_sound"] == 500) then
					player.registry["gfx_sound"] = 421
				elseif (player.registry["gfx_sound"] == 600) then
					player.registry["gfx_sound"] = 514
				elseif (player.registry["gfx_sound"] == 700) then
					player.registry["gfx_sound"] = 603
				elseif (player.registry["gfx_sound"] == 900) then
					player.registry["gfx_sound"] = 740
				elseif (player.registry["gfx_sound"] == 1001) then
					player.registry["gfx_sound"] = 910
				else
					player.registry["gfx_sound"] = player.registry["gfx_sound"] - 1
				end

				player:playSound(player.registry["gfx_sound"])
				player:sendMinitext("Sound : " .. player.registry["gfx_sound"])
			end
			printf = 0
		elseif (speech == "sound") then
			player:sendMinitext("Sound #: " .. player.registry["gfx_sound"])
			player:playSound(player.registry["gfx_sound"])
			printf = 0
		elseif (string.match(speech, "sound (%d+)") ~= nil and string.sub(speech, 0, 5) == "sound") then
			player.registry["gfx_sound"] = tonumber(string.match(speech, "sound (%d+)"))
			player:playSound(player.registry["gfx_sound"])
			printf = 0
		end
	end

	----------------------------------------------------------------------------------------------------------

	-- Calculator
	if (string.byte(speech, 1) == 61) then
		--== 99)then
		if ((string.byte(speech, 2) >= 48) and (string.byte(speech, 2) <= 57)) or ((string.byte(speech, 2) == 40) and ((string.byte(speech, 3) >= 48) and (string.byte(speech, 3) <= 57))) or ((string.byte(speech, 2) == 46) and ((string.byte(speech, 3) >= 48) and (string.byte(speech, 3) <= 57))) then
			local eq = string.gsub(speech, "=", "")
			local f, l, x
			f = ""
			for l in string.gmatch(eq, ".") do
				f = f .. l
			end
			x = string.gsub(
				"" .. f .. " = $return " .. f .. "$",
				"%$(.-)%$",
				function(s)
					return loadstring(s)()
				end
			)
			player:talk(0, "" .. x)
			printf = 0
		end
	end

	-- Sensitive commands!!-------------------------------------------------------------------------------------------------------------
	if player.gmLevel >= 99 then
		if speech == "/gmspell" then
			player:addGMSpells()
			return
		end

		if (string.match(player.speech, "/testmap (.+)") ~= nil and string.sub(
			player.speech,
			1,
			8
		) == "/testmap") then
			local map = string.match(player.speech, "/testmap (.+)")
			local mapNum = 50000 + player.ID

			if (string.byte(map, string.len(map) - 3) == 46) then
				os.execute("cd ../rtkmaps;svn up;cd ../rtk")
				setMap(mapNum, "../rtkmaps/Accepted/" .. map)
				player:warp(mapNum, 5, 5)
				player.spell = 1
			else
				player:sendMinitext("Only .map is supported, sorry.")
			end
			printf = 0
		end

		-- Mapper End

		if (lspeech == "reload") or (lspeech == "/reload") then
			os.execute("cd ../rtkmaps;svn up;cd ../rtklua; svn up; cd ../rtk; svn up")
			player.speech = "/reload"
			player:gmMsg(
				"<Console>: " .. player.name .. " has svn up and reloaded the server.",
				50
			)
			os.execute("echo " .. player.name .. " has SVN UP and RELOADED server.")
		elseif (lspeech == "svn up") then
			os.execute("cd ../rtkmaps;svn up;cd ../rtklua; svn up; cd ../rtk; svn up")
			player:gmMsg(
				"<Console>: " .. player.name .. " has svn up the server.",
				50
			)
			os.execute("echo " .. player.name .. " has SVN UP the server.")
			printf = 0
		elseif lspeech == "/metan" then
			os.execute("./metan")
			player:gmMsg(
				"<Console>: " .. player.name .. " has used ./metan",
				50
			)
			os.execute("echo " .. player.name .. " has used ./metan")
			printf = 0
		elseif lspeech == "/make map" then
			os.execute("svn up")
			player:gmMsg(
				"<Console>: " .. player.name .. " has begun SVN UP + MAP compile.",
				50
			)
			player.gameRegistry["make"] = os.time()
			os.execute("make map")
			local make = os.difftime(os.time(), player.gameRegistry["make"])
			if (make < 4) then
				player:gmMsg(
					"<Console>: Compilation ERROR on MAP by " .. player.name .. " (" .. make .. ")",
					50
				)
			else
				player:gmMsg(
					"<Console>: " .. player.name .. " has SVN UP & compiled map in " .. make .. " seconds.",
					50
				)
				os.execute("echo " .. player.name .. " has svn up and compiled map.")
			end
			printf = 0
		elseif (lspeech == "/make char") then
			os.execute("svn up")
			player:gmMsg(
				"<Console>: " .. player.name .. " has begun SVN UP + CHAR compile.",
				50
			)
			player.gameRegistry["make"] = os.time()
			os.execute("make char")
			local make = os.difftime(os.time(), player.gameRegistry["make"])
			player:gmMsg(
				"<Console>: " .. player.name .. " has SVN UP & compiled char in " .. make .. " seconds.",
				50
			)
			os.execute("echo " .. player.name .. " has svn up and compiled char.")
			printf = 0
		elseif (lspeech == "/make login") then
			os.execute("svn up")
			player:gmMsg(
				"<Console>: " .. player.name .. " has begun SVN UP + LOGIN compile.",
				50
			)
			player.gameRegistry["make"] = os.time()
			os.execute("make login")
			local make = os.difftime(os.time(), player.gameRegistry["make"])
			player:gmMsg(
				"<Console>: " .. player.name .. " has SVN UP & compiled LOGIN in " .. make .. " seconds.",
				50
			)
			os.execute("echo " .. player.name .. " has svn up and compiled login.")
			printf = 0
		end
	end

	-- END OF SPECIAL COMMAND

	if printf == 0 then
		return
	else
		local npcs = player:getObjectsInArea(BL_NPC)

		if player.gmLevel == 0 then
			if player:hasDuration("venom") or player:hasDuration("break_jaw") then
				local vspeech = player.speech
				local vspeech2 = ""

				if vspeech ~= "" then
					for i = 1, string.len(vspeech) do
						local random = math.random(1, 5)

						if random == 1 then
							vspeech2 = vspeech2 .. "*"
						else
							vspeech2 = vspeech2 .. string.sub(vspeech, i, i)
						end
					end
					player:speak(vspeech2, talkType)
				end
			else
				player:speak(player.speech, talkType)
			end
		elseif player.gmLevel > 0 then
			player:speak(player.speech, talkType)
		end

		player:onSayQuestCheck(player.speech)

		for i = 1, #npcs do
			if distanceSquare(player, npcs[i], distance) then
				--lspeech = lspeech:gsub("[']+",'') -- remove apostrophe

				if npcs[i].shopNPC == 1 then
					verbalScriptCheckShop(player, npcs[i], lspeech)
				end
				if npcs[i].repairNPC == 1 then
					verbalScriptCheckRepair(player, npcs[i], lspeech)
				end
				if npcs[i].bankNPC == 1 then
					verbalScriptCheckBank(player, npcs[i], lspeech)
				end
				verbalScriptGeneral(player, npcs[i], lspeech)
			end
		end

		characterLog.localChat(player, player.speech)

		if player.gmLevel > 0 then
			characterLog.gmSpeechWrite(player, player.speech)
		else
			characterLog.speechWrite(player, player.speech)
		end

		--if player:hasDuration("reverse_talk") then
		--	player:speak(string.reverse(player.speech..""), talkType)
		--else
		--player:speak(player.speech, talkType)
		--end
		--snoop.showChat(player, player.speech, talkType)
	end
end
