heavens_kiss_poet = {
	cast = function(player)
		local spellName = "Heaven's Kiss"
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 390) then
			player:sendMinitext("Not enough mana.")
			return
		end

		player.magic = player.magic - 390
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_heal.cast(player, target[1], 1000, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 80
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {80, 1, 800}
		local description = "Heal those around you for a large amount."
		return level, items, itemAmounts, description
	end
}

clan_of_souls_poet = {
	cast = function(player)
		local spellName = "Clan of Souls"
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 390) then
			player:sendMinitext("Not enough mana.")
			return
		end

		player.magic = player.magic - 390
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_heal.cast(player, target[1], 1000, 0, 1)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 80
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {80, 1, 800}
		local description = "Heal those around you for a large amount."
		return level, items, itemAmounts, description
	end
}

healing_hand_poet = {
	cast = function(player)
		local spellName = "Healing Hand"
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 390) then
			player:sendMinitext("Not enough mana.")
			return
		end

		player.magic = player.magic - 390
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_heal.cast(player, target[1], 1000, 0, 2)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 80
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {80, 1, 800}
		local description = "Heal those around you for a large amount."
		return level, items, itemAmounts, description
	end
}

earths_embrace_poet = {
	cast = function(player)
		local spellName = "Earth's Embrace"
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 390) then
			player:sendMinitext("Not enough mana.")
			return
		end

		player.magic = player.magic - 390
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_heal.cast(player, target[1], 1000, 0, 3)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 80
		local items = {Item("acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {80, 1, 800}
		local description = "Heal those around you for a large amount."
		return level, items, itemAmounts, description
	end
}
