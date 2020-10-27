onScriptedTilesCarnage = function(player)
	if player.mapTitle == "Carnage Hall" then
		if ((player.x == 2 or player.x == 3 or player.x == 10 or player.x == 11 or player.x == 18 or player.x == 19 or player.x == 27 or player.x == 26) and player.y == 32) then
			player:warp(3001, 5, 5)
		end
		if ((player.x == 21 or player.x == 22 or player.x == 5 or player.x == 6 or player.x == 13 or player.x == 14 or player.x == 29 or player.x == 30) and player.y == 32) then
			player:calcStat()
			minigames.giveMinigameExp(player, 2)
			player:returnToInn()
			clone.wipe(player)
			player:updateState()
		end

		if (player.x >= 1 and player.x <= 31 and player.y == 10) then
			--local carnageMaps = {31, 3009, 3011, 3016, 3017}

			local m = core.gameRegistry["carnageMap"]
			local x = 0
			local y = 0

			if m == 33 then
				-- stone valley arena
				if player.gfxDye == 63 then
					-- red
					x = math.random(4, 10)
					y = math.random(6, 12)
				elseif player.gfxDye == 66 then
					-- blue
					x = math.random(39, 47)
					y = math.random(6, 12)
				elseif player.gfxDye == 60 then
					-- black
					x = math.random(38, 42)
					y = math.random(38, 42)
				elseif player.gfxDye == 61 then
					-- white
					x = math.random(7, 12)
					y = math.random(38, 42)
				end
			end

			if m == 3017 then
				-- stone valley arena
				if player.gfxDye == 63 then
					-- red
					x = math.random(30, 35)
					y = math.random(32, 35)
				elseif player.gfxDye == 66 then
					-- blue
					x = math.random(39, 47)
					y = math.random(6, 12)
				elseif player.gfxDye == 60 then
					-- black
					x = math.random(5, 10)
					y = math.random(5, 10)
				elseif player.gfxDye == 61 then
					-- white
					x = math.random(7, 12)
					y = math.random(38, 42)
				end
			end

			if m == 3011 then
				-- stone valley arena
				if player.gfxDye == 63 then
					-- red
					x = math.random(3, 6)
					y = math.random(4, 6)
				elseif player.gfxDye == 60 then
					-- blue
					x = math.random(26, 28)
					y = math.random(27, 29)
				end
			end

			player.state = 0
			player:updateState()

			if (player.gfxDye == 0) then
				player:warp(3010, 12, 20)
			else
				player:warp(m, x, y)
			end

			player:calcStat()
		end
	end
end
