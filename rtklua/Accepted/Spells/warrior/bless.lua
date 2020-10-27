bless_warrior = {
	cast = function(player)
		local magic = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(blessings)

		player:sendMinitext("You cast Bless.")
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("bless_warrior", 625000)
		player:playSound(4)
		player:sendAnimation(2)
		player:calcStat()
	end,
	uncast = function(player)
		player.hit = player.hit - 2
		player:sendStatus()
	end,
	recast = function(player)
		player.hit = player.hit + 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 10
		local items = {Item("antler").id, 0}
		local itemAmounts = {3, 80}
		local description = "Increases your chance to strike an enemy."
		return level, items, itemAmounts, description
	end
}

sanctification_warrior = {
	cast = function(player)
		local magic = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(blessings)

		player:sendMinitext("You cast Sanctification.")
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("sanctification_warrior", 625000)
		player:playSound(4)
		player:sendAnimation(2)
		player:calcStat()
	end,
	uncast = function(player)
		player.hit = player.hit - 2
		player:sendStatus()
	end,
	recast = function(player)
		player.hit = player.hit + 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 10
		local items = {Item("antler").id, 0}
		local itemAmounts = {3, 80}
		local description = "Increases your chance to strike an enemy."
		return level, items, itemAmounts, description
	end
}

tribal_gathering_warrior = {
	cast = function(player)
		local magic = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(blessings)

		player:sendMinitext("You cast Tribal gathering.")
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("tribal_gathering_warrior", 625000)
		player:playSound(4)
		player:sendAnimation(2)
		player:calcStat()
	end,
	uncast = function(player)
		player.hit = player.hit - 2
		player:sendStatus()
	end,
	recast = function(player)
		player.hit = player.hit + 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 10
		local items = {Item("antler").id, 0}
		local itemAmounts = {3, 80}
		local description = "Increases your chance to strike an enemy."
		return level, items, itemAmounts, description
	end
}

strength_of_purpose_warrior = {
	cast = function(player)
		local magic = 60

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(blessings)

		player:sendMinitext("You cast Strength of purpose.")
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("strength_of_purpose_warrior", 625000)
		player:playSound(4)
		player:sendAnimation(2)
		player:calcStat()
	end,
	uncast = function(player)
		player.hit = player.hit - 2
		player:sendStatus()
	end,
	recast = function(player)
		player.hit = player.hit + 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 10
		local items = {Item("antler").id, 0}
		local itemAmounts = {3, 80}
		local description = "Increases your chance to strike an enemy."
		return level, items, itemAmounts, description
	end
}
