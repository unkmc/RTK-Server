essence_of_life_poet = {
	cast = function(player, target)
		local spellName = "Essence of Life"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 20000, 2000, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 99
		local items = {"mountain_ginseng", 0}
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 20000 vita."
		return level, items, itemAmounts, description
	end
}

essence_of_spirit_poet = {
	cast = function(player, target)
		local spellName = "Essence of Spirit"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 20000, 2000, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 99
		local items = {"mountain_ginseng", 0}
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 20000 vita."
		return level, items, itemAmounts, description
	end
}

lifes_embrace_poet = {
	cast = function(player, target)
		local spellName = "Life's Embrace"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 20000, 2000, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 99
		local items = {"mountain_ginseng", 0}
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 20000 vita."
		return level, items, itemAmounts, description
	end
}

earths_cradle_poet = {
	cast = function(player, target)
		local spellName = "Earth's Cradle"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 20000, 2000, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,
	requirements = function(player)
		local level = 99
		local items = {"mountain_ginseng", 0}
		local itemAmounts = {1, 25000}
		local description = "Heals a target for 20000 vita."
		return level, items, itemAmounts, description
	end
}
