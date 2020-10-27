valor_poet = {
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
		target:setDuration("valor_poet", duration)
		player:sendMinitext("You cast Valor")
		target:sendMinitext(player.name .. " cast Valor on you.")
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
		local level = 21
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 100}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

strengthen_poet = {
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
		target:setDuration("strengthen_poet", duration)
		player:sendMinitext("You cast Strengthen")
		target:sendMinitext(player.name .. " cast Strengthen on you.")
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
		local level = 21
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 100}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

bless_muscles_poet = {
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
		target:setDuration("bless_muscles_poet", duration)
		player:sendMinitext("You cast Bless muscles")
		target:sendMinitext(player.name .. " cast Bless muscles on you.")
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
		local level = 21
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 100}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}

power_burst_poet = {
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
		target:setDuration("power_burst_poet", duration)
		player:sendMinitext("You cast Power burst")
		target:sendMinitext(player.name .. " cast Power burst on you.")
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
		local level = 21
		local items = {Item("snake_meat").id, Item("antler").id, 0}
		local itemAmounts = {20, 10, 100}
		local description = "Increases another persons might by 3."
		return level, items, itemAmounts, description
	end
}
