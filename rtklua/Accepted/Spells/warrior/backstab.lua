backstab_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(backstabs)

		player:sendAction(6, 35)
		player:setDuration("backstab_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.backstab = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.backstab = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 15
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 3, 100}
		local description = "Strikes an enemy behind you."
		return level, items, itemAmounts, description
	end
}

back_battle_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(backstabs)

		player:sendAction(6, 35)
		player:setDuration("back_battle_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.backstab = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.backstab = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 15
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 3, 100}
		local description = "Strikes an enemy behind you."
		return level, items, itemAmounts, description
	end
}

back_attack_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(backstabs)

		player:sendAction(6, 35)
		player:setDuration("back_attack_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.backstab = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.backstab = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 15
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 3, 100}
		local description = "Strikes an enemy behind you."
		return level, items, itemAmounts, description
	end
}

back_damage_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(backstabs)

		player:sendAction(6, 35)
		player:setDuration("back_damage_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.backstab = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.backstab = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 15
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 3, 100}
		local description = "Strikes an enemy behind you."
		return level, items, itemAmounts, description
	end
}
