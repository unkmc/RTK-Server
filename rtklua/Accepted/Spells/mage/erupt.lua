erupt_mage = {
	cast = function(player)
		local spellName = "Erupt"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 80) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 80
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
		local level = 22
		local items = {Item("acorn").id, Item("topaz").id}
		local itemAmounts = {50, 2}
		local description = "Strike your surroundings with a weak elemental attack."
		return level, items, itemAmounts, description
	end
}

soulstorm_mage = {
	cast = function(player)
		local spellName = "Soulstorm"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 80) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 80
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
		local level = 22
		local items = {Item("acorn").id, Item("topaz").id}
		local itemAmounts = {50, 2}
		local description = "Strike your surroundings with a weak elemental attack."
		return level, items, itemAmounts, description
	end
}

avalanche_mage = {
	cast = function(player)
		local spellName = "Avalanche"
		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 80) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 80
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
		local level = 22
		local items = {Item("acorn").id, Item("topaz").id}
		local itemAmounts = {50, 2}
		local description = "Strike your surroundings with a weak elemental attack."
		return level, items, itemAmounts, description
	end
}

deluge_mage = {
	cast = function(player)
		local spellName = "Deluge"

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 80) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 80
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
		local level = 22
		local items = {Item("acorn").id, Item("topaz").id}
		local itemAmounts = {50, 2}
		local description = "Strike your surroundings with a weak elemental attack."
		return level, items, itemAmounts, description
	end
}
