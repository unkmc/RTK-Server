onScriptedTilesArena = async(function(player)
	local npc = NPC("Tower")

	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local m = player.m
	local x = player.x
	local y = player.y

	if player.mapTitle == "Tower Arena" then
		if os.time() < player.registry["minigameBan"] then
			player:returnToInn()
			player:dialogSeq({t, "You may not participate in this event"}, 0)
			return
		end
		if (x >= 1 and x <= 20 and y == 2) then
			-- doorways
			if (core.gameRegistry["minigameEventId"] == 11 and player.level >= 6 and player.level <= 35) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 12 and player.level >= 36 and player.level <= 65) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 13 and player.level >= 66 and player.level <= 85) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 14 and player.level >= 86 and player.level <= 98) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 15 and player.level >= 99 and player.baseHealth <= 49999 and player.baseMagic <= 24999) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 16 and player.level >= 99 and player.baseHealth >= 50000 and player.baseMagic >= 25000 and player.baseHealth <= 159999 and player.baseMagic <= 79999) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 17 and player.level >= 99 and player.baseHealth >= 160000 and player.baseMagic >= 80000) then
				player:warp(3013, 6, 10)
			elseif (core.gameRegistry["minigameEventId"] == 18 and player.level >= 1) then
				player:warp(3013, 6, 10)
			else
				player:sendMinitext("You may not enter this carnage!")
				player:warp(31, 11, 7)
			end
		end

		if (y >= 5 and y <= 18 and (x == 0 or x == 21)) then
			-- side doors

			if (x == 21 and (y == 5 or y == 6)) then
				-- kug legends
				arenaPVPReqsCheckAndWarp(player, "Kugnae Legends")
			elseif (x == 21 and (y == 11 or y == 12)) then
				-- kug ancients
				arenaPVPReqsCheckAndWarp(player, "Kugnae Ancients")
			elseif (x == 0 and (y == 11 or y == 12)) then
				-- kug heroes
				arenaPVPReqsCheckAndWarp(player, "Kugnae Heroes")
			elseif (x == 0 and (y == 17 or y == 18)) then
				-- kug glory
				arenaPVPReqsCheckAndWarp(player, "Kugnae Glory")
			elseif (x == 0 and (y == 5 or y == 6)) then
				-- kug adventure
				arenaPVPReqsCheckAndWarp(player, "Kugnae Adventure")
			end
		end
	end

	if player.mapTitle == "Nagnang Arena" then
		if (y == 2) then
			-- top doors
			if os.time() < player.registry["minigameBan"] then
				player:returnToInn()
				player:dialogSeq(
					{t, "You may not participate in this event"},
					0
				)
				return
			end
			if player.level < 6 then
				player:warp(player.m, player.x, player.y + 5)
				player:sendMinitext("You need to be at least level 6 in order to play.")
				return
			end

			if player.money < 500 then
				player:warp(player.m, player.x, player.y + 5)
				player:sendMinitext("You need 500 gold to participate in Elixir.")
				return
			end

			player:flushDuration(1)
			player.state = 0
			player.speed = 90
			player:updateState()
			player:removeGold(500)
			player:removeLegendbyName("participated_in_elixir_wars")
			player.registry["participated_in_elixir_wars"] = player.registry[
				"participated_in_elixir_wars"
			] + 1
			player:addLegend(
				"Participated in " .. player.registry[
					"participated_in_elixir_wars"
				] .. " Elixir Wars",
				"participated_in_elixir_wars",
				1,
				128
			)
			player:warp(3042, math.random(1, 18), math.random(14, 27))
		end

		if (y >= 7 and y <= 14 and (x == 0 or x == 19)) then
			-- side doors

			if (x == 19 and (y == 7 or y == 8)) then
				arenaPVPReqsCheckAndWarp(player, "Stone Pit")
			elseif (x == 0 and (y == 7 or y == 8)) then
				arenaPVPReqsCheckAndWarp(player, "Forsaken Arena")
			elseif (x == 0 and (y == 13 or y == 14)) then
				arenaPVPReqsCheckAndWarp(player, "Village Arena")
			end
		end
	end

	if player.mapTitle == "Mountain Arena" then
		if x == 0 and (y == 5 or y == 6) then
			arenaPVPReqsCheckAndWarp(player, "Yusa Pit")
		end
	end
end)
