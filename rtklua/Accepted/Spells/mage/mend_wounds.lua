mend_wounds_mage = {
	cast = function(player, target)
		local spellName = "Mend Wounds"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 100, 80, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("bears_liver").id, Item("ginseng").id}
		local itemAmounts = {5, 1}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

spiritual_cure_mage = {
	cast = function(player, target)
		local spellName = "Spiritual Cure"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 100, 80, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("bears_liver").id, Item("ginseng").id}
		local itemAmounts = {5, 1}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

natures_kiss_mage = {
	cast = function(player, target)
		local spellName = "Nature's Kiss"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 100, 80, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("bears_liver").id, Item("ginseng").id}
		local itemAmounts = {5, 1}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

cooling_touch_mage = {
	cast = function(player, target)
		local spellName = "Cooling Touch"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 100, 80, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("bears_liver").id, Item("ginseng").id}
		local itemAmounts = {5, 1}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}
