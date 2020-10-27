seeSpotTraps = function(player)
	local npcs = player:getObjectsInArea(BL_NPC)
	local npctraps = {}

	local class = player.baseClass

	if #npcs == 0 then
		return
	end

	if (class == 1) then
		for i = 1, #npcs do
			if npcs[i].yname == "MobSpawnNpc" and distanceSquare(player, npcs[i], 15) then
				table.insert(npctraps, npcs[i])
			end
		end
	elseif (class == 2) then
		--rogue
		for i = 1, #npcs do
			if ((npcs[i].yname == "DartTrapNpc" or
				npcs[i].yname == "FlashTrapNpc" or
				npcs[i].yname == "RepeatingDartTrapNpc" or
				npcs[i].yname == "SnareTrapNpc" or
				npcs[i].yname == "SpearTrapNpc" or
				npcs[i].yname == "PoisonDartTrapNpc" or
				npcs[i].yname == "DeathTrapNpc" or
				npcs[i].yname == "SleepTrapNpc") and
				distanceSquare(player, npcs[i], 15)) then
				
				table.insert(npctraps, npcs[i])
			end
		end
	end

	for i = 1, #npctraps do
		player:dropItemXY(
			99,
			1,
			0,
			0,
			npctraps[i].m,
			npctraps[i].x,
			npctraps[i].y
		)

		local items = player:getObjectsInCellWithTraps(
			npctraps[i].m,
			npctraps[i].x,
			npctraps[i].y,
			BL_ITEM
		)

		for j = 1, #items do
			if items[j].id == 99 then
				items[j]:addTrapSpotters(player.ID)
			end
		end
	end
	player:updateState()
	player:refresh()
end

getSpotTrapIds = function(player)
	local items = player:getObjectsInCellWithTraps(
		player.m,
		player.x,
		player.y,
		BL_ITEM
	)

	for i = 1, #items do
		local ids = items[i]:getTrapSpotters()

		for j = 1, #ids do
			player:talk(0, "" .. ids[j])
		end
	end
end

removeSpotTraps = async(function(player)
	local npcBlocks = player:getObjectsInArea(BL_NPC)
	local npcsToRemove = {}

	local type = player:menuString(
		"Please choose npc spawners (warriors) or traps (rogues)",
		{"npc spawners", "traps"}
	)

	if type == "npc spawners" then
		for i = 1, #npcBlocks do
			if npcBlocks[i].yname == "MobSpawnNpc" then
				table.insert(npcsToRemove, npcBlocks[i])
			end
		end
	elseif type == "traps" then
		for i = 1, #npcBlocks do
			if (npcBlocks[i].yname == "DartTrapNpc" or
				npcBlocks[i].yname == "FlashTrapNpc" or
				npcBlocks[i].yname == "RepeatingDartTrapNpc" or
				npcBlocks[i].yname == "SnareTrapNpc" or
				npcBlocks[i].yname == "SpearTrapNpc" or
				npcBlocks[i].yname == "poison_trap" or -- @TODO: Not sure this NPC actually exists
				npcBlocks[i].yname == "DeathTrapNpc" or
				npcBlocks[i].yname == "SleepTrapNpc") then

				table.insert(npcsToRemove, npcBlocks[i])
			end
		end
	end

	if #npcsToRemove > 0 then
		for i = 1, #npcsToRemove do
			local items = player:getObjectsInCellWithTraps(
				npcsToRemove[i].m,
				npcsToRemove[i].x,
				npcsToRemove[i].y,
				BL_ITEM
			)

			if #items > 0 then
				for j = 1, #items do
					if items[j].id == 99 then
						items[j]:delete()
					end
				end
			end

			npcsToRemove[i]:delete()
		end
	end
end)

removeTrapItem = function(npc)
	local items = npc:getObjectsInCellWithTraps(npc.m, npc.x, npc.y, BL_ITEM)

	if (items ~= nil) then
		if #items > 0 then
			for j = 1, #items do
				if items[j].id == 99 then
					items[j]:delete()
				end
			end
		end
	end
end

removeTrap = function(npc)
	npc:delete()
end
