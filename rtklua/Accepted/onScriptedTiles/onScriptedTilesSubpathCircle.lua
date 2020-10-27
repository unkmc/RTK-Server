onScriptedTilesSubpathCircle = async(function(player)
	-- This file will fulfill all the subpath's circle tiles

	local mapTitle = player.mapTitle
	local x, y = player.x, player.y
	local element = ""

	-- return on every map that is not a subpath circle
	if mapTitle ~= "Barbarian Circle" and mapTitle ~= "Chongun Circle" and mapTitle ~= "Do Circle" and mapTitle ~= "Merchant Circle" and mapTitle ~= "Ranger Circle" and mapTitle ~= "Spy Circle" and mapTitle ~= "Diviner Circle" and mapTitle ~= "Geomancer Circle" and mapTitle ~= "Shaman Circle" and mapTitle ~= "Muse Circle" and mapTitle ~= "Druid Circle" and mapTitle ~= "Monk Circle" then
		return
	end

	if x == 8 and y == 11 then
		element = "Fire"

		-- middle left
	elseif x == 9 and y == 9 then
		element = "Mountain"

		-- top left
	elseif x == 9 and y == 13 then
		element = "Wind"

		-- bottom left
	elseif x == 11 and y == 8 then
		element = "Earth"

		-- top
	elseif x == 11 and y == 14 then
		element = "Heaven"

		-- bottom
	elseif x == 13 and y == 9 then
		element = "Thunder"

		-- top right
	elseif x == 13 and y == 13 then
		element = "Pond"

		-- bottom right
	elseif x == 14 and y == 11 then
		element = "Water"

		-- middle right
	else
		return
	end

	local key = Item("key_to_" .. string.lower(element))

	local t = {graphic = key.icon, color = key.iconColor}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = player.ID

	player:dialogSeq(
		{
			t,
			"You shall choose the person that has the spirit of " .. element .. " who shall Ascend to the next Octave of your Path."
		},
		1
	)

	local input = player:inputLetterCheck(player:inputSeq(
		"Who has the spirit of " .. element .. "?",
		"The great",
		"has the spirit of " .. element .. ".",
		{},
		{}
	))

	local ascendPerson = Player(input)

	if ascendPerson == nil then
		player:dialogSeq({t, "That person is not present to Ascend"}, 0)
		return
	end

	-- You can only ascend your elder. (shows silver coin)
end)
