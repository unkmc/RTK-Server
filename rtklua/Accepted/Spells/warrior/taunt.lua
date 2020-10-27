taunt_warrior = {
	cast = function(player, target)
		local spellName = "Taunt"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_zap.cast(player, target, 1, 1, 13)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 5}
		local description = "Gain the attention of your foe."
		return level, items, itemAmounts, description
	end
}

anger_warrior = {
	cast = function(player, target)
		local spellName = "Anger"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_zap.cast(player, target, 1, 1, 13)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 5}
		local description = "Gain the attention of your foe."
		return level, items, itemAmounts, description
	end
}

tease_warrior = {
	cast = function(player, target)
		local spellName = "Tease"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_zap.cast(player, target, 1, 1, 13)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 5}
		local description = "Gain the attention of your foe."
		return level, items, itemAmounts, description
	end
}

mock_warrior = {
	cast = function(player, target)
		local spellName = "Mock"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_zap.cast(player, target, 1, 1, 13)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 5}
		local description = "Gain the attention of your foe."
		return level, items, itemAmounts, description
	end
}
