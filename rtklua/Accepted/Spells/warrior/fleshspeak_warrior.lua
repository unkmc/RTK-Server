fleshspeak_warrior = {
	cast = function(player, target)
		local spellName = "Fleshspeak"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 13
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 40}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

spiritsong_warrior = {
	cast = function(player, target)
		local spellName = "Spiritsong"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 13
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 40}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

helping_hand_warrior = {
	cast = function(player, target)
		local spellName = "Helping Hand"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 13
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 40}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

heal_others_warrior = {
	cast = function(player, target)
		local spellName = "Heal Others"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 50, 60, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 13
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 40}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}
