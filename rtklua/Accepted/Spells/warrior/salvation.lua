salvation_warrior = {
	cast = function(player)
		local spellName = "Salvation"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 500, 400, 0)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "A self-heal spell."
		return level, items, itemAmounts, description
	end
}

redemption_warrior = {
	cast = function(player)
		local spellName = "Redemption"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 500, 400, 1)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "A self-heal spell."
		return level, items, itemAmounts, description
	end
}

ointment_of_light_warrior = {
	cast = function(player)
		local spellName = "Ointment of Light"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 500, 400, 2)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "A self-heal spell."
		return level, items, itemAmounts, description
	end
}

return_of_life_warrior = {
	cast = function(player)
		local spellName = "Return of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 500, 400, 3)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 10000}
		local description = "A self-heal spell."
		return level, items, itemAmounts, description
	end
}
