mapGenerator = {
	prepareMap = function(mapid)
		local tempmap = 59999

		local maps = {"test1", "test2"}

		local minX, maxX, minY, maxY = 0, 32, 0, 32

		math.randomseed(os.time())

		for y = 1, 8 do
			for x = 1, 8 do
				map = maps[math.random(1, #maps)]
				setMap(
					tempmap,
					"../rtkmaps/Accepted/test/" .. map .. ".map",
					"Merry Forest",
					0,
					0,
					0,
					1,
					0,
					0,
					3600000,
					0,
					0,
					2,
					1,
					0,
					0
				)
				local objs, tiles, passabilities = mapGenerator.copyMap(
					tempmap,
					0,
					0,
					32,
					32
				)

				mapGenerator.writeMap(
					mapid,
					minX,
					minY,
					maxX,
					maxX,
					objs,
					tiles,
					passabilities
				)

				minX = minX + 32
				maxX = maxX + 32

				if maxX > 256 then
					minX = 0
					maxX = 32
					minY = minY + 32
					maxY = maxY + 32
				end
			end
		end
	end,

	copyMap = function(mapid, minX, minY, maxX, maxY)
		local objs = {}
		local tiles = {}
		local passabilities = {}

		for y = minY, maxY do
			for x = minX, maxX do
				local obj = getObject(mapid, x, y)
				local tile = getTile(mapid, x, y)
				local pass = getPass(mapid, x, y)

				if obj ~= nil then
					table.insert(objs, obj)
				else
					table.insert(objs, 0)
				end

				--Player(2):talk(0,"x: "..x.." y: "..y)
				table.insert(tiles, tile)
				table.insert(passabilities, pass)
			end
		end

		return objs, tiles, passabilities
	end,

	writeMap = function(mapid, minX, minY, maxX, maxY, objs, tiles, passabilities)
		local x = minX
		local y = minY

		for i = 1, #objs do
			if x > maxX then
				x = minX
				y = y + 1
			end

			setObject(mapid, x, y, objs[i])
			setTile(mapid, x, y, tiles[i])
			setPass(mapid, x, y, passabilities[i])
			x = x + 1
		end
	end,

	clearMap = function(mapid)
		for i = 0, getMapXMax(mapid) do
			for j = 0, getMapYMax(mapid) do
				setObject(mapid, i, j, 0)
				setTile(mapid, i, j, 0)
				setPass(mapid, i, j, 0)
			end
		end
	end
}
