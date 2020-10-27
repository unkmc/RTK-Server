onScriptedTilesMap = function(player)
	local mapTitle = player.mapTitle
	local x = player.x
	local y = player.y

	if mapTitle == "North Hamgyong Valley" then
		if (y == 0 and (x == 7 or x == 8 or x == 9)) then
			sendWorldMap(player, "Hamgyong Nam-Do")
		end
	end

	if mapTitle == "Kugnae Gathering" then
		if ((y == 12 or y == 13) and x == 19) then
			sendWorldMap(player, "Kugnae")
		end
	end

	if mapTitle == "Buya Gathering" then
		if ((y >= 8 and y <= 12) and x == 0) then
			sendWorldMap(player, "Buya")
		end
	end

	if mapTitle == "Mythic Nexus" then
		if (x >= 28 and x <= 32 and y == 1) then
			sendWorldMap(player, "Mythic Nexus")
		end
	end

	if mapTitle == "KaMing's Encampment" then
		if (x >= 30 and x <= 34 and (y == 0 or y == 1)) then
			sendWorldMap(player, "KaMing's Encampment")
		end
	end

	if mapTitle == "Haeng Tavern" then
		if (x == 10 and (y == 7 or y == 8)) then
			sendWorldMap(player, "Arctic Land")
		end
	end

	if mapTitle == "Kafas Tavern" then
		if (x == 11 and (y == 7 or y == 8 or y == 9)) then
			sendWorldMap(player, "Hausson")
		end
	end

	if mapTitle == "Nagnang Gathering" then
		if ((x == 7 or x == 8 or x == 9) and y == 5) then
			sendWorldMap(player, "Nagnang")
		end
	end

	if mapTitle == "Kugnae Houses" then
		if ((x >= 6 and x <= 9) and y == 0) then
			sendHouseMap(player, "Kugnae")
		end
	end

	if mapTitle == "Mount Baekdu" then
		if ((x == 9 or x == 10) and y == 21) then
			sendWorldMap(player, "Mount Baekdu")
		end
	end
end
