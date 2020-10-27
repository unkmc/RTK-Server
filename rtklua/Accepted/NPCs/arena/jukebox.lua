JukeboxNpc = {
	click = async(function(player, npc)
		local name = "<b>[" .. npc.name .. "]\n\n"
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		local m = player.m
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		local song = 1

		local pc = player:getObjectsInMap(player.m, BL_PC)
		local options = {}
		local goldCost = 500
		local playTime = 45

		table.insert(options, "Play a song")
		table.insert(options, "No thanks")

		if npc.registry["timer"] > os.time() then
			player:popUp("Someone else just started a song!\n\nIt would be rude to interrupt.\n\n(NOW PLAYING): Track #" .. player.bgm - 100)
		else
			if player.bgm > 100 then
				menu = player:menuString(
					"It's a jukebox. Would you like to play a song for " .. goldCost .. " coins?\n\n(NOW PLAYING): Track #" .. player.bgm - 100,
					options
				)
			else
				menu = player:menuString(
					"It's a jukebox. Would you like to play a song for " .. goldCost .. " coins?\n\n(NOW PLAYING): Track #" .. player.bgm + 60,
					options
				)
			end
			if menu == "Play a song" then
				song = player:inputNumberCheck(player:input("Please Enter a BGM number from 1-68:"))
				if song >= 1 and song <= 60 then
					if player.money < goldCost then
						player:dialogSeq(
							{t, "Yea, you don't have enough money."},
							0
						)
						return
					end

					player:removeGold(goldCost)
					JukeboxNpc.addLegend(player)

					if #pc > 0 then
						for i = 1, #pc do
							pc[i].bgm = (song + 100)
							pc[i]:refresh()
						end
					end

					npc.registry["timer"] = os.time() + playTime
					broadcast(
						npc.m,
						"[JUKEBOX]: " .. player.name .. " just paid to set the jukebox to track #" .. player.bgm - 100
					)
				elseif song >= 61 and song <= 67 then
					if player.money < goldCost then
						player:dialogSeq(
							{t, "Yea, you don't have enough money."},
							0
						)
						return
					end

					JukeboxNpc.addLegend(player)
					if #pc > 0 then
						for i = 1, #pc do
							pc[i].bgm = (song - 60)
							pc[i]:refresh()
						end
					end

					npc.registry["timer"] = os.time() + playTime
					broadcast(
						npc.m,
						"[JUKEBOX]: " .. player.name .. " just paid to set the jukebox to track #" .. player.bgm + 60
					)
				elseif song == 68 then
					if player.money < goldCost then
						player:dialogSeq(
							{t, "Yea, you don't have enough money."},
							0
						)
						return
					end

					JukeboxNpc.addLegend(player)
					if #pc > 0 then
						for i = 1, #pc do
							pc[i].bgm = 999
							pc[i]:refresh()
						end
					end

					npc.registry["timer"] = os.time() + playTime
					broadcast(
						npc.m,
						"[JUKEBOX]: " .. player.name .. " just paid to set the jukebox to track #" .. player.bgm + 60
					)
				else
					player:popUp("Invalid number!")
				end
			else
			end
		end
	end),

	addLegend = function(player)
		local reg = player.registry["jukebox_songs_purchased"]

		if player:hasLegend("jukebox") then
			player:removeLegendbyName("jukebox")
		end

		if reg > 0 then
			player.registry["jukebox_songs_purchased"] = player.registry[
				"jukebox_songs_purchased"
			] + 1
			player:addLegend(
				"Played " .. player.registry["jukebox_songs_purchased"] .. " songs on the jukebox",
				"jukebox",
				192,
				16
			)
		else
			player.registry["jukebox_songs_purchased"] = 1
			player:addLegend("Played 1 song on the jukebox", "jukebox", 192, 16)
		end
		if player.registry["jukebox_songs_purchased"] == 100 then
			broadcast(
				-1,
				"[TITLE]: " .. player.name .. " has just earned the title 'DJ'!"
			)
		end
	end
}
