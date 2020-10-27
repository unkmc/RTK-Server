gangrel_rogue = {
	cast = function(player)
		local duration = 185000
		local q = string.lower(player.question)

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("gangrel_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (q == "fox") then
			player.disguise = 22
		elseif (q == "wolf") then
			player.disguise = 23
		else
			return
		end

		player:setDuration("gangrel_rogue", duration)
		player.state = 4

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
		local level = 33
		local items = {"acorn", "fox_fur", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into different animals. If you choose to join an alignment, your morph changes into 1 specific morph."
		return level, items, itemAmounts, description
	end
}

kwisin_mask_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("kwisin_mask_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("kwisin_mask_rogue", duration)
		player.state = 4

		player.disguise = 30
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
		local level = 33
		local items = {"acorn", "fox_fur", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a skeleton."
		return level, items, itemAmounts, description
	end
}

mingken_mask_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("mingken_mask_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("mingken_mask_rogue", duration)
		player.state = 4
		player.disguise = 89
		if player.sex == 1 then
			player.disguise = 88
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
		local level = 33
		local items = {"acorn", "fox_fur", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a buck."
		return level, items, itemAmounts, description
	end
}

ohaeng_mask_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("ohaeng_mask_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("ohaeng_mask_rogue", duration)
		player.state = 4

		player.disguise = 112
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
		local level = 33
		local items = {"acorn", "fox_fur", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a fire elemental."
		return level, items, itemAmounts, description
	end
}
