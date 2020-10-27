inspire_poet = {
	cast = function(player, target)
		local magicCost = 30
		if target.blType ~= BL_PC then
			return
		end
		target:sendStatus()
		local mana = target.maxMagic - target.magic

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end
		if target.ID == player.ID then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target.blType == BL_PC then
			if player.magic < mana then
				target.magic = target.magic + player.magic
				player.magic = 0
			else
				player.magic = player.magic - mana
				target.magic = target.magic + mana
			end

			target:sendAnimation(11)
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Inspire on you.")
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Inspire.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Restore mana to a target."
		return level, items, itemAmounts, description
	end
}

share_energy_poet = {
	cast = function(player, target)
		local magicCost = 30
		if target.blType ~= BL_PC then
			return
		end
		target:sendStatus()
		local mana = target.maxMagic - target.magic

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end
		if target.ID == player.ID then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target.blType == BL_PC then
			if player.magic < mana then
				target.magic = target.magic + player.magic
				player.magic = 0
			else
				player.magic = player.magic - mana
				target.magic = target.magic + mana
			end

			target:sendAnimation(33)
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Share Energy on you.")
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Share Energy.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Restore mana to a target."
		return level, items, itemAmounts, description
	end
}

bestow_power_poet = {
	cast = function(player, target)
		local magicCost = 30
		if target.blType ~= BL_PC then
			return
		end
		target:sendStatus()
		local mana = target.maxMagic - target.magic

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end
		if target.ID == player.ID then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target.blType == BL_PC then
			if player.magic < mana then
				target.magic = target.magic + player.magic
				player.magic = 0
			else
				player.magic = player.magic - mana
				target.magic = target.magic + mana
			end

			target:sendAnimation(70)
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Bestow Power on you.")
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Bestow Power.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Restore mana to a target."
		return level, items, itemAmounts, description
	end
}

release_focus_poet = {
	cast = function(player, target)
		local magicCost = 30
		if target.blType ~= BL_PC then
			return
		end
		target:sendStatus()
		local mana = target.maxMagic - target.magic

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Not enough mana.")
			return
		end
		if target.ID == player.ID then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target.blType == BL_PC then
			if player.magic < mana then
				target.magic = target.magic + player.magic
				player.magic = 0
			else
				player.magic = player.magic - mana
				target.magic = target.magic + mana
			end

			target:sendAnimation(49)
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Release Focus on you.")
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Release Focus.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 45
		local items = {Item("gold_acorn").id, Item("amethyst").id, 0}
		local itemAmounts = {1, 1, 100}
		local description = "Restore mana to a target."
		return level, items, itemAmounts, description
	end
}
