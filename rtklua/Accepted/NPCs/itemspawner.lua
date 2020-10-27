itemspawner = function()
	kugnaeFarmChestnutSpawn()
	buyaChestnutSpawn()
end

kugnaeFarmChestnutSpawn = function()
	--------Chestnuts in Farm in Kugnae spawn-------

	local itemsFound = core:getObjectsInMap(0, BL_ITEM)
	local totalChestnuts = {}
	local totalChestnutsInArea = {}
	local maxChestnuts = 20
	local chestnutsToSpawn = 0
	local minX = 102
	local maxX = 115
	local minY = 132
	local maxY = 155

	if next(itemsFound) ~= nil then
		for i = 1, #itemsFound do
			if itemsFound[i].yname == "chestnut" then
				table.insert(totalChestnuts, itemsFound[i])
			end
		end
	end

	if next(totalChestnuts) ~= nil then
		for j = 1, #totalChestnuts do
			if (totalChestnuts[j].x >= minX and totalChestnuts[j].x <= maxX and totalChestnuts[
				j
			].y >= minY and totalChestnuts[j].y <= maxY) then
				table.insert(totalChestnutsInArea, totalChestnuts[j])
			end
		end
	end

	if next(totalChestnutsInArea) ~= nil then
		chestnutsToSpawn = maxChestnuts - #totalChestnutsInArea
		if (chestnutsToSpawn < 0) then
			chestnutsToSpawn = 0
		end
	else
		chestnutsToSpawn = maxChestnuts
	end

	for k = 1, chestnutsToSpawn do
		x = math.random(minX, maxX)
		y = math.random(minY, maxY)

		if getPass(0, x, y) == 0 then
			core:dropItemXY(10037, math.random(1, 3), 0, 0, 0, x, y)
		end
	end
end

buyaChestnutSpawn = function()
	--------Chestnuts in Buya spawn-------

	local itemsFound = core:getObjectsInMap(330, BL_ITEM)
	local totalChestnuts = {}
	local totalChestnutsInArea = {}
	local maxChestnuts = 20
	local chestnutsToSpawn = 0
	local minX = 20
	local maxX = 27
	local minY = 37
	local maxY = 47

	if itemsFound ~= nil then
		for i = 1, #itemsFound do
			if itemsFound[i].yname == "chestnut" then
				table.insert(totalChestnuts, itemsFound[i])
			end
		end
	end

	if totalChestnuts ~= nil then
		for j = 1, #totalChestnuts do
			if (totalChestnuts[j].x >= minX and totalChestnuts[j].x <= maxX and totalChestnuts[
				j
			].y >= minY and totalChestnuts[j].y <= maxY) then
				table.insert(totalChestnutsInArea, totalChestnuts[j])
			end
		end
	end

	if totalChestnutsInArea ~= nil then
		chestnutsToSpawn = maxChestnuts - #totalChestnutsInArea
		if (chestnutsToSpawn < 0) then
			chestnutsToSpawn = 0
		end
	else
		chestnutsToSpawn = maxChestnuts
	end

	for k = 1, chestnutsToSpawn do
		x = math.random(minX, maxX)
		y = math.random(minY, maxY)

		if getPass(0, x, y) == 0 then
			core:dropItemXY(10037, math.random(1, 3), 0, 0, 330, x, y)
		end
	end
end
