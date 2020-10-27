harden_body_poet = {
	cast = function(player)
		local duration = 12000
		local magicCost = 300

		if (player:hasDuration("death_save") == true) then
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()

		--local successRate = math.ceil((120+armor))
		armor = armor * -1
		local successRate = 50 + math.floor(armor / 3)

		local random = math.random(1, 100)

		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:playSound(5)
		player:sendMinitext("You cast Harden Body.")
		player:setDuration("harden_body_poet", duration)
		player:sendAnimation(11, 3)
	end,
	while_cast = function(block)
	end,

	requirements = function(player)
		local level = 95
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {100, 20, 5000}
		local desc = "Grants temporary immortality."
		return level, items, itemAmounts, desc
	end
}

deaths_guard_poet = {
	cast = function(player)
		local duration = 12000
		local magicCost = 300

		if (player:hasDuration("death_save") == true) then
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()

		--local successRate = math.ceil((120+armor))

		armor = armor * -1
		local successRate = 40 + math.floor(armor / 3)

		local random = math.random(1, 100)

		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:playSound(50)
		player:sendMinitext("You cast Death's Guard.")
		player:setDuration("deaths_guard_poet", duration)
		player:sendAnimation(74, 3)
	end,
	while_cast = function(block)
	end,

	requirements = function(player)
		local level = 95
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {100, 20, 5000}
		local desc = "Grants temporary immortality."
		return level, items, itemAmounts, desc
	end
}

lifes_protection_poet = {
	cast = function(player)
		local duration = 12000
		local magicCost = 300

		if (player:hasDuration("death_save") == true) then
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()

		--local successRate = math.ceil((120+armor))

		armor = armor * -1
		local successRate = 40 + math.floor(armor / 3)

		local random = math.random(1, 100)

		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:playSound(108)
		player:sendMinitext("You cast Life's Protection.")
		player:setDuration("lifes_protection_poet", duration)
		player:sendAnimation(72, 3)
	end,
	while_cast = function(block)
	end,

	requirements = function(player)
		local level = 95
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {100, 20, 5000}
		local desc = "Grants temporary immortality."
		return level, items, itemAmounts, desc
	end
}

body_of_alignment_poet = {
	cast = function(player)
		local duration = 12000
		local magicCost = 300

		if (player:hasDuration("death_save") == true) then
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()

		--local successRate = math.ceil((120+armor))

		armor = armor * -1
		local successRate = 40 + math.floor(armor / 3)

		local random = math.random(1, 100)

		if random > successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:playSound(5)
		player:sendMinitext("You cast Body of Alignment.")
		player:setDuration("body_of_alignment_poet", duration)
		player:sendAnimation(87, 3)
	end,
	while_cast = function(block)
	end,

	requirements = function(player)
		local level = 95
		local items = {Item("acorn").id, Item("amber").id, 0}
		local itemAmounts = {100, 20, 5000}
		local desc = "Grants temporary immortality."
		return level, items, itemAmounts, desc
	end
}
