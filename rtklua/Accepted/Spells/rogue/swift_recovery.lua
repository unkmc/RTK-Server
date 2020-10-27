swift_recovery_rogue = {
	cast = function(player, target)
		local spellName = "Swift Recovery"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 900, 700, 0)
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
		local description = "Heals a target for a decent amount of health."
		return level, items, itemAmounts, description
	end
}

renew_energy_rogue = {
	cast = function(player, target)
		local spellName = "Renew Energy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 900, 700, 1)
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
		local description = "Heals a target for a decent amount of health."
		return level, items, itemAmounts, description
	end
}

loving_dew_rogue = {
	cast = function(player, target)
		local spellName = "Loving Dew"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 900, 700, 2)
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
		local description = "Heals a target for a decent amount of health."
		return level, items, itemAmounts, description
	end
}

invigorate_rogue = {
	cast = function(player, target)
		local spellName = "Invigorate"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 900, 700, 3)
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
		local description = "Heals a target for a decent amount of health."
		return level, items, itemAmounts, description
	end
}
