might_mage = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(mights)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Might.")
		player:setDuration("might_mage", 625000)
		player:playSound(12)
		player:sendAnimation(11)
		player:calcStat()
	end,
	recast = function(player)
		player.might = player.might + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.might = player.might - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("bears_liver").id, Item("antler").id, 0}
		local itemAmounts = {1, 5, 50}
		local desc = "Temporarily increases your might."
		return level, items, itemAmounts, desc
	end
}

spirit_strength_mage = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(mights)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Spirit Strength.")
		player:setDuration("spirit_strength_mage", 625000)
		player:playSound(31)
		player:sendAnimation(117)
		player:calcStat()
	end,
	recast = function(player)
		player.might = player.might + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.might = player.might - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("bears_liver").id, Item("antler").id, 0}
		local itemAmounts = {1, 5, 50}
		local desc = "Temporarily increases your might."
		return level, items, itemAmounts, desc
	end
}

inner_blessing_mage = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(mights)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Inner Blessing.")
		player:setDuration("inner_blessing_mage", 625000)
		player:playSound(31)
		player:sendAnimation(11)
		player:calcStat()
	end,
	recast = function(player)
		player.might = player.might + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.might = player.might - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("bears_liver").id, Item("antler").id, 0}
		local itemAmounts = {1, 5, 50}
		local desc = "Temporarily increases your might."
		return level, items, itemAmounts, desc
	end
}

temper_mage = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(mights)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Temper.")
		player:setDuration("temper_mage", 625000)
		player:playSound(31)
		player:sendAnimation(11)
		player:calcStat()
	end,
	recast = function(player)
		player.might = player.might + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.might = player.might - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 6
		local items = {Item("bears_liver").id, Item("antler").id, 0}
		local itemAmounts = {1, 5, 50}
		local desc = "Temporarily increases your might."
		return level, items, itemAmounts, desc
	end
}
