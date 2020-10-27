doze_mage = {
	cast = function(player, target)
		local duration = 10000
		local magicCost = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("You can't do that.")
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (target.sleep > 1) then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player:setAether("doze_mage", 36000)
		target:playSound(305)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			target:setDuration("doze_mage", duration)
			target.sleep = 1.3
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:setDuration("doze_mage", duration)
			target:sendMinitext(player.name .. " cast Doze on you.")
			target:calcStat()
		else
			return
		end

		target:sendAnimation(2)
		player:sendMinitext("You cast Doze.")
		player.magic = player.magic - magicCost
		player:sendStatus()
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("doze_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("doze_mage", 0)
	end,

	uncast = function(block)
		block.sleep = 1
	end,

	requirements = function(player)
		local level = 82
		local items = {Item("dark_amber").id, Item("viper_stick").id}
		local itemAmounts = {5, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

voids_touch_mage = {
	cast = function(player, target)
		local duration = 10000
		local magicCost = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("You can't do that.")
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (target.sleep > 1) then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player:setAether("voids_touch_mage", 24000)

		-- verified aethers from tk pvp video, they ARE less than unaligned
		target:playSound(305)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			target:setDuration("voids_touch_mage", duration)
			target.sleep = 1.3
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:setDuration("voids_touch_mage", duration)
			target:sendMinitext(player.name .. " cast Void's Touch on you.")
			target:calcStat()
		else
			return
		end

		target:sendAnimation(2)
		player:sendMinitext("You cast Void's Touch.")
		player.magic = player.magic - magicCost
		player:sendStatus()
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("voids_touch_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("voids_touch_mage", 0)
	end,

	uncast = function(block)
		block.sleep = 1
	end,

	requirements = function(player)
		local level = 82
		local items = {Item("dark_amber").id, Item("viper_stick").id}
		local itemAmounts = {5, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

still_ethers_mage = {
	cast = function(player, target)
		local duration = 10000
		local magicCost = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("You can't do that.")
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (target.sleep > 1) then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player:setAether("still_ethers_mage", 24000)

		-- verified aethers from tk pvp video, they ARE less than unaligned
		target:playSound(305)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			target:setDuration("still_ethers_mage", duration)
			target.sleep = 1.3
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:setDuration("still_ethers_mage", duration)
			target:sendMinitext(player.name .. " cast Still Ethers on you.")
			target:calcStat()
		else
			return
		end

		target:sendAnimation(2)
		player:sendMinitext("You cast Still Ethers.")
		player.magic = player.magic - magicCost
		player:sendStatus()
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("still_ethers_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("still_ethers_mage", 0)
	end,

	uncast = function(block)
		block.sleep = 1
	end,

	requirements = function(player)
		local level = 82
		local items = {Item("dark_amber").id, Item("viper_stick").id}
		local itemAmounts = {5, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

still_waters_mage = {
	cast = function(player, target)
		local duration = 10000
		local magicCost = 30

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("You can't do that.")
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		if (target.sleep > 1) then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:sendAction(6, 35)
		player:setAether("still_waters_mage", 24000)

		-- verified aethers from tk pvp video, they ARE less than unaligned
		target:playSound(305)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			target:setDuration("still_waters_mage", duration)
			target.sleep = 1.3
		elseif (target.blType == BL_PC and player:canPK(target)) then
			target:setDuration("still_waters_mage", duration)
			target:sendMinitext(player.name .. " cast Still Waters on you.")
			target:calcStat()
		else
			return
		end

		target:sendAnimation(2)
		player:sendMinitext("You cast Still Waters.")
		player.magic = player.magic - magicCost
		player:sendStatus()
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("still_waters_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("still_waters_mage", 0)
	end,

	uncast = function(block)
		block.sleep = 1
	end,

	requirements = function(player)
		local level = 82
		local items = {Item("dark_amber").id, Item("viper_stick").id}
		local itemAmounts = {5, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}
