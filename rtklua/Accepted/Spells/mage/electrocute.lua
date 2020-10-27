electrocute_mage = {
	cast = function(player)
		local spellName = "Electrocute"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 200 + (player.level * 4) + math.floor(((player.will + 1) / 2) * 4)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 250) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 250
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_zap.cast(player, target[1], damage, 0, 0)
			end

			target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_zap.cast(player, target[1], damage, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 64
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}

eater_of_the_dead_mage = {
	cast = function(player)
		local spellName = "Eater of the Dead"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 200 + (player.level * 4) + math.floor(((player.will + 1) / 2) * 4)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 250) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 250
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_zap.cast(player, target[1], damage, 0, 1)
			end

			target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_zap.cast(player, target[1], damage, 0, 1)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 64
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}

forests_discord_mage = {
	cast = function(player)
		local spellName = "Forest's Discord"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 200 + (player.level * 4) + math.floor(((player.will + 1) / 2) * 4)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 250) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 250
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_zap.cast(player, target[1], damage, 0, 2)
			end

			target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_zap.cast(player, target[1], damage, 0, 2)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 64
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}

shatter_storm_mage = {
	cast = function(player)
		local spellName = "Shatter Storm"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 200 + (player.level * 4) + math.floor(((player.will + 1) / 2) * 4)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 250) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 250
		player:sendStatus()

		for i = 1, 4 do
			local target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_MOB
			)
			if #target > 0 then
				global_zap.cast(player, target[1], damage, 0, 3)
			end

			target = player:getObjectsInCell(
				player.m,
				player.x + x[i],
				player.y + y[i],
				BL_PC
			)
			if #target > 0 then
				local worked = global_zap.cast(player, target[1], damage, 0, 3)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 64
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {70, 1, 500}
		local description = "Strike your surroundings with a strong lightning attack."
		return level, items, itemAmounts, description
	end
}
