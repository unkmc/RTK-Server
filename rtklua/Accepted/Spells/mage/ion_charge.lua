ion_charge_mage = {
	cast = function(player)
		local spellName = "Ion Charge"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 120) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 120
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
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("light_fox_fur").id,
			Item("moon_wine").id,
			0
		}
		local itemAmounts = {1, 25, 1, 150}
		local description = "Strike your surroundings with a lightning attack."
		return level, items, itemAmounts, description
	end
}

crescendo_mage = {
	cast = function(player)
		local spellName = "Crescendo"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 120) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 120
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
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("light_fox_fur").id,
			Item("moon_wine").id,
			0
		}
		local itemAmounts = {1, 25, 1, 150}
		local description = "Strike your surroundings with a lightning attack."
		return level, items, itemAmounts, description
	end
}

flight_of_arrows_mage = {
	cast = function(player)
		local spellName = "Flight of Arrows"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 120) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 120
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
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("light_fox_fur").id,
			Item("moon_wine").id,
			0
		}
		local itemAmounts = {1, 25, 1, 150}
		local description = "Strike your surroundings with a lightning attack."
		return level, items, itemAmounts, description
	end
}

blazing_sands_mage = {
	cast = function(player)
		local spellName = "Blazing Sands"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local x = {-1, 0, 1, 0}
		local y = {0, -1, 0, 1}

		if (player.magic < 120) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 120
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
		local level = 32
		local items = {
			Item("gold_acorn").id,
			Item("light_fox_fur").id,
			Item("moon_wine").id,
			0
		}
		local itemAmounts = {1, 25, 1, 150}
		local description = "Strike your surroundings with a lightning attack."
		return level, items, itemAmounts, description
	end
}
