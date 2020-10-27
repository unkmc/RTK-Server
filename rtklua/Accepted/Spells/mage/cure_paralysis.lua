cure_paralysis_mage = {
	cast = function(player, target)
		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(paras)

		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(10)
		target:sendStatus()
		player:sendStatus()
		taget:sendAction(6, 35)
	end,
	requirements = function(player)
		local level = 36
		local items = {Item("gold_acorn").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 150}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

release_binds_mage = {
	cast = function(player, target)
		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(paras)

		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(70)
		target:sendStatus()
		player:sendStatus()
		taget:sendAction(6, 35)
	end,
	requirements = function(player)
		local level = 36
		local items = {Item("gold_acorn").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 150}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

return_movement_mage = {
	cast = function(player, target)
		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(paras)

		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(57)
		target:sendStatus()
		player:sendStatus()
		taget:sendAction(6, 35)
	end,
	requirements = function(player)
		local level = 36
		local items = {Item("gold_acorn").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 150}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

free_movement_mage = {
	cast = function(player, target)
		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(paras)

		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(108)
		target:sendStatus()
		player:sendStatus()
		taget:sendAction(6, 35)
	end,
	requirements = function(player)
		local level = 36
		local items = {Item("gold_acorn").id, Item("mountain_ginseng").id, 0}
		local itemAmounts = {1, 1, 150}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}
