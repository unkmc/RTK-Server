flare_poet = {
	cast = function(player, target)
		local spellName = "Flare"
		if not player:canCast(1, 1, 0) then
			return
		end
		local magic = 80
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, magic, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("gold_acorn").id, 0}
		local itemAmounts = {5, 10000}
		local description = "A ranged lightning attack."
		return level, items, itemAmounts, description
	end
}

dance_of_death_poet = {
	cast = function(player, target)
		local spellName = "Dance of Death"
		if not player:canCast(1, 1, 0) then
			return
		end
		local magic = 80
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, magic, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("gold_acorn").id, 0}
		local itemAmounts = {5, 10000}
		local description = "A ranged lightning attack."
		return level, items, itemAmounts, description
	end
}

breaking_of_the_world_poet = {
	cast = function(player, target)
		local spellName = "Breaking of the World"
		if not player:canCast(1, 1, 0) then
			return
		end
		local magic = 80
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, magic, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("gold_acorn").id, 0}
		local itemAmounts = {5, 10000}
		local description = "A ranged lightning attack."
		return level, items, itemAmounts, description
	end
}

storm_crow_poet = {
	cast = function(player, target)
		local spellName = "Storm Crow"
		if not player:canCast(1, 1, 0) then
			return
		end
		local magic = 80
		local damage = 100 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 2)
		local worked = global_zap.cast(player, target, damage, magic, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 90
		local items = {Item("gold_acorn").id, 0}
		local itemAmounts = {5, 10000}
		local description = "A ranged lightning attack."
		return level, items, itemAmounts, description
	end
}
