fortify_poet = {
	cast = function(player)
		local spellName = "Fortify"

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 200) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - 200
		player:setAether("fortify_poet", 65000)
		player:sendStatus()

		for i = 1, #player.group do
			local target = Player(player.group[i])
			local worked = global_heal.cast(player, target, 500, 0, 0)
			if worked == 2 then
				target:sendMinitext(player.name .. " casts " .. spellName .. " on you.")
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 50
		local items = {Item("light_fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "a healing spell that heals all group members for 500 vita"
		return level, items, itemAmounts, description
	end
}

ancestors_kiss_poet = {
	cast = function(player)
		local spellName = "Ancestor's Kiss"
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 200) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - 200
		player:setAether("ancestors_kiss_poet", 65000)
		player:sendStatus()

		for i = 1, #player.group do
			local target = Player(player.group[i])
			local worked = global_heal.cast(player, target, 500, 0, 1)
			if worked == 2 then
				target:sendMinitext(player.name .. " casts " .. spellName .. " on you.")
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 50
		local items = {Item("light_fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "a healing spell that heals all group members for 500 vita"
		return level, items, itemAmounts, description
	end
}

fertile_soil_poet = {
	cast = function(player)
		local spellName = "Fertile Soil"
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 200) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - 200
		player:setAether("fertile_soil_poet", 65000)
		player:sendStatus()

		for i = 1, #player.group do
			local target = Player(player.group[i])
			local worked = global_heal.cast(player, target, 500, 0, 2)
			if worked == 2 then
				target:sendMinitext(player.name .. " casts " .. spellName .. " on you.")
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 50
		local items = {Item("light_fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "a healing spell that heals all group members for 500 vita"
		return level, items, itemAmounts, description
	end
}

waters_of_purity_poet = {
	cast = function(player)
		local spellName = "Waters of Purity"
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 200) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - 200
		player:setAether("waters_of_purity_poet", 65000)
		player:sendStatus()

		for i = 1, #player.group do
			local target = Player(player.group[i])
			local worked = global_heal.cast(player, target, 500, 0, 3)
			if worked == 2 then
				target:sendMinitext(player.name .. " casts " .. spellName .. " on you.")
			end
		end

		player:sendMinitext("You cast " .. spellName .. ".")
		player:sendAction(6, 20)
	end,

	requirements = function(player)
		local level = 50
		local items = {Item("light_fox_fur").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {20, 1, 100}
		local description = "a healing spell that heals all group members for 500 vita"
		return level, items, itemAmounts, description
	end
}
