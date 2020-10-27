rejuvenate_mage = {
	cast = function(player, target)
		local spellName = "Rejuvenate"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 800, 180, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 10000}
		local description = "Heals a target for 800."
		return level, items, itemAmounts, description
	end
}

still_embrace_mage = {
	cast = function(player, target)
		local spellName = "Still Embrace"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 800, 180, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 10000}
		local description = "Heals a target for 800."
		return level, items, itemAmounts, description
	end
}

infuse_life_mage = {
	cast = function(player, target)
		local spellName = "Infuse Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 800, 180, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 10000}
		local description = "Heals a target for 800."
		return level, items, itemAmounts, description
	end
}

healing_rain_mage = {
	cast = function(player, target)
		local spellName = "Healing Rain"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 800, 180, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 10000}
		local description = "Heals a target for 800."
		return level, items, itemAmounts, description
	end
}
