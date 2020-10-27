refresh_rogue = {
	cast = function(player, target)
		local spellName = "Refresh"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 600, 400, 0)
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
		local description = "Heals a target for a moderate amount of health."
		return level, items, itemAmounts, description
	end
}

souls_awakening_rogue = {
	cast = function(player, target)
		local spellName = "Soul's Awakening"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 600, 400, 1)
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
		local description = "Heals a target for a moderate amount of health."
		return level, items, itemAmounts, description
	end
}

healing_waters_rogue = {
	cast = function(player, target)
		local spellName = "Healing Waters"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 600, 400, 2)
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
		local description = "Heals a target for a moderate amount of health."
		return level, items, itemAmounts, description
	end
}

fire_dance_rogue = {
	cast = function(player, target)
		local spellName = "Fire Dance"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 600, 400, 3)
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
		local description = "Heals a target for a moderate amount of health."
		return level, items, itemAmounts, description
	end
}
