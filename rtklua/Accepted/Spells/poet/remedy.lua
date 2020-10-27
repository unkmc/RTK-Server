remedy_poet = {
	cast = function(player)
		local spellName = "Remedy"
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
				local worked = global_heal.cast(player, target[1], 500, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "Heal those around you for a moderate amount."
		return level, items, itemAmounts, description
	end
}

brethren_of_spirits_poet = {
	cast = function(player)
		local spellName = "Brethren of Spirits"
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
				local worked = global_heal.cast(player, target[1], 500, 0, 1)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "Heal those around you for a moderate amount."
		return level, items, itemAmounts, description
	end
}

gathering_of_the_flock_poet = {
	cast = function(player)
		local spellName = "Gathering of the Flock"
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
				local worked = global_heal.cast(player, target[1], 500, 0, 2)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "Heal those around you for a moderate amount."
		return level, items, itemAmounts, description
	end
}

gathering_of_majesty_poet = {
	cast = function(player)
		local spellName = "Gathering of Majesty"
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
				local worked = global_heal.cast(player, target[1], 500, 0, 3)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "Heal those around you for a moderate amount."
		return level, items, itemAmounts, description
	end
}
