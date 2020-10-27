bekyuns_heal_mage = {
	cast = function(player, target)
		local spellName = "Bekyun's Heal"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 4000, 1200, 0)
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
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 4000."
		return level, items, itemAmounts, description
	end
}

death_denied_mage = {
	cast = function(player, target)
		local spellName = "Death Denied"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 4000, 1200, 1)
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
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 4000."
		return level, items, itemAmounts, description
	end
}

one_with_life_mage = {
	cast = function(player, target)
		local spellName = "One with Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 4000, 1200, 2)
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
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 4000."
		return level, items, itemAmounts, description
	end
}

balanced_touch_mage = {
	cast = function(player, target)
		local spellName = "Balanced Touch"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 4000, 1200, 3)
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
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 4000."
		return level, items, itemAmounts, description
	end
}
