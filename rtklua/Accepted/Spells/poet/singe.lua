singe_poet = {
	cast = function(player, target)
		local spellName = "Singe"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 25 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 11)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

embrace_of_the_void_poet = {
	cast = function(player, target)
		local spellName = "Embrace of the Void"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 25 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

lightning_poet = {
	cast = function(player, target)
		local spellName = "Lightning"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 25 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

natures_storm_poet = {
	cast = function(player, target)
		local spellName = "Nature's Storm"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 25 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 17
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}
