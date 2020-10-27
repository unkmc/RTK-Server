revitalize_poet = {
	cast = function(player, target)
		local spellName = "Revitalize"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 1000, 210, 0)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 40
		local items = {Item("aged_wine").id, Item("amethyst").id}
		local itemAmounts = {1, 1}
		local description = "Heals a target for 1000 vita."
		return level, items, itemAmounts, description
	end
}

ancestors_embrace_poet = {
	cast = function(player, target)
		local spellName = "Ancestor's Embrace"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 1000, 210, 1)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 40
		local items = {Item("aged_wine").id, Item("amethyst").id}
		local itemAmounts = {1, 1}
		local description = "Heals a target for 1000 vita."
		return level, items, itemAmounts, description
	end
}

lifeforce_poet = {
	cast = function(player, target)
		local spellName = "Life-Force"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 1000, 210, 2)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 40
		local items = {Item("aged_wine").id, Item("amethyst").id}
		local itemAmounts = {1, 1}
		local description = "Heals a target for 1000 vita."
		return level, items, itemAmounts, description
	end
}

lifespring_poet = {
	cast = function(player, target)
		local spellName = "Lifespring"
		if not player:canCast(1, 1, 0) then
			return
		end
		local worked = global_heal.cast(player, target, 1000, 210, 3)
		if worked ~= 0 then
			player:sendMinitext("You cast " .. spellName .. ".")
		end
		if worked == 2 then
			target:sendMinitext(player.name .. " cast " .. spellName .. " on you.")
		end
	end,

	requirements = function(player)
		local level = 40
		local items = {Item("aged_wine").id, Item("amethyst").id}
		local itemAmounts = {1, 1}
		local description = "Heals a target for 1000 vita."
		return level, items, itemAmounts, description
	end
}
