atone_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(curses)
		target:removeDuras(snares)

		player:sendMinitext("You cast Atone.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(10)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 48
		local items = {Item("gold_acorn").id, Item("scroll").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Removes Scourge and similiar spells from target."
		return level, items, itemAmounts, description
	end
}

restore_will_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(curses)
		target:removeDuras(snares)

		player:sendMinitext("You cast Restore will.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(108)
		target:sendAnimation(71)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 48
		local items = {Item("gold_acorn").id, Item("scroll").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Removes Scourge and similiar spells from target."
		return level, items, itemAmounts, description
	end
}

raise_guard_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(curses)
		target:removeDuras(snares)
		player:sendMinitext("You cast Raise guard.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(107)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 48
		local items = {Item("gold_acorn").id, Item("scroll").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Removes Scourge and similiar spells from target."
		return level, items, itemAmounts, description
	end
}

align_armor_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(curses)
		target:removeDuras(snares)
		player:sendMinitext("You cast Align armor.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		target:sendAnimation(58)
		target:sendStatus()
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 48
		local items = {Item("gold_acorn").id, Item("scroll").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Removes Scourge and similiar spells from target."
		return level, items, itemAmounts, description
	end
}
