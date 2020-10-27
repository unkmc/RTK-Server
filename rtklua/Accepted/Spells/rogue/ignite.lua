ignite_rogue = {
	cast = function(player, target)
		local spellName = "Ignite"
		local damage = 260
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_zap.cast(player, target, damage, 30, 250)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "light_fox_fur", "topaz", 0}
		local itemAmounts = {30, 1, 2, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

spirit_strike_rogue = {
	cast = function(player, target)
		local spellName = "Spirit Strike"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 260
		local worked = global_zap.cast(player, target, damage, 30, 251)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "light_fox_fur", "topaz", 0}
		local itemAmounts = {30, 1, 2, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

wrath_of_nature_rogue = {
	cast = function(player, target)
		local spellName = "Wrath of Nature"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 260
		local worked = global_zap.cast(player, target, damage, 30, 252)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "light_fox_fur", "topaz", 0}
		local itemAmounts = {30, 1, 2, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}

thunderclap_rogue = {
	cast = function(player, target)
		local spellName = "Thunderclap"
		if not player:canCast(1, 1, 0) then
			return
		end
		local damage = 260
		local worked = global_zap.cast(player, target, damage, 30, 253)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "light_fox_fur", "topaz", 0}
		local itemAmounts = {30, 1, 2, 200}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}
