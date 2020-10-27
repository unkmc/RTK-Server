remove_veil_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(blinds)
		target:sendMinitext(player.name .. " casts Remove Veil on you.")
		player:sendMinitext("You cast Remove Veil.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		player:sendStatus()
		target:updateState()
		target:sendStatus()
		target:sendAnimation(10)
	end,

	requirements = function(player)
		local level = 31
		local items = {Item("ancient_robes").id}
		local itemAmounts = {1}
		local description = "Removes blindness from target"
		return level, items, itemAmounts, description
	end
}

clear_darkness_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(blinds)

		target:sendMinitext(player.name .. " casts Clear Darkness on you.")
		player:sendMinitext("You cast Clear Darkness.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		player:sendStatus()
		target:updateState()
		target:sendStatus()
		target:sendAnimation(70)
	end,

	requirements = function(player)
		local level = 31
		local items = {Item("ancient_robes").id}
		local itemAmounts = {1}
		local description = "Removes blindness from target"
		return level, items, itemAmounts, description
	end
}

restore_sight_poet = {
	cast = function(player, target)
		local magic = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(blinds)

		target:sendMinitext(player.name .. " casts Restore Sight on you.")
		player:sendMinitext("You cast Restore Sight.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(10)
		player:sendStatus()
		target:updateState()
		target:sendStatus()
		target:sendAnimation(57)
	end,

	requirements = function(player)
		local level = 31
		local items = {Item("ancient_robes").id}
		local itemAmounts = {1}
		local description = "Removes blindness from target"
		return level, items, itemAmounts, description
	end
}

purge_darkness_poet = {
	cast = function(player, target)
		local magic = 60
		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		target:removeDuras(blinds)

		target:sendMinitext(player.name .. " casts Purge Darkness on you.")
		player:sendMinitext("You cast Purge Darkness.")

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		target:playSound(95)
		player:sendStatus()
		target:updateState()
		target:sendStatus()
		target:sendAnimation(108)
	end,

	requirements = function(player)
		local level = 31
		local items = {Item("ancient_robes").id}
		local itemAmounts = {1}
		local description = "Removes blindness from target"
		return level, items, itemAmounts, description
	end
}
