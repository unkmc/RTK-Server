onScriptedTilesTutorsHaven = function(player)
	local x, y = player.x, player.y
	local m = 0

	if player.mapTitle == "Tutor's Haven" then
		if y == 0 then
			-- poet jinsun
			if x == 4 then
				-- poet jinsun
				m = 17
			elseif x == 10 then
				-- poet song
				m = 344
			elseif x == 16 then
				-- poet staff
				m = 2516
			end
		elseif x == 0 then
			if y == 4 then
				-- rogue maro
				m = 15
			elseif y == 10 then
				-- rogue maso
				m = 343
			elseif y == 16 then
				-- rogue dagger
				m = 2514
			end
		elseif x == 20 then
			if y == 4 then
				-- warrior tebaek
				m = 11
			elseif y == 10 then
				-- warrior yebaek
				m = 341
			elseif y == 16 then
				-- warrior sword
				m = 2510
			end
		elseif y == 20 then
			if x == 4 then
				-- mage haedu
				m = 13
			elseif x == 10 then
				-- mage eldritch
				m = 342
			elseif x == 16 then
				-- mage wand
				m = 2512
			end
		elseif x == 10 and y == 8 then
			-- tutor's domain
			m = 3301
		end

		if m == 0 then
			return
		end

		player:warp(
			m,
			math.floor(getMapXMax(m) / 2),
			math.floor(getMapYMax(m) / 2)
		)
	end
end
