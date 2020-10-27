lay_hands_mage = {
	cast = function(player)
		local spellName = "Lay Hands"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 100, 90, 0)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 21
		local items = {Item("ginseng").id, Item("light_fox_fur").id}
		local itemAmounts = {1, 10}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

spirits_smile_mage = {
	cast = function(player)
		local spellName = "Spirit's Smile"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 100, 90, 1)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 21
		local items = {Item("ginseng").id, Item("light_fox_fur").id}
		local itemAmounts = {1, 10}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

lifes_water_mage = {
	cast = function(player)
		local spellName = "Life's Water"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 100, 90, 2)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 21
		local items = {Item("ginseng").id, Item("light_fox_fur").id}
		local itemAmounts = {1, 10}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

quicken_mage = {
	cast = function(player)
		local spellName = "Quicken"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 100, 90, 3)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 21
		local items = {Item("ginseng").id, Item("light_fox_fur").id}
		local itemAmounts = {1, 10}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}
