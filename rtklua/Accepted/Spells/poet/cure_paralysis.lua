cure_paralysis_poet = {
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
		local level = 34
		local items = {Item("fine_snake_meat").id, 0}
		local itemAmounts = {1, 100}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

release_binds_poet = {
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
		local level = 34
		local items = {Item("fine_snake_meat").id, 0}
		local itemAmounts = {1, 100}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

return_movement_poet = {
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
		local level = 34
		local items = {Item("fine_snake_meat").id, 0}
		local itemAmounts = {1, 100}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}

free_movement_poet = {
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
		target:playSound(95)
		target:sendAnimation(108)
		target:sendStatus()
		player:sendStatus()
		taget:sendAction(6, 35)
	end,
	requirements = function(player)
		local level = 34
		local items = {Item("fine_snake_meat").id, 0}
		local itemAmounts = {1, 100}
		local description = "Remove stuns from a target."
		return level, items, itemAmounts, description
	end
}
