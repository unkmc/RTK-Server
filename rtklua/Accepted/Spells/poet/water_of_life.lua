water_of_life_poet = {
	cast = function(player, target)
		local spellName = "Water of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 5000, 390, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 85
		local items = {
			Item("acorn").id,
			Item("dark_amber").id,
			Item("red_potion").id,
			0
		}
		local itemAmounts = {100, 1, 1, 5000}
		local description = "Heals a target for 5000 vita."
		return level, items, itemAmounts, description
	end
}

breath_of_power_poet = {
	cast = function(player, target)
		local spellName = "Breath of Power"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 5000, 390, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 85
		local items = {
			Item("acorn").id,
			Item("dark_amber").id,
			Item("red_potion").id,
			0
		}
		local itemAmounts = {100, 1, 1, 5000}
		local description = "Heals a target for 5000 vita."
		return level, items, itemAmounts, description
	end
}

healing_breath_poet = {
	cast = function(player, target)
		local spellName = "Healing Breath"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 5000, 390, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 85
		local items = {
			Item("acorn").id,
			Item("dark_amber").id,
			Item("red_potion").id,
			0
		}
		local itemAmounts = {100, 1, 1, 5000}
		local description = "Heals a target for 5000 vita."
		return level, items, itemAmounts, description
	end
}

breath_of_life_poet = {
	cast = function(player, target)
		local spellName = "Breath of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 5000, 390, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 85
		local items = {
			Item("acorn").id,
			Item("dark_amber").id,
			Item("red_potion").id,
			0
		}
		local itemAmounts = {100, 1, 1, 5000}
		local description = "Heals a target for 5000 vita."
		return level, items, itemAmounts, description
	end
}
