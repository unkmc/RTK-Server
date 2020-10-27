blind_mage = {
	cast = function(player, target)
		local duration = 50000
		local magicCost = 90

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType ~= BL_MOB) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(blinds) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(70)
		player:sendMinitext("You cast Blind.")
		target:setDuration("blind_mage", duration)
		target:sendAnimation(75, 0)
		target.blind = true
	end,
	while_cast = function(block)
		block.blind = true
	end,
	recast = function(block)
		block.blind = true
	end,
	uncast = function(block)
		block.blind = false
	end,

	requirements = function(player)
		local level = 61
		local items = {Item("amber").id, Item("dark_amber").id, 0}
		local itemAmounts = {2, 1, 400}
		local description = "Blinds target"
		return level, items, itemAmounts, description
	end
}

dark_veil_mage = {
	cast = function(player, target)
		local duration = 50000
		local magicCost = 90

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType ~= BL_MOB) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(blinds) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(70)
		player:sendMinitext("You cast Dark Veil.")
		target:setDuration("dark_veil_mage", duration)
		target:sendAnimation(136, 0)
		target.blind = true
	end,
	while_cast = function(block)
		block.blind = true
	end,
	recast = function(block)
		block.blind = true
	end,
	uncast = function(block)
		block.blind = false
	end,

	requirements = function(player)
		local level = 61
		local items = {Item("amber").id, Item("dark_amber").id, 0}
		local itemAmounts = {2, 1, 400}
		local description = "Blinds target"
		return level, items, itemAmounts, description
	end
}

winters_shadow_mage = {
	cast = function(player, target)
		local duration = 50000
		local magicCost = 90

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType ~= BL_MOB) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(blinds) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(70)
		player:sendMinitext("You cast Winter's Shadow.")
		target:setDuration("winters_shadow_mage", duration)
		target:sendAnimation(123, 0)
		target.blind = true
	end,
	while_cast = function(block)
		block.blind = true
	end,
	recast = function(block)
		block.blind = true
	end,
	uncast = function(block)
		block.blind = false
	end,

	requirements = function(player)
		local level = 61
		local items = {Item("amber").id, Item("dark_amber").id, 0}
		local itemAmounts = {2, 1, 400}
		local description = "Blinds target"
		return level, items, itemAmounts, description
	end
}

ice_glare_mage = {
	cast = function(player, target)
		local duration = 50000
		local magicCost = 90

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Not enough mana.")
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That is no longer useful.")
			return
		end

		if (target.blType ~= BL_MOB) then
			player:sendMinitext("It doesn't work.")
			return
		end

		if target:checkIfCast(blinds) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:playSound(70)
		player:sendMinitext("You cast Ice Glare.")
		target:setDuration("ice_glare_mage", duration)
		target:sendAnimation(52, 0)
		target.blind = true
	end,
	while_cast = function(block)
		block.blind = true
	end,
	recast = function(block)
		block.blind = true
	end,
	uncast = function(block)
		block.blind = false
	end,

	requirements = function(player)
		local level = 61
		local items = {Item("amber").id, Item("dark_amber").id, 0}
		local itemAmounts = {2, 1, 400}
		local description = "Blinds target"
		return level, items, itemAmounts, description
	end
}
