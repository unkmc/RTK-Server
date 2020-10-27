instance_check_counter = 1

InstanceTestNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local cave = 1

		if player.level >= 99 then
			cave = 2
		end

		if player.baseHealth >= 160000 or player.baseMagic >= 80000 then
			cave = 3
		end

		if player.baseHealth >= 320000 or player.baseMagic >= 160000 then
			cave = 4
		end

		local player_instances = {}
		local opts = {}
		if #instances > 0 then
			for i = 1, #instances do
				for k = 1, #instances[i].group do
					if instances[i].group[k] == player.ID then
						table.insert(player_instances, {
							index = i,
							name = instances[i].map_type,
							owner = instances[i].owner
						})
					end
				end
			end
		end

		if #player_instances > 0 then
			for i = 1, #player_instances do
				table.insert(
					opts,
					player_instances[i].name .. " (" .. player_instances[i].owner .. ")"
				)
			end
		end
		table.insert(opts, "Explore Map")
		local menu = player:menuSeq("", opts, {})

		if menu == #opts then
			InstanceTestNpc.createInstance(player, npc)
		else
			if cave == instances[player_instances[menu].index].level then
				player:sendAnimationXY(406, player.x, player.y, 1)
				player:warp(
					instances[player_instances[menu].index].start_map,
					instances[player_instances[menu].index].map_coords[1],
					instances[player_instances[menu].index].map_coords[2]
				)
			else
				player:dialogSeq(
					{
						t,
						"You do not meet the requirements to enter this dungeon."
					},
					1
				)
			end
		end
	end),
	action = function(npc)
		if (#instances > 0) then
			for i = 0, #instances[instance_check_counter].maps - 1 do
				local players = npc:getObjectsInMap(
					instances[instance_check_counter].start_map + i,
					BL_PC
				)
				if #players > 0 then
					for k = 1, #players do
						local found = false
						for g = 1, #instances[instance_check_counter].group do
							if instances[instance_check_counter].group[g] == players[k].ID then
								found = true
							end
						end
						if found == false then
							players[k]:warp(4259, 15, 14)
						end
					end
				end
			end
			instance_check_counter = instance_check_counter + 1
			if instance_check_counter > #instances then
				instance_check_counter = 1
			end

			-----------------------
			for i = 1, #instances do
				if instances[i].special == false then
					for k = 1, #instances[i].maps do
						local players = npc:getObjectsInMap(
							instances[i].maps[k],
							BL_PC
						)
						local text = ""
						local teeming = false
						local kills = instances[i].kills
						local kills_required = 200

						if kills > kills_required then
							kills = kills_required
						end

						for g = 1, #instances[i].modifiers do
							text = text .. "" .. maps.formatModifierString(
								instances[i].modifiers[g].modifier,
								instances[i].modifiers[g].value
							)
							text = text .. "\n"

							if instances[i].modifiers[g].modifier == "teeming" then
								teeming = true
							end
						end

						text = text .. "Kills: " .. kills .. "/" .. kills_required .. "\n"
						text = text .. "Time left: " .. (instances[i].start + 3600) - os.time() .. " seconds"

						if #players > 0 then
							for z = 1, #players do
								if instances[i].special == false then
									players[z]:guitext(text)
								end
							end
						end

						if kills >= kills_required and instances[i].boss_spawned == false then
							local boss_map = math.random(
								instances[i].maps[1],
								instances[i].maps[#instances[i].maps]
							)
							instances[i].boss_spawned = true
							broadcast2(
								instances[i].maps,
								"A powerful enemy approaches..."
							)
							InstanceTestNpc.spawnBoss(npc, boss_map, i)
						end

						if teeming == false then
							if instances[i].level == 2 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{696},
									{40},
									420
								)
							end
							if instances[i].level == 3 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{697},
									{40},
									420
								)
							end
							if instances[i].level == 4 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{698},
									{40},
									420
								)
							end
						else
							if instances[i].level == 2 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{696},
									{55},
									420
								)
							end
							if instances[i].level == 3 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{697},
									{55},
									420
								)
							end
							if instances[i].level == 4 then
								MobSpawnHandlerNpc.handleSpawn(
									npc,
									instances[i].maps[k],
									{698},
									{55},
									420
								)
							end
						end
					end
				elseif instances[i].special == true then
					if instances[i].map_type_yname == "druid_instance" then
						druid_instance_quest.quest(
							instances[i].maps,
							instances[i].owner
						)
					end
					if instances[i].map_type_yname == "underground_casino" then
						underground_casino_quest.quest(
							instances[i].maps,
							instances[i].owner
						)
					end
				end

				if os.time() > instances[i].start + 3600 then
					for k = 0, #instances[i].maps - 1 do
						broadcast(
							instances[i].start_map + k,
							"Forceful winds push you back."
						)
						local players = npc:getObjectsInMap(
							instances[i].start_map + k,
							BL_PC
						)
						local mobs = npc:getObjectsInMap(
							instances[i].start_map + k,
							BL_MOB
						)
						local npcs = npc:getObjectsInMap(
							instances[i].start_map + k,
							BL_NPC
						)
						spawnTable[instances[i].start_map + k] = {}
						if #players > 0 then
							for g = 1, #players do
								players[g]:warp(4259, 15, 14)
								players[g]:updateState()
							end
						end
						if #mobs > 0 then
							for g = 1, #mobs do
								mobs[g]:delete()
								mobs[g] = nil
							end
						end
						if #npcs > 0 then
							for g = 1, #npcs do
								removeTrapItem(npcs[g])
								npcs[g]:delete()
							end
						end
					end
					table.remove(instances, i)
					instance_check_counter = 1
				end
			end
		else
			instance_check_counter = 1
		end
	end,
	spawnBoss = function(npc, map, index)
		local minX = 0
		local maxX = getMapXMax(map)
		local minY = 0
		local maxY = getMapYMax(map)
		local mobCount = 0
		local fail = 0
		repeat
			local spawnX = math.random(minX, maxX)
			local spawnY = math.random(minY, maxY)

			local passCheck = getPass(map, spawnX, spawnY)
			local objCheck = getObject(map, spawnX, spawnY)
			local pcCheck = npc:getObjectsInCell(map, spawnX, spawnY, BL_PC)
			local mobCheck = npc:getObjectsInCell(map, spawnX, spawnY, BL_MOB)
			if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and not getWarp(
				map,
				spawnX,
				spawnY
			)) then
				if instances[index].level == 2 then
					npc:spawn(706, spawnX, spawnY, 1, map)
				end
				if instances[index].level == 3 then
					npc:spawn(705, spawnX, spawnY, 1, map)
				end
				if instances[index].level == 4 then
					npc:spawn(704, spawnX, spawnY, 1, map)
				end
				mobCount = mobCount + 1
			else
				fail = fail + 1
				if (fail >= 100) then
					mobCount = 100
				end
			end
		until mobCount >= 1
	end,
	createInstance = function(player, npc, special, displayname, maxsize)
		local warp_map = InstanceTestNpc.findOpenInstance()

		-- need to determine the map the player is warped to
		local instance_set_index = 0
		local coords = {}
		local maps = {}
		local selected_item
		local mapMods

		if special == nil then
			local mapChoice = player:sell(
				"Please select the map you wish to explore",
				mapTypes
			)
			local selection = player:getInventoryItem(mapChoice - 1)
			selected_item = {
				name = selection.name,
				yname = selection.yname,
				custom = selection.custom
			}
			mapMods = getMapModifiers(selected_item.custom)

			player:removeItem(selected_item.yname, 1)
		else
			if displayname ~= nil then
				selected_item = {name = displayname, yname = special}
			else
				selected_item = {name = "instance", yname = special}
			end
		end

		for k = 1, #instance_sets do
			if (instance_sets[k].map_required == selected_item.yname) then
				coords = instance_sets[k].start_coords
				instance_set_index = k
			end
		end

		local modifiers = {}
		local values = {}
		local player_modifiers = {}

		if mapMods ~= nil then
			for i = 1, #mapMods, 2 do
				table.insert(player_modifiers, {
					modifier = mapMods[i],
					value = mapMods[i + 1],
					range = InstanceTestNpc.getMapModifierRange(mapMods[i])
				})
			end
		end

		-- 1 = 99 - under ilsan
		-- 2 = ilsan - under ee san
		-- 3 = eesan +

		local player_cave_level = 1

		if player.level >= 99 then
			player_cave_level = 2
		end

		if player.baseHealth >= 160000 or player.baseMagic >= 80000 then
			player_cave_level = 3
		end

		if player.baseHealth >= 320000 or player.baseMagic >= 160000 then
			player_cave_level = 4
		end

		for z = 1, #instance_sets[instance_set_index].maps do
			local map = instance_sets[instance_set_index].maps[z]

			for g = string.len(map), 5 do
				map = "0" .. map
			end

			setMap(
				(warp_map + z) - 1,
				"../rtkmaps/Accepted/TK" .. map .. ".map",
				instance_sets[instance_set_index].name .. " " .. player_cave_level,
				0,
				0,
				0,
				1,
				0,
				0,
				3600000,
				0,
				0,
				5,
				1,
				1,
				0
			)
			setMapRegistry(
				(warp_map + z) - 1,
				"moblook",
				instance_sets[instance_set_index].mob_look
			)
			setMapRegistry(
				(warp_map + z) - 1,
				"moblookcolor",
				instance_sets[instance_set_index].mob_look_color
			)
			setMapAttribute((warp_map + z) - 1, "maxLvl", 99)
			setMapAttribute((warp_map + z) - 1, "maxVita", 4294967295)
			setMapAttribute((warp_map + z) - 1, "maxMana", 4294967295)
			setMapAttribute((warp_map + z) - 1, "canUse", 1)
			setMapAttribute((warp_map + z) - 1, "canSmoke", 1)
			setMapAttribute((warp_map + z) - 1, "canEat", 1)
			setMapAttribute((warp_map + z) - 1, "canMount", 1)
			setMapAttribute((warp_map + z) - 1, "canGroup", 1)
			table.insert(maps, (warp_map + z) - 1)

			local shrine_rand = math.random(1, 4)

			if shrine_rand == 1 and special == nil then
				local minX = 0
				local maxX = getMapXMax((warp_map + z) - 1)
				local minY = 0
				local maxY = getMapYMax((warp_map + z) - 1)
				local mobCount = 0
				local fail = 0
				repeat
					local spawnX = math.random(minX, maxX)
					local spawnY = math.random(minY, maxY)

					local passCheck = getPass(
						(warp_map + z) - 1,
						spawnX,
						spawnY
					)
					local objCheck = getObject(
						(warp_map + z) - 1,
						spawnX,
						spawnY
					)
					local pcCheck = npc:getObjectsInCell(
						(warp_map + z) - 1,
						spawnX,
						spawnY,
						BL_PC
					)
					local mobCheck = npc:getObjectsInCell(
						(warp_map + z) - 1,
						spawnX,
						spawnY,
						BL_MOB
					)
					if (passCheck == 0 and #pcCheck == 0 and #mobCheck == 0 and objCheck == 0 and not getWarp(
						(warp_map + z) - 1,
						spawnX,
						spawnY
					)) then
						npc:spawn(703, spawnX, spawnY, 1, (warp_map + z) - 1)
						mobCount = mobCount + 1
					else
						fail = fail + 1
						if (fail >= 100) then
							mobCount = 100
						end
					end
				until mobCount >= 1
			end
		end

		for z = 1, #instance_sets[instance_set_index].maps do
			local map_warps = getWarps(instance_sets[instance_set_index].maps[z])

			for i = 1, #map_warps, 6 do
				local source_map = 0
				local source_x = 0
				local source_y = 0
				local dest_map = 330
				local dest_x = 15
				local dest_y = 15

				source_map = map_warps[i]
				source_x = map_warps[i + 1]
				source_y = map_warps[i + 2]
				dest_map = map_warps[i + 3]
				dest_x = map_warps[i + 4]
				dest_y = map_warps[i + 5]

				if InstanceTestNpc.checkMapExists(source_map, instance_set_index) and InstanceTestNpc.checkMapExists(
					dest_map,
					instance_set_index
				) then
					local source_map_index = InstanceTestNpc.getMapIndex(
						source_map,
						instance_set_index
					)
					local destination_map_index = InstanceTestNpc.getMapIndex(
						dest_map,
						instance_set_index
					)
					setWarps(
						(warp_map - 1) + source_map_index,
						source_x,
						source_y,
						(warp_map - 1) + destination_map_index,
						dest_x,
						dest_y
					)
				end
			end
		end

		setWarps(
			warp_map,
			instance_sets[instance_set_index].exit_coords[1],
			instance_sets[instance_set_index].exit_coords[2],
			4259,
			15,
			15
		)

		for z = 1, #player.group do
			local pc = Player(player.group[z])
			if pc.m == 4259 then
				if InstanceTestNpc.getPlayerCaveLevel(pc) == player_cave_level then
					pc:sendAnimationXY(406, pc.x, pc.y, 1)
					pc:warp(
						warp_map,
						instance_sets[instance_set_index].start_coords[1],
						instance_sets[instance_set_index].start_coords[2]
					)
					pc:updateState()
				else
					pc:sendMinitext("A party member opened a dungeon you can not enter.")
				end
			end

			if special ~= nil and maxsize ~= nil and #player.group <= maxsize then
				if InstanceTestNpc.getPlayerCaveLevel(pc) == player_cave_level then
					pc:sendAnimationXY(406, pc.x, pc.y, 1)
					pc:warp(
						warp_map,
						instance_sets[instance_set_index].start_coords[1],
						instance_sets[instance_set_index].start_coords[2]
					)
					pc:updateState()
				else
					pc:sendMinitext("Your group size does not meet the requirements: " .. maxsize)
				end
			else
				pc:sendMinitext("Error opening dungeon")
			end
		end

		table.insert(instances, {
			owner = player.name,
			start = os.time(),
			group = player.group,
			modifiers = player_modifiers,
			map_type = selected_item.name,
			map_type_yname = selected_item.yname,
			level = player_cave_level,
			start_map = warp_map,
			start_warps = {},
			map_coords = coords,
			maps = maps,
			kills = 0,
			boss_spawned = false,
			special = instance_sets[instance_set_index].special
		})
	end,
	getPlayerCaveLevel = function(player)
		local player_cave_level = 1

		if player.level >= 99 then
			player_cave_level = 2
		end

		if player.baseHealth >= 160000 or player.baseMagic >= 80000 then
			player_cave_level = 3
		end

		if player.baseHealth >= 320000 or player.baseMagic >= 160000 then
			player_cave_level = 4
		end

		return player_cave_level
	end,
	getMapModifierRange = function(modifier)
		local range = {}
		for i = 1, #mapMods2 do
			if mapMods2[i].modifier == modifier then
				range = mapMods2[i].range
			end
		end
		return range
	end,
	getInstancesOpenForPlayer = function(player)
		local player_instances = {}
		for i = 1, #instances do
			for k = 1, #instances[i].group do
				if (instances[i].group[k] == player.ID) then
					table.insert(player_instances, i)
				end
			end
		end
		return player_instances
	end,
	getInstanceIndex = function(player)
		for i = 1, #instances do
			if (instances[i].owner == player.name) then
				return i
			end
		end
	end,
	checkMapExists = function(map, index)
		local found = false
		for i = 1, #instance_sets[index].maps do
			if instance_sets[index].maps[i] == map then
				found = true
			end
		end
		return found
	end,
	getMapIndex = function(map, index)
		local val = 0
		for i = 1, #instance_sets[index].maps do
			if instance_sets[index].maps[i] == map then
				val = i
			end
		end
		return val
	end,
	findOpenInstance = function()
		for i = 60000, 65000, 20 do
			local found = false
			for k = 1, #instances do
				if i == instances[k].start_map then
					found = true
				end
			end
			if found == false then
				return i
			end
		end
		return "no instance"
	end
}
