ion_mage = {
	cast = function(player, target)
		local spellName = "Ion"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local worked = global_zap.cast(player, target, damage, 60, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 26
		local items = {Item("gold_acorn").id, Item("topaz").id}
		local itemAmounts = {1, 1}
		local description = "A decent elemental attack."
		return level, items, itemAmounts, description
	end
}

soul_strike_mage = {
	cast = function(player, target)
		local spellName = "Soul Strike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local worked = global_zap.cast(player, target, damage, 60, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 26
		local items = {Item("gold_acorn").id, Item("topaz").id}
		local itemAmounts = {1, 1}
		local description = "A decent elemental attack."
		return level, items, itemAmounts, description
	end
}

tree_dart_mage = {
	cast = function(player, target)
		local spellName = "Tree Dart"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local worked = global_zap.cast(player, target, damage, 60, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 26
		local items = {Item("gold_acorn").id, Item("topaz").id}
		local itemAmounts = {1, 1}
		local description = "A decent elemental attack."
		return level, items, itemAmounts, description
	end
}

sunstroke_mage = {
	cast = function(player, target)
		local spellName = "Sunstroke"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(25 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))
		local worked = global_zap.cast(player, target, damage, 60, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 26
		local items = {Item("gold_acorn").id, Item("topaz").id}
		local itemAmounts = {1, 1}
		local description = "A decent elemental attack."
		return level, items, itemAmounts, description
	end
}
