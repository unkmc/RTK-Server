daggers_remedy_rogue = {
	cast = function(player)
		local spellName = "Dagger's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 4500, 3000, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {3, 75000}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

kwisin_daggers_remedy_rogue = {
	cast = function(player)
		local spellName = "Dagger's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 4500, 3000, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {3, 75000}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

mingken_daggers_remedy_rogue = {
	cast = function(player)
		local spellName = "Dagger's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 4500, 3000, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {3, 75000}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}

ohaeng_daggers_remedy_rogue = {
	cast = function(player)
		local spellName = "Dagger's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 4500, 3000, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {3, 75000}
		local description = "Heal yourself for a large amount."
		return level, items, itemAmounts, description
	end
}
