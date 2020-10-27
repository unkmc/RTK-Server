vigor_warrior = {
	cast = function(player)
		local spellName = "Vigor"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 280, 180, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {
			Item("angels_tear").id,
			Item("light_fox_fur").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 40, 1, 10000}
		local description = "Heals a target for a fair amount of health."
		return level, items, itemAmounts, description
	end
}

touch_of_health_warrior = {
	cast = function(player)
		local spellName = "Touch of Health"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 280, 180, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {
			Item("angels_tear").id,
			Item("light_fox_fur").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 40, 1, 10000}
		local description = "Heals a target for a fair amount of health."
		return level, items, itemAmounts, description
	end
}

balm_warrior = {
	cast = function(player)
		local spellName = "Balm"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 280, 180, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {
			Item("angels_tear").id,
			Item("light_fox_fur").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 40, 1, 10000}
		local description = "Heals a target for a fair amount of health."
		return level, items, itemAmounts, description
	end
}

restoration_warrior = {
	cast = function(player)
		local spellName = "Restoration"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 280, 180, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {
			Item("angels_tear").id,
			Item("light_fox_fur").id,
			Item("mountain_ginseng").id,
			0
		}
		local itemAmounts = {1, 40, 1, 10000}
		local description = "Heals a target for a fair amount of health."
		return level, items, itemAmounts, description
	end
}
