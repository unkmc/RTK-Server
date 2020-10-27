local _defaultRates = {
    -- Newbie
    ["thirsty_ogre"] = 90,
    ["kingdom_rat"] = 300,
	["green_squirrel"] = {300, 240, 330},
	["sheep"] = 240,

    -- Mythic
    ["monkey_sentry"] = {300, 300, 300},
    ["dog_sentry"] = {300, 300, 240},
    ["rooster_sentry"] = {120, 120, 120},
    ["rat_sentry"] = {300, 300, 300},
    ["horse_sentry"] = {300, 300, 210},
    ["ox_sentry"] = {300, 300, 300},
    ["pig_sentry"] = {300, 300, 300},
    ["snake_sentry"] = {115, 115, 115},
    ["sheep_sentry"] = {300, 300, 300},
    ["dragon_sentry"] = {300, 300, 300},

    -- Bosses
    ["zangze_zinte_chtan_sintu"] = 6000,
    ["golden_lobster"] = 3600
}

local _rebalancedRates = {
    -- Newbie
    ["thirsty_ogre"] = 90,
    ["kingdom_rat"] = 300,
	["green_squirrel"] = {300, 240, 330},
	["sheep"] = 120,

    -- Mythic
    ["monkey_sentry"] = {300, 300, 300},
    ["dog_sentry"] = {300, 300, 240},
    ["rooster_sentry"] = {120, 120, 120},
    ["rat_sentry"] = {300, 300, 300},
    ["horse_sentry"] = {300, 300, 210},
    ["ox_sentry"] = {300, 300, 300},
    ["pig_sentry"] = {300, 300, 300},
    ["snake_sentry"] = {115, 115, 115},
    ["sheep_sentry"] = {300, 300, 300},
    ["dragon_sentry"] = {300, 300, 300},

    -- Bosses
    ["zangze_zinte_chtan_sintu"] = 1500,
    ["golden_lobster"] = 900
}

local _fastRates = {
    -- Newbie
    ["thirsty_ogre"] = 30,
    ["kingdom_rat"] = 60,
	["green_squirrel"] = {60, 60, 60},
	["sheep"] = 60,

    -- Mythic
    ["monkey_sentry"] = {60, 60, 60},
    ["dog_sentry"] = {60, 60, 60},
    ["rooster_sentry"] = {60, 60, 60},
    ["rat_sentry"] = {60, 60, 60},
    ["horse_sentry"] = {60, 60, 60},
    ["ox_sentry"] = {60, 60, 60},
    ["pig_sentry"] = {60, 60, 60},
    ["snake_sentry"] = {60, 60, 60},
    ["sheep_sentry"] = {60, 60, 60},
    ["dragon_sentry"] = {60, 60, 60},

    -- Bosses
    ["zangze_zinte_chtan_sintu"] = 600,
    ["golden_lobster"] = 240
}

MobSpawnHandlerNpc = {
	action = function(npc)
		local start = os.time() * 1000 + timeMS()
		local spawnRates = _defaultRates

		if (Config.rebalancedSpawnsEnabled) then
			spawnRates = _rebalancedRates
		end

		if (Config.fastSpawnsEnabled) then
			spawnRates = _fastRates
		end

		--(npc,map,{mob ids},{mob counts},timer)

		--handleSpawn = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)

		-------------------
		-- For spy quest --
		-------------------
		if os.time() % 60 == 0 then
			if os.time() > getMapRegistry(npc.m, "hwan") + 60 then
				-- this will check for the last time he was taken so it doesn't respawn immediately
				local mob = npc:getObjectsInCell(330, 38, 99, BL_MOB)
				if #mob == 0 then
					if (curTime() >= 22 and curTime() <= 24) or (curTime() >= 0 and curTime() <= 5) then
						npc:spawn(729, 38, 99, 1, 330)
					end
				else
					if curTime() >= 6 and curTime() <= 21 then
						if mob[1].yname == "spy_hwan" then
							mob[1]:delete()
						end
					end
				end
			end
		end

		--BUYA 330
		MobSpawnHandlerNpc.handleSpawn(npc, 330, {8}, {20}, 300, 6, 19, 17, 100)

		-- Wilderness
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1002,
			{1, 2, 3, 4, 10, 70, 8, 9, 72, 73, 74, 814},
			{75, 75, 15, 15, 15, 15, 15, 15, 15, 15, 15, 5},
			300
		)

		-- Wilderness sheep
		MobSpawnHandlerNpc.handleSpawn(npc, 1002, {71}, {100}, spawnRates["sheep"], 86, 88, 136, 162)

		--Mythic (thirsty_ogre 553)
		MobSpawnHandlerNpc.handleSpawn(npc, 41, {553}, {12}, spawnRates["thirsty_ogre"], 0, 50, 10, 59)
		MobSpawnHandlerNpc.handleSpawn(npc, 41, {2, 3, 4}, {50, 5, 5}, 300)

		-- Tutorial
		MobSpawnHandlerNpc.handleSpawn(npc, 4711, {1, 2}, {5, 5}, 60)
		MobSpawnHandlerNpc.handleSpawn(npc, 4714, {1, 2}, {15, 15}, 60)
		MobSpawnHandlerNpc.handleSpawn(npc, 4715, {1, 2}, {10, 10}, 60)

		-- Buya Rat
		MobSpawnHandlerNpc.handleSpawn(npc, 370, {10, 49}, {12, 4}, spawnRates["kingdom_rat"])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			371,
			{10, 49, 50, 52},
			{6, 10, 4, 1},
			spawnRates["kingdom_rat"]
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			372,
			{10, 98, 50, 52},
			{10, 6, 4, 1},
			spawnRates["kingdom_rat"]
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 373, {53, 54}, {16, 4}, spawnRates["kingdom_rat"])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			374,
			{10, 50, 98, 52, 53, 54},
			{6, 2, 8, 2, 6, 2},
			spawnRates["kingdom_rat"]
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			375,
			{10, 50, 52, 55},
			{8, 4, 1, 4},
			spawnRates["kingdom_rat"]
		)

		--HAUSSON
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1023,
			{547, 10, 72, 8},
			{20, 20, 10, 10},
			2
		)

		-- FOREVER TREE
		-- man-shik raven 315  -- tree spawn is a static spawn and in the spawn table
		MobSpawnHandlerNpc.handleSpawn(npc, 1228, {315}, {40}, 120)

		-- Kaming encampment
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3800,
			{558, 559, 560, 561},
			{18, 14, 12, 1},
			300
		)

		-- Southern Koguryo
		-- rabbit 1, squirrel 2, rat 10, deer 3, doe 4, snake 72, strange thing 313
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1009,
			{1, 2, 10, 3, 4, 72},
			{35, 25, 15, 5, 5, 15},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 1009, {313}, {1}, 21600)

		-- ST Spawn 6 hrs

		-- Nagnang
		-- rabbit 1, squirrel 2, rat 10, deer 3, doe 4, snake 72, crow 314, strange thing 313
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2500,
			{1, 2, 10, 3, 4, 72, 314},
			{65, 45, 25, 28, 24, 20, 20},
			240
		)

		-- Strange thing 313
		MobSpawnHandlerNpc.handleSpawn(npc, 2500, {313}, {1}, 21600)

		-- ST Spawn 6 hrs

		-- Buya Lib caverns
		-- blind mouse 198, blind rat 199, blind lib mouse 200, blind centipede 201, blind lib rat 202, blind mantis 203

		for i = 6502, 6598, 20 do
			-- 5 levels

			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i,
				{198, 199, 200},
				{15, 18, 7},
				300
			)

			-- cavern 3
			MobSpawnHandlerNpc.handleSpawn(npc, i + 1, {198, 199}, {10, 10}, 300)

			-- cavern 1
			MobSpawnHandlerNpc.handleSpawn(npc, i + 2, {200, 202}, {12, 8}, 300)

			-- cavern 9
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 3,
				{198, 199, 200},
				{15, 18, 7},
				300
			)

			-- cavern 4
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 4,
				{198, 199, 200},
				{15, 18, 7},
				300
			)

			-- cavern 5
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 5,
				{198, 199, 200},
				{15, 18, 7},
				300
			)

			-- cavern 6
			MobSpawnHandlerNpc.handleSpawn(npc, i + 6, {200, 202}, {12, 8}, 300)

			-- cavern 7
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 7,
				{198, 199, 200},
				{15, 18, 7},
				300
			)

			-- cavern 2
			MobSpawnHandlerNpc.handleSpawn(npc, i + 8, {200, 202}, {12, 8}, 300)

			-- cavern 8
			MobSpawnHandlerNpc.handleSpawn(npc, i + 9, {200, 202}, {12, 8}, 300)

			-- cavern 10
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 11,
				{200, 201, 203},
				{12, 8, 4},
				300
			)

			-- cavern 12
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 12,
				{201, 202, 203},
				{12, 8, 4},
				300
			)

			-- cavern 13
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 13,
				{201, 202, 203},
				{12, 8, 4},
				300
			)

			-- cavern 14
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 14,
				{201, 202, 203},
				{12, 8, 4},
				300
			)

			-- cavern 15
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 15,
				{201, 202, 203},
				{12, 8, 4},
				300
			)

			-- cavern 16
			MobSpawnHandlerNpc.handleSpawn(
				npc,
				i + 16,
				{201, 202, 203},
				{12, 8, 4},
				300
			)

			-- cavern 17
		end

		-- Poet whip quest Nagnang maps
		-- magic bunny 301, evil presence 302, the infected 303
		MobSpawnHandlerNpc.handleSpawn(npc, 2522, {301}, {40}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2521, {301, 302}, {40, 30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2525, {301, 302}, {50, 50}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2523, {301, 302}, {40, 30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2526, {301, 302}, {50, 50}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2524, {301, 302}, {50, 50}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2529, {301, 302}, {40, 40}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2527, {301, 302}, {40, 40}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2528, {302}, {60}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 2530, {303}, {1}, 300)

		-- Dark Forest mobs
		-- mercenary 305, pine fox 306, pine wolf 307, pine raven 308
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5800,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5801,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5802,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5803,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5804,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5805,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5840,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5841,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5842,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5843,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5844,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5845,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5880,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5881,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5882,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5883,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5884,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5885,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5920,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5921,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5922,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5923,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5924,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5925,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5960,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5961,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5962,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5963,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5964,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5965,
			{305, 306, 307, 308},
			{2, 5, 3, 2},
			300
		)

		-- Valley Farm
		-- rabbit 1, deer 3, doe 4, cat 11, cow 309, sheep 71
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5810,
			{1, 3, 4, 11, 309, 71},
			{15, 4, 4, 2, 6, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5850,
			{1, 3, 4, 11, 309, 71},
			{15, 4, 4, 2, 6, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5890,
			{1, 3, 4, 11, 309, 71},
			{15, 4, 4, 2, 6, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5930,
			{1, 3, 4, 11, 309, 71},
			{15, 4, 4, 2, 6, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5970,
			{1, 3, 4, 11, 309, 71},
			{15, 4, 4, 2, 6, 5},
			300
		)

		-- Nagnag's Courtyard
		--mercenary_1 310, mercenary_2 311, mercenary_3 312
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5806,
			{310, 311, 312},
			{15, 12, 18},
			420
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5846,
			{310, 311, 312},
			{15, 12, 18},
			420
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5886,
			{310, 311, 312},
			{15, 12, 18},
			420
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5926,
			{310, 311, 312},
			{15, 12, 18},
			420
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5966,
			{310, 311, 312},
			{15, 12, 18},
			420
		)

		-- Palace Wall
		--mercenary_1 310, mercenary_2 311, mercenary_3 312
		MobSpawnHandlerNpc.handleSpawn(npc, 5811, {310, 311, 312}, {4, 4, 3}, 420)
		MobSpawnHandlerNpc.handleSpawn(npc, 5851, {310, 311, 312}, {4, 4, 3}, 420)
		MobSpawnHandlerNpc.handleSpawn(npc, 5891, {310, 311, 312}, {4, 4, 3}, 420)
		MobSpawnHandlerNpc.handleSpawn(npc, 5931, {310, 311, 312}, {4, 4, 3}, 420)
		MobSpawnHandlerNpc.handleSpawn(npc, 5971, {310, 311, 312}, {4, 4, 3}, 420)

		-- Benitnaths Island
		-- rabbit 1, cat 11, cow 309, sheep 71
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5807,
			{1, 11, 309, 71},
			{15, 2, 6, 5},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5847,
			{1, 11, 309, 71},
			{15, 2, 6, 5},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5887,
			{1, 11, 309, 71},
			{15, 2, 6, 5},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5927,
			{1, 11, 309, 71},
			{15, 2, 6, 5},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5967,
			{1, 11, 309, 71},
			{15, 2, 6, 5},
			240
		)

		-- SEWERS
		-- blood mouse 687, blood rat 688, blood snake 689, blood serpent 690, blood leech 691
		-- 5812 - 5821  // Level 1
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5812,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5813,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5814,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5815,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5816,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5817,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5818,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5819,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5820,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5821,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)

		-- 5852 - 5861  // Level 2
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5852,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5853,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5854,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5855,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5856,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5857,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5858,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5859,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5860,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5861,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)

		-- 5892 - 5901  // Level 3
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5892,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5893,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5894,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5895,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5896,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5897,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5898,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5899,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5900,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5901,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)

		-- 5932 - 5941  // Level 4
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5932,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5933,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5934,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5935,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5936,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5937,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5938,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5939,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5940,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5941,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)

		-- 5972 - 5981  // Level 5
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5972,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5973,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5974,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5975,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5976,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5977,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5978,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5979,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5980,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5981,
			{687, 688, 689, 690, 691},
			{15, 8, 15, 8, 4},
			240
		)

		-- ARMORY SPAWNS
		-- armory_mercenary_1a 317, armory_mercenary_1b 318, armory_mercenary_1c 319, armory_mercenary_2a 320, armory_mercenary_2b 321, armory_mercenary_2c 322, armory_mercenary_3a 323, armory_mercenary_3b 324, armory_mercenary_3c 325,

		MobSpawnHandlerNpc.handleSpawn(npc, 5809, {320, 321, 322}, {6, 7, 5}, 300)

		-- Grand Hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5834, {317, 318, 319}, {7, 8, 7}, 300)

		-- Warrior Storage
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5836,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Warrior Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5849, {320, 321, 322}, {6, 7, 5}, 300)

		-- Grand Hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5874, {317, 318, 319}, {7, 8, 7}, 300)

		-- Warrior Storage
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5876,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Warrior Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5889, {320, 321, 322}, {6, 7, 5}, 300)

		-- Grand Hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5914, {317, 318, 319}, {7, 8, 7}, 300)

		-- Warrior Storage
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5916,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Warrior Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5929, {320, 321, 322}, {6, 7, 5}, 300)

		-- Grand Hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5954, {317, 318, 319}, {7, 8, 7}, 300)

		-- Warrior Storage
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5956,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Warrior Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5969, {320, 321, 322}, {6, 7, 5}, 300)

		-- Grand Hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5994, {317, 318, 319}, {7, 8, 7}, 300)

		-- Warrior Storage
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5996,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Warrior Stairwell

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5823,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Rogue Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5825, {323, 324, 325}, {9, 8, 9}, 300)

		-- Rogue Center courtyard
		MobSpawnHandlerNpc.handleSpawn(npc, 5827, {317, 318, 319}, {4, 3, 4}, 300)

		-- Rogue kitchen
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5863,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Rogue Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5865, {323, 324, 325}, {9, 8, 9}, 300)

		-- Rogue Center courtyard
		MobSpawnHandlerNpc.handleSpawn(npc, 5867, {317, 318, 319}, {4, 3, 4}, 300)

		-- Rogue kitchen
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5903,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Rogue Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5905, {323, 324, 325}, {9, 8, 9}, 300)

		-- Rogue Center courtyard
		MobSpawnHandlerNpc.handleSpawn(npc, 5907, {317, 318, 319}, {4, 3, 4}, 300)

		-- Rogue kitchen
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5943,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Rogue Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5945, {323, 324, 325}, {9, 8, 9}, 300)

		-- Rogue Center courtyard
		MobSpawnHandlerNpc.handleSpawn(npc, 5947, {317, 318, 319}, {4, 3, 4}, 300)

		-- Rogue kitchen
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			5983,
			{323, 324, 325},
			{10, 10, 10},
			300
		)

		-- Rogue Stairwell
		MobSpawnHandlerNpc.handleSpawn(npc, 5985, {323, 324, 325}, {9, 8, 9}, 300)

		-- Rogue Center courtyard
		MobSpawnHandlerNpc.handleSpawn(npc, 5987, {317, 318, 319}, {4, 3, 4}, 300)

		-- Rogue kitchen

		MobSpawnHandlerNpc.handleSpawn(npc, 5826, {317, 318, 319}, {7, 8, 7}, 300)

		-- Mage Dining hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5829, {323, 324, 325}, {4, 5, 4}, 300)

		-- Mage meeting room
		MobSpawnHandlerNpc.handleSpawn(npc, 5866, {317, 318, 319}, {7, 8, 7}, 300)

		-- Mage Dining hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5869, {323, 324, 325}, {4, 5, 4}, 300)

		-- Mage meeting room
		MobSpawnHandlerNpc.handleSpawn(npc, 5906, {317, 318, 319}, {7, 8, 7}, 300)

		-- Mage Dining hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5909, {323, 324, 325}, {4, 5, 4}, 300)

		-- Mage meeting room
		MobSpawnHandlerNpc.handleSpawn(npc, 5946, {317, 318, 319}, {7, 8, 7}, 300)

		-- Mage Dining hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5949, {323, 324, 325}, {4, 5, 4}, 300)

		-- Mage meeting room
		MobSpawnHandlerNpc.handleSpawn(npc, 5986, {317, 318, 319}, {7, 8, 7}, 300)

		-- Mage Dining hall
		MobSpawnHandlerNpc.handleSpawn(npc, 5989, {323, 324, 325}, {4, 5, 4}, 300)

		-- Mage meeting room

		MobSpawnHandlerNpc.handleSpawn(npc, 5824, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Lower Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5830, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Upper Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5833, {317, 318, 319}, {8, 7, 8}, 300)

		-- Poet bedroom
		MobSpawnHandlerNpc.handleSpawn(npc, 5864, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Lower Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5870, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Upper Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5873, {317, 318, 319}, {8, 7, 8}, 300)

		-- Poet bedroom
		MobSpawnHandlerNpc.handleSpawn(npc, 5904, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Lower Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5910, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Upper Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5913, {317, 318, 319}, {8, 7, 8}, 300)

		-- Poet bedroom
		MobSpawnHandlerNpc.handleSpawn(npc, 5944, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Lower Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5950, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Upper Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5953, {317, 318, 319}, {8, 7, 8}, 300)

		-- Poet bedroom
		MobSpawnHandlerNpc.handleSpawn(npc, 5984, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Lower Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5990, {323, 324, 325}, {5, 6, 5}, 300)

		-- Poet Upper Corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 5993, {317, 318, 319}, {8, 7, 8}, 300)

		-- Poet bedroom

		-- Buya Snakes (Cromlech)
		MobSpawnHandlerNpc.handleSpawn(npc, 376, {107, 108}, {5, 5}, 300)

		-- Foul Pond
		MobSpawnHandlerNpc.handleSpawn(npc, 377, {108, 110}, {5, 5}, 300)

		-- Coil Cave
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			378,
			{109, 110, 111, 112},
			{2, 2, 2, 1},
			300
		)

		-- Sick Man Pond
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			379,
			{108, 109, 110, 111, 113},
			{5, 5, 5, 5, 3},
			300
		)

		-- Fang Gouge
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			380,
			{109, 110, 111, 112, 113, 114},
			{4, 5, 3, 4, 4, 2},
			300
		)

		-- Serpent Secret
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			381,
			{108, 109, 110, 111, 112, 113},
			{4, 3, 3, 4, 2, 2},
			300
		)

		-- Serpent Cove
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			382,
			{109, 110, 111, 112, 113, 114},
			{4, 3, 3, 4, 2, 2},
			300
		)

		-- Serpent Falls
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			383,
			{109, 110, 111, 112, 113, 114},
			{4, 3, 3, 4, 2, 2},
			300
		)

		-- Cromlech

		-- Buya HH
		-- pale zombie 90, lesser ghost 133, lesser skeleton 92, wicked ghost 134
		MobSpawnHandlerNpc.handleSpawn(npc, 450, {90, 92}, {15, 5}, 300)

		-- Old Shanty
		MobSpawnHandlerNpc.handleSpawn(npc, 451, {133}, {20}, 300)

		-- Dagger House
		MobSpawnHandlerNpc.handleSpawn(npc, 458, {133}, {20}, 300)

		-- Dagger Yard
		MobSpawnHandlerNpc.handleSpawn(npc, 453, {133}, {20}, 300)

		-- Condemned
		MobSpawnHandlerNpc.handleSpawn(npc, 454, {133}, {20}, 300)

		-- Broken Floor
		MobSpawnHandlerNpc.handleSpawn(npc, 452, {90, 92}, {15, 5}, 300)

		-- Wicked Yard
		MobSpawnHandlerNpc.handleSpawn(npc, 457, {133}, {20}, 300)

		-- Ruined House
		MobSpawnHandlerNpc.handleSpawn(npc, 455, {133}, {20}, 300)

		-- Sorrow Well
		MobSpawnHandlerNpc.handleSpawn(npc, 456, {90}, {10}, 300)

		-- Sorrow Yard
		MobSpawnHandlerNpc.handleSpawn(npc, 459, {90, 92}, {15, 5}, 300)

		-- Wicked House
		MobSpawnHandlerNpc.handleSpawn(npc, 384, {92}, {10}, 300)

		-- Gangrel Cave
		MobSpawnHandlerNpc.handleSpawn(npc, 385, {92}, {10}, 300)

		-- Bear Chamber
		MobSpawnHandlerNpc.handleSpawn(npc, 388, {92}, {10}, 300)

		-- Cub Cavern
		MobSpawnHandlerNpc.handleSpawn(npc, 389, {92}, {10}, 300)

		-- Paw Catacomb
		MobSpawnHandlerNpc.handleSpawn(npc, 389, {134}, {1}, 1800)

		-- Paw Catacomb
		MobSpawnHandlerNpc.handleSpawn(npc, 386, {92}, {10}, 300)

		-- Curtain Den
		MobSpawnHandlerNpc.handleSpawn(npc, 387, {92}, {10}, 300)

		-- Winding Cave

		-- -------------------
		-- Buya Scorpion cave
		-- -------------------
		-- 99 carrion_raven
		-- 101 giant_scorpion
		-- 554 vile_scorpion
		-- 555 scorpion_lurker (trapped)
		-- 556 radiant_scorpion
		-- 557 crimson_scorpion (boss)
		MobSpawnHandlerNpc.handleSpawn(npc, 410, {99, 554}, {4, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 411, {99, 554, 101, 556}, {3, 10, 4, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 412, {99, 554, 101, 556}, {3, 10, 4, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 413, {99, 554, 101, 556}, {3, 10, 4, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 414, {99, 554, 101, 556}, {3, 10, 4, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 415, {99, 554, 101, 556}, {3, 10, 4, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 416, {99, 554, 101, 556, 104, 105}, {2, 8, 2, 8, 2, 1}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 417, {99, 554, 101, 556, 104, 105}, {2, 8, 2, 8, 2, 1}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 418, {99, 554, 101, 556, 104, 105}, {2, 8, 2, 8, 2, 1}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 419, {99, 554, 101, 556, 104, 105}, {2, 8, 2, 8, 2, 1}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 419, {557}, {1}, 1800)

		-- Buya Rabbit
		--hare 116, blissful bird 126, dark wolf 127, dark buck 135, dark deer 136, large hare 128, ravenous bird 129, albino buck 115, blood tick 137
		--MobSpawnHandlerNpc.handleSpawn(npc, mapid, {mob ids}, {mob amounts}, 240) -- map name
		MobSpawnHandlerNpc.handleSpawn(npc, 400, {116, 126}, {10, 10}, 240) -- Radiant Valley
		MobSpawnHandlerNpc.handleSpawn(npc, 401, {116, 126, 127, 135, 136, 128}, {10, 10, 5, 5, 5, 3}, 240) -- deer field
		MobSpawnHandlerNpc.handleSpawn(npc, 402, {126, 127, 135, 136, 128}, {10, 10, 5, 5, 3}, 240 ) -- Barren SLopes
		MobSpawnHandlerNpc.handleSpawn(npc, 403, {127, 135, 128, 129}, {10, 10, 5, 5}, 240) -- grazing rows
		MobSpawnHandlerNpc.handleSpawn(npc, 404, {127, 135, 128, 129}, {10, 10, 5, 5}, 240) -- warm sands
		MobSpawnHandlerNpc.handleSpawn(npc, 405, {127, 135, 136, 128, 129}, {10, 10, 10, 5, 5}, 240) -- deer edge
		MobSpawnHandlerNpc.handleSpawn(npc, 406, {135, 129, 115}, {10, 10, 5}, 240) -- disturbed nests
		MobSpawnHandlerNpc.handleSpawn(npc, 407, {135, 128, 129, 137}, {10, 10, 5, 1}, 240) -- narrow pass
		MobSpawnHandlerNpc.handleSpawn(npc, 408, {135, 128, 129, 115, 137}, {10, 10, 5, 5, 1}, 240) -- albino way
		MobSpawnHandlerNpc.handleSpawn(npc, 409, {135, 129, 115, 137}, {10, 10, 5, 1}, 240) -- prey

		-- Buya Sute's Cave
		-- yachi 141, seki 142, li 143, sute 144
		MobSpawnHandlerNpc.handleSpawn(npc, 446, {141}, {10}, 300)

		-- Sute's welcome
		MobSpawnHandlerNpc.handleSpawn(npc, 441, {141, 142}, {15, 10}, 300)

		-- Barren Graves
		MobSpawnHandlerNpc.handleSpawn(npc, 447, {141, 142}, {15, 10}, 300)

		-- Dark pools
		MobSpawnHandlerNpc.handleSpawn(npc, 444, {141, 142}, {15, 10}, 300)

		-- the Black Lake
		MobSpawnHandlerNpc.handleSpawn(npc, 445, {141, 142}, {15, 10}, 300)

		-- Deaths' Isthmus
		MobSpawnHandlerNpc.handleSpawn(npc, 443, {141, 142, 143}, {15, 10, 6}, 300)

		-- Forsaken Grotto
		MobSpawnHandlerNpc.handleSpawn(npc, 442, {141, 142, 144}, {15, 10, 1}, 300)

		-- Sute's Nest

		-- Arctic Northern Ogres
		-- northern ogre 149, frost ogre 150, ice panther 151, ice ogre 152, citelam 153, maletic 154,
		MobSpawnHandlerNpc.handleSpawn(npc, 138, {149}, {10}, 180)

		-- northern ogre caves
		MobSpawnHandlerNpc.handleSpawn(npc, 139, {149}, {10}, 180)

		-- thin ice
		MobSpawnHandlerNpc.handleSpawn(npc, 134, {149, 150}, {8, 4}, 180)

		-- ogre meeting room
		MobSpawnHandlerNpc.handleSpawn(npc, 131, {149, 150}, {10, 5}, 180)

		-- ogre crossroads
		MobSpawnHandlerNpc.handleSpawn(npc, 132, {149, 150}, {10, 5}, 180)

		-- frozen labyrinth
		MobSpawnHandlerNpc.handleSpawn(npc, 133, {149, 150}, {10, 5}, 180)

		-- frozen corridor
		MobSpawnHandlerNpc.handleSpawn(npc, 135, {150, 152}, {10, 8}, 180)

		-- ice canyon
		MobSpawnHandlerNpc.handleSpawn(npc, 140, {150}, {10}, 75)

		-- crystalline islee
		MobSpawnHandlerNpc.handleSpawn(npc, 140, {152}, {10}, 120)

		-- Arctic Ogres
		--  snow rabbit 491, arctic deer 492
		--  slush ogre 493, slush king 502  -- snow ogre 494, snow king 503 -- sleet ogre 495, sleet king 504
		--  hail ogre 496, hail king 505 -- flurry ogre 497, flurry king 506 -- blizzard ogre 498, blizzard king 507
		--  avalanche ogre 499, avalanche king 508 -- tempest ogre 500, tempest king 509 -- cyclone ogre 501, cyclone king 510
		MobSpawnHandlerNpc.handleSpawn(npc, 511, {491, 492, 493}, {6, 6, 32}, 300) -- snow dungeon
		MobSpawnHandlerNpc.handleSpawn(npc, 511, {502}, {1}, 900) -- slush king
		MobSpawnHandlerNpc.handleSpawn(npc, 512, {491, 492, 494}, {6, 6, 36}, 300) -- stone frost
		MobSpawnHandlerNpc.handleSpawn(npc, 512, {503}, {1}, 900) -- snow king
		MobSpawnHandlerNpc.handleSpawn(npc, 513, {491, 492, 495}, {6, 6, 40}, 300) -- rock ice
		MobSpawnHandlerNpc.handleSpawn(npc, 513, {504}, {1}, 900) -- sleet king
		MobSpawnHandlerNpc.handleSpawn(npc, 514, {491, 492, 496}, {6, 6, 44}, 300) -- frozen fire
		MobSpawnHandlerNpc.handleSpawn(npc, 514, {505}, {1}, 900) -- hail king
		MobSpawnHandlerNpc.handleSpawn(npc, 515, {491, 492, 497}, {6, 6, 44}, 300) -- latitudes
		MobSpawnHandlerNpc.handleSpawn(npc, 515, {506}, {1}, 900) -- flurry king
		MobSpawnHandlerNpc.handleSpawn(npc, 516, {491, 492, 498}, {6, 6, 44}, 300) -- snow blind
		MobSpawnHandlerNpc.handleSpawn(npc, 516, {507}, {1}, 900) -- blizzard king
		--- map 517/518 and misc? (icebound/ice palace/frozen dash/frozen bend/ice ring/frost field) to be added later.
		--- [ ^^ avalanche/tempest/cyclone ogres ^^ ]

		-- Tiger Palace  night 548 storm 549 blizzard 550 summit 551 two stripes 552
		MobSpawnHandlerNpc.handleSpawn(npc, 220, {548, 551}, {3, 3}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 221, {548, 551}, {3, 4}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 222, {548, 551}, {4, 4}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 223, {548, 551}, {5, 4}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 224, {548, 550, 551}, {4, 5, 4}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 225, {548, 550, 551}, {5, 4, 5}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 226, {548, 550, 551}, {5, 5, 5}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 227, {548, 551}, {7, 7}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 228, {548, 549, 550, 551}, {3, 2, 2, 4}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 229, {548, 550, 551}, {4, 6, 5}, 600)
		MobSpawnHandlerNpc.handleSpawn(npc, 230, {548, 549, 551, 552}, {3, 2, 4, 1}, 600)

		-- Scribe Mountain
		MobSpawnHandlerNpc.handleSpawn(npc, 1451, {2, 4}, {10, 5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1452, {2, 4}, {15, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1453, {2, 4}, {15, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1454, {2, 4}, {20, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1455, {2, 1}, {4, 3}, 300)

		-- Kug Rat
		MobSpawnHandlerNpc.handleSpawn(npc, 50, {49}, {10}, spawnRates["kingdom_rat"])
		MobSpawnHandlerNpc.handleSpawn(npc, 51, {49, 10, 50}, {9, 7, 3}, spawnRates["kingdom_rat"])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			52,
			{52, 53, 54, 55},
			{2, 10, 1, 8},
			spawnRates["kingdom_rat"]
		)

		-- bat cave
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			53,
			{49, 10, 50, 52},
			{12, 8, 4, 1},
			spawnRates["kingdom_rat"]
		)

		-- rat maze
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			54,
			{49, 10, 50, 52, 53, 54, 55, 97},
			{8, 6, 4, 1, 6, 1, 6, 1},
			spawnRates["kingdom_rat"]
		)

		-- rat den
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			55,
			{49, 10, 50, 52, 53, 54, 55, 97},
			{8, 6, 4, 1, 6, 2, 6, 1},
			spawnRates["kingdom_rat"]
		)

		-- bats and rats

		-- Kug Earthworks -- 107 = wild piglet, 108 = worm, 109 = wild_pig, 110 = mud snake, 111 = fire_worm, 112 = mud bull, 113 = earth_snake, 114 = warthog
		MobSpawnHandlerNpc.handleSpawn(npc, 59, {107, 108, 110}, {5, 5, 15}, 300)

		-- EarthWorks
		MobSpawnHandlerNpc.handleSpawn(npc, 56, {107, 108, 110}, {5, 5, 15}, 300)

		-- Worm Pits
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			62,
			{108, 109, 110, 111, 113},
			{15, 5, 25, 5, 3},
			300
		)

		-- Snake Coil
		MobSpawnHandlerNpc.handleSpawn(npc, 58, {109, 111, 113}, {15, 2, 1}, 300)

		-- Golden Soil
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			60,
			{108, 109, 111, 112, 113},
			{15, 10, 5, 2, 3},
			300
		)

		-- Ringworm
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			61,
			{108, 109, 111, 112, 113, 114},
			{15, 10, 5, 2, 3, 1},
			300
		)

		-- Tremor
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			57,
			{108, 109, 111, 112, 113, 114},
			{15, 10, 5, 2, 3, 1},
			300
		)

		-- Muddy Delta
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			63,
			{109, 110, 111, 112, 113, 114},
			{4, 3, 3, 4, 2, 2},
			300
		)

		-- Snake Food

		-- Kugnae HH
		-- 91 witch, 92 lesser skeleton, 93 witch shaman, 94 skel ju, 95 skel mage, 96 skel warr
		MobSpawnHandlerNpc.handleSpawn(npc, 122, {91}, {30}, 300)

		-- witches' brew
		MobSpawnHandlerNpc.handleSpawn(npc, 129, {91}, {15}, 300)

		-- dogrun death
		MobSpawnHandlerNpc.handleSpawn(npc, 121, {90, 92}, {10, 10}, 300)

		-- slime field
		MobSpawnHandlerNpc.handleSpawn(npc, 123, {90, 92}, {10, 10}, 300)

		-- death's playground
		MobSpawnHandlerNpc.handleSpawn(npc, 127, {90, 92}, {10, 10}, 300)

		-- ghoul's block
		MobSpawnHandlerNpc.handleSpawn(npc, 130, {90, 92}, {10, 10}, 300)

		-- scream dream
		MobSpawnHandlerNpc.handleSpawn(npc, 64, {92}, {10}, 300)

		-- dugout cave
		MobSpawnHandlerNpc.handleSpawn(npc, 65, {92}, {10}, 300)

		-- chamber den
		MobSpawnHandlerNpc.handleSpawn(npc, 68, {92}, {15}, 300)

		-- mother den
		MobSpawnHandlerNpc.handleSpawn(npc, 66, {92}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 66, {96}, {1}, 1800)
		MobSpawnHandlerNpc.handleSpawn(npc, 69, {92}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 69, {95}, {1}, 1800)
		MobSpawnHandlerNpc.handleSpawn(npc, 67, {92}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 67, {94}, {1}, 1800)
		MobSpawnHandlerNpc.handleSpawn(npc, 125, {91}, {10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 125, {93}, {1}, 1800)
		MobSpawnHandlerNpc.handleSpawn(npc, 124, {91}, {10}, 300)

		-- mover's nightmare
		MobSpawnHandlerNpc.handleSpawn(npc, 128, {91}, {10}, 300)

		-- crying room
		MobSpawnHandlerNpc.handleSpawn(npc, 126, {91}, {10}, 300)

		-- worm eaten

		MobSpawnHandlerNpc.handleSpawn(npc, 124, {93}, {1}, 1800)

		-- mover's nightmare
		MobSpawnHandlerNpc.handleSpawn(npc, 128, {93}, {1}, 1800)

		-- crying room
		MobSpawnHandlerNpc.handleSpawn(npc, 126, {93}, {1}, 1800)

		-- worm eaten

		-- kugnae spider
		MobSpawnHandlerNpc.handleSpawn(npc, 90, {99, 100}, {7, 7}, 300) -- spider's web
		
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			93,
			{99, 100, 101, 103},
			{15, 10, 5, 1},
			300
		) -- spider bite
		
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			96,
			{99, 100, 101, 103, 104, 105},
			{7, 5, 3, 3, 3, 1},
			300
		) -- spider bite
		
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			91,
			{99, 100, 101, 103},
			{10, 10, 5, 1},
			300
		) -- glow spider
		
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			95,
			{99, 100, 101, 103, 104, 105},
			{15, 10, 5, 5, 5, 1},
			300
		) -- spider climb
		
		MobSpawnHandlerNpc.handleSpawn(npc, 92, {99, 100, 103}, {5, 5, 1}, 300) -- spider's web

		-- Kugnae Fox Cave
		MobSpawnHandlerNpc.handleSpawn(npc, 70, {75}, {7}, 300)

		-- Fox crossroads
		MobSpawnHandlerNpc.handleSpawn(npc, 79, {75}, {15}, 300)

		-- Fox plateau
		MobSpawnHandlerNpc.handleSpawn(npc, 78, {115, 75}, {10, 15}, 300)

		-- Buck Bridge
		MobSpawnHandlerNpc.handleSpawn(npc, 77, {75, 76, 78}, {10, 10, 6}, 300)

		-- Dark den
		MobSpawnHandlerNpc.handleSpawn(npc, 73, {75, 76, 78}, {10, 10, 6}, 300)

		-- Fire den
		MobSpawnHandlerNpc.handleSpawn(npc, 74, {117, 78}, {10, 6}, 300)

		-- Misplaced Roost
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			75,
			{80, 75, 76, 78},
			{10, 10, 10, 7},
			300
		)

		-- Greener Pastures
		MobSpawnHandlerNpc.handleSpawn(npc, 76, {75, 76, 78}, {10, 10, 6}, 300)

		-- Fox gauntlet
		MobSpawnHandlerNpc.handleSpawn(npc, 72, {80, 75, 76}, {10, 10, 10}, 300)

		-- Green Pastures
		MobSpawnHandlerNpc.handleSpawn(npc, 71, {75}, {10}, 300)

		-- Coal cells

		-- Kugnae Rabbit
		--hare 116, blissful bird 126, dark wolf 127, large hare 128, ravenous bird 129, red hare 130, sheep 71, giant mantis 131, blood mantis 132
		MobSpawnHandlerNpc.handleSpawn(npc, 80, {116, 126}, {10, 10}, 240) -- Serene Valley
		MobSpawnHandlerNpc.handleSpawn(npc, 81, {116, 126, 71}, {10, 10, 5}, 240) -- Sparse Grazing
		MobSpawnHandlerNpc.handleSpawn(npc, 82, {126, 128, 71}, {10, 10, 5}, 240) -- Hare Glen
		MobSpawnHandlerNpc.handleSpawn(npc, 83, {128, 129, 71}, {10, 10, 5}, 240) -- Rock Forest
		MobSpawnHandlerNpc.handleSpawn(npc, 84, {127, 128, 130, 71}, {10, 10, 10, 5}, 240) -- Hare Sands
		MobSpawnHandlerNpc.handleSpawn(npc, 85, {127, 128, 130, 71}, {10, 10, 10, 5}, 240) -- Sheep Refuge
		MobSpawnHandlerNpc.handleSpawn(npc, 86, {127, 129, 130, 131, 132}, {10, 10, 10, 1, 1}, 240) -- Deadly Aerie
		MobSpawnHandlerNpc.handleSpawn(npc, 87, {127, 129, 130}, {10, 10, 5}, 240) -- Guarded Pass
		MobSpawnHandlerNpc.handleSpawn(npc, 88, {127, 129, 130, 131, 132}, {10, 10, 10, 1, 1}, 240) -- Mantis Trap
		MobSpawnHandlerNpc.handleSpawn(npc, 89, {127, 129, 130, 131, 132}, {10, 10, 10, 1, 1}, 240)	-- Insect's bane

		-- Rat 1
		MobSpawnHandlerNpc.handleSpawn(npc, 151, {15}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 152, {15}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 153, {15, 16}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 155, {15, 16}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 156, {16, 17}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 157, {16}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 158, {16, 17, 18}, {10, 10, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 159, {16, 17, 18}, {10, 10, 10}, 300)

		-- Rat 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3151, {166}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3152, {166}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3153, {166, 167}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3155, {166, 167}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3156, {167, 168}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3157, {167}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3158,
			{167, 168, 169},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3159,
			{167, 168, 169},
			{10, 10, 10},
			300
		)

		-- Rat 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4151, {171}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4152, {171}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4153, {171, 172}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4155, {171, 172}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4156, {172, 173}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4157, {172}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4158,
			{172, 173, 174},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4159,
			{172, 173, 174},
			{10, 10, 10},
			300
		)

		-- Rabbit 1 golden hare 518 mad rabbit 519 giant hare 520
		MobSpawnHandlerNpc.handleSpawn(npc, 201, {518}, {9}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 202, {518, 519}, {8, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 203, {518, 519, 520}, {8, 6, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 204, {518, 519, 520}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 205, {518, 519, 520}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 206, {518, 519, 520}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 207, {518, 519}, {11, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			208,
			{518, 519, 520},
			{8, 5, 3},
			360,
			0,
			23,
			29,
			39
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 208, {521}, {16}, 60, 0, 0, 29, 22) -- rabbit_sentry

		-- Rabbit 2 golden rabbit 57 mad hare 524 giant rabbit 525
		MobSpawnHandlerNpc.handleSpawn(npc, 3201, {599}, {9}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3202, {599, 524}, {8, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3203, {599, 524, 525}, {8, 6, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3204, {599, 524, 525}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3205, {599, 524, 525}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3206, {599, 524, 525}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 3207, {599, 524}, {11, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3208,
			{599, 524, 525},
			{8, 5, 3},
			360,
			0,
			23,
			29,
			39
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3208, {526}, {16}, 60, 0, 0, 29, 22) -- rabbit_guardian

		-- Rabbit 3 hop 529 thump 530 fluff 531
		MobSpawnHandlerNpc.handleSpawn(npc, 4201, {529}, {9}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4202, {529, 530}, {8, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4203, {529, 530, 531}, {8, 6, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4204, {529, 530, 531}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4205, {529, 530, 531}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4206, {529, 530, 531}, {10, 7, 4}, 360)
		MobSpawnHandlerNpc.handleSpawn(npc, 4207, {529, 530}, {11, 6}, 360)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4208,
			{529, 530, 531},
			{8, 5, 3},
			360,
			0,
			23,
			29,
			39
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4208, {532}, {16}, 60, 0, 0, 29, 22) -- rabbit_defender

		-- Monkey 1
		MobSpawnHandlerNpc.handleSpawn(npc, 160, {5}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 161, {5, 12}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 162, {5, 12}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 163, {5, 12}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 164, {12, 13}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 165, {12, 13}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 166, {12, 13}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 167, {13, 13, 14}, {10, 10, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 168, {14}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 169, {87}, {26}, spawnRates["monkey_sentry"][1])

		-- Monkey 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3160, {326}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3161, {326, 327}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3162, {326, 327}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3163, {326, 327}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3164, {327, 328}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3165, {327, 328}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3166, {327, 328}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3167, {328, 329}, {20, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3168, {329}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3169, {330}, {26}, spawnRates["monkey_sentry"][2])

		-- Monkey 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4160, {333}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4161, {333, 334}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4162, {333, 334}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4163, {333, 334}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4164, {327, 335}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4165, {327, 335}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4166, {327, 335}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4167, {328, 336}, {20, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4168, {336}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4169, {337}, {26}, spawnRates["monkey_sentry"][3])

		-- Ox 1
		MobSpawnHandlerNpc.handleSpawn(npc, 170, {19, 20}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 171, {19, 20}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 172, {20}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 173, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 174, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 175, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 176, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 177, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 178, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 179, {20, 21}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 180, {122}, {20}, spawnRates["ox_sentry"][1])

		-- Ox 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3170, {366, 367}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3171, {366, 367}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3172, {367}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3173, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3174, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3175, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3176, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3177, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3178, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3179, {367, 368}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3180, {369}, {20}, spawnRates["ox_sentry"][2])

		-- Ox 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4170, {372, 373}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4171, {372, 373}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4172, {373}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4173, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4174, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4175, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4176, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4177, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4178, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4179, {373, 374}, {13, 13}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4180, {375}, {20}, spawnRates["ox_sentry"][3])

		-- Pig 1
		MobSpawnHandlerNpc.handleSpawn(npc, 181, {22}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 182, {23, 24}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 183, {123}, {20}, spawnRates["pig_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 184, {22, 23}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 185, {22, 23, 24}, {10, 10, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 186, {24}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 187, {24, 25}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 188, {24}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 189, {23, 24, 25}, {10, 10, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 190, {24}, {30}, 300)

		-- Pig 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3181, {352}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3182, {353, 354}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3183, {356}, {20}, spawnRates["pig_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(npc, 3184, {352, 353}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3185,
			{352, 353, 354},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3186, {354}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3187, {354, 355}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3188, {354}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3189,
			{353, 354, 355},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3190, {354}, {30}, 300)

		-- Pig 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4181, {359}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4182, {360, 361}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4183, {363}, {20}, spawnRates["pig_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4184, {359, 360}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4185,
			{359, 360, 361},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4186, {361}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4187, {361, 362}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4188, {361}, {30}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4189,
			{360, 361, 362},
			{10, 10, 10},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4190, {361}, {30}, 300)

		-- Dog 1
		MobSpawnHandlerNpc.handleSpawn(npc, 191, {26, 27}, {15, 15}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 192, {26, 27, 28}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 193, {26, 27, 28}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 194, {26, 27, 28}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 195, {26, 27, 28}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 196, {145}, {20}, spawnRates["dog_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 197, {27, 28, 29}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 198, {27, 28, 29}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 199, {27, 28, 29}, {10, 10, 10}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 200, {27, 28, 29}, {10, 10, 10}, 90)

		-- Dog 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3191, {402, 403}, {15, 15}, 90)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3192,
			{402, 403, 404},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3193,
			{402, 403, 404},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3194,
			{402, 403, 404},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3195,
			{402, 403, 404},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3196, {406}, {20}, spawnRates["dog_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3197,
			{403, 404, 405},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3198,
			{403, 404, 405},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3199,
			{403, 404, 405},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3200,
			{403, 404, 405},
			{10, 10, 10},
			90
		)

		-- Dog 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4191, {409, 410}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4192,
			{409, 410, 411},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4193,
			{409, 410, 411},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4194,
			{409, 410, 411},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4195,
			{409, 410, 411},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4196, {413}, {35}, spawnRates["dog_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4197,
			{410, 411, 412},
			{10, 10, 10},
			90
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4198, {411, 412}, {15, 15}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 4199, {411, 412}, {15, 15}, 90)
		MobSpawnHandlerNpc.handleSpawn(npc, 4200, {412}, {15}, 95)
		MobSpawnHandlerNpc.handleSpawn(npc, 4200, {411}, {15}, 80)

		-- Rooster 1
		MobSpawnHandlerNpc.handleSpawn(npc, 210, {30, 31, 33}, {10, 10, 10}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 211, {30}, {30}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 212, {31, 32, 33}, {10, 10, 10}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 213, {31, 32, 33}, {10, 10, 10}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 214, {30}, {50}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 215, {31, 32, 33}, {10, 10, 10}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 216, {30, 31, 33}, {10, 10, 10}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 217, {446}, {20}, spawnRates["rooster_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 218, {31, 32, 33}, {10, 10, 10}, 120)

		-- Rooster 2
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3210,
			{449, 450, 451},
			{10, 10, 10},
			120
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3211, {449}, {30}, 120)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3212,
			{450, 451, 452},
			{10, 10, 10},
			120
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3213,
			{450, 451, 452},
			{10, 10, 10},
			120
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3214, {449}, {50}, 120)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3215,
			{450, 451, 452},
			{10, 10, 10},
			120
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3216,
			{449, 450, 451},
			{15, 15, 15},
			120
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3217, {453}, {20}, spawnRates["rooster_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3218,
			{450, 451, 452},
			{10, 10, 10},
			120
		)

		-- Rooster 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4210, {456, 457}, {17, 17}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4210, {459}, {5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4211, {456}, {30}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4212, {457, 458}, {17, 17}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4212, {459}, {5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4213, {457, 458}, {17, 17}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4213, {459}, {5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4214, {456}, {50}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4215, {457, 456}, {20, 20}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4215, {459}, {5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4216, {456, 457}, {16, 16}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4216, {459}, {5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4217, {460}, {20}, spawnRates["rooster_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4218, {457, 458}, {16, 16}, 120)
		MobSpawnHandlerNpc.handleSpawn(npc, 4218, {459}, {5}, 300)

		-- Snake 1
		MobSpawnHandlerNpc.handleSpawn(npc, 231, {34, 35}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 232, {35, 36, 37}, {10, 10, 10}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 233, {35, 36}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 234, {35, 36, 37}, {10, 10, 10}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 235, {164}, {20}, spawnRates["snake_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 236, {35, 36}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 237, {35, 36, 37}, {10, 10, 10}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 238, {35, 37}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 239, {35, 36}, {15, 15}, 115)

		-- Snake 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3231, {432, 433}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3232,
			{433, 434, 435},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3233, {433, 434}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3234,
			{433, 434, 435},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3235, {436}, {20}, spawnRates["snake_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(npc, 3236, {433, 434}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			3237,
			{433, 434, 435},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 3238, {433, 434}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 3239, {433, 434}, {15, 15}, 115)

		-- Snake 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4231, {439, 440}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4232,
			{440, 441, 442},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4233, {440, 441}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4234,
			{440, 441, 442},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4235, {443}, {20}, spawnRates["snake_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4236, {440, 441}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			4237,
			{440, 441, 442},
			{10, 10, 10},
			115
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 4238, {440, 441}, {15, 15}, 115)
		MobSpawnHandlerNpc.handleSpawn(npc, 4239, {440, 441}, {15, 15}, 115)

		-- Horse 1
		MobSpawnHandlerNpc.handleSpawn(npc, 240, {38, 39, 809}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 241, {38, 809}, {20, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 242, {39, 40, 809}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 243, {39, 40}, {15, 15}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 244, {138, 41}, {20, 40}, spawnRates["horse_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 245, {39, 809}, {20, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 246, {38}, {20}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 247, {39, 40, 808}, {20, 20, 20}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 248, {808, 40, 39}, {12, 12, 15}, 210)

		-- Horse 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3240, {378, 380, 811}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3241, {378, 810}, {15, 15}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3242, {380, 378, 811}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3243, {380, 381, 811}, {15, 15, 5}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3244, {382, 379}, {20, 40}, spawnRates["horse_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(npc, 3245, {380, 811}, {20, 7}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3246, {378}, {20}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3247, {380, 381, 810, 811}, {13, 13, 13, 8}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3248, {381, 810, 380}, {12, 12, 15}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 3248, {811}, {3}, 300)

		-- Horse 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4240, {385, 386, 813}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4241, {385, 813}, {15, 15}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4242, {386, 385, 813}, {10, 10, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4243, {386, 387}, {15, 15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4244, {388, 389}, {20, 40}, spawnRates["horse_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4245, {386, 813}, {20, 10}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4246, {385}, {20}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4247, {386, 387, 812, 813}, {13, 13, 13, 8}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4248, {812, 387, 386}, {12, 12, 15}, 210)
		MobSpawnHandlerNpc.handleSpawn(npc, 4248, {813}, {3}, 300)

		-- Dragon 1
		MobSpawnHandlerNpc.handleSpawn(npc, 250, {45}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 251, {44}, {18}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 252, {44, 45}, {7, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 253, {45}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 254, {45}, {25}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 255, {161}, {20}, spawnRates["dragon_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 256, {44, 45}, {8, 16}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 257, {43}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 258, {45}, {25}, 300)

		-- Dragon 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3250, {418, 419}, {8, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3251, {417, 418}, {9, 9}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3252, {417, 418}, {7, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3253, {418, 419}, {8, 7}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3254, {418}, {25}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3255, {420}, {25}, spawnRates["dragon_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(npc, 3256, {418, 419}, {15, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3257, {416, 417}, {8, 7}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 3258, {418}, {25}, 300)

		-- Dragon 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4250, {424, 425}, {8, 8}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4251, {423, 424}, {9, 9}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4252, {424}, {15}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4253, {424, 425}, {8, 7}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4254, {424}, {25}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4255, {426}, {20}, spawnRates["dragon_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4256, {424, 425}, {15, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4257, {423, 424}, {8, 7}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 4258, {424}, {25}, 300)

		-- Sheep 1
		MobSpawnHandlerNpc.handleSpawn(npc, 470, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 471, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 472, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 473, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 474, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 475, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 476, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 477, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 478, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 479, {106}, {20}, spawnRates["sheep_sentry"][1])
		MobSpawnHandlerNpc.handleSpawn(npc, 480, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 481, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 482, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 483, {46, 47}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 484, {46, 47}, {8, 8}, 100)

		-- Sheep 2
		MobSpawnHandlerNpc.handleSpawn(npc, 3470, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3471, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3472, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3473, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3474, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3475, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3476, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3477, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3478, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3479, {394}, {20}, spawnRates["sheep_sentry"][2])
		MobSpawnHandlerNpc.handleSpawn(npc, 3480, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3481, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3482, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3483, {392, 393}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 3484, {392, 393}, {8, 8}, 100)

		-- Sheep 3
		MobSpawnHandlerNpc.handleSpawn(npc, 4470, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4471, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4472, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4473, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4474, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4475, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4476, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4477, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4478, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4479, {399}, {20}, spawnRates["sheep_sentry"][3])
		MobSpawnHandlerNpc.handleSpawn(npc, 4480, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4481, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4482, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4483, {397, 398}, {8, 8}, 100)
		MobSpawnHandlerNpc.handleSpawn(npc, 4484, {397, 398}, {8, 8}, 100)

		-- VALE --
		-- Buya Valley
		MobSpawnHandlerNpc.handleSpawn(npc, 1001, {1}, {13}, 300)

		-- Vale area: rabbit 1 doe 4 horse 8 wolf 9 rat 10 fox 70 sheep 71 snake 72  bear 511 tiger 512 lobster 513 boa 514
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1005,
			{4, 8, 9, 70, 72, 514},
			{12, 10, 6, 4, 10, 8},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1005,
			{1, 71},
			{76, 36},
			300,
			162,
			122,
			221,
			150
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1005,
			{512},
			{12},
			300,
			48,
			135,
			117,
			170
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 1005, {511}, {6}, 300, 222, 5, 247, 38)
		MobSpawnHandlerNpc.handleSpawn(npc, 1005, {513}, {4}, 300, 187, 5, 220, 23)

		-- Black Skeletons 479 je 480 ja 481 ji 482 sa 483
		MobSpawnHandlerNpc.handleSpawn(npc, 501, {479}, {15}, 300) -- dirge
		MobSpawnHandlerNpc.handleSpawn(npc, 502, {479}, {15}, 300) -- bone feet
		MobSpawnHandlerNpc.handleSpawn(npc, 503, {479}, {15}, 300) -- lost pen
		MobSpawnHandlerNpc.handleSpawn(npc, 504, {479}, {15}, 300) -- bone finger
		MobSpawnHandlerNpc.handleSpawn(npc, 505, {480, 481}, {8, 7}, 300) -- muffled drum
		MobSpawnHandlerNpc.handleSpawn(npc, 506, {480, 481}, {7, 8}, 300) -- torn shroud
		MobSpawnHandlerNpc.handleSpawn(npc, 507, {481, 482}, {8, 7}, 300) -- vile pit
		MobSpawnHandlerNpc.handleSpawn(npc, 508, {482}, {15}, 300) -- death march
		MobSpawnHandlerNpc.handleSpawn(npc, 508, {483}, {1}, 1800) -- death march - skeleton sa

		-- Polar Bears 487 satan's little helper 488 snow beast 489 deathwish 490
		MobSpawnHandlerNpc.handleSpawn(npc, 1271, {487, 489}, {14, 1}, 300) -- white pine valley
		MobSpawnHandlerNpc.handleSpawn(npc, 1272, {487, 489}, {16, 1}, 300) -- pyramid mountain
		MobSpawnHandlerNpc.handleSpawn(npc, 1273, {487, 489}, {18, 1}, 300) -- frost valley
		MobSpawnHandlerNpc.handleSpawn(npc, 1274, {488, 489}, {20, 2}, 300) -- twin passes
		MobSpawnHandlerNpc.handleSpawn(npc, 1275, {488, 489}, {20, 2}, 300) -- lake placid
		MobSpawnHandlerNpc.handleSpawn(npc, 1276, {488, 489}, {20, 3}, 300) -- frozen plateau
		MobSpawnHandlerNpc.handleSpawn(npc, 1277, {488}, {24}, 300) -- secret snow
		MobSpawnHandlerNpc.handleSpawn(npc, 1277, {490}, {1}, 900) -- secret snow - deathwish

		-- Buya Fox
		MobSpawnHandlerNpc.handleSpawn(npc, 390, {75}, {20}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 391, {75}, {20}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 392, {75, 80}, {15, 10}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			393,
			{75, 76, 77, 78},
			{10, 10, 6, 3},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 394, {75, 78, 79}, {15, 5, 5}, 300)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			395,
			{80, 76, 78, 79},
			{10, 15, 5, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			396,
			{75, 76, 79, 78},
			{15, 15, 5, 5},
			300
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			397,
			{75, 76, 79, 78, 165},
			{15, 15, 5, 5, 5},
			300
		)

		-- added white wolf
		MobSpawnHandlerNpc.handleSpawn(npc, 398, {76, 79}, {20, 5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 399, {76, 79}, {20, 5}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 399, {76, 79}, {20, 5}, 300)

		--- ISLETS ---
		-- Islets Area: rabbit 1 squirrel 2 deer 3 doe 4 horse 8 wolf 9 rat 10 snake 72 tiger 512 boa 514
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1008,
			{2, 3, 4, 8, 9},
			{24, 10, 10, 2, 5},
			300,
			0,
			44,
			54,
			62
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1008,
			{1, 512},
			{18, 4},
			300,
			70,
			23,
			79,
			67
		)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1008,
			{10, 72},
			{12, 6},
			300,
			8,
			78,
			79,
			102
		)
		MobSpawnHandlerNpc.handleSpawn(npc, 1008, {514}, {6}, 300, 8, 78, 79, 126)
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			1008,
			{464, 465},
			{72, 24},
			300,
			0,
			160,
			79,
			199
		)

		--Deep Woods Mantis
		----[ deep woods mantis 466,  dirt mantis 467, shadow mantis 468, dark mantis 469, sting 472 ]----
		MobSpawnHandlerNpc.handleSpawn(npc, 532, {466}, {14}, 300) -- spirit grove
		MobSpawnHandlerNpc.handleSpawn(npc, 533, {466}, {16}, 300) -- lilac walk
		MobSpawnHandlerNpc.handleSpawn(npc, 534, {466}, {18}, 300) -- crumbling steps
		MobSpawnHandlerNpc.handleSpawn(npc, 535, {466, 469}, {18, 2}, 300) -- infested granary
		MobSpawnHandlerNpc.handleSpawn(npc, 535, {467}, {1}, 420) -- ++ dirt mantis ++
		MobSpawnHandlerNpc.handleSpawn(npc, 536, {466, 469}, {18, 2}, 300) -- oak pathway
		MobSpawnHandlerNpc.handleSpawn(npc, 536, {467}, {1}, 420) -- ++ dirt mantis ++
		MobSpawnHandlerNpc.handleSpawn(npc, 537, {466, 469}, {18, 2}, 300) -- meeting field
		MobSpawnHandlerNpc.handleSpawn(npc, 537, {467}, {1}, 420) -- ++ dirt mantis ++
		MobSpawnHandlerNpc.handleSpawn(npc, 538, {466, 469}, {18, 2}, 300) -- pine grove
		MobSpawnHandlerNpc.handleSpawn(npc, 538, {472}, {1}, 1500) -- ++ sting ++
		MobSpawnHandlerNpc.handleSpawn(npc, 539, {466, 469}, {18, 2}, 300) -- open pasture
		MobSpawnHandlerNpc.handleSpawn(npc, 539, {468}, {1}, 420) -- ++ shadow mantis ++
		MobSpawnHandlerNpc.handleSpawn(npc, 540, {466, 469}, {18, 2}, 300) -- tangled thicket
		MobSpawnHandlerNpc.handleSpawn(npc, 540, {468}, {1}, 420) -- ++ shadow mantis ++
		MobSpawnHandlerNpc.handleSpawn(npc, 541, {466, 469}, {18, 2}, 300) -- stone bridge
		MobSpawnHandlerNpc.handleSpawn(npc, 541, {468}, {1}, 420) -- ++ shadow mantis ++
		
		--Dark Mantis
		----[ forest mantis 470, dark mantis 469, ch'tan 473 ]----
		MobSpawnHandlerNpc.handleSpawn(npc, 528, {470, 469}, {12, 2}, 300) -- stone sentinels
		MobSpawnHandlerNpc.handleSpawn(npc, 529, {470, 469}, {14, 2}, 300) -- shrubbery
		MobSpawnHandlerNpc.handleSpawn(npc, 530, {470, 469}, {16, 2}, 300) -- apple orcard
		MobSpawnHandlerNpc.handleSpawn(npc, 531, {470, 469}, {18, 3}, 300) -- mantis meadow
		MobSpawnHandlerNpc.handleSpawn(npc, 531, {473}, {1}, spawnRates["zangze_zinte_chtan_sintu"]) -- ++ ch'tan ++
		
		--Ghost Mantis
		----[ forest mantis 470, ghost mantis 471, sin-tu 474 ]----
		MobSpawnHandlerNpc.handleSpawn(npc, 523, {470, 471}, {12, 2}, 300) -- flowery dell
		MobSpawnHandlerNpc.handleSpawn(npc, 524, {470, 471}, {14, 2}, 300) -- poplar forest
		MobSpawnHandlerNpc.handleSpawn(npc, 525, {470, 471}, {16, 2}, 300) -- silent watchers
		MobSpawnHandlerNpc.handleSpawn(npc, 526, {470, 471}, {18, 3}, 300) -- field of flags
		MobSpawnHandlerNpc.handleSpawn(npc, 527, {470, 471}, {20, 3}, 300) -- golden boughs
		MobSpawnHandlerNpc.handleSpawn(npc, 527, {474}, {1}, spawnRates["zangze_zinte_chtan_sintu"]) -- ++ sin-tu ++

		--- GRIM OGRES---
		-- grim ogre 155, southern ogre 156, muck ogre 157, slime ogre 158, log 159, hill 160
		MobSpawnHandlerNpc.handleSpawn(npc, 141, {155}, {20}, 300) -- the flats
		MobSpawnHandlerNpc.handleSpawn(npc, 142, {155}, {20}, 300) -- amber ponds
		MobSpawnHandlerNpc.handleSpawn(npc, 143, {155}, {20}, 300) -- lime canals
		MobSpawnHandlerNpc.handleSpawn(npc, 147, {155, 156, 158}, {20, 3, 1}, 300) -- southern reaches
		MobSpawnHandlerNpc.handleSpawn(npc, 148, {155, 156, 158}, {20, 3, 1}, 300) -- southern mines
		MobSpawnHandlerNpc.handleSpawn(npc, 149, {155, 156, 158}, {20, 3, 1}, 300) -- southern hordes
		MobSpawnHandlerNpc.handleSpawn(npc, 150, {155, 156, 159, 160}, {20, 3, 1, 1}, 300) -- petrified
		MobSpawnHandlerNpc.handleSpawn(npc, 144, {155, 156, 157}, {20, 3, 1}, 300) -- northern reaches
		MobSpawnHandlerNpc.handleSpawn(npc, 145, {155, 156, 157}, {20, 3, 1}, 300) -- northern mines
		MobSpawnHandlerNpc.handleSpawn(npc, 146, {155, 156, 157}, {20, 3, 1}, 300) -- northern hordes

		--- MARSH OGRES ---
		MobSpawnHandlerNpc.handleSpawn(npc, 115, {156, 484}, {32, 6}, 300) -- five rings
		MobSpawnHandlerNpc.handleSpawn(npc, 116, {156, 484}, {32, 6}, 300) -- decayed forest
		MobSpawnHandlerNpc.handleSpawn(npc, 118, {156, 484}, {32, 6}, 300) -- twilight wall
		MobSpawnHandlerNpc.handleSpawn(npc, 119, {156, 484}, {32, 6}, 300) -- zangze's parlor
		MobSpawnHandlerNpc.handleSpawn(npc, 120, {156, 484}, {32, 6}, 300) -- zangze
		MobSpawnHandlerNpc.handleSpawn(npc, 120, {485}, {1}, spawnRates["zangze_zinte_chtan_sintu"]) -- zangze_ogre

		--- HILL OGRES ---
		MobSpawnHandlerNpc.handleSpawn(npc, 117, {156, 160}, {32, 6}, 300) -- harsh echo
		MobSpawnHandlerNpc.handleSpawn(npc, 113, {156, 160}, {32, 6}, 300) -- marsh divide
		MobSpawnHandlerNpc.handleSpawn(npc, 112, {156, 160}, {32, 6}, 300) -- dim
		MobSpawnHandlerNpc.handleSpawn(npc, 111, {156, 160}, {32, 6}, 300) -- zin-te
		MobSpawnHandlerNpc.handleSpawn(npc, 111, {486}, {1}, spawnRates["zangze_zinte_chtan_sintu"]) -- zinte_ogre

		--- WILDERNESS ---
		-- Rats     (fierce mouse 52, bat 53, big rat 55)
		MobSpawnHandlerNpc.handleSpawn(npc, 1351, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1352, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1353, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1354, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1355, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1356, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1357, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1358, {52, 53, 55}, {18, 8, 4}, 300)
		MobSpawnHandlerNpc.handleSpawn(npc, 1359, {52, 53, 55}, {18, 8, 4}, 300)

		-- .....Iron Labrynth..... (iron panda 475 iron tiger 476 giant iron tiger 477)
		MobSpawnHandlerNpc.handleSpawn(npc, 1301, {475}, {48}, 300) -- level 1
		MobSpawnHandlerNpc.handleSpawn(npc, 1303, {475, 476}, {36, 12}, 300) -- level 2
		MobSpawnHandlerNpc.handleSpawn(npc, 1305, {475, 476}, {24, 24}, 300) -- level 3
		MobSpawnHandlerNpc.handleSpawn(npc, 1302, {475, 476}, {24, 24}, 300) -- level 4
		MobSpawnHandlerNpc.handleSpawn(npc, 1304, {475, 476}, {12, 36}, 300) -- level 5
		MobSpawnHandlerNpc.handleSpawn(npc, 1306, {476}, {48}, 300) -- level 6
		MobSpawnHandlerNpc.handleSpawn(npc, 1308, {477}, {36}, 240) -- gim yi den
		MobSpawnHandlerNpc.handleSpawn(npc, 1308, {478}, {1}, 300) -- gimyi

		-- Wilderness Lobsters (sand 515 rock 516 golden 517)
		MobSpawnHandlerNpc.handleSpawn(npc, 1311, {515}, {16}, 120) -- washed shores
		MobSpawnHandlerNpc.handleSpawn(npc, 1312, {515}, {20}, 120) -- lobster maze
		MobSpawnHandlerNpc.handleSpawn(npc, 1313, {515}, {20}, 120) -- sandy burrow
		MobSpawnHandlerNpc.handleSpawn(npc, 1314, {515, 516}, {15, 15}, 120) -- lobster claw
		MobSpawnHandlerNpc.handleSpawn(npc, 1315, {515, 516}, {10, 10}, 120) -- sandy niche
		MobSpawnHandlerNpc.handleSpawn(npc, 1316, {516}, {30}, 120) -- sandy mounds
		MobSpawnHandlerNpc.handleSpawn(npc, 1316, {517}, {1}, spawnRates["golden_lobster"]) -- + golden lobster
		MobSpawnHandlerNpc.handleSpawn(npc, 1317, {516}, {30}, 120) -- sand trap
		MobSpawnHandlerNpc.handleSpawn(npc, 1317, {517}, {1}, spawnRates["golden_lobster"]) -- + golden lobster

		-- LEVIATHAN QUEST
		-- leviathan 182, green squirrel 185
		MobSpawnHandlerNpc.handleSpawn(npc, 2535, {185}, {20}, spawnRates["green_squirrel"][1]) -- southern path
		MobSpawnHandlerNpc.handleSpawn(npc, 2536, {185}, {20}, spawnRates["green_squirrel"][1]) -- southern fork
		MobSpawnHandlerNpc.handleSpawn(npc, 2538, {182}, {5}, 240) -- Lev fields
		MobSpawnHandlerNpc.handleSpawn(npc, 2538, {185}, {20}, spawnRates["green_squirrel"][1]) -- Lev fields
		MobSpawnHandlerNpc.handleSpawn(npc, 2539, {185, 182}, {22, 5}, spawnRates["green_squirrel"][2]) -- Lev hermit
		MobSpawnHandlerNpc.handleSpawn(npc, 2537, {185, 182}, {22, 5}, spawnRates["green_squirrel"][3]) -- Lev mound
		MobSpawnHandlerNpc.handleSpawn(npc, 2544, {183}, {6}, 240) -- blight pen
		MobSpawnHandlerNpc.handleSpawn(npc, 2542, {185, 1}, {3, 3}, 330) -- worn path
		MobSpawnHandlerNpc.handleSpawn(npc, 2543, {185, 1}, {5, 5}, 330) -- worn path

		-- Gauntlet Mob spawns
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2546,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Fields
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2547,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Havok
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2548,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Malestrom
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2575,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Formations
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2576,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Jeweled Rows
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2577,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Path

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2551,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Fields
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2552,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Havok
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2553,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Malestrom
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2578,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Formations
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2579,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Jeweled Rows
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2580,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Path

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2556,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Fields
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2557,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Havok
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2558,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Malestrom
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2581,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Formations
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2582,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Jeweled Rows
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2583,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Path

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2561,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Fields
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2562,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Havok
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2563,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Malestrom
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2584,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Formations
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2585,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Jeweled Rows
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2586,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Path

		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2566,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Fields
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2567,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Havok
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2568,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Malestrom
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2587,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Formations
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2588,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Jeweled Rows
		MobSpawnHandlerNpc.handleSpawn(
			npc,
			2589,
			{186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			240
		)

		-- Crystal Path

		broadcast(4, "Mob Spawn: " .. (os.time() * 1000 + timeMS()) - start)
	end,

	spawnMob = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
		local minX = 0
		local maxX = getMapXMax(map)
		local minY = 0
		local maxY = getMapYMax(map)

		if (spawnMinX ~= nil and spawnMaxX ~= nil and spawnMinY ~= nil and spawnMaxY ~= nil) then
			minX = spawnMinX
			maxX = spawnMaxX
			minY = spawnMinY
			maxY = spawnMaxY

			if maxX > getMapXMax(map) then
				maxX = getMapXMax(map)
			end
			if maxY > getMapYMax(map) then
				maxY = getMapYMax(map)
			end
		end

		local pc = npc:getObjectsInMap(map, BL_PC)

		--local pc = getMapUsers(map)
		local mobBlocks = npc:getObjectsInMap(map, BL_MOB)

		if (spawnTable[map][mobs[1]] == nil) then
			spawnTable[map][mobs[1]] = 0
		end

		if (os.time() > (spawnTable[map][mobs[1]] + timer) and #pc > 0) then
			--if(os.time() > (getMapRegistry(map,"lastSpawn"..mobs[1]) + timer) and #pc > 0) then
			for z = 1, #mobs do
				local fail = 0
				local mobCount = 0
				if (#mobBlocks > 0) then
					for i = 1, #mobBlocks do
						if (mobBlocks[i].mobID == mobs[z]) then
							mobCount = mobCount + 1
						end
					end
				end

				if (mobCount < maxMobs[z]) then
					repeat
						local spawnX = math.random(minX, maxX)
						local spawnY = math.random(minY, maxY)

						local passCheck = getPass(map, spawnX, spawnY)
						local objCheck = getObject(map, spawnX, spawnY)
						local pcCheck = npc:getObjectsInCell(
							map,
							spawnX,
							spawnY,
							BL_PC
						)
						local mobCheck = npc:getObjectsInCell(
							map,
							spawnX,
							spawnY,
							BL_MOB
						)
						if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and not getWarp(
							map,
							spawnX,
							spawnY
						)) then
							npc:spawn(mobs[z], spawnX, spawnY, 1, map)
							mobCount = mobCount + 1
						else
							fail = fail + 1
							if (fail >= maxMobs[z] * 4) then
								mobCount = maxMobs[z]
							end
						end
					until mobCount >= maxMobs[z]
				end
			end

			--setMapRegistry(map,"lastSpawn"..mobs[1],os.time())
			spawnTable[map][mobs[1]] = os.time()
		else
			if (#mobBlocks == 0) then
				if (os.time() % 10 == 0) then
					local spawnTimer = spawnTable[map][mobs[1]] - 10
					if (spawnTimer > 0) then
						spawnTable[map][mobs[1]] = spawnTimer
					end
				end
			end
		end
	end,

	deleteMob = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
		local minX = 0
		local maxX = getMapXMax(map)
		local minY = 0
		local maxY = getMapYMax(map)

		if (spawnMinX ~= nil and spawnMaxX ~= nil and spawnMinY ~= nil and spawnMaxY ~= nil) then
			minX = spawnMinX
			maxX = spawnMaxX
			minY = spawnMinY
			maxY = spawnMaxY

			if maxX > getMapXMax(map) then
				maxX = getMapXMax(map)
			end
			if maxY > getMapYMax(map) then
				maxY = getMapYMax(map)
			end
		end

		if (spawnTable[map][mobs[1]] == nil) then
			spawnTable[map][mobs[1]] = 0
		end

		--local pc = getMapUsers(map)
		local pc = npc:getObjectsInMap(map, BL_PC)
		local mobBlocks = {}

		--if(pc == 0 and (os.time() > (getMapRegistry(map,"lastSpawn"..mobs[1]) + timer))) then
		if (#pc == 0 and (os.time() > (spawnTable[map][mobs[1]] + timer))) then
			mobBlocks = npc:getObjectsInMap(map, BL_MOB)

			if (#mobBlocks > 0) then
				for i = 1, #mobBlocks do
					for z = 1, #mobs do
						if (mobBlocks[i] ~= nil) then
							if (mobBlocks[i].mobID == mobs[z] and mobBlocks[i].x >= minX and mobBlocks[i].x <= maxX and mobBlocks[
								i
							].y >= minY and mobBlocks[i].y <= maxY) then
								--mobBlocks[i].attacker = 0
								--mobBlocks[i]:removeHealth(4000000000)
								mobBlocks[i]:delete()
								mobBlocks[i] = nil

								--table.remove(mobBlocks,mobBlocks[i])
								--i=i-1
							end
						end
					end
				end
			end
		end
	end,

	handleSpawn = function(npc, map, mobs, maxMobs, timer, spawnMinX, spawnMinY, spawnMaxX, spawnMaxY)
		MobSpawnHandlerNpc.deleteMob(
			npc,
			map,
			mobs,
			maxMobs,
			timer,
			spawnMinX,
			spawnMinY,
			spawnMaxX,
			spawnMaxY
		)
		MobSpawnHandlerNpc.spawnMob(
			npc,
			map,
			mobs,
			maxMobs,
			timer,
			spawnMinX,
			spawnMinY,
			spawnMaxX,
			spawnMaxY
		)
	end
}
