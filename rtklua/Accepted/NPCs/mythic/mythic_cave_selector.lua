local _easy = "The easy one"
local _dangerous = "The dangerous one"
local _deadly = "The deadly one"

local _warps = {
	["Rabbit"] = {map = 201, x = 13, y = 19},
	["Monkey"] = {map = 160, x = 1, y = 1},
	["Dog"] = {map = 191, x = 11, y = 27},
	["Rooster"] = {map = 214, x = 9, y = 58},
	["Rat"] = {map = 151, x = 12, y = 18},
	["Horse"] = {map = 246, x = 7, y = 22},
	["Ox"] = {map = 170, x = 2, y = 27},
	["Pig"] = {map = 181, x = 26, y = 22},
	["Snake"] = {map = 231, x = 17, y = 1},
	["Sheep"] = {map = 470, x = 14, y = 12},
	["Tiger"] = {map = 100, x = 30, y = 4},
	["Dragon"] = {map = 257, x = 17, y = 10}
}

MythicCaveSelector = {
	click = async(function(player, mobName, maxCaveLevel)
		local destination = _warps[mobName]

		if (maxCaveLevel < 1) then
			player:warp(41, player.x, player.y + 1)

			local message = "You are not yet ready to enter here."

			if (maxCaveLevel == 0) then
				message = "You almost understand the secrets of this entrance."
			elseif (maxCaveLevel == -2) then
				message = "Nightmarish visions of your own death repel you."
			end

			player:sendMinitext(message)
			return
		end

		if (maxCaveLevel == 1) then
			player:warp(destination.map, destination.x, destination.y)
			return
		end

		local npc = NPC("Mythic " .. mobName)

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {
			_easy,
			_dangerous
		}

		if (maxCaveLevel > 2) then
			table.insert(opts, _deadly)
		end

		local choice = opts[maxCaveLevel]

		if (player.gmLevel > 0 or Config.mythicCaveSelectEnabled) then
			choice = player:menuString("You see multiple paths before you. Which will you choose?", opts)
		end

		local caveNumber = 1
		local destinationMap = destination.map

		if (choice == _dangerous) then
			destinationMap = destination.map + 3000
			caveNumber = 2
		elseif (choice == _deadly) then
			destinationMap = destination.map + 4000
			caveNumber = 3
		elseif (not choice == _easy) then
			player:warp(41, player.x, player.y + 1)
			return
		end

		player:warp(destinationMap, destination.x, destination.y)
		player:sendMinitext("Entering Mythic " .. mobName .. " " .. caveNumber)
	end)
}
