stormstrike_mage = {
	cast = function(player, target)
		local spellName = "Stormstrike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 125 + (player.level * 4) + math.ceil(((player.will + 1) / 2) * 3.5)
		local worked = global_zap.cast(player, target, damage, 150, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 77
		local items = {Item("dark_amber").id, Item("steel_saber").id, 0}
		local itemAmounts = {3, 1, 2500}
		local description = "A powerful elemental attack."
		return level, items, itemAmounts, description
	end
}

river_of_blood_mage = {
	cast = function(player, target)
		local spellName = "River of Blood"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 125 + (player.level * 4) + math.ceil(((player.will + 1) / 2) * 3.5)
		local worked = global_zap.cast(player, target, damage, 150, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 77
		local items = {Item("dark_amber").id, Item("steel_saber").id, 0}
		local itemAmounts = {3, 1, 2500}
		local description = "A powerful elemental attack."
		return level, items, itemAmounts, description
	end
}

natural_disaster_mage = {
	cast = function(player, target)
		local spellName = "Natural Disaster"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 125 + (player.level * 4) + math.ceil(((player.will + 1) / 2) * 3.5)
		local worked = global_zap.cast(player, target, damage, 150, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 77
		local items = {Item("dark_amber").id, Item("steel_saber").id, 0}
		local itemAmounts = {3, 1, 2500}
		local description = "A powerful elemental attack."
		return level, items, itemAmounts, description
	end
}

winds_of_disaster_mage = {
	cast = function(player, target)
		local spellName = "Winds of Disaster"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 125 + (player.level * 4) + math.ceil(((player.will + 1) / 2) * 3.5)
		local worked = global_zap.cast(player, target, damage, 150, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 77
		local items = {Item("dark_amber").id, Item("steel_saber").id, 0}
		local itemAmounts = {3, 1, 2500}
		local description = "A powerful elemental attack."
		return level, items, itemAmounts, description
	end
}
