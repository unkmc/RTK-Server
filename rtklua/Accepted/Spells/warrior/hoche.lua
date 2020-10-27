hoche_warrior = {
	cast = function(player)
		local magic = 5000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:sendMinitext("You cast Hoche.")
		player:setDuration("hoche_warrior", 60000)
		player:setAether("hoche_warrior", 180000)
		player:playSound(10)
		player:sendAnimation(22)
		player:sendStatus()
		player:sendAction(6, 35)
	end,
	recast = function(player)
		player:sendStatus()
	end,
	uncast = function(player)
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {Item("spike").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 25000}
		local description = "Prevents being cursed."
		return level, items, itemAmounts, description
	end
}

immunity_warrior = {
	cast = function(player)
		local magic = 5000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:sendMinitext("You cast Immunity.")
		player:setDuration("immunity_warrior", 60000)
		player:setAether("immunity_warrior", 180000)
		player:playSound(10)
		player:sendAnimation(62)
		player:sendStatus()
		player:sendAction(6, 35)
	end,
	recast = function(player)
		player:sendStatus()
	end,
	uncast = function(player)
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {Item("spike").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 25000}
		local description = "Prevents being cursed."
		return level, items, itemAmounts, description
	end
}

forest_blessing_warrior = {
	cast = function(player)
		local magic = 5000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:sendMinitext("You cast Forest Blessing.")
		player:setDuration("forest_blessing_warrior", 60000)
		player:setAether("forest_blessing_warrior", 180000)
		player:playSound(10)
		player:sendAnimation(62)
		player:sendStatus()
		player:sendAction(6, 35)
	end,
	recast = function(player)
		player:sendStatus()
	end,
	uncast = function(player)
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {Item("spike").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 25000}
		local description = "Prevents being cursed."
		return level, items, itemAmounts, description
	end
}

magics_shield_warrior = {
	cast = function(player)
		local magic = 5000

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player.magic = player.magic - magic
		player:sendMinitext("You cast Magic Shield.")
		player:setDuration("magics_shield_warrior", 60000)
		player:setAether("magics_shield_warrior", 180000)
		player:playSound(10)
		player:sendAnimation(62)
		player:sendStatus()
		player:sendAction(6, 35)
	end,
	recast = function(player)
		player:sendStatus()
	end,
	uncast = function(player)
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 99
		local items = {Item("spike").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 25000}
		local description = "Prevents being cursed."
		return level, items, itemAmounts, description
	end
}
