heal_poet = {
	cast = function(player, target)
		local spellName = "Heal"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 500, 120, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 25
		local items = {Item("snake_meat").id, Item("ink").id}
		local itemAmounts = {10, 1}
		local description = "Heals a target for 500."
		return level, items, itemAmounts, description
	end
}

ancestors_touch_poet = {
	cast = function(player, target)
		local spellName = "Ancestor's Touch"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 500, 120, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 25
		local items = {Item("snake_meat").id, Item("ink").id}
		local itemAmounts = {10, 1}
		local description = "Heals a target for 500."
		return level, items, itemAmounts, description
	end
}

life_flow_poet = {
	cast = function(player, target)
		local spellName = "Life Flow"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 500, 120, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 25
		local items = {Item("snake_meat").id, Item("ink").id}
		local itemAmounts = {10, 1}
		local description = "Heals a target for 500."
		return level, items, itemAmounts, description
	end
}

infuse_lifeforce_poet = {
	cast = function(player, target)
		local spellName = "Infuse Life-Force"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 500, 120, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 25
		local items = {Item("snake_meat").id, Item("ink").id}
		local itemAmounts = {10, 1}
		local description = "Heals a target for 500."
		return level, items, itemAmounts, description
	end
}
