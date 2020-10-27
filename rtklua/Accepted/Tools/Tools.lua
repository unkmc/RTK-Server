Tools = {
	-- ----------------------------------------------------------------------
	-- Prevents a player from talking to an NPC if his/her karma is too low.
	-- Note: This will end the entire call stack when triggered.
	-- ----------------------------------------------------------------------
	checkKarma = function(player)
		if player.karma <= -3 then
			player:dialogSeq({"Go away scum!"}, 0) -- @TODO: Have to rework this if you ever fix the fact that the 0 arg ends the entire call stack
			return
		end
	end,

	-- ------------------------------------------------------------------------------------
	-- Helper method for configuring the appearance of dialog boxes when talking to an NPC
	-- ------------------------------------------------------------------------------------
	configureDialog = function(player, npc, dialogType, lastClickNpcId)
		if (not dialogType) then
			dialogType = 0
		end

		if (not lastClickNpcId) then
			lastClickNpcId = npc.ID
		end

		local stateTable = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = stateTable.graphic
		player.npcColor = stateTable.color
		player.dialogType = 0
		player.lastClick = npc.ID

		return stateTable
	end,

	-- -------------------------------------------------------------------------------------------
	-- Causes the player to speak the name and location of every object on the current map.
	-- This does not appear to be in use anywhere, but it should be reworked to be a GM function.
	-- -------------------------------------------------------------------------------------------
	findObjectsInMap = function(player)
		local block = player:getObjectsInSameMap(BL_ALL)

		for z = 1, #block do
			player:talkSelf(0, block[z].name .. " " .. block[z].x .. " " .. block[z].y)
		end
	end,

	-- ---------------------------------------
	-- Returns a number formatted with commas
	-- ---------------------------------------
	formatNumber = function(value)
		local formattedValue = value
		local count

		while true do
			formattedValue, count = string.gsub(formattedValue, "^(-?%d+)(%d%d%d)", '%1,%2')

			if (count == 0) then
				break
			end
		end

		return formattedValue
	end,

	-- ------------------------------------------------------------------
	-- Returns true if a value is in between the values of the lower and
	-- upper bound parameters. Comparisons are inclusive.
	-- ------------------------------------------------------------------
	isBetween = function(value, lowerBound, upperBound)
		return value >= lowerBound and value <= upperBound
	end,

	-- ----------------------------------------------------------
	-- Rounds a number to the specified number of decimal places
	-- ----------------------------------------------------------
	round = function(value, numberOfDecimalPlaces)
		local mult = 10 ^ (numberOfDecimalPlaces or 0)
		return math.floor(value * mult + 0.5) / mult
	end,

	-- ------------------------------------------------------------------------------------------------
	-- Returns an arrary of values from a string delimited by commas, semicolons, pipes, and/or spaces
	-- ------------------------------------------------------------------------------------------------
	split = function(delimitedString)
		local values = {}

		for match in string.gmatch(delimitedString, '([^,;|%s]+)') do
			table.insert(values, match)
		end

		return values
	end,

	-- ---------------------------------------------------
	-- Returns true if a table contains the specified key
	-- ---------------------------------------------------
	tableContainsKey = function(table, key)
		return table[key] ~= nil
	end,

	-- -----------------------------------------------------
	-- Returns true if a table contains the specified value
	-- -----------------------------------------------------
	tableContainsValue = function(table, value)
		for _, v in pairs(table) do
			if (v == value) then
				return true
			end
		end

		return false
	end,

    -- --------------------------------------------------------------------
    -- This function is executed whenever a GM speaks "/testlua" or "/tl".
    -- --------------------------------------------------------------------
	testLua = function(player)
		player.registryString["waypoints"] = ""
		player:sendAnimation(11)
		player:playSound(29)

		player.registry["minor_quest_timer"] = 0
		player:sendMinitext("Minor quest timer reset!")

		player.registry["totem_worship_daily_timer"] = 0
		player:sendMinitext("Totem worship timer reset!")

		player.registry["carnagePrizeTime"] = 0
		player:sendMinitext("Carnage prize timer reset!")

		player:forceSave()
    end
}
