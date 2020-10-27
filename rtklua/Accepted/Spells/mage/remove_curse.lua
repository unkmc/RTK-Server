remove_curse_mage = {
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
		local level = 34
		local items = {Item("gold_acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {1, 10, 200}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

release_curse_mage = {
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
		local level = 34
		local items = {Item("gold_acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {1, 10, 200}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

undo_evil_mage = {
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
		local level = 34
		local items = {Item("gold_acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {1, 10, 200}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}

restore_armor_mage = {
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
		local level = 34
		local items = {Item("gold_acorn").id, Item("fox_fur").id, 0}
		local itemAmounts = {1, 10, 200}
		local description = "Removes Vex and similar spells from target upon cast."
		return level, items, itemAmounts, description
	end
}
