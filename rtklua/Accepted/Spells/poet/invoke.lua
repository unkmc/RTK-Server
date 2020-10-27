invoke_poet = {
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
		player:setAether("invoke_poet", aether)
		player:playSound(85)
		player:sendAnimation(11)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Invoke.")
	end,

	requirements = function(player)
		local level = 7
		local items = {Item("ink").id, Item("wine").id}
		local itemAmounts = {1, 1}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

spirits_power_poet = {
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
		player:setAether("spirits_power_poet", aether)
		player:playSound(18)
		player:sendAnimation(95)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Spirit's Power.")
	end,

	requirements = function(player)
		local level = 7
		local items = {Item("ink").id, Item("wine").id}
		local itemAmounts = {1, 1}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

life_force_poet = {
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
		player:setAether("life_force_poet", aether)
		player:playSound(97)
		player:sendAnimation(90)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Life Force.")
	end,

	requirements = function(player)
		local level = 7
		local items = {Item("ink").id, Item("wine").id}
		local itemAmounts = {1, 1}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}

gather_magic_poet = {
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
		player:setAether("gather_magic_poet", aether)
		player:playSound(105)
		player:sendAnimation(78)
		player.magic = player.maxMagic
		player:sendStatus()
		player:sendMinitext("You cast Gather Magic.")
	end,

	requirements = function(player)
		local level = 7
		local items = {Item("ink").id, Item("wine").id}
		local itemAmounts = {1, 1}
		local description = "A spell that takes away the casters vita in exchange for mana"
		return level, items, itemAmounts, description
	end
}
