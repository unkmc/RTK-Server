energy_bloom = {
	cast = function(player, target)
		local magicCost = 600
		local damage = math.ceil(50 + (player.level * 2) + math.floor(((player.will + 1) / 2) * 1.5))

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if not distanceSquare(player, target, 10) then
			return
		end

		-- maximum 10 tiles away in either direction (verified on NTK)

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendAction(6, 35)

		target:sendAnimation(4)
		player:playSound(701)
		player:playSound(1)
		player:sendMinitext("You cast Energy bloom.")

		if target.blType == BL_MOB then
			local threat = threat.getHighestThreat(target)
			player:setThreat(target.ID, threat + damage)
		elseif target.blType == BL_PC then
			if not player:canPK(target) then
				player:sendMinitext("You cannot attack that target.")
				return
			end
			target:sendMinitext(player.name .. " cast Energy bloom on you.")
		end

		target.attacker = player.ID
		target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("gold_acorn").id, Item("topaz").id}
		local itemAmounts = {1, 1}
		local description = "A decent elemental attack."
		return level, items, itemAmounts, description
	end
}
