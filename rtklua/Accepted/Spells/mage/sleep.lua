sleep_mage = {
	cast = function(player, target)
		local duration = 8000
		local magicCost = 300

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if target:checkIfCast(sleeps) or target.sleep > 1 then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:setAether("sleep_mage", 18000)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			player:sendMinitext("You cast Sleep.")
			player.magic = player.magic - magicCost
			target:setDuration("sleep_mage", duration)
			target:sendAnimation(2)
			player:sendAction(6, 35)
			player:playSound(305)
			target.sleep = 1.3
		else
			player:sendMinitext("Something went wrong.")
		end
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("sleep_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("sleep_mage", 0)
	end,

	uncast = function(block)
		if (block.blType == BL_MOB) then
			block.sleep = 1
		end
	end,

	requirements = function(player)
		local level = 70
		local items = {Item("dark_amber").id, Item("fox_blade").id}
		local itemAmounts = {10, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

sweet_musings_mage = {
	cast = function(player, target)
		local duration = 8000
		local magicCost = 300

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if target:checkIfCast(sleeps) or target.sleep > 1 then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:setAether("sweet_musings_mage", 18000)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			player:sendMinitext("You cast Sweet Musings.")
			player.magic = player.magic - magicCost
			target:setDuration("sweet_musings_mage", duration)
			target:sendAnimation(2)
			player:sendAction(6, 35)
			player:playSound(305)
			target.sleep = 1.3
		else
			player:sendMinitext("Something went wrong.")
		end
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("sweet_musings_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("sweet_musings_mage", 0)
	end,

	uncast = function(block)
		if (block.blType == BL_MOB) then
			block.sleep = 1
		end
	end,

	requirements = function(player)
		local level = 70
		local items = {Item("dark_amber").id, Item("fox_blade").id}
		local itemAmounts = {10, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

essence_of_poppies_mage = {
	cast = function(player, target)
		local duration = 8000
		local magicCost = 300

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if target:checkIfCast(sleeps) or target.sleep > 1 then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:setAether("essence_of_poppies_mage", 18000)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			player:sendMinitext("You cast Essence of Poppies.")
			player.magic = player.magic - magicCost
			target:setDuration("essence_of_poppies_mage", duration)
			target:sendAnimation(2)
			player:sendAction(6, 35)
			player:playSound(305)
			target.sleep = 1.3
		else
			player:sendMinitext("Something went wrong.")
		end
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("essence_of_poppies_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("essence_of_poppies_mage", 0)
	end,

	uncast = function(block)
		if (block.blType == BL_MOB) then
			block.sleep = 1
		end
	end,

	requirements = function(player)
		local level = 70
		local items = {Item("dark_amber").id, Item("fox_blade").id}
		local itemAmounts = {10, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}

stillness_mage = {
	cast = function(player, target)
		local duration = 8000
		local magicCost = 300

		if not player:canCast(1, 1, 0) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if target:checkIfCast(sleeps) or target.sleep > 1 then
			player:sendMinitext("This spell is already in effect.")
			return
		end

		player:setAether("stillness_mage", 18000)

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 2000
			end
			player:sendMinitext("You cast Stillness.")
			player.magic = player.magic - magicCost
			target:setDuration("stillness_mage", duration)
			target:sendAnimation(2)
			player:sendAction(6, 35)
			player:playSound(305)
			target.sleep = 1.3
		else
			player:sendMinitext("Something went wrong.")
		end
	end,

	recast = function(block)
		block.sleep = 1.3
	end,

	while_cast = function(block)
		if (block.sleep == 1) then
			block:setDuration("stillness_mage", 0)
		else
			block:sendAnimation(2)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("stillness_mage", 0)
	end,

	uncast = function(block)
		if (block.blType == BL_MOB) then
			block.sleep = 1
		end
	end,

	requirements = function(player)
		local level = 70
		local items = {Item("dark_amber").id, Item("fox_blade").id}
		local itemAmounts = {10, 1}
		local description = "Disables target from moving. Increases attack damage."
		return level, items, itemAmounts, description
	end
}
