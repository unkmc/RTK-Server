hunangs_relief_warrior = {
	cast = function(player)
		local spellName = "Hunang's Relief"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 800, 800, 0)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 25000}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

from_the_brink_warrior = {
	cast = function(player)
		local spellName = "From the Brink"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 800, 800, 1)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 25000}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

natures_slave_warrior = {
	cast = function(player)
		local spellName = "Nature's Slave"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 800, 800, 2)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 25000}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}

lifes_essence_warrior = {
	cast = function(player)
		local spellName = "Life's Essence"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 800, 800, 3)
		if worked == 1 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 25000}
		local description = "A minor self-heal spell."
		return level, items, itemAmounts, description
	end
}
