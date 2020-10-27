call_lightning_mage = {
	cast = function(player, target)
		local spellName = "Call Lightning"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local worked = global_zap.cast(player, target, damage, 120, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 54
		local items = {Item("gold_acorn").id, Item("scribes_pen").id, 0}
		local itemAmounts = {1, 1, 500}
		local description = "A potent elemental attack."
		return level, items, itemAmounts, description
	end
}

death_scream_mage = {
	cast = function(player, target)
		local spellName = "Death Scream"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local worked = global_zap.cast(player, target, damage, 120, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 54
		local items = {Item("gold_acorn").id, Item("scribes_pen").id, 0}
		local itemAmounts = {1, 1, 500}
		local description = "A potent elemental attack."
		return level, items, itemAmounts, description
	end
}

natures_wounding_mage = {
	cast = function(player, target)
		local spellName = "Nature's Wounding"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local worked = global_zap.cast(player, target, damage, 120, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 54
		local items = {Item("gold_acorn").id, Item("scribes_pen").id, 0}
		local itemAmounts = {1, 1, 500}
		local description = "A potent elemental attack."
		return level, items, itemAmounts, description
	end
}

rain_of_fire_mage = {
	cast = function(player, target)
		local spellName = "Rain of Fire"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 150 + (player.level * 3) + math.floor(((player.will + 1) / 2) * 3)
		local worked = global_zap.cast(player, target, damage, 120, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 54
		local items = {Item("gold_acorn").id, Item("scribes_pen").id, 0}
		local itemAmounts = {1, 1, 500}
		local description = "A potent elemental attack."
		return level, items, itemAmounts, description
	end
}
