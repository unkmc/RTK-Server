ignite_mage = {
	cast = function(player, target)
		local spellName = "Ignite"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 30, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 18
		local items = {Item("ink").id, Item("book").id, 0}
		local itemAmounts = {1, 1, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

spirit_strike_mage = {
	cast = function(player, target)
		local spellName = "Spirit Strike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 30, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 18
		local items = {Item("ink").id, Item("book").id, 0}
		local itemAmounts = {1, 1, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

wrath_of_nature_mage = {
	cast = function(player, target)
		local spellName = "Wrath of Nature"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 30, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 18
		local items = {Item("ink").id, Item("book").id, 0}
		local itemAmounts = {1, 1, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

thunderclap_mage = {
	cast = function(player, target)
		local spellName = "Thunderclap"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 40 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)
		local worked = global_zap.cast(player, target, damage, 30, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 18
		local items = {Item("ink").id, Item("book").id, 0}
		local itemAmounts = {1, 1, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}
