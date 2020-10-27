feral_rogue = {
	cast = function(player, target)
		local duration = 185000
		local q = string.lower(player.question)

		if player:hasDuration("feral_rogue") then
			player:removeDuras(morphs)
			return
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("feral_rogue", duration)
		player.state = 4

		if (q == "pig") then
			player.disguise = 19
		elseif (q == "piglet") then
			player.disguise = 20
		elseif (q == "puppy") then
			player.disguise = 18
		elseif (q == "mongrel") then
			player.disguise = 103
		elseif (q == "cat") then
			player.disguise = 182
		else
			return
		end

		player.disguiseColor = player.armorColor
		player:sendAnimation(3)
		player:updateState()
	end,

	uncast = function(player)
		player.disguise = 0
		player.disguiseColor = 0
		player.state = 0
		player:updateState()
	end,
	requirements = function(player)
		local level = 10
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {50, 10, 100}
		local description = "Used to morph into different animals. If you choose to join an alignment, your morph changes into 1 specific morph."
		return level, items, itemAmounts, description
	end
}

kwisin_cloak_rogue = {
	cast = function(player)
		local duration = 185000

		if player:hasDuration("kwisin_cloak_rogue") then
			player:removeDuras(morphs)
			return
		end

		if not player:canCast(1, 1, 0) then
			return
		end
		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("kwisin_cloak_rogue", duration)
		player.state = 4

		player.disguise = 32
		player.disguiseColor = player.armorColor
		player:sendAnimation(12)
		player:updateState()
	end,

	uncast = function(player)
		player.disguise = 0
		player.disguiseColor = 0
		player.state = 0
		player:updateState()
	end,
	requirements = function(player)
		local level = 10
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {50, 10, 100}
		local description = "Used to morph into a centipede."
		return level, items, itemAmounts, description
	end
}

mingken_cloak_rogue = {
	cast = function(player)
		local duration = 185000

		if player:hasDuration("mingken_cloak_rogue") then
			player:removeDuras(morphs)
			return
		end

		if not player:canCast(1, 1, 0) then
			return
		end
		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("mingken_cloak_rogue", duration)
		player.state = 4

		player.disguise = 153
		player.disguiseColor = player.armorColor
		player:sendAnimation(12)
		player:updateState()
	end,

	uncast = function(player)
		player.disguise = 0
		player.disguiseColor = 0
		player.state = 0
		player:updateState()
	end,
	requirements = function(player)
		local level = 10
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {50, 10, 100}
		local description = "Used to morph into a warthog."
		return level, items, itemAmounts, description
	end
}

ohaeng_cloak_rogue = {
	cast = function(player)
		local duration = 185000

		if player:hasDuration("ohaeng_cloak_rogue") then
			player:removeDuras(morphs)
			return
		end

		if not player:canCast(1, 1, 0) then
			return
		end
		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("ohaeng_cloak_rogue", duration)
		player.state = 4

		player.disguise = 98
		player.disguiseColor = player.armorColor
		player:sendAnimation(12)
		player:updateState()
	end,

	uncast = function(player)
		player.disguise = 0
		player.disguiseColor = 0
		player.state = 0
		player:updateState()
	end,
	requirements = function(player)
		local level = 10
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {50, 10, 100}
		local description = "Used to morph into a mantis."
		return level, items, itemAmounts, description
	end
}
