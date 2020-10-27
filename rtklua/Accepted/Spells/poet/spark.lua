spark_poet = {
	cast = function(player, target)
		local spellName = "Spark"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 15 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 11)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A weak elemental attack."
		return level, items, itemAmounts, description
	end
}

glimpse_of_the_void_poet = {
	cast = function(player, target)
		local spellName = "Glimpse of the Void"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 15 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A weak elemental attack."
		return level, items, itemAmounts, description
	end
}

bolt_poet = {
	cast = function(player, target)
		local spellName = "Bolt"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 15 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A weak elemental attack."
		return level, items, itemAmounts, description
	end
}

natures_ire_poet = {
	cast = function(player, target)
		local spellName = "Nature's Ire"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 15 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 20, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 11
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A weak elemental attack."
		return level, items, itemAmounts, description
	end
}
