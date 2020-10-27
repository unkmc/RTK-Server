masos_remedy_rogue = {
	cast = function(player)
		local spellName = "Maso's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 3000, 2000, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end

		--if worked == 2 then target:sendMinitext(player.name.." cast "..spellName.." on you.") end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 50000}
		local description = "Heal yourself for a nice amount of health"
		return level, items, itemAmounts, description
	end
}

kwisin_masos_remedy_rogue = {
	cast = function(player)
		local spellName = "Maso's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 3000, 2000, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end

		--if worked == 2 then target:sendMinitext(player.name.." cast "..spellName.." on you.") end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 50000}
		local description = "Heal yourself for a nice amount of health"
		return level, items, itemAmounts, description
	end
}

mingken_masos_remedy_rogue = {
	cast = function(player)
		local spellName = "Maso's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 3000, 2000, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end

		--if worked == 2 then target:sendMinitext(player.name.." cast "..spellName.." on you.") end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 50000}
		local description = "Heal yourself for a nice amount of health"
		return level, items, itemAmounts, description
	end
}

ohaeng_masos_remedy_rogue = {
	cast = function(player)
		local spellName = "Maso's Remedy"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, player, 3000, 2000, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end

		--if worked == 2 then target:sendMinitext(player.name.." cast "..spellName.." on you.") end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("mountain_ginseng").id, 0}
		local itemAmounts = {2, 50000}
		local description = "Heal yourself for a nice amount of health"
		return level, items, itemAmounts, description
	end
}
