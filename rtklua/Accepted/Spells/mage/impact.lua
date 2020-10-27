impact_mage = {
	cast = function(player, target)
		local spellName = "Impact"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, 120, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 41
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 250}
		local description = "A substantial elemental attack."
		return level, items, itemAmounts, description
	end
}

soul_spike_mage = {
	cast = function(player, target)
		local spellName = "Soul Spike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, 120, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 41
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 250}
		local description = "A substantial elemental attack."
		return level, items, itemAmounts, description
	end
}

treefall_mage = {
	cast = function(player, target)
		local spellName = "Treefall"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, 120, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 41
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 250}
		local description = "A substantial elemental attack."
		return level, items, itemAmounts, description
	end
}

shatter_mage = {
	cast = function(player, target)
		local spellName = "Shatter"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, 120, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 41
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 250}
		local description = "A substantial elemental attack."
		return level, items, itemAmounts, description
	end
}
