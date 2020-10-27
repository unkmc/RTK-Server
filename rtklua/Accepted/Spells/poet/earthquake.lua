earthquake_poet = {
	cast = function(player, target)
		local spellName = "Earthquake"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 90) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 90
		player:sendStatus()

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 0)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 0)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 74
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 5, 500}
		local description = "Strike several enemies with lightning."
		return level, items, itemAmounts, description
	end
}

tossing_the_bones_poet = {
	cast = function(player, target)
		local spellName = "Tossing the Bones"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 90) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 90
		player:sendStatus()

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 1)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 1)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 74
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 5, 500}
		local description = "Strike several enemies with lightning."
		return level, items, itemAmounts, description
	end
}

natures_fury_poet = {
	cast = function(player, target)
		local spellName = "Nature's Fury"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 90) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 90
		player:sendStatus()

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 2)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 2)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 74
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 5, 500}
		local description = "Strike several enemies with lightning."
		return level, items, itemAmounts, description
	end
}

groundstrike_poet = {
	cast = function(player, target)
		local spellName = "Ground Strike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local x = {0, -1, 0, 1, 0}
		local y = {0, 0, -1, 0, 1}

		if (player.magic < 90) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - 90
		player:sendStatus()

		for i = 1, 5 do
			local hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_MOB
			)
			if #hits > 0 then
				global_zap.cast(player, hits[1], damage, 0, 3)
			end
			hits = target:getObjectsInCell(
				target.m,
				target.x + x[i],
				target.y + y[i],
				BL_PC
			)
			if #hits > 0 then
				local worked = global_zap.cast(player, hits[1], damage, 0, 3)
				if worked == 2 then
					target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
				end
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 35)
	end,

	requirements = function(player)
		local level = 74
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {80, 5, 500}
		local description = "Strike several enemies with lightning."
		return level, items, itemAmounts, description
	end
}
