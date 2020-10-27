tempest_mage = {
	cast = function(player)
		local spellName = "Tempest"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 250 + (player.level * 5) + math.floor(((player.will + 1) / 2) * 5)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 310) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 310
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
		local level = 85
		local items = {Item("gold_acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {3, 2, 2000}
		local description = "Strike your surroundings with a potent lightning attack."
		return level, items, itemAmounts, description
	end
}

dance_macabre_mage = {
	cast = function(player)
		local spellName = "Dance Macabre"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 250 + (player.level * 5) + math.floor(((player.will + 1) / 2) * 5)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 310) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 310
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
		local level = 85
		local items = {Item("gold_acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {3, 2, 2000}
		local description = "Strike your surroundings with a potent lightning attack."
		return level, items, itemAmounts, description
	end
}

wilding_mage = {
	cast = function(player)
		local spellName = "Wilding"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 250 + (player.level * 5) + math.floor(((player.will + 1) / 2) * 5)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 310) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 310
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
		local level = 85
		local items = {Item("gold_acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {3, 2, 2000}
		local description = "Strike your surroundings with a potent lightning attack."
		return level, items, itemAmounts, description
	end
}

chain_lightning_mage = {
	cast = function(player)
		local spellName = "Chain Lightning"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 250 + (player.level * 5) + math.floor(((player.will + 1) / 2) * 5)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 310) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 310
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
		local level = 85
		local items = {Item("gold_acorn").id, Item("dark_amber").id, 0}
		local itemAmounts = {3, 2, 2000}
		local description = "Strike your surroundings with a potent lightning attack."
		return level, items, itemAmounts, description
	end
}
