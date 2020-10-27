map_editor = {
	cast = function(player)
		map_editor.enter(player)
	end,

	click = function(player, npc)
		player.dialogType = 0
		local opts = {}
		if player.registry["map_editor"] == 0 then
			table.insert(opts, "Edit Mode")
		else
			table.insert(opts, "Quit Editor")
			table.insert(opts, "Save Map")
		end

		txt = "<b>[Map Editor]\n"
		txt = txt .. "MapName: " .. player.mapTitle .. " (Id: " .. player.m .. ")\n"

		--	txt = txt.."MapFile: "..getMapFolder(player.m)..""

		menu = player:menuString(txt, opts)

		if menu == "Edit Mode" then
			map_editor.enter(player)
		elseif menu == "Quit Editor" then
			map_editor.quit(player)
		elseif menu == "Save Map" then
			confirm = player:menuString(
				txt .. "\nAre you sure to save change in map?",
				{"Yes", "No"}
			)
			if confirm == "Yes" then
				saveMap(player.m, "../rtkmaps/Accepted/" .. player.mapfile)
				player:sendMinitext("Map saved!")
				gm = player:getUsers()
				for i = 1, #gm do
					if gm[i].gmLevel > 0 then
						gm[i]:msg(
							4,
							player.name .. " has made changes to " .. player.mapTitle .. " map (Id: " .. player.m .. ") and saved the map file!",
							gm[i].ID
						)
						gm[i]:msg(
							4,
							"[SAVED]: " .. player.mapTitle .. " to " .. player.mapfile .. "",
							gm[i].ID
						)
					end
				end
			end
		end
	end,

	enter = function(player)
		local spells = player:getSpells()
		local add = {
			"editor_exit",
			"tile_next",
			"tile_prev",
			"toggle_pass",
			"obj_next",
			"obj_prev",
			"tile_copy",
			"tile_paste",
			"obj_copy",
			"obj_paste",
			"tile_check",
			"tile_find",
			"obj_check",
			"obj_find",
			"toggle_pass",
			"editor_save",
			"toggle_highlight_pass"
		}

		for i = 1, 255 do
			player.registry["spells_" .. i] = 0
		end

		if #spells > 0 then
			for i = 1, #spells do
				player.registry["spells_" .. i] = spells[i]
			end
		end
		cspells(player)
		for i = 1, #add do
			player:addSpell(add[i] .. "")
		end

		player.registry["map_editor"] = 1
		player:sendMinitext("Active Map Editor")
	end,

	quit = function(player)
		cspells(player)
		for i = 1, 52 do
			if player.registry["spells_" .. i] > 0 then
				player:addSpell(player.registry["spells_" .. i] .. "")
			end
		end
		if player:hasDuration("toggle_highlight_pass") then
			player:setDuration("toggle_highlight_pass", 0)
		end
		player.registry["map_editor"] = 0
		player:sendMinitext("Quit Map Editor")
	end
}

tile = {
	option = function(player, type, num)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		if type == "copy" then
			player.registry["saved_tile"] = tile
			player:talkSelf(
				0,
				"<Saved> Tile : " .. player.registry["saved_tile"] .. ""
			)
			return
		elseif type == "paste" then
			setTile(m, x, y, player.registry["saved_tile"])
			player:talkSelf(
				0,
				"<Pasted> Tile : " .. player.registry["saved_tile"] .. ""
			)
			return
		elseif type == "next" then
			if tile + 1 <= 47919 then
				setTile(m, x, y, tile + 1)
			end
			player:talkSelf(0, "<Next> Tile : " .. tile)
		elseif type == "previous" then
			if tile - 1 >= 0 then
				setTile(m, x, y, tile - 1)
			end
			player:talkSelf(0, "<Prev> Tile : " .. tile)
		elseif type == "jump" and num ~= nil then
			setTile(m, x, y, num)
			player:talkSelf(0, "Tile : " .. tile)
		elseif type == "check" then
			player:talkSelf(0, "Tile : " .. tile)
		end
		player:selfAnimationXY(player.ID, 235, x, y)
	end,
}

object = {
	option = function(player, type, num)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local obj = getObject(m, x, y)

		if type == "copy" then
			player.registry["saved_obj"] = obj
			player:talkSelf(
				0,
				"<Saved> Object : " .. player.registry["saved_obj"] .. ""
			)
			return
		elseif type == "paste" then
			setObject(m, x, y, player.registry["saved_obj"])
			player:talkSelf(
				0,
				"<Pasted> Object : " .. player.registry["saved_obj"] .. ""
			)
			return
		elseif type == "next" then
			if obj + 1 <= 19542 then
				setObject(m, x, y, obj + 1)
			end
			player:talkSelf(0, "<Next> Object : " .. obj)
		elseif type == "previous" then
			if obj - 1 >= 0 then
				setObject(m, x, y, obj - 1)
			end
			player:talkSelf(0, "<Prev> Object : " .. obj)
		elseif type == "jump" and num ~= nil then
			setObject(m, x, y, num)
			player:talkSelf(0, "Object: " .. obj)
		elseif type == "check" then
			player:talkSelf(0, "Object: " .. obj)
		end
		player:selfAnimationXY(player.ID, 228, x, y)
	end,
}

tile_next = {
	cast = function(player)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		if tile + 1 <= 47919 then
			setTile(m, x, y, tile + 1)
		end
		player:talkSelf(0, "<Next> Tile : " .. tile)
		player:selfAnimationXY(player.ID, 235, x, y)
	end
}

tile_prev = {
	cast = function(player)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		if tile - 1 >= 0 then
			setTile(m, x, y, tile - 1)
		end
		player:talkSelf(0, "<Prev> Tile : " .. tile)
		player:selfAnimationXY(player.ID, 235, x, y)
	end
}

tile_check = {
	cast = function(player)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		player:talkSelf(0, "Tile : " .. tile)
		player:selfAnimationXY(player.ID, 235, x, y)
	end
}

tile_copy = {
	cast = function(player)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		player.registry["saved_tile"] = tile
		player:talkSelf(
			0,
			"<Saved> Tile : " .. player.registry["saved_tile"] .. ""
		)
	end
}

tile_paste = {
	cast = function(player)
		local m, x, y, num = player.m, player.x, player.y, tonumber(num)
		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end
		local tile = getTile(m, x, y)
		setTile(m, x, y, player.registry["saved_tile"])
		player:talkSelf(
			0,
			"<Pasted> Tile : " .. player.registry["saved_tile"] .. ""
		)
	end
}

tile_find = {
	cast = function(player)
		local input = tonumber(player.question)

		if (not input) then
			anim(player, "Number only!")
			return
		else
			if input > 47919 then
				anim(player, "Max tile: 47919")
				return
			else
				tile.option(player, "jump", input)
			end
		end
	end
}

obj_next = {
	cast = function(player)
		object.option(player, "next")
	end
}
obj_prev = {
	cast = function(player)
		object.option(player, "previous")
	end
}
obj_check = {
	cast = function(player)
		object.option(player, "check")
	end
}
obj_copy = {
	cast = function(player)
		object.option(player, "copy")
	end
}
obj_paste = {
	cast = function(player)
		object.option(player, "paste")
	end
}

obj_find = {
	cast = function(player)
		local input = tonumber(player.question)

		if (not input) then
			anim(player, "Number only!")
			return
		else
			if input > 19542 then
				anim(player, "Max Object: 19542")
				return
			else
				object.option(player, "jump", input)
			end
		end
	end
}

set_pass = {
	cast = function(player)
		local m, x, y = player.m, player.x, player.y
		local input = tonumber(player.question)

		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end

		if (not input) then
			anim(player, "Number only!")
			return
		else
			if input - 1 >= 0 then
				setPass(m, x, y, input - 1)
				if getPass(m, x, y) == 0 then
					id = 235
				else
					id = 228
				end
				player:sendFrontAnimation(id)
			end
		end
	end
}

toggle_pass = {
	cast = function(player)
		local m, x, y = player.m, player.x, player.y

		if player.side == 0 then
			y = y - 1
		end
		if player.side == 1 then
			x = x + 1
		end
		if player.side == 2 then
			y = y + 1
		end
		if player.side == 3 then
			x = x - 1
		end

		if getPass(m, x, y) == 0 then
			setPass(m, x, y, 1)
			player:talk(2, "Pass set: False")
			printf = 0
		elseif getPass(m, x, y) == 1 then
			setPass(m, x, y, 0)
			player:talk(2, "Pass set: True")
			printf = 0
		end
	end
}

toggle_highlight_pass = {
	cast = function(player)
		if player:hasDuration("toggle_highlight_pass") then
			player:setDuration("toggle_highlight_pass", 0)
		else
			player:setDuration("toggle_highlight_pass", 100000000)
		end
	end,

	while_cast = function(player)
		local m = player.m
		local xmax = player.xmax
		local ymax = player.ymax

		for x = 0, player.xmax do
			for y = 0, player.ymax do
				if getPass(m, x, y) == 0 then
					player:selfAnimationXY(player.ID, 540, x, y)
				elseif getPass(m, x, y) == 1 then
					player:selfAnimationXY(player.ID, 542, x, y)
				end
			end
		end
	end
}

editor_save = {
	cast = function(player)
		saveMap(player.m, "../rtkmaps/Accepted/" .. player.mapFile)

		player:sendMinitext("Map saved!")

		local gm = player:getUsers()
		for i = 1, #gm do
			if gm[i].gmLevel > 0 then
				gm[i]:msg(
					4,
					player.name .. " has made changes to " .. player.mapTitle .. " map (Id: " .. player.m .. ") and saved the map file!",
					gm[i].ID
				)
				gm[i]:msg(
					4,
					"[SAVED]: " .. player.mapTitle .. " to " .. player.mapfile .. "",
					gm[i].ID
				)
			end
		end
	end
}

editor_exit = {
	cast = function(player)
		map_editor.quit(player)
	end
}
