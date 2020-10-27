function roundToSecondDecimal(t)
	return math.round(t * 100) * 0.1
end

function mithia_lore_time()
	--exactly 52 weeks a year
	--12 months a year, 30,30,31,30,30,31,30,30,31,30,30,31
	--4 seasons
	-- every season starts on Lunae,

	local days = {
		"Lunae",
		"Martis",
		"Mercurii",
		"Jovis",
		"Veneris",
		"Saturni",
		"Solis"
	}
	local months = {
		"Ianuarius",
		"Februarius",
		"Martius",
		"Aprilis",
		"Maius",
		"Iunus",
		"Quintilis",
		"Augustus",
		"September",
		"October",
		"November",
		"December"
	}
	local seasons = {"Winter", "Spring", "Summer", "Autumn"}
	local year = curYear()

	--gets current year
	local date = curDay()

	--gets current day
	local day = days[(date % 7) + 1]
	local time = curTime()

	--gets current time
	local season = seasons[curSeason()]

	--gets current Season (string)
	local dayOfMonth = date

	local mdate = date
	if (mdate >= 91) then
		mdate = 90
	end

	if (dayOfMonth == 91) then
		dayOfMonth = 31
	else
		while (dayOfMonth > 30) do
			dayOfMonth = dayOfMonth - 30
		end
	end

	if (dayOfMonth > 30) then
		dayOfMonth = dayOfMonth - 30
	end

	if (dayOfMonth > 30) then
		dayOfMonth = dayOfMonth - 30
	end

	local month = months[
		(curSeason() - 1) * 3 + math.floor((mdate - 1) / 30) + 1
	]

	return {
		Year = year,
		SeasonOfYear = season,
		DayOfSeason = date,
		DayOfWeek = day,
		MonthOfYear = month,
		DayOfMonth = dayOfMonth,
		Time = time
	}
end

checktile = function(tipo, dist)
	--type, distance, Returns TRUE for empty, FALSE for taken.

	local d = {}

	-- Facing North
	if (tipo.side == 0) then
		d = tipo:getObjectsInCell(tipo.m, tipo.x, tipo.y - dist, BL_ALL)

		if (#d == 0 and tipo:objectCanMove(tipo.x, tipo.y - dist, tipo.side) == true and getPass(
			tipo.m,
			tipo.x,
			tipo.y - dist
		) == 0) then
			--				tipo:sendMinitext("Empty.")
			return true
		else
			--tipo:sendMinitext("There is nowhere for you to land!")
			return false
		end

		--Facing East
	elseif (tipo.side == 1) then
		d = tipo:getObjectsInCell(tipo.m, tipo.x + dist, tipo.y, BL_ALL)

		if (#d == 0 and tipo:objectCanMove(tipo.x + dist, tipo.y, tipo.side) == true and getPass(
			tipo.m,
			tipo.x + dist,
			tipo.y
		) == 0) then
			--			tipo:sendMinitext("Empty.")
			return true
		else
			--tipo:sendMinitext("There is nowhere for you to land!")
			return false
		end

		--Facing South
	elseif (tipo.side == 2) then
		d = tipo:getObjectsInCell(tipo.m, tipo.x, tipo.y + dist, BL_ALL)

		if (#d == 0 and tipo:objectCanMove(tipo.x, tipo.y + dist, tipo.side) == true and getPass(
			tipo.m,
			tipo.x,
			tipo.y + dist
		) == 0) then
			--				tipo:sendMinitext("Empty.")
			return true
		else
			--tipo:sendMinitext("There is nowhere for you to land!")
			return false
		end

		--Facing West
	elseif (tipo.side == 3) then
		d = tipo:getObjectsInCell(tipo.m, tipo.x - dist, tipo.y, BL_ALL)

		if (#d == 0 and tipo:objectCanMove(tipo.x - dist, tipo.y, tipo.side) == true and getPass(
			tipo.m,
			tipo.x - dist,
			tipo.y
		) == 0) then
			--			tipo:sendMinitext("Empty.")
			return true
		else
			--tipo:sendMinitext("There is nowhere for you to land!")
			return false
		end
	end
end

checkSpecificTile = function(player, x, y)
	-- Returns TRUE for empty, FALSE for taken.
	if (player:objectCanMove(x, y, player.side) == true and getPass(player.m, x, y) == 0) then
		return true
	else
		return false
	end
end

checktiletype = function(tipo, dist)
	--tar, dist, state) --targettypes: 1 = PC, 2 = MOB, 3 = NPC
	--returns true IF it finds something of that targettype on the distance selected
	local m = tipo.m
	local x = tipo.x
	local y = tipo.y
	local d = {}
	local e = {}
	local f = {}

	if (tipo.side == 0) then
		y = y - dist
	end
	if (tipo.side == 1) then
		x = x + dist
	end
	if (tipo.side == 2) then
		y = y + dist
	end
	if (tipo.side == 3) then
		x = x - dist
	end

	--if (tar == 1) then
	d = tipo:getObjectsInCell(m, x, y, BL_PC)

	--elseif (tar == 2) then
	e = tipo:getObjectsInCell(m, x, y, BL_MOB)

	--elseif (tar == 3) then
	f = tipo:getObjectsInCell(m, x, y, BL_NPC)

	--end
	if (#d + #e + #f == 0) then
		--tipo:sendMinitext("There is no target in front of you.")
		return false
	else
		if (#d ~= 0) then
			return d[1]

			--returning a block allows us to use every aspect of it
		elseif (#e ~= 0) then
			return e[1]
		elseif (#f ~= 0) then
			return f[1]
		end

		--	if (tar == 1) and (d[1].state ~= 1) then
		--		return false
		--	else
		--		return true
		--	end
	end
end

getTileFacing = function(block, side)
	local nside
	if (side ~= nil) then
		nside = side
	else
		nside = block.side
	end
	local x = block.x
	local y = block.y

	if (nside == 0) then
		y = y - 1
	elseif (nside == 1) then
		x = x + 1
	elseif (nside == 2) then
		y = y + 1
	elseif (nside == 3) then
		x = x - 1
	end

	local tile = getTile(block.m, x, y)
	return tile
end

getObjFacing = function(block, side)
	local nside
	if (side ~= nil) then
		nside = side
	else
		nside = block.side
	end
	local x = block.x
	local y = block.y

	if (nside == 0) then
		y = y - 1
	elseif (nside == 1) then
		x = x + 1
	elseif (nside == 2) then
		y = y + 1
	elseif (nside == 3) then
		x = x - 1
	end

	local obj = getObject(block.m, x, y)
	return obj
end

getPassFacing = function(block, side)
	local nside
	if (side ~= nil) then
		nside = side
	else
		nside = block.side
	end
	local x = block.x
	local y = block.y

	if (nside == 0) then
		y = y - 1
	elseif (nside == 1) then
		x = x + 1
	elseif (nside == 2) then
		y = y + 1
	elseif (nside == 3) then
		x = x - 1
	end

	local pass = getPass(block.m, x, y)
	if (pass == 0) then
		pass = true
	else
		pass = false
	end
	return pass
end

checkMove = function(block, m, x, y, side)
	local x1 = x
	local y1 = y
	local x2 = x
	local y2 = y

	if (side == 0) then
		y1 = y - 1
		x1 = x
		y2 = y + 1
		x2 = x
	end

	if (side == 1) then
		x1 = x + 1
		y1 = y
		x2 = x - 1
		y2 = y
	end

	if (side == 2) then
		y1 = y + 1
		x1 = x
		y2 = y - 1
		x2 = x
	end

	if (side == 3) then
		x1 = x - 1
		y1 = y
		x2 = x + 1
		y2 = y
	end

	if (getPass(m, x1, y1) == 0) then
		-- and (block:objectCanMove(x2,y2,side) == true) then-- and (block:objectCanMoveFrom(x1,y1,side)==true) then
		return true
	else
		return false
	end

	--[[if (mob:objectCanMove (x,y,side) == true) then
		mob:talk(0,"cMove True")
		return true
	else
		mob:talk(0,"cMove false?")
		return false
	end
	if (mob:objectCanMove (x,y,side) == true) then
		--mob:talk(0,"MoveFrom True")
		return true
	else
		--mob:talk(0,"MoveFrom false?")
		return false
	end]]
	--
end

distance = function(block, target)
	local dist = 0

	if (target == nil) then
		target = block
	end

	dist = dist + math.abs(block.x - target.x)
	dist = dist + math.abs(block.y - target.y)

	return dist
end

distanceXY = function(block, x, y)
	local dist = 0

	dist = dist + math.abs(block.x - x)
	dist = dist + math.abs(block.y - y)

	return dist
end

distanceSquare = function(block, target, dist)
	if (target == nil or dist == nil) then
		return false
	end

	if block.m ~= target.m then
		return false
	end

	if dist == 0 then
		-- special case for mob ai

		local targets = getTargetsAround(block, BL_ALL)
		local targetNextTo = false

		if #targets > 0 then
			for i = 1, #targets do
				if targets[i].blType == BL_PC or targets[i].blType == BL_MOB then
					if targets[i].ID == target.ID then
						targetNextTo = true
					end
				end
			end
		end

		return targetNextTo
	end

	if (math.abs(block.x - target.x) <= dist and math.abs(block.y - target.y) <= dist) then
		return true
	end

	return false
end

distanceSquareXY = function(block, targetX, targetY, dist)
	if (targetX == nil or targetY == nil or dist == nil) then
		return false
	end

	if (math.abs(block.x - targetX) <= dist and math.abs(block.y - targetY) <= dist) then
		return true
	end

	return false
end

findObjects = function(block, maxDist)
	local dist = 0
	local g = block:getObjectsInArea(BL_ITEM)
	local h = {}
	local x
	local target

	for x = 1, #g do
		target = FloorItem(g[x].ID)
		dist = distance(block, target)

		if (dist <= maxDist) then
			table.insert(h, g[x])
		end
	end

	return h
end

getTargetFacing = function(block, bltype, priority, dist)
	local objs = {}
	local target = nil

	if (dist == nil) then
		dist = 1
	end

	if (priority == nil) then
		priority = 0
	end

	if (block.side == 0) then
		objs = block:getObjectsInCell(block.m, block.x, block.y - dist, bltype)
	elseif (block.side == 1) then
		objs = block:getObjectsInCell(block.m, block.x + dist, block.y, bltype)
	elseif (block.side == 2) then
		objs = block:getObjectsInCell(block.m, block.x, block.y + dist, bltype)
	elseif (block.side == 3) then
		objs = block:getObjectsInCell(block.m, block.x - dist, block.y, bltype)
	end

	if (bltype == BL_ITEM and #objs > 0) then
		return objs
	end

	if (bltype == BL_NPC and #objs > 0) then
		return objs[1]
	end

	if (#objs > 0) then
		for x = 1, #objs do
			--objs[x]:talk(0,''..objs[x].state)
			if (target == nil) then
				if (priority == 0) then
					if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
						return objs[x]
					end
				elseif (priority == 1) then
					if (objs[x].state == 1) then
						return objs[x]
					end
				elseif (priority == 2) then
					if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
						return objs[x]
					elseif (x == #objs and target == nil) then
						for x = 1, #objs do
							if (objs[x].state == 1) then
								return objs[x]
							end
						end
					end
				elseif (priority == 3) then
					if (objs[x].state == 1) then
						return objs[x]
					elseif (x == #objs and target == nil) then
						for x = 1, #objs do
							if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
								return objs[x]
							end
						end
					end
				end
			end
		end
	end

	return nil
end

getTargetsBackstab = function(block, blockType)
	local frontBlocks = {}
	local backBlocks = {}
	local returnTable = {}

	if block.side == 0 then
		frontBlocks = block:getObjectsInCell(
			block.m,
			block.x,
			block.y - 1,
			blockType
		)
		backBlocks = block:getObjectsInCell(
			block.m,
			block.x,
			block.y + 1,
			blockType
		)
	elseif block.side == 1 then
		-- right
		frontBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y,
			blockType
		)
		backBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y,
			blockType
		)
	elseif block.side == 2 then
		frontBlocks = block:getObjectsInCell(
			block.m,
			block.x,
			block.y + 1,
			blockType
		)
		backBlocks = block:getObjectsInCell(
			block.m,
			block.x,
			block.y - 1,
			blockType
		)
	elseif block.side == 3 then
		frontBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y,
			blockType
		)
		backBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y,
			blockType
		)
	end

	if (#frontBlocks > 0) then
		for i = 1, #frontBlocks do
			if frontBlocks[i].blType == BL_MOB or (frontBlocks[i].blType == BL_PC and block:canPK(frontBlocks[i])) then
				table.insert(returnTable, frontBlocks[i])
			end
		end
	end

	if (#backBlocks > 0) then
		for i = 1, #backBlocks do
			if backBlocks[i].blType == BL_MOB or (backBlocks[i].blType == BL_PC and block:canPK(backBlocks[i])) then
				table.insert(returnTable, backBlocks[i])
			end
		end
	end

	return returnTable
end

getTargetsFlank = function(block, blockType)
	local rightSideBlocks = {}
	local leftSideBlocks = {}
	local returnTable = {}

	if block.side == 0 then
		rightSideBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y,
			blockType
		)
		leftSideBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y,
			blockType
		)
	elseif block.side == 1 then
		-- right
		rightSideBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y + 1,
			blockType
		)
		leftSideBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y - 1,
			blockType
		)
	elseif block.side == 2 then
		rightSideBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y,
			blockType
		)
		leftSideBlocks = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y,
			blockType
		)
	elseif block.side == 3 then
		rightSideBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y - 1,
			blockType
		)
		leftSideBlocks = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y + 1,
			blockType
		)
	end

	if (#rightSideBlocks > 0) then
		for i = 1, #rightSideBlocks do
			if rightSideBlocks[i].blType == BL_MOB or (rightSideBlocks[i].blType == BL_PC and block:canPK(rightSideBlocks[i])) then
				table.insert(returnTable, rightSideBlocks[i])
			end
		end
	end

	if (#leftSideBlocks > 0) then
		for i = 1, #leftSideBlocks do
			if leftSideBlocks[i].blType == BL_MOB or (leftSideBlocks[i].blType == BL_PC and block:canPK(leftSideBlocks[i])) then
				table.insert(returnTable, leftSideBlocks[i])
			end
		end
	end

	return returnTable
end

getTargetsAround = function(block, blockType)
	local northBlocks = block:getObjectsInCell(
		block.m,
		block.x,
		block.y - 1,
		blockType
	)
	local eastBlocks = block:getObjectsInCell(
		block.m,
		block.x + 1,
		block.y,
		blockType
	)
	local southBlocks = block:getObjectsInCell(
		block.m,
		block.x,
		block.y + 1,
		blockType
	)
	local westBlocks = block:getObjectsInCell(
		block.m,
		block.x - 1,
		block.y,
		blockType
	)
	local returnTable = {}

	if (#northBlocks > 0) then
		for i = 1, #northBlocks do
			table.insert(returnTable, northBlocks[i])
		end
	end

	if (#eastBlocks > 0) then
		for i = 1, #eastBlocks do
			table.insert(returnTable, eastBlocks[i])
		end
	end

	if (#southBlocks > 0) then
		for i = 1, #southBlocks do
			table.insert(returnTable, southBlocks[i])
		end
	end

	if (#westBlocks > 0) then
		for i = 1, #westBlocks do
			table.insert(returnTable, westBlocks[i])
		end
	end

	return returnTable
end

getTargetXY = function(m, x, y, bltype, priority)
	local target = nil

	if (priority == nil) then
		priority = 0
	end

	local objs = block:getObjectsInCell(m, x, y, bltype)

	for x = 1, #objs do
		--objs[x]:talk(0,''..objs[x].state)
		if (target == nil) then
			if (priority == 0) then
				if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
					return objs[x]
				end
			elseif (priority == 1) then
				if (objs[x].state == 1) then
					return objs[x]
				end
			elseif (priority == 2) then
				if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
					return objs[x]
				elseif (x == #objs and target == nil) then
					for x = 1, #objs do
						if (objs[x].state == 1) then
							return objs[x]
						end
					end
				end
			elseif (priority == 3) then
				if (objs[x].state == 1) then
					return objs[x]
				elseif (x == #objs and target == nil) then
					for x = 1, #objs do
						if (objs[x].state == 0 or objs[x].state == 2 or objs[x].state == 3 or objs[x].state == 4) then
							return objs[x]
						end
					end
				end
			end
		end
	end

	return nil
end

getHalfSide = function(block)
	local side = block.side
	local sides = {}

	--local ans
	if (side == 0) then
		sides = {3, 0, 1}
	elseif (side == 1) then
		sides = {0, 1, 2}
	elseif (side == 2) then
		sides = {1, 2, 3}
	elseif (side == 3) then
		sides = {2, 3, 0}
	end

	return sides
end

curT = function()
	timemark = "Yuri " .. curYear() .. ", " .. getCurSeason() .. ""
	return timemark
end

getDirection = function(block1, block2)
	local block1x = block1.x
	local block1y = block1.y
	local block2x = block2.x
	local block2y = block2.y
	local x = math.abs(block2x - block1x)
	local y = math.abs(block2y - block1y)
	local str = ""
	local quadrant

	if (block1x == block2x) and (block1y == block2y) then
		str = "error"
	end

	if (block1x > block2x) and (block1y > block2y) then
		quadrant = 4
	elseif (block1x < block2x) and (block1y < block2y) then
		quadrant = 2
	elseif (block1x < block2x) and (block1y > block2y) then
		quadrant = 3
	elseif (block1x > block2x) and (block1y < block2y) then
		quadrant = 1
	elseif (block1x == block2x) then
		if (block1y > block2y) then
			str = "north"
		elseif (block1y < block2y) then
			str = "south"
		end
	elseif (block1y == block2y) then
		if (block1x > block2x) then
			str = "west"
		elseif (block1x < block2x) then
			str = "east"
		end
	end

	local angle = math.deg(math.atan(y / x))

	--angle = math.abs(angle)
	if (quadrant == 1) then
		--67.5 22.5
		if (angle >= 60) then
			str = "south"
		elseif (angle < 60) and (angle > 30) then
			str = "south west"
		elseif (angle <= 30) then
			str = "west"
		end
	elseif (quadrant == 2) then
		if (angle >= 60) then
			str = "south"
		elseif (angle < 60) and (angle > 30) then
			str = "south east"
		elseif (angle <= 30) then
			str = "east"
		end
	elseif (quadrant == 3) then
		if (angle >= 60) then
			str = "north"
		elseif (angle < 60) and (angle > 30) then
			str = "north east"
		elseif (angle <= 30) then
			str = "east"
		end
	elseif (quadrant == 4) then
		if (angle >= 60) then
			str = "north"
		elseif (angle < 60) and (angle > 30) then
			str = "north west"
		elseif (angle <= 30) then
			str = "west"
		end
	end

	--broadcast(-1, block1.name..": "..block2.name.." is "..str.." of me.")
	return str
end

getAngle = function(block1, block2)
	local x = block2.x - block1.x
	local y = block2.y - block1.y
	local angle = math.deg(math.atan(y / x))

	if (x == 0 and y == 0) then
		angle = 9001
	elseif ((x >= 0 and y < 0) or (x > 0 and y <= 0)) then
		angle = math.abs(angle)
	elseif ((x <= 0 and y < 0) or (x < 0 and y <= 0)) then
		angle = 180 - angle
	elseif ((x <= 0 and y > 0) or (x < 0 and y >= 0)) then
		angle = 180 + math.abs(angle)
	elseif ((x >= 0 and y > 0) or (x > 0 and y >= 0)) then
		angle = 360 - angle
	end

	--broadcast(-1, ""..angle)
	return angle
end

getAngleXY = function(block, targetX, targetY)
	local x = targetX - block.x
	local y = targetY - block.y
	local angle = math.deg(math.atan(y / x))

	if (x == 0 and y == 0) then
		angle = 9001
	elseif ((x >= 0 and y < 0) or (x > 0 and y <= 0)) then
		angle = math.abs(angle)
	elseif ((x <= 0 and y < 0) or (x < 0 and y <= 0)) then
		angle = 180 - angle
	elseif ((x <= 0 and y > 0) or (x < 0 and y >= 0)) then
		angle = 180 + math.abs(angle)
	elseif ((x >= 0 and y > 0) or (x > 0 and y >= 0)) then
		angle = 360 - angle
	end

	--broadcast(-1, ""..angle)
	return angle
end

objBrowser = function()
	if (getObject(10000, 1, 11) > 0) then
		return
	end
	local x = 1
	local y = 11
	for i = 0, 19543 do
		setObject(10000, x + i, y, 1 + i)
	end
	for x = 0, 19543 do
		for y = 9, 12 do
			setTile(10000, x, y, 10727)
		end
	end
end

tileBrowser = function()
	if (getTile(10001, 1, 1) > 0) then
		return
	end
	local x, y, z

	for x = 1, 4800 do
		for y = 1, 11 do
			setTile(10001, x, y, ((y - 1) + ((x - 1) * 11)))
		end
	end
end

getSide = function(block, target)
	local direction = getDirection(block, target)

	if (direction == "north" or direction == "north east") then
		return 0
	elseif (direction == "east" or direction == "south east") then
		return 1
	elseif (direction == "south" or direction == "south west") then
		return 2
	elseif (direction == "west" or direction == "north west") then
		return 3
	else
		return nil
	end
end

canMove = function(block)
	local checkPCNorth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y - 1,
		BL_PC
	)
	local checkblockNorth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y - 1,
		BL_MOB
	)
	local checkNPCNorth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y - 1,
		BL_NPC
	)

	local checkPCEast = block:getObjectsInCell(
		block.m,
		block.x + 1,
		block.y,
		BL_PC
	)
	local checkblockEast = block:getObjectsInCell(
		block.m,
		block.x + 1,
		block.y,
		BL_MOB
	)
	local checkNPCEast = block:getObjectsInCell(
		block.m,
		block.x + 1,
		block.y,
		BL_NPC
	)

	local checkPCWest = block:getObjectsInCell(
		block.m,
		block.x - 1,
		block.y,
		BL_PC
	)
	local checkblockWest = block:getObjectsInCell(
		block.m,
		block.x - 1,
		block.y,
		BL_MOB
	)
	local checkNPCWest = block:getObjectsInCell(
		block.m,
		block.x - 1,
		block.y,
		BL_NPC
	)

	local checkPCSouth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y + 1,
		BL_PC
	)
	local checkblockSouth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y + 1,
		BL_MOB
	)
	local checkNPCSouth = block:getObjectsInCell(
		block.m,
		block.x,
		block.y + 1,
		BL_NPC
	)

	if (#checkNPCNorth > 0) then
		i = 0

		repeat
			i = i + 1

			if (checkNPCNorth[i] ~= nil and (checkNPCNorth[i].subType == 2 or checkNPCNorth[i].subType == 3)) then
				table.remove(checkNPCNorth, i)
				i = i - 1
			end
		until (i == #checkNPCNorth)
	end

	if (#checkNPCEast > 0) then
		i = 0

		repeat
			i = i + 1

			if (checkNPCEast[i] ~= nil and (checkNPCEast[i].subType == 2 or checkNPCEast[i].subType == 3)) then
				table.remove(checkNPCEast, i)
				i = i - 1
			end
		until (i == #checkNPCEast)
	end

	if (#checkNPCWest > 0) then
		i = 0

		repeat
			i = i + 1

			if (checkNPCWest[i] ~= nil and (checkNPCWest[i].subType == 2 or checkNPCWest[i].subType == 3)) then
				table.remove(checkNPCWest, i)
				i = i - 1
			end
		until (i == #checkNPCWest)
	end

	if (#checkNPCSouth > 0) then
		i = 0

		repeat
			i = i + 1

			if (checkNPCSouth[i] ~= nil and (checkNPCSouth[i].subType == 2 or checkNPCSouth[i].subType == 3)) then
				table.remove(checkNPCSouth, i)
				i = i - 1
			end
		until (i == #checkNPCSouth)
	end

	if (block.y - 1 > 0 and #checkPCNorth + #checkblockNorth + #checkNPCNorth == 0 and block:objectCanMove(
		block.x,
		block.y - 1,
		0
	) == true and getPass(block.m, block.x, block.y - 1) == 0) then
		return true
	elseif (block.x + 1 <= block.xmax and #checkPCEast + #checkblockEast + #checkNPCEast == 0 and block:objectCanMove(
		block.x + 1,
		block.y,
		1
	) == true and getPass(block.m, block.x + 1, block.y) == 0) then
		return true
	elseif (block.x - 1 > 0 and #checkPCWest + #checkblockWest + #checkNPCWest == 0 and block:objectCanMove(
		block.x - 1,
		block.y,
		3
	) == true and getPass(block.m, block.x - 1, block.y) == 0) then
		return true
	elseif (block.y + 1 <= block.ymax and #checkPCSouth + #checkblockSouth + #checkNPCSouth == 0 and block:objectCanMove(
		block.x,
		block.y + 1,
		2
	) == true and getPass(block.m, block.x, block.y + 1) == 0) then
		return true
	else
		return false
	end
end

getExp = function(player, limit, ratio)
	local level = player.level + (player.mark * 250)
	local levelExp
	local xp = 0

	if (ratio == nil) then
		ratio = 75
	end
	ratio = ratio / 100

	if (limit == nil) then
		limit = 1250
	end

	if (level > limit) then
		level = limit
	end

	levelExp = toNextLevel(level)

	xp = math.floor(levelExp * ratio)

	return xp
end

setTitleColor = function(player)
	local gfxDyes = {50, 21, 60, 61, 63, 66}
	local colors = {1, 4, 8, 15, 4, 1}
	local color = 0

	for i = 1, #gfxDyes do
		if player.gfxDye == gfxDyes[i] then
			color = colors[i]
			break
		end
	end

	if player.registry["elixirTeam"] > 0 then
		color = 0
	end

	player.gfxTitleColor = color
end

calculateDamage = function(block, amount)
	local attacker
	local ded = 0

	if (block.attacker >= 1073741823) then
		attacker = Mob(block.attacker)
	elseif (block.attacker > 0) then
		attacker = Player(block.attacker)
	end

	if block.sleep > 0 then
		amount = amount * block.sleep
	end

	if (block.deduction < 0) then
		amount = 0
	elseif (block.deduction > 0) then
		amount = amount * block.deduction
	end

	local armoramount = block.armor
	local lowarmor = 0

	if block.blType == BL_MOB then
		lowarmor = -95
	elseif block.blType == BL_PC then
		lowarmor = -80
	end

	if armoramount < lowarmor then
		armoramount = lowarmor
	end

	if armoramount > 100 then
		armoramount = 100
	end

	if armoramount ~= 0 then
		amount = amount * (1 + (armoramount / 100))
	else
		amount = amount
	end

	if (block.dmgShield > 0) then
		if (block.dmgShield > amount) then
			block.dmgShield = block.dmgShield - amount
			amount = 0
		else
			amount = amount - block.dmgShield
			block.dmgShield = 0
		end
	else
		amount = amount - block.dmgShield
		block.dmgShield = 0
	end

	if (attacker ~= nil) then
		attacker.damage = amount
		attacker.critChance = 0
	else
		block.damage = amount
		block.critChance = 0
	end

	return amount
end

checkProximityObjects = function(player, objs, distance)
	local found = false

	for y = player.y - distance, player.y + distance do
		for x = player.x - distance, player.x + distance do
			if y < 0 then
				y = 0
			end
			if x < 0 then
				x = 0
			end
			if y > getMapYMax(player.m) then
				y = getMapYMax(player.m)
			end
			if x > getMapXMax(player.m) then
				x = getMapXMax(player.m)
			end

			local obj = getObject(player.m, x, y)
			for i = 1, #objs do
				if objs[i] == obj then
					found = true
					break
				end
			end
		end
	end

	return found
end

getInstanceWarps = function(mapid)
	local warps = getWarps(mapid)
	local mapWarps = {}

	for i = 1, #warps, 6 do
		table.insert(mapWarps, {
			mm = warps[i],
			mx = warps[i + 1],
			my = warps[i + 2],
			dm = warps[i + 3],
			dx = warps[i + 4],
			dy = warps[i + 5]
		})
	end

	Player(2):talk(0, "" .. #mapWarps)

	return mapWarps
end
