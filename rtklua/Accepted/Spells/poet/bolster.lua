bolster_poet = {
	cast = function(player, target)
		local duration = 37000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType ~= BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(5)
		player:sendMinitext("You cast Bolster.")
		target:setDuration("bolster_poet", duration)
		target:sendAnimation(2, 0)
		target:sendMinitext(player.name .. " casts Bolster on you.")
		target:calcStat()
	end,

	recast = function(block)
		block.armor = block.armor - 4
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor + 4
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Improve a target's armor."
		return level, items, itemAmounts, description
	end
}

dark_armor_poet = {
	cast = function(player, target)
		local duration = 37000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType ~= BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(5)
		player:sendMinitext("You cast Dark Armor.")
		target:setDuration("dark_armor_poet", duration)
		target:sendAnimation(111, 0)
		target:sendMinitext(player.name .. " casts Dark Armor on you.")
		target:calcStat()
	end,

	recast = function(block)
		block.armor = block.armor - 4
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor + 4
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Improve a target's armor."
		return level, items, itemAmounts, description
	end
}

life_armor_poet = {
	cast = function(player, target)
		local duration = 37000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType ~= BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(5)
		player:sendMinitext("You cast Life Armor.")
		target:setDuration("life_armor_poet", duration)
		target:sendAnimation(110, 0)
		target:sendMinitext(player.name .. " casts Life Armor on you.")
		target:calcStat()
	end,

	recast = function(block)
		block.armor = block.armor - 4
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor + 4
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Improve a target's armor."
		return level, items, itemAmounts, description
	end
}

armor_of_elements_poet = {
	cast = function(player, target)
		local duration = 37000
		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1 or target.blType ~= BL_PC) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(disheartens) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end
		if target:checkIfCast(bolsters) then
			player:sendMinitext("Another spell of that type is already in effect.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(5)
		player:sendMinitext("You cast Armor of Elements.")
		target:setDuration("armor_of_elements_poet", duration)
		target:sendAnimation(98, 0)
		target:sendMinitext(player.name .. " casts Armor of Elements on you.")
		target:calcStat()
	end,

	recast = function(block)
		block.armor = block.armor - 4
		block:sendStatus()
	end,
	uncast = function(block)
		block.armor = block.armor + 4
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {150000}
		local description = "Improve a target's armor."
		return level, items, itemAmounts, description
	end
}
