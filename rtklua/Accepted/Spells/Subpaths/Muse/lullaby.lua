lullaby = {
	cast = function(player, target)
		local duration = 8000 * 2
		local magicCost = 300

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
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

		player:setAether("lullaby", 18000 * 2)

		-- double aethers

		if (target.blType == BL_MOB) then
			if (target.isBoss ~= 0) then
				duration = 4000
			end
			player:sendMinitext("You cast Lullaby.")
			player.magic = player.magic - magicCost
			target:setDuration("lullaby", duration)
			target:sendAnimation(426)
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

	while_cast_250 = function(block)
		if (block.sleep == 1) then
			block:setDuration("lullaby", 0)
		else
			block:sendAnimation(426, 1)
		end
	end,

	on_takedamage_while_cast = function(block)
		block:setDuration("lullaby", 0)
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
