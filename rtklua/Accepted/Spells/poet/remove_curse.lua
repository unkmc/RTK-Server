remove_curse_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		target:removeDuras(minorcurses)
		player:sendMinitext("You cast Remove curse.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(10)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 18
		local items = {Item("blue_ring").id, 0}
		local itemAmounts = {1, 10}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

release_curse_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		target:removeDuras(minorcurses)
		player:sendMinitext("You cast Release curse.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(71)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 18
		local items = {Item("blue_ring").id, 0}
		local itemAmounts = {1, 10}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

undo_evil_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		target:removeDuras(minorcurses)
		player:sendMinitext("You cast Undo evil.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(107)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 18
		local items = {Item("blue_ring").id, 0}
		local itemAmounts = {1, 10}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

restore_armor_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		target:removeDuras(minorcurses)
		player:sendMinitext("You cast Restore armor.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(58)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 18
		local items = {Item("blue_ring").id, 0}
		local itemAmounts = {1, 10}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}
