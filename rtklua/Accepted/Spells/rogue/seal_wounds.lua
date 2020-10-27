seal_wounds_rogue = {
	cast = function(player, target)
		local spellName = "Seal Wounds"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 280, 220, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {0}
		local itemAmounts = {25000}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

spirit_caress_rogue = {
	cast = function(player, target)
		local spellName = "Spirit Caress"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 280, 220, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {0}
		local itemAmounts = {25000}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

heal_injury_rogue = {
	cast = function(player, target)
		local spellName = "Heal Injury"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 280, 220, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {0}
		local itemAmounts = {25000}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}

bandage_rogue = {
	cast = function(player, target)
		local spellName = "Bandage"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 280, 220, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {0}
		local itemAmounts = {25000}
		local description = "Heals a target for a small amount of health."
		return level, items, itemAmounts, description
	end
}
