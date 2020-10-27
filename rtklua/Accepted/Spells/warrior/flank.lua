flank_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(flanks)

		player:sendAction(6, 35)
		player:setDuration("flank_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.flank = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.flank = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 20
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 5, 150}
		local description = "Strikes an enemy on your side."
		return level, items, itemAmounts, description
	end
}

flank_battle_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(flanks)

		player:sendAction(6, 35)
		player:setDuration("flank_battle_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.flank = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.flank = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 20
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 5, 150}
		local description = "Strikes an enemy on your side."
		return level, items, itemAmounts, description
	end
}

flank_attack_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(flanks)

		player:sendAction(6, 35)
		player:setDuration("flank_attack_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.flank = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.flank = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 20
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 5, 150}
		local description = "Strikes an enemy on your side."
		return level, items, itemAmounts, description
	end
}

flank_damage_warrior = {
	cast = function(player)
		local magic = 90

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(flanks)

		player:sendAction(6, 35)
		player:setDuration("flank_damage_warrior", 625000)
		player.magic = player.magic - magic
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.flank = true
		player:sendStatus()
	end,
	uncast = function(player)
		player.flank = false
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 20
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 5, 150}
		local description = "Strikes an enemy on your side."
		return level, items, itemAmounts, description
	end
}
