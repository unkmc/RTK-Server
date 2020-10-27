random_spawn_scrolls = {
	cast = function(player)
		player:freeAsync()
		player.lastClick = player.ID
		random_spawn_scrolls.click(player)
	end,

	click = async(function(player, npc)
		local t = {graphic = convertGraphic(776, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local red, blue, green, orange, yellow, pink = {}, {}, {}, {}, {}, {}

		local redscriptnum
		local bluescriptnum
		local greenscriptnum
		local orangescriptnum
		local pinkscriptnum
		local yellowscriptnum
		local randomX
		local randomY
		local x, y

		item = player:getObjectsInMap(player.m, BL_ITEM)

		if #item > 0 then
			for i = 1, #item do
				if item[i].yname == "red_script" then
					table.insert(red, item[i].ID)
				elseif item[i].yname == "blue_script" then
					table.insert(blue, item[i].ID)
				elseif item[i].yname == "green_script" then
					table.insert(green, item[i].ID)
				elseif item[i].yname == "orange_script" then
					table.insert(orange, item[i].ID)
				elseif item[i].yname == "yellow_script" then
					table.insert(yellow, item[i].ID)
				elseif item[i].yname == "pink_script" then
					table.insert(pink, item[i].ID)
				end
			end
		end

		local opts = {}
		table.insert(
			opts,
			"Red script (" .. #red .. ")   : " .. player.registry[
				"red_script_num"
			]
		)
		table.insert(
			opts,
			"Blue script (" .. #blue .. ")  : " .. player.registry[
				"blue_script_num"
			]
		)
		table.insert(
			opts,
			"Green script (" .. #green .. ") : " .. player.registry[
				"green_script_num"
			]
		)

		table.insert(
			opts,
			"Orange script (" .. #orange .. ") : " .. player.registry[
				"orange_script_num"
			]
		)
		table.insert(
			opts,
			"Yellow script (" .. #yellow .. ") : " .. player.registry[
				"yellow_script_num"
			]
		)
		table.insert(
			opts,
			"Pink script (" .. #pink .. ") : " .. player.registry[
				"pink_script_num"
			]
		)

		table.insert(opts, "Randomly place scrolls on map")

		menu = player:menuString(
			"Set amount of scrolls to place randomly",
			opts
		)

		if menu == "Red script (" .. #red .. ")   : " .. player.registry[
			"red_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["red_script_num"] .. ")")))
			player.registry["red_script_num"] = num
		elseif menu == "Blue script (" .. #blue .. ")  : " .. player.registry[
			"blue_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["blue_script_num"] .. ")")))
			player.registry["blue_script_num"] = num
		elseif menu == "Green script (" .. #green .. ") : " .. player.registry[
			"green_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["green_script_num"] .. ")")))
			player.registry["green_script_num"] = num
		elseif menu == "Orange script (" .. #orange .. ") : " .. player.registry[
			"orange_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["orange_script_num"] .. ")")))
			player.registry["orange_script_num"] = num
		elseif menu == "Yellow script (" .. #yellow .. ") : " .. player.registry[
			"yellow_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["yellow_script_num"] .. ")")))
			player.registry["yellow_script_num"] = num
		elseif menu == "Pink script (" .. #pink .. ") : " .. player.registry[
			"pink_script_num"
		] then
			num = math.floor(tonumber(player:input("Enter amount : (" .. player.registry["pink_script_num"] .. ")")))
			player.registry["pink_script_num"] = num
		elseif menu == "Randomly place scrolls on map" then
			confirm = player:menuString(
				"Are you sure you want to place these scrolls?",
				{"Yes", "No"}
			)
			if confirm == "Yes" then
				async(random_spawn_scrolls.place(player))
			end
		end
	end),

	place = function(player)
		random_spawn_scrolls.placeRed(player, 0)
		random_spawn_scrolls.placeBlue(player, 0)
		random_spawn_scrolls.placeGreen(player, 0)
		random_spawn_scrolls.placeOrange(player, 0)
		random_spawn_scrolls.placeYellow(player, 0)
		random_spawn_scrolls.placePink(player, 0)
	end,

	placeRed = function(player, tries)
		if tries >= 20 then
			return
		end

		tries = tries + 1

		local red = {}
		local redscriptnum
		local x, y
		local groundItem
		redscriptnum = player.registry["red_script_num"]

		if redscriptnum > 0 then
			for i = 1, redscriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"red_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["red_script_num"] = player.registry[
									"red_script_num"
								] - 1
							else
								return random_spawn_scrolls.placeRed(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placeRed(player, tries)
						end
					else
						return random_spawn_scrolls.placeRed(player, tries)
					end
				else
					return random_spawn_scrolls.placeRed(player, tries)
				end
			end
		end
	end,

	placeBlue = function(player, tries)
		if tries >= 20 then
			return
		end
		tries = tries + 1

		local blue = {}
		local bluescriptnum
		local x, y
		local groundItem
		bluescriptnum = player.registry["blue_script_num"]

		if bluescriptnum > 0 then
			for i = 1, bluescriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"blue_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["blue_script_num"] = player.registry[
									"blue_script_num"
								] - 1
							else
								return random_spawn_scrolls.placeBlue(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placeBlue(player, tries)
						end
					else
						return random_spawn_scrolls.placeBlue(player, tries)
					end
				else
					return random_spawn_scrolls.placeBlue(player, tries)
				end
			end
		end
	end,

	placeGreen = function(player, tries)
		if tries >= 20 then
			return
		end
		tries = tries + 1

		local green = {}
		local greenscriptnum
		local x, y
		local groundItem
		greenscriptnum = player.registry["green_script_num"]

		if greenscriptnum > 0 then
			for i = 1, greenscriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"green_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["green_script_num"] = player.registry[
									"green_script_num"
								] - 1
							else
								return random_spawn_scrolls.placeGreen(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placeGreen(
								player,
								tries
							)
						end
					else
						return random_spawn_scrolls.placeGreen(player, tries)
					end
				else
					return random_spawn_scrolls.placeGreen(player, tries)
				end
			end
		end
	end,

	placeOrange = function(player, tries)
		if tries >= 20 then
			return
		end
		tries = tries + 1

		local orange = {}
		local orangescriptnum
		local x, y
		local groundItem
		orangescriptnum = player.registry["orange_script_num"]

		if orangescriptnum > 0 then
			for i = 1, orangescriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"orange_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["orange_script_num"] = player.registry[
									"orange_script_num"
								] - 1
							else
								return random_spawn_scrolls.placeOrange(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placeOrange(
								player,
								tries
							)
						end
					else
						return random_spawn_scrolls.placeOrange(player, tries)
					end
				else
					return random_spawn_scrolls.placeOrange(player, tries)
				end
			end
		end
	end,

	placeYellow = function(player, tries)
		if tries >= 20 then
			return
		end
		tries = tries + 1

		local yellow = {}
		local yellowscriptnum
		local x, y
		local groundItem
		yellowscriptnum = player.registry["yellow_script_num"]

		if yellowscriptnum > 0 then
			for i = 1, yellowscriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"yellow_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["yellow_script_num"] = player.registry[
									"yellow_script_num"
								] - 1
							else
								return random_spawn_scrolls.placeYellow(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placeYellow(
								player,
								tries
							)
						end
					else
						return random_spawn_scrolls.placeYellow(player, tries)
					end
				else
					return random_spawn_scrolls.placeYellow(player, tries)
				end
			end
		end
	end,

	placePink = function(player, tries)
		if tries >= 20 then
			return
		end
		tries = tries + 1

		local pink = {}
		local pinkscriptnum
		local x, y
		local groundItem
		pinkscriptnum = player.registry["pink_script_num"]

		if pinkscriptnum > 0 then
			for i = 1, pinkscriptnum do
				x = math.random(1, player.xmax)
				y = math.random(1, player.ymax)
				groundItem = player:getObjectsInCell(player.m, x, y, BL_ITEM)
				if getPass(player.m, x, y) == 0 then
					if not getWarp(player.m, x, y) then
						if getObject(player.m, x, y) == 0 then
							if #groundItem == 0 then
								tries = 0
								player:dropItemXY(
									"pink_script",
									1,
									0,
									0,
									player.m,
									x,
									y
								)
								player.registry["pink_script_num"] = player.registry[
									"pink_script_num"
								] - 1
							else
								return random_spawn_scrolls.placePink(
									player,
									tries
								)
							end
						else
							return random_spawn_scrolls.placePink(player, tries)
						end
					else
						return random_spawn_scrolls.placePink(player, tries)
					end
				else
					return random_spawn_scrolls.placePink(player, tries)
				end
			end
		end
	end
}

spawn_tool = {
	cast = function(player)
		player:freeAsync()
		player.lastClick = player.ID
		spawn_tool.click(player)
	end,

	click = async(function(player, npc)
		local t = {graphic = convertGraphic(776, "monster"), color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local red, blue, green, orange, yellow, pink = {}, {}, {}, {}, {}, {}

		item = player:getObjectsInMap(player.m, BL_ITEM)

		if #item > 0 then
			for i = 1, #item do
				if item[i].yname == "red_script" then
					table.insert(red, item[i].ID)
				elseif item[i].yname == "blue_script" then
					table.insert(blue, item[i].ID)
				elseif item[i].yname == "green_script" then
					table.insert(green, item[i].ID)
				elseif item[i].yname == "orange_script" then
					table.insert(orange, item[i].ID)
				elseif item[i].yname == "yellow_script" then
					table.insert(yellow, item[i].ID)
				elseif item[i].yname == "pink_script" then
					table.insert(pink, item[i].ID)
				end
			end
		end

		local opts = {}

		table.insert(
			opts,
			"Red script (" .. #red .. ")   : " .. player.registry["red_script"]
		)
		table.insert(
			opts,
			"Blue script (" .. #blue .. ")  : " .. player.registry[
				"blue_script"
			]
		)
		table.insert(
			opts,
			"Green script (" .. #green .. ") : " .. player.registry[
				"green_script"
			]
		)
		table.insert(
			opts,
			"Orange script (" .. #orange .. ") : " .. player.registry[
				"orange_script"
			]
		)
		table.insert(
			opts,
			"Yellow script (" .. #yellow .. ") : " .. player.registry[
				"yellow_script"
			]
		)
		table.insert(
			opts,
			"Pink script (" .. #pink .. ") : " .. player.registry["pink_script"]
		)

		table.insert(opts, "Delete all scripts in map")
		table.insert(opts, "Permanently spawn all mobs on each script")

		menu = player:menuString("Set mob to spawn for each script", opts)

		if menu == "Red script (" .. #red .. ")   : " .. player.registry["red_script"] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["red_script"] .. ")")))
			player.registry["red_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Blue script (" .. #blue .. ")  : " .. player.registry[
			"blue_script"
		] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["blue_script"] .. ")")))
			player.registry["blue_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Green script (" .. #green .. ") : " .. player.registry[
			"green_script"
		] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["green_script"] .. ")")))
			player.registry["green_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Orange script (" .. #orange .. ") : " .. player.registry[
			"orange_script"
		] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["orange_script"] .. ")")))
			player.registry["orange_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Yellow script (" .. #yellow .. ") : " .. player.registry[
			"yellow_script"
		] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["yellow_script"] .. ")")))
			player.registry["yellow_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Pink script (" .. #pink .. ") : " .. player.registry[
			"pink_script"
		] then
			mob = math.abs(tonumber(player:input("Enter mobID : (" .. player.registry["pink_script"] .. ")")))
			player.registry["pink_script"] = mob
			spawn_tool.click(player, npc)
		elseif menu == "Delete all scripts in map" then
			local script = {
				Item("red_script").id,
				Item("blue_script").id,
				Item("green_script").id,
				Item("orange_script").id,
				Item("pink_script").id,
				Item("yellow_script").id
			}

			--player:talk(0,""..script[1])
			item = player:getObjectsInMap(player.m, BL_ITEM)
			if #item > 0 then
				for i = 1, #item do
					for j = 1, #script do
						if item[i].id == script[j] then
							item[i]:delete()
							player:talkSelf(2, "All scripts deleted")
						end
					end
				end
			end
		elseif menu == "Permanently spawn all mobs on each script" then
			spawn_tool.spawn(player)
		elseif menu == "Get spell" then
			player:addSpell("add_script")

			--	player:addSpell("delete_spawn")
			player:msg(4, "[INFO] 'Add script' spell added!", player.ID)

			--	player:msg(4, "[INFO] 'Delete spawn' spell added!", player.ID)
			spawn_tool.click(player, npc)
		end
	end),

	spawn = function(player)
		local item = player:getObjectsInMap(player.m, BL_ITEM)
		local mobID

		if player.registry["red_script"] == 0 and player.registry["blue_script"] == 0 and player.registry[
			"green_script"
		] == 0 then
			anim(player)
			player:sendMinitext("set mobID for script first!")
			return
		else
			if #item > 0 then
				for i = 1, #item do
					if item[i].yname == "red_script" then
						if player.registry["red_script"] > 0 then
							mobID = player.registry["red_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					elseif item[i].yname == "blue_script" then
						if player.registry["blue_script"] > 0 then
							mobID = player.registry["blue_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					elseif item[i].yname == "green_script" then
						if player.registry["green_script"] > 0 then
							mobID = player.registry["green_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					elseif item[i].yname == "orange_script" then
						if player.registry["orange_script"] > 0 then
							mobID = player.registry["orange_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					elseif item[i].yname == "yellow_script" then
						if player.registry["yellow_script"] > 0 then
							mobID = player.registry["yellow_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					elseif item[i].yname == "pink_script" then
						if player.registry["pink_script"] > 0 then
							mobID = player.registry["pink_script"]
							addMob(player.m, item[i].x, item[i].y, mobID)
							player:sendAnimationXY(111, item[i].x, item[i].y)
							item[i]:delete()
							player:sendMinitext("Monster added!")
						end
					end
				end
			end
		end
	end
}
