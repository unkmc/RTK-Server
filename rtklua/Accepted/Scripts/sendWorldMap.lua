sendWorldMap = function(player, origin)
	local worldMap = "WMkru"

	local destinations = {}

	table.insert(destinations, {
		x0 = 930,
		y0 = 650,
		name = "Hamgyong Nam-Do",
		m = 99,
		x1 = 8,
		y1 = 2
	})
	table.insert(destinations, {
		x0 = 1000,
		y0 = 100,
		name = "Arctic Land",
		m = 1013,
		x1 = 9,
		y1 = 9
	})
	table.insert(
		destinations,
		{x0 = 765, y0 = 400, name = "Buya", m = 1012, x1 = 1, y1 = 11}
	)
	table.insert(
		destinations,
		{x0 = 950, y0 = 470, name = "Hausson", m = 1025, x1 = 10, y1 = 8}
	)
	table.insert(
		destinations,
		{x0 = 722, y0 = 550, name = "Kugnae", m = 1011, x1 = 18, y1 = 14}
	)
	table.insert(
		destinations,
		{x0 = 650, y0 = 660, name = "Nagnang", m = 2520, x1 = 8, y1 = 8}
	)
	table.insert(destinations, {
		x0 = 380,
		y0 = 230,
		name = "Mythic Nexus",
		m = 41,
		x1 = 30,
		y1 = 4
	})
	table.insert(destinations, {
		x0 = 280,
		y0 = 370,
		name = "KaMing's Encampment",
		m = 3800,
		x1 = 31,
		y1 = 3
	})
	if player.quest["instance"] == 8 then
		table.insert(destinations, {
			x0 = 738,
			y0 = 192,
			name = "Mount Baekdu",
			m = 4259,
			x1 = 9,
			y1 = 20
		})
	end

	--table.insert(destinations,{x0 = 0, y0 = 0, name = "test", m = 0, x1 = 0, y1 = 0})

	local x0 = {}
	local y0 = {}
	local name = {}
	local m = {}
	local x1 = {}
	local y1 = {}

	for i = 1, #destinations do
		-- this makes our origin always first entry in table
		if destinations[i].name == origin then
			table.insert(x0, destinations[i].x0)
			table.insert(y0, destinations[i].y0)
			table.insert(name, destinations[i].name)
			table.insert(m, destinations[i].m)
			table.insert(x1, destinations[i].x1)
			table.insert(y1, destinations[i].y1)
			break
		end
	end

	for i = 1, #destinations do
		-- this adds all the rest of the entries as long as they are not the origin
		if destinations[i].name ~= origin then
			table.insert(x0, destinations[i].x0)
			table.insert(y0, destinations[i].y0)
			table.insert(name, destinations[i].name)
			table.insert(m, destinations[i].m)
			table.insert(x1, destinations[i].x1)
			table.insert(y1, destinations[i].y1)
		end
	end

	player:mapSelection(worldMap, x0, y0, name, m, x1, y1)
end
