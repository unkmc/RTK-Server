explode_mage = {
	cast = function(player)
		local spellName = "Explode"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 180) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 180
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
		local level = 42
		local items = {Item("acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {100, 10, 100}
		local description = "Strike your surroundings with a moderate lightning attack."
		return level, items, itemAmounts, description
	end
}

soul_chasm_mage = {
	cast = function(player)
		local spellName = "Soul Chasm"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 180) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 180
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
		local level = 42
		local items = {Item("acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {100, 10, 100}
		local description = "Strike your surroundings with a moderate lightning attack."
		return level, items, itemAmounts, description
	end
}

winters_vortex_mage = {
	cast = function(player)
		local spellName = "Winter's Vortex"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 180) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 180
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
		local level = 42
		local items = {Item("acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {100, 10, 100}
		local description = "Strike your surroundings with a moderate lightning attack."
		return level, items, itemAmounts, description
	end
}

volcano_mage = {
	cast = function(player)
		local spellName = "Volcano"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 180) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 180
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
		local level = 42
		local items = {Item("acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {100, 10, 100}
		local description = "Strike your surroundings with a moderate lightning attack."
		return level, items, itemAmounts, description
	end
}
