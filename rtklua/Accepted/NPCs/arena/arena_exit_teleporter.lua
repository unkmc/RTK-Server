ArenaExitTeleporterNpc = {
	click = async(function(player, npc)
		local name = "<b>[" .. npc.name .. "]\n\n"
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {}
		table.insert(opts, "Let me out of this place")
		menu = player:menuString(
			name .. "Are a chicken like me, BAA-CAWWWWWWKKKKKKK!",
			opts
		)

		if (menu == "Let me out of this place") then
			minigame_powers.resetPlayer(player)
		end
	end)
}

minigame_powers = {
	f1click = function(player, npc)
		clone.gfx(player, npc)
		player:refresh()

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 2
		local playerToBan
		local banTime
		local opts = {}
		local pc = player:getObjectsInMap(player.m, BL_PC)

		table.insert(opts, "Add Player")
		table.insert(opts, "Remove Player")
		table.insert(opts, "Pause Game")
		table.insert(opts, "Unpause Game")
		table.insert(opts, "Check Online Bans")
		table.insert(opts, "Set Minigame Ban")

		menu = player:menuString(
			"<b>[MINIGAME POWERS]\nWhat would you like to  do?",
			opts
		)

		if menu == "Add Player" then
			playerToAdd = player:input("Who needs to be added to the minigame?")
			if Player(playerToAdd) ~= nil then
				minigame_powers.addPlayer(player, Player(playerToAdd))
			end
		elseif menu == "Remove Player" then
			playerToKick = player:input("Who needs to be removed from the minigame?")
			if Player(playerToKick) ~= nil then
				minigame_powers.kickPlayer(Player(playerToKick))
			end
		elseif menu == "Pause Game" then
			if #pc > 0 then
				for i = 1, #pc do
					pc[i]:sendAnimation(2)
					pc[i].paralyzed = true
				end
			end
			broadcast(player.m, "The game has been paused by " .. player.name)
		elseif menu == "Unpause Game" then
			if #pc > 0 then
				for i = 1, #pc do
					pc[i]:sendAnimation(3)
					pc[i].paralyzed = false
				end
			end
			broadcast(player.m, "The game has been paused by " .. player.name)
		elseif menu == "Check Online Bans" then
			minigame_powers.checkBans(player)
		elseif menu == "Set Minigame Ban" then
			playerToBan = Player(player:input("Ban who?"))
			banTime = player:input("Ban for how many hours?")
			playerToBan.registry["minigame_ban_timer"] = os.time() + (banTime * 3600)
			player:popUp("" .. playerToBan.name .. " has been banned from minigames for " .. banTime .. " hours.")
		end
	end,

	checkBans = function(player)
		local pc = core:getUsers()
		local calc, dif, hour, minute, second = 0, 0, 0, 0, 0
		local banned = {}

		for i = 1, #pc do
			if pc[i].registry["minigameBan"] > os.time() then
				dif = pc[i].registry["minigame_ban_timer"] - os.time()
				hour = string.format("%02.f", math.floor(dif / 3600))
				minute = string.format(
					"%02.f",
					math.floor(dif / 60 - (hour * 60))
				)
				second = string.format(
					"%02.f",
					math.floor(dif - hour * 3600 - minute * 60)
				)

				calc = hour .. ":" .. minute .. ":" .. second

				table.insert(banned, "" .. pc[i].name .. " banned for " .. calc)

				--Player(4):talk(0,""..pc[i].name.." banned for "..calc)
			end
		end
		player:menuString("<b>[CURRENT BANS]", banned)
	end,

	resetPlayer = function(player)
		--[[
	if player.m == 15020 then
		if player.registry["beach_war_team"] == 1 then
			table.remove(livingRedSquirt)
		elseif player.registry["beach_war_team"] == 2 then
			table.remove(livingBlueSquirt)
		end
	end
]]
		--
		player.registry["beach_war_times_hit"] = 0
		player.registry["beach_war_gun_pct"] = 0
		player.registry["beach_war_registered"] = 0
		player.registry["beach_war_flag"] = 0
		player.registry["beach_war_team"] = 0
		player.registry["beach_war_kills"] = 0

		player.registry["freeze_war_registered"] = 0
		player.registry["freeze_war_flag"] = 0
		player.registry["freeze_war_team"] = 0

		player.registry["sumo_war_registered"] = 0
		player.registry["sumo_war_team"] = 0

		player.registry["elixir_registered"] = 0
		player.registry["elixir_flag"] = 0
		player.registry["elixir_team"] = 0
		player.registry["elixir_hit"] = 0
		player.registry["elixir_arrows"] = 0

		player.registry["bomber_war_registered"] = 0
		player.registry["bomber_war_team"] = 0
		player.registry["speed_boost"] = 0
		player.registry["bomb_max"] = 0
		player.registry["bomb_distance"] = 0

		player.speed = 80
		player.gfxClone = 0
		player.calcStat()
		player:updateState()
		player:warp(31, math.random(6, 15), math.random(8, 15))
		player:sendAnimation(16)
		player:playSound(29)
	end,

	kickPlayer = function(player)
		minigame_powers.resetPlayer(player)
		player:sendMinitext("You have been booted from the minigame.")
	end,

	addPlayer = function(player, target)
		local ctfPlayers = core:getObjectsInMap(15000, BL_PC)
		local reds = {}
		local blues = {}

		if #ctfPlayers > 0 then
			for i = 1, #ctfPlayers do
				if ctfPlayers[i].registry["ctf_team"] == 1 then
					table.insert(reds, ctfPlayers[i].ID)
				elseif ctfPlayers[i].registry["ctf_team"] == 2 then
					table.insert(blues, ctfPlayers[i].ID)
				end
			end
		end

		if player.m == 15000 then
			if target.registry["ctf_team"] == 0 then
				target.registry["ctf_registered"] = 1
				if #reds > #blues then
					target.registry["ctf_team"] = 2
				elseif #blues > #reds then
					target.registry["ctf_team"] = 1
				elseif #blues == #reds then
					target.registry["ctf_team"] = math.random(1, 2)
				end

				core.gameRegistry["ctf_players"] = core.gameRegistry[
					"ctf_players"
				] + 1
				if target.registry["ctf_team"] == 1 then
					target:warp(15000, 16, 2)
				elseif target.registry["ctf_team"] == 2 then
					target:warp(15000, 16, 38)
				end

				if target.state == 3 then
					target.state = 0
					target.speed = 80
					target.registry["mounted"] = 0
					target:updateState()
				end

				ctf.costume(target)
				target:sendAnimation(16)
				target:playSound(29)
				target:dialogSeq(
					{
						t,
						n .. "Allright, your character is registered for Flag Freeze Tag."
					},
					1
				)
				ctf.entryLegend(target)
			end
		elseif player.m == 15020 then
		elseif player.m == 15030 then
		elseif player.m == 15040 then
		elseif player.m == 15050 then
		end
	end
}
