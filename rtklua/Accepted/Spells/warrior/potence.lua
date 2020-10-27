potence_warrior = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player:removeDuras(potency)
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("potence_warrior", 625000)
		player:sendAnimation(2)
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.dam = player.dam + 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.dam = player.dam - 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 35
		local items = {
			Item("ambrosia").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {1, 10, 10, 500}
		local description = "Increases your damage."
		return level, items, itemAmounts, description
	end
}

spirit_arm_warrior = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player:removeDuras(potency)
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("spirit_arm_warrior", 625000)
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.dam = player.dam + 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.dam = player.dam - 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 35
		local items = {
			Item("ambrosia").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {1, 10, 10, 500}
		local description = "Increases your damage."
		return level, items, itemAmounts, description
	end
}

touch_of_the_bear_warrior = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player:removeDuras(potency)
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("touch_of_the_bear_warrior", 625000)
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.dam = player.dam + 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.dam = player.dam - 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 35
		local items = {
			Item("ambrosia").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {1, 10, 10, 500}
		local description = "Increases your damage."
		return level, items, itemAmounts, description
	end
}

sharpen_warrior = {
	cast = function(player)
		local magic = 30

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		player:removeDuras(potency)
		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:setDuration("sharpen_warrior", 625000)
		player:playSound(4)
		player:calcStat()
	end,
	recast = function(player)
		player.dam = player.dam + 2
		player:sendStatus()
	end,
	uncast = function(player)
		player.dam = player.dam - 2
		player:sendStatus()
	end,
	requirements = function(player)
		local level = 35
		local items = {
			Item("ambrosia").id,
			Item("red_fox_fur").id,
			Item("light_fox_fur").id,
			0
		}
		local itemAmounts = {1, 10, 10, 500}
		local description = "Increases your damage."
		return level, items, itemAmounts, description
	end
}
