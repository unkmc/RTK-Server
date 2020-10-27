vital_spark_poet = {
	cast = function(player)
		local spellName = "Vital Spark"
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
				local worked = global_heal.cast(player, target[1], 100, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 15
		local items = {Item("acorn").id, 0}
		local itemAmounts = {50, 100}
		local description = "Heal those around you for a small amount."
		return level, items, itemAmounts, description
	end
}

spirits_kiss_poet = {
	cast = function(player)
		local spellName = "Spirit's Kiss"
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
				local worked = global_heal.cast(player, target[1], 100, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 15
		local items = {Item("acorn").id, 0}
		local itemAmounts = {50, 100}
		local description = "Heal those around you for a small amount."
		return level, items, itemAmounts, description
	end
}

spark_of_health_poet = {
	cast = function(player)
		local spellName = "Spark of Health"
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
				local worked = global_heal.cast(player, target[1], 100, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 15
		local items = {Item("acorn").id, 0}
		local itemAmounts = {50, 100}
		local description = "Heal those around you for a small amount."
		return level, items, itemAmounts, description
	end
}

water_of_nature_poet = {
	cast = function(player)
		local spellName = "Water of Nature"
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
				local worked = global_heal.cast(player, target[1], 100, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 15
		local items = {Item("acorn").id, 0}
		local itemAmounts = {50, 100}
		local description = "Heal those around you for a small amount."
		return level, items, itemAmounts, description
	end
}
