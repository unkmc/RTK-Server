rodent_rogue = {
	cast = function(player, target)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("rodent_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("rodent_rogue", duration)
		player.state = 4

		if (q == "rabbit") then
			player.disguise = 21
		elseif (q == "squirrel") then
			player.disguise = 25
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
		local level = 25
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into either squirrel or rabbit. If you choose to join an alignment, your morph changes into 1 specific morph."
		return level, items, itemAmounts, description
	end
}

kwisin_disguise_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("kwisin_disguise_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("kwisin_disguise_rogue", duration)
		player.state = 4

		player.disguise = 97
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
		local level = 25
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a spider."
		return level, items, itemAmounts, description
	end
}

mingken_disguise_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("mingken_disguise_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("mingken_disguise_rogue", duration)
		player.state = 4

		player.disguise = 183
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
		local level = 25
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a caterpillar."
		return level, items, itemAmounts, description
	end
}

ohaeng_disguise_rogue = {
	cast = function(player)
		local duration = 185000

		if not player:canCast(1, 1, 0) then
			return
		end

		if player:hasDuration("ohaeng_disguise_rogue") then
			player:removeDuras(morphs)
			return
		end

		if (player.magic < 30) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		player:setDuration("ohaeng_disguise_rogue", duration)
		player.state = 4

		player.disguise = 126
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
		local level = 25
		local items = {"acorn", "rabbit_meat", 0}
		local itemAmounts = {80, 10, 100}
		local description = "Used to morph into a monkey."
		return level, items, itemAmounts, description
	end
}
