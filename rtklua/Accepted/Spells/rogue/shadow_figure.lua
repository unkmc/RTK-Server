shadow_figure_rogue = {
	cast = function(player)
		local magic = 60
		local duration = 625000

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(shadowFigures)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Shadow Figure.")
		player:setDuration("shadow_figure_rogue", duration)
		player:playSound(4)
		player:sendAnimation(2)
		player:calcStat()
	end,
	recast = function(player)
		player.grace = player.grace + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.grace = player.grace - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 10, 200}
		local desc = "Increases your movement speed, making it harder for enemies to hit you."
		return level, items, itemAmounts, desc
	end
}

spirit_warrior_rogue = {
	cast = function(player)
		local magic = 60
		local duration = 625000

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(shadowFigures)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Spirit Warrior.")
		player:setDuration("spirit_warrior_rogue", duration)
		player:playSound(4)
		player:sendAnimation(20)
		player:calcStat()
	end,
	recast = function(player)
		player.grace = player.grace + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.grace = player.grace - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 10, 200}
		local desc = "Increases your movement speed, making it harder for enemies to hit you."
		return level, items, itemAmounts, desc
	end
}

natural_defense_rogue = {
	cast = function(player)
		local magic = 60
		local duration = 625000

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(shadowFigures)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Natural Defense.")
		player:setDuration("natural_defense_rogue", duration)
		player:playSound(4)
		player:sendAnimation(20)
		player:calcStat()
	end,
	recast = function(player)
		player.grace = player.grace + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.grace = player.grace - 3
		player:sendStatus()
	end,

	requirements = function(player)
		local level = 24
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 10, 200}
		local desc = "Increases your movement speed, making it harder for enemies to hit you."
		return level, items, itemAmounts, desc
	end
}

ohaengs_armor_rogue = {
	cast = function(player)
		local magic = 60
		local duration = 625000

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:removeDuras(shadowFigures)

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendMinitext("You cast Ohaeng's Armor.")
		player:setDuration("ohaengs_armor_rogue", duration)
		player:playSound(4)
		player:sendAnimation(21)
		player:calcStat()
	end,
	recast = function(player)
		player.grace = player.grace + 3
		player:sendStatus()
	end,
	uncast = function(player)
		player.grace = player.grace - 3
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 24
		local items = {"acorn", "red_fox_fur", 0}
		local itemAmounts = {100, 10, 200}
		local desc = "Increases your movement speed, making it harder for enemies to hit you."
		return level, items, itemAmounts, desc
	end
}
