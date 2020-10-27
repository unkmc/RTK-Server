arenaPVPReqsCheckAndWarp = function(player, mapName)
	local npc = NPC("Tower")

	local t = {
		graphic = convertGraphic(npc.look, "monster"),
		color = npc.lookColor
	}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local m = 0
	local x = 0
	local y = 0

	local rejectLow = false
	local rejectHigh = false

	if mapName == "Kugnae Glory" then
		if player.level < 66 then
			rejectLow = true
		end
		if player.level > 85 then
			rejectHigh = true
		end

		m = 3006
		x = math.random(15, 16)
		y = 3
	elseif mapName == "Kugnae Ancients" then
		if player.level < 99 or player.mark ~= 0 then
			rejectLow = true
		end
		if player.baseHealth > 49999 or player.baseMagic > 24999 then
			rejectHigh = true
		end

		m = 3008
		x = math.random(15, 16)
		y = 3
	elseif mapName == "Kugnae Legends" then
		if player.level < 86 then
			rejectLow = true
		end
		if player.level > 98 then
			rejectHigh = true
		end

		m = 3007
		x = math.random(15, 16)
		y = 3
	elseif mapName == "Kugnae Heroes" then
		if player.level < 36 then
			rejectLow = true
		end
		if player.level > 65 then
			rejectHigh = true
		end

		m = 3005
		x = math.random(15, 16)
		y = 3
	elseif mapName == "Kugnae Adventure" then
		if player.level < 6 then
			rejectLow = true
		end
		if player.level > 35 then
			rejectHigh = true
		end

		m = 3004
		x = math.random(15, 16)
		y = 3
	end

	if mapName == "Stone Pit" then
		if player.level < 66 then
			rejectLow = true
		end
		if player.level > 85 then
			rejectHigh = true
		end

		m = 2593
		x = math.random(15, 16)
		y = 3
	elseif mapName == "Forsaken Arena" then
		if player.level < 99 or player.mark ~= 0 then
			rejectLow = true
		end
		if player.baseHealth > 49999 or player.baseMagic > 24999 then
			rejectHigh = true
		end

		m = 2591
		x = math.random(15, 16)
		y = 4
	elseif mapName == "Village Arena" then
		if player.level < 86 then
			rejectLow = true
		end
		if player.level > 98 then
			rejectHigh = true
		end

		m = 2592
		x = math.random(15, 16)
		y = 3
	end

	if mapName == "Yusa Pit" then
		m = 35
		x = math.random(7, 8)
		y = 3
	end

	if rejectLow == true or rejectHigh == true then
		if rejectLow == true then
			player:sendMinitext("Nightmarish visions of your own death repel you.")
		end
		if rejectHigh == true then
			player:sendMinitext("Your honor forbids you from entering.")
		end

		if player.side == 3 then
			-- facing left
			player:warp(player.m, player.x + 2, player.y)
		elseif player.side == 1 then
			--facing right
			player:warp(player.m, player.x - 2, player.y)
		end

		return
	end

	player:dialogSeq(
		{
			t,
			"Be careful, you may be slain by another player within this realm and items on the floor can be destroyed by bombs!"
		},
		1
	)

	player:warp(m, x, y)
end
