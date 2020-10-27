getNagnangShieldQuestBaseMap = function(player)
	local baseMap = 5800

	if math.abs(player.m - 5800) < 40 then
		baseMap = 5800
	elseif math.abs(player.m - 5840) < 40 then
		baseMap = 5840
	elseif math.abs(player.m - 5880) < 40 then
		baseMap = 5880
	elseif math.abs(player.m - 5920) < 40 then
		baseMap = 5920
	elseif math.abs(player.m - 5960) < 40 then
		baseMap = 5960
	end

	return baseMap
end

-- il san 160/80
-- ee san 320/160
-- sam 640/320

onScriptedTilesNagnangShieldQuest = async(function(player)
	--[[
5800-5805      5806 - 5836
5840-5845      5846 - 5876
5880-5885      5886 - 5916
5920-5925      5926 - 5956
5960-5965      5966 - 5996
]]
	--

	--DARK FOREST QUEST MAP

	local baseMap = getNagnangShieldQuestBaseMap(player)

	if player.mapTitle == "The Dark Forest" then
		local northExit = false
		local southExit = false
		local eastExit = false
		local westExit = false

		local m
		local x
		local y

		local northEntry = {}

		-- going from south exit of map to north entrance
		table.insert(northEntry, {m = baseMap, x = math.random(6, 8), y = 1})
		table.insert(
			northEntry,
			{m = baseMap + 1, x = math.random(16, 17), y = 1}
		)
		table.insert(
			northEntry,
			{m = baseMap + 2, x = math.random(15, 16), y = 1}
		)
		table.insert(
			northEntry,
			{m = baseMap + 4, x = math.random(21, 22), y = 1}
		)
		table.insert(
			northEntry,
			{m = baseMap + 5, x = math.random(7, 8), y = 1}
		)
		local southEntry = {}

		-- going from north exit of map to south entrance
		table.insert(southEntry, {m = baseMap, x = math.random(8, 9), y = 28})
		table.insert(
			southEntry,
			{m = baseMap + 1, x = math.random(11, 12), y = 28}
		)
		table.insert(
			southEntry,
			{m = baseMap + 2, x = math.random(10, 11), y = 28}
		)
		table.insert(
			southEntry,
			{m = baseMap + 3, x = math.random(22, 24), y = 28}
		)
		table.insert(
			southEntry,
			{m = baseMap + 4, x = math.random(7, 8), y = 28}
		)
		table.insert(
			southEntry,
			{m = baseMap + 5, x = math.random(13, 15), y = 28}
		)
		local westEntry = {}

		-- going from east exit of map to west entrance
		table.insert(westEntry, {m = baseMap + 1, x = 1, y = math.random(5, 7)})
		table.insert(
			westEntry,
			{m = baseMap + 2, x = 1, y = math.random(16, 18)}
		)
		table.insert(westEntry, {m = baseMap + 3, x = 1, y = math.random(5, 7)})
		table.insert(westEntry, {m = baseMap + 4, x = 1, y = math.random(3, 5)})

		local eastEntry = {}

		-- going from west exit of map to east entrance
		table.insert(eastEntry, {m = baseMap, x = 28, y = math.random(9, 11)})
		table.insert(
			eastEntry,
			{m = baseMap + 1, x = 28, y = math.random(15, 17)}
		)
		table.insert(
			eastEntry,
			{m = baseMap + 3, x = 28, y = math.random(2, 4)}
		)
		table.insert(
			eastEntry,
			{m = baseMap + 4, x = 28, y = math.random(21, 23)}
		)
		table.insert(
			eastEntry,
			{m = baseMap + 5, x = 28, y = math.random(17, 19)}
		)

		-- north exits
		if player.m == baseMap and player.x >= 6 and player.x <= 7 and player.y == 0 then
			northExit = true
		end
		if player.m == baseMap + 1 and player.x >= 15 and player.x <= 17 and player.y == 0 then
			northExit = true
		end
		if player.m == baseMap + 2 and player.x >= 14 and player.x <= 16 and player.y == 0 then
			northExit = true
		end
		if player.m == baseMap + 4 and player.x >= 21 and player.x <= 23 and player.y == 0 then
			northExit = true
		end
		if player.m == baseMap + 5 and player.x >= 7 and player.x <= 9 and player.y == 0 then
			northExit = true
		end

		-- west exits
		if player.m == baseMap + 1 and player.x == 0 and player.y >= 5 and player.y <= 7 then
			westExit = true
		end
		if player.m == baseMap + 2 and player.x == 0 and player.y >= 16 and player.y <= 18 then
			westExit = true
		end
		if player.m == baseMap + 3 and player.x == 0 and player.y >= 5 and player.y <= 7 then
			westExit = true
		end
		if player.m == baseMap + 4 and player.x == 0 and player.y >= 3 and player.y <= 5 then
			westExit = true
		end

		-- east exits
		if player.m == baseMap and player.x == 29 and player.y >= 9 and player.y <= 11 then
			eastExit = true
		end
		if player.m == baseMap + 1 and player.x == 29 and player.y >= 15 and player.y <= 17 then
			if player.quest["used_compass"] == 1 then
				player.quest["used_compass"] = 0
				player:warp(baseMap + 10, math.random(27, 29), 58)
				player:sendMinitext("You break out of the forest at last!")
			elseif player.quest["used_compass"] == 0 then
				eastExit = true
			end
		end
		if player.m == baseMap + 3 and player.x == 29 and player.y >= 2 and player.y <= 4 then
			eastExit = true
		end
		if player.m == baseMap + 4 and player.x == 29 and player.y >= 21 and player.y <= 23 then
			eastExit = true
		end
		if player.m == baseMap + 5 and player.x == 29 and player.y >= 17 and player.y <= 19 then
			eastExit = true
		end

		-- south exits
		if player.m == baseMap and player.x >= 8 and player.x <= 10 and player.y == 29 then
			southExit = true
		end
		if player.m == baseMap + 1 and player.x >= 10 and player.x <= 12 and player.y == 29 then
			southExit = true
		end
		if player.m == baseMap + 2 and player.x >= 10 and player.x <= 12 and player.y == 29 then
			southExit = true
		end
		if player.m == baseMap + 3 and player.x >= 22 and player.x <= 24 and player.y == 29 then
			southExit = true
		end
		if player.m == baseMap + 4 and player.x >= 7 and player.x <= 9 and player.y == 29 then
			southExit = true
		end
		if player.m == baseMap + 5 and player.x >= 13 and player.x <= 16 and player.y == 29 then
			southExit = true
		end

		if northExit == true or southExit == true or westExit == true or eastExit == true then
			local messages = {
				"You see footprints, and realize they are your own.",
				"You are positive you have been here before!",
				"You feel lost and confused.",
				"You feel like you are going in circles."
			}

			if northExit == true then
				local n = math.random(1, #southEntry)
				player:warp(southEntry[n].m, southEntry[n].x, southEntry[n].y)
			end
			if southExit == true then
				local n = math.random(1, #northEntry)
				player:warp(northEntry[n].m, northEntry[n].x, northEntry[n].y)
			end
			if westExit == true then
				local n = math.random(1, #eastEntry)
				player:warp(eastEntry[n].m, eastEntry[n].x, eastEntry[n].y)
			end
			if eastExit == true then
				local n = math.random(1, #westEntry)
				player:warp(westEntry[n].m, westEntry[n].x, westEntry[n].y)
			end

			player:sendMinitext(messages[math.random(1, #messages)])
		end
	end

	if player.mapTitle == "Nagnag's Courtyard" then
		local t = {
			graphic = Item("lockpick").icon,
			color = Item("lockpick").iconC
		}
		if player.x == 41 and (player.y == 30 or player.y == 31) then
			if player:hasItem("lockpick", 1) == true then
				player:dialogSeq(
					{
						t,
						"You place the lockpick in the hole, and jiggle it a bit."
					},
					1
				)
				player:warp(baseMap + 11, 9, 58)
			else
				player:dialogSeq(
					{t, "You try to pick the lock, but it doesn't work."},
					0
				)
			end
		end
		if player.x == 45 and (player.y == 30 or player.y == 31) then
			if player:hasItem("lockpick", 1) == true then
				player:dialogSeq(
					{t, "You try to pick the lock, but it doesn't work."},
					0
				)
			end
		end
		if player.x >= 23 and player.x <= 26 and player.y == 42 then
			if player:hasItem("lockpick", 1) == true then
				player:dialogSeq(
					{t, "You try to pick the lock, but it doesn't work."},
					0
				)
			end
		end

		-- courtyard to office
		if player.x >= 13 and player.x <= 14 and player.y == 27 then
			-- to office
			player:warp(baseMap + 22, player.x - 9, 8)
		end

		-- courtyard to palace wall
		if player.x == 41 and player.y == 8 then
			player:warp(baseMap + 11, 9, 16)
		end
	end

	if player.mapTitle == "Palace Wall" and player.m >= 5800 and player.m <= 5996 then
		if player.x == 8 and player.y == 15 then
			-- warp to courtyard top
			player:warp(baseMap + 6, 40, 8)
		end
		if player.x == 9 and player.y == 59 then
			-- warp to courtyard bottom
			player:warp(baseMap + 6, 40, 30)
		end
	end

	-- Office to Courtyard
	if player.mapTitle == "Office" and player.m >= 5800 and player.m <= 5996 then
		if player.x >= 4 and player.x <= 5 and player.y == 9 then
			player:warp(baseMap + 6, player.x + 9, 28)
		end
	end

	-- Sewer exit to office
	if player.mapTitle == "Sewers" and (player.m == 5816 or player.m == 5856 or player.m == 5896 or player.m == 5936 or player.m == 5976) then
		-- 2 exit points
		if player.x == 6 and player.y == 14 then
			player:warp(baseMap + 6, 8, 25)
		elseif player.x == 2 and player.y == 23 then
			player:warp(baseMap + 6, 8, 25)
		end
	end

	if player.mapTitle == "Benitnaths Room" then
		if player.x == 11 and player.y == 3 then
			local t = {
				graphic = Item("lantern").icon,
				color = Item("lantern").iconC
			}
			player.npcGraphic = 0
			player.npcColor = 0
			player.dialogType = 0
			player.lastClick = 0

			player:dialogSeq(
				{
					t,
					"You find the drain hole Benitnath talked about.",
					"It's pitch black down there, you would have to be crazy to go in."
				},
				1
			)

			if player:hasItem("lantern", 1) == true then
				player:dialogSeq(
					{
						t,
						"With the lantern in your hand, you feel it is safe to enter."
					},
					1
				)
				player:warp(baseMap + 12, 21, 2)
				return
			end

			local choice = player:menuSeq(
				"Do you want to go in anyways?",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				player:warp(baseMap + 12, 21, 2)
			end
		end
	end

	if player.mapTitle == "Valley Farm" and player.y == 18 then
		if player:hasItem("stilts", 1) == true then
			local t = {
				graphic = Item("stilts").icon,
				color = Item("stilts").iconC
			}
			player.npcGraphic = 0
			player.npcColor = 0
			player.dialogType = 0
			player.lastClick = 0

			player:dialogSeq(
				{
					t,
					"You approach the waters edge, and slowly place the stilts in the water.",
					"You grab a hold of them, and quickly stand up, just like Majhum told you.",
					"You're a little wobbly, but you slowly get the hang of the stilts, and start your way across."
				},
				1
			)

			player:warp(baseMap + 6, 24, 48)
		end
	end

	if player.mapTitle == "Nagnang" and player.x == 79 and player.y == 1 then
		--{5800,5840,5880,5920,5960}
		player:eventCaveLevelPrompt({5803, 5843, 5883, 5923, 5963}, 23, 27)
	end
end)
