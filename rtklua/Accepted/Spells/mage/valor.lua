valor_mage = {
	cast = function(player, target)
		local magic = 30
		local duration = 300000

		if (target.blType == BL_PC and player:canPK(target)) then
			duration = 185000
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target:checkIfCast(mights) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()
		target:setDuration("valor_mage", duration)
		player:playSound(12)
		target:sendAnimation(11)
		target:calcStat()
	end,
	recast = function(target)
		target.might = target.might + 3
		target:sendStatus()
	end,
	uncast = function(target)
		target.might = target.might - 3
		target:sendStatus()
	end,
	requirements = function(player)
		local level = 23
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 150}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

strengthen_mage = {
	cast = function(player, target)
		local magic = 30
		local duration = 300000
		if (target.blType == BL_PC and player:canPK(target)) then
			duration = 185000
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target:checkIfCast(mights) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()
		target:setDuration("strengthen_mage", duration)
		player:playSound(31)
		target:sendAnimation(117)
		target:calcStat()
	end,
	recast = function(target)
		target.might = target.might + 3
		target:sendStatus()
	end,
	uncast = function(target)
		target.might = target.might - 3
		target:sendStatus()
	end,
	requirements = function(player)
		local level = 23
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 150}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

bless_muscles_mage = {
	cast = function(player, target)
		local magic = 30
		local duration = 300000
		if (target.blType == BL_PC and player:canPK(target)) then
			duration = 185000
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target:checkIfCast(mights) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()
		target:setDuration("bless_muscles_mage", duration)
		player:playSound(31)
		target:sendAnimation(117)
		target:calcStat()
	end,
	recast = function(target)
		target.might = target.might + 3
		target:sendStatus()
	end,
	uncast = function(target)
		target.might = target.might - 3
		target:sendStatus()
	end,
	requirements = function(player)
		local level = 23
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 150}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

power_burst_mage = {
	cast = function(player, target)
		local magic = 30
		local duration = 300000
		if (target.blType == BL_PC and player:canPK(target)) then
			duration = 185000
		end
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if target:checkIfCast(mights) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()
		target:setDuration("power_burst_mage", duration)
		player:playSound(31)
		target:sendAnimation(117)
		target:calcStat()
	end,
	recast = function(target)
		target.might = target.might + 3
		target:sendStatus()
	end,
	uncast = function(target)
		target.might = target.might - 3
		target:sendStatus()
	end,
	requirements = function(player)
		local level = 23
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 150}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}
