stream_of_life_poet = {
	cast = function(player, target)
		local spellName = "Stream of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 10000, 1000, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "Heals a target for 10000 vita."
		return level, items, itemAmounts, description
	end
}

purity_of_spirit_poet = {
	cast = function(player, target)
		local spellName = "Purity of Spirit"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 10000, 1000, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "Heals a target for 10000 vita."
		return level, items, itemAmounts, description
	end
}

natures_abundance_poet = {
	cast = function(player, target)
		local spellName = "Nature's Abundance"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 10000, 1000, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "Heals a target for 10000 vita."
		return level, items, itemAmounts, description
	end
}

forge_of_life_poet = {
	cast = function(player, target)
		local spellName = "Forge of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 10000, 1000, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "Heals a target for 10000 vita."
		return level, items, itemAmounts, description
	end
}
