invoke_mage = {
	cast = function(player)
		local aether = 22000
		local healthCost = math.floor(player.maxMagic *.4)
		local minMagic = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < minMagic) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player:sendAction(6, 20)
		player:setAether("invoke_mage", aether)
		player:playSound(85)
		player:sendAnimation(11)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Invoke.")
	end,

	requirements = function(player)
		local level = 39
		local items = {
			Item("fine_snake_meat").id,
			Item("ink").id,
			Item("book").id,
			0
		}
		local itemAmounts = {5, 1, 1, 250}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

spirits_power_mage = {
	cast = function(player)
		local aether = 22000
		local healthCost = math.floor(player.maxMagic *.4)
		local minMagic = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < minMagic) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player:sendAction(6, 20)
		player:setAether("spirits_power_mage", aether)
		player:playSound(18)
		player:sendAnimation(95)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Spirit's Power.")
	end,

	requirements = function(player)
		local level = 39
		local items = {
			Item("fine_snake_meat").id,
			Item("ink").id,
			Item("book").id,
			0
		}
		local itemAmounts = {5, 1, 1, 250}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

life_force_mage = {
	cast = function(player)
		local aether = 22000
		local healthCost = math.floor(player.maxMagic *.4)
		local minMagic = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < minMagic) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player:sendAction(6, 20)
		player:setAether("life_force_mage", aether)
		player:playSound(97)
		player:sendAnimation(90)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Life Force.")
	end,

	requirements = function(player)
		local level = 39
		local items = {
			Item("fine_snake_meat").id,
			Item("ink").id,
			Item("book").id,
			0
		}
		local itemAmounts = {5, 1, 1, 250}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

gather_magic_mage = {
	cast = function(player)
		local aether = 22000
		local healthCost = math.floor(player.maxMagic *.4)
		local minMagic = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < minMagic) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (player.health - healthCost < 100) then
			player.health = 100
		else
			player.health = player.health - healthCost
		end

		player:sendAction(6, 20)
		player:setAether("gather_magic_mage", aether)
		player:playSound(105)
		player:sendAnimation(78)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Gather Magic.")
	end,

	requirements = function(player)
		local level = 39
		local items = {
			Item("fine_snake_meat").id,
			Item("ink").id,
			Item("book").id,
			0
		}
		local itemAmounts = {5, 1, 1, 250}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}
