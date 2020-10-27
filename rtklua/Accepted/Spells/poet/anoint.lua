anoint_poet = {
	cast = function(player)
		local spellName = "Anoint"

		if not player:canCast(1, 1, 0) then
			return
		end

		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

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
				local worked = global_heal.cast(player, target[1], 200, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 28
		local items = {Item("aged_wine").id, 0}
		local itemAmounts = {1, 100}
		local description = "Heal those around you."
		return level, items, itemAmounts, description
	end
}

brothers_of_spirit_poet = {
	cast = function(player)
		local spellName = "Brother's of Spirit"

		if not player:canCast(1, 1, 0) then
			return
		end

		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

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
				local worked = global_heal.cast(player, target[1], 200, 0, 1)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 28
		local items = {Item("aged_wine").id, 0}
		local itemAmounts = {1, 100}
		local description = "Heal those around you."
		return level, items, itemAmounts, description
	end
}

gathering_of_power_poet = {
	cast = function(player)
		local spellName = "Gathering of Power"

		if not player:canCast(1, 1, 0) then
			return
		end
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

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
				local worked = global_heal.cast(player, target[1], 200, 0, 2)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 28
		local items = {Item("aged_wine").id, 0}
		local itemAmounts = {1, 100}
		local description = "Heal those around you."
		return level, items, itemAmounts, description
	end
}

natures_family_poet = {
	cast = function(player)
		local spellName = "Nature's Family"

		if not player:canCast(1, 1, 0) then
			return
		end
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

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
				local worked = global_heal.cast(player, target[1], 200, 0, 3)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 28
		local items = {Item("aged_wine").id, 0}
		local itemAmounts = {1, 100}
		local description = "Heal those around you."
		return level, items, itemAmounts, description
	end
}
