Player.mythicCaveReqCheck = function(player, mobName)
	mobName = mobName:lower()

	local requirements = {}

	requirements["rabbit"] = {
		{level = 25, health = 0, magic = 0},
		{level = 70, health = 0, magic = 0},
		{level = 99, health = 20000, magic = 10000}
	}

	requirements["monkey"] = {
		{level = 32, health = 0, magic = 0},
		{level = 77, health = 0, magic = 0},
		{level = 99, health = 40000, magic = 20000}
	}

	requirements["dog"] = {
		{level = 39, health = 0, magic = 0},
		{level = 84, health = 0, magic = 0},
		{level = 99, health = 60000, magic = 30000}
	}

	requirements["rooster"] = {
		{level = 46, health = 0, magic = 0},
		{level = 91, health = 0, magic = 0},
		{level = 99, health = 100000, magic = 50000}
	}

	requirements["rat"] = {
		{level = 53, health = 0, magic = 0},
		{level = 98, health = 0, magic = 0},
		{level = 99, health = 140000, magic = 70000}
	}

	requirements["horse"] = {
		{level = 60, health = 0, magic = 0},
		{level = 99, health = 30000, magic = 15000},
		{level = 99, health = 180000, magic = 90000}
	}

	requirements["ox"] = {
		{level = 67, health = 0, magic = 0},
		{level = 99, health = 50000, magic = 25000},
		{level = 99, health = 220000, magic = 110000}
	}

	requirements["pig"] = {
		{level = 74, health = 0, magic = 0},
		{level = 99, health = 80000, magic = 40000},
		{level = 99, health = 260000, magic = 130000}
	}

	requirements["snake"] = {
		{level = 81, health = 0, magic = 0},
		{level = 99, health = 110000, magic = 55000},
		{level = 99, health = 300000, magic = 150000}
	}

	requirements["sheep"] = {
		{level = 88, health = 0, magic = 0},
		{level = 99, health = 140000, magic = 70000},
		{level = 99, health = 340000, magic = 170000}
	}

	requirements["tiger"] = {
		{level = 95, health = 0, magic = 0},
		{level = 99, health = 170000, magic = 85000},
		{level = 99, health = 380000, magic = 190000}
	}

	requirements["dragon"] = {
		{level = 99, health = 0, magic = 0},
		{level = 99, health = 200000, magic = 100000},
		{level = 99, health = 420000, magic = 210000}
	}

	for i = 3, 1, -1 do
		local reqs = requirements[mobName][i]
		if (player.level >= reqs.level and (player.baseHealth >= reqs.health or player.baseMagic >= reqs.magic)) then
			return i
		end
	end

	local minimumLevel = requirements[mobName][1].level
	local levelsUntilEntry = minimumLevel - player.level

	if (levelsUntilEntry >= 8) then
		return -2
	elseif (levelsUntilEntry >= 4) then
		return -1
	end

	return 0
end
