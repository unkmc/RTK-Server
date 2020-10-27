retribution_poet = {
	cast = function(player, target)
		local spellName = "Retribution"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic *.34)
		local worked = global_zap.cast(player, target, damage, 500, 40)
		if worked ~= 0 then
			player.magic = 0
			player:setAether("retribution_poet", 24000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 56
		local items = {Item("wicked_staff").id, "fragile_rose", 0}
		local itemAmounts = {1, 1, 2000}
		local description = "Targetable elemental attack that deals 34% of current mana to target"
		return level, items, itemAmounts, description
	end
}

spirit_puppet_poet = {
	cast = function(player, target)
		local spellName = "Spirit Puppet"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic *.34)
		local worked = global_zap.cast(player, target, damage, 500, 41)
		if worked ~= 0 then
			player.magic = 0
			player:setAether("spirit_puppet_poet", 24000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 56
		local items = {Item("wicked_staff").id, "fragile_rose", 0}
		local itemAmounts = {1, 1, 2000}
		local description = "Targetable elemental attack that deals 34% of current mana to target"
		return level, items, itemAmounts, description
	end
}

palm_of_life_poet = {
	cast = function(player, target)
		local spellName = "Palm of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic *.34)
		local worked = global_zap.cast(player, target, damage, 500, 42)
		if worked ~= 0 then
			player.magic = 0
			player:setAether("palm_of_life_poet", 24000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 56
		local items = {Item("wicked_staff").id, "fragile_rose", 0}
		local itemAmounts = {1, 1, 2000}
		local description = "Targetable elemental attack that deals 34% of current mana to target"
		return level, items, itemAmounts, description
	end
}

tornado_poet = {
	cast = function(player, target)
		local spellName = "Tornado"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = math.ceil(player.magic *.34)
		local worked = global_zap.cast(player, target, damage, 500, 43)
		if worked ~= 0 then
			player.magic = 0
			player:setAether("tornado_poet", 24000)
			player:sendStatus()
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 56
		local items = {Item("wicked_staff").id, "fragile_rose", 0}
		local itemAmounts = {1, 1, 2000}
		local description = "Targetable elemental attack that deals 34% of current mana to target"
		return level, items, itemAmounts, description
	end
}
