inferno_mage = {
	cast = function(player, target)
		local spellName = "Inferno"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 1.5)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 600) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 30)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 30)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:setAether("inferno_mage", 70000)
		player.magic = 0
		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {500000}
		local description = "5 way Hellfire Attack"
		return level, items, itemAmounts, description
	end
}

deaths_door_mage = {
	cast = function(player, target)
		local spellName = "Death's Door"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 1.5)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 600) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 31)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 31)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:setAether("deaths_door_mage", 70000)
		player.magic = 0
		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {500000}
		local description = "5 way Hellfire Attack"
		return level, items, itemAmounts, description
	end
}

natures_denial_mage = {
	cast = function(player, target)
		local spellName = "Nature's Denial"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 1.5)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 600) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 32)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 32)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:setAether("natures_denial_mage", 70000)
		player.magic = 0
		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {500000}
		local description = "5 way Hellfire Attack"
		return level, items, itemAmounts, description
	end
}

steel_storm_mage = {
	cast = function(player, target)
		local spellName = "Steel Storm"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic * 1.5)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 600) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 33)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 33)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:setAether("steel_storm_mage", 70000)
		player.magic = 0
		player:sendStatus()
		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {500000}
		local description = "5 way Hellfire Attack"
		return level, items, itemAmounts, description
	end
}
