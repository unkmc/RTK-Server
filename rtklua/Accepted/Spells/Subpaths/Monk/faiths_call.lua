faiths_call = {
	cast = function(player, target)
		local magicCost = 150

		if not player:canCast(1, 1, 0) then
			return
		end

		local damage = 700 + math.floor(player.level / 2) + math.floor((player.will + 3) / 4)

		-- did 1568 damage at 100AC (rabbit)       Monk Level 99, 13k/10k. M 80, G 97, W 149.  This is the correct ballpark damage. do not change.

		if not distanceSquare(player, target, 10) then
			return
		end

		-- maximum 10 tiles away in either direction (verified on NTK)

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 35)

		if target.blType == BL_MOB then
			local threat = threat.getHighestThreat(target)
			player:setThreat(target.ID, threat + damage)
		elseif target.blType == BL_PC then
			if not player:canPK(target) then
				player:sendMinitext("You cannot attack that target.")
				return
			end
		end

		target:playSound(56)
		target:sendAnimation(4)
		target.attacker = player.ID
		target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
		target:sendStatus()

		player:sendMinitext("You cast Faiths call.")
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("acorn").id, Item("rabbit_meat").id}
		local itemAmounts = {20, 10}
		local description = "A moderate elemental attack."
		return level, items, itemAmounts, description
	end
}
