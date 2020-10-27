beast_mage = {
	cast = function(player)
		local duration = 185000
		local magicCost = 30
		local q = string.lower(player.question)

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("beast_mage") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("beast_mage", duration)
		player.state = 4

		if (q == "tiger") then
			player.disguise = 29
		elseif (q == "bear") then
			player.disguise = 24
		else
			return
		end

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
		local level = 50
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 100}
		local description = "Used to morph into different animals. If you choose to join an alignment, your morph changes into 1 specific morph."
		return level, items, itemAmounts, description
	end
}

kwisin_chameleon_mage = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("kwisin_chameleon_mage") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("kwisin_chameleon_mage", duration)
		player.state = 4

		player.disguise = 105
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
		local level = 50
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 100}
		local description = "Used to morph into a bat."
		return level, items, itemAmounts, description
	end
}

mingken_chameleon_mage = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("mingken_chameleon_mage") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("mingken_chameleon_mage", duration)
		player.state = 4

		player.disguise = 121
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
		local level = 50
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 100}
		local description = "Used to morph into a chicken."
		return level, items, itemAmounts, description
	end
}

ohaeng_chameleon_mage = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("ohaeng_chameleon_mage") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("ohaeng_chameleon_mage", duration)
		player.state = 4

		player.disguise = 170
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
		local level = 50
		local items = {Item("acorn").id, 0}
		local itemAmounts = {70, 100}
		local description = "Used to morph into a Giasomo bird."
		return level, items, itemAmounts, description
	end
}
