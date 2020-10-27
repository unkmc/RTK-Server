lightning_storm = {
	cast = function(player)
		-- dmg 6802 to 90 ac

		local damage = 3600
		local aethers = 87000
		local magicCost = 1200

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 25)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("lightning_storm", aethers)
		player:sendMinitext("You cast Lightning storm.")

		local targets = player:getObjectsInArea(BL_ALL)

		if #targets > 0 then
			for i = 1, #targets do
				if distanceSquare(player, targets[i], 10) and math.random(1, 2) == 1 then
					-- only 50% of targets

					if (targets[i].blType == BL_PC and player:canPK(targets[i])) or targets[i].blType == BL_MOB then
						if targets[i].blType == BL_PC then
							targets[i]:sendMinitext(player.name .. " cast Lightning storm on you.")
						end
						targets[i]:sendAnimation(30, 5)
						targets[i].attacker = player.ID
						targets[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
					end
				end
			end
			player:playSound(719)
			player:playSound(1)
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"rat_meat", "rabbit_meat"}
		local itemAmounts = {30, 20}
		local description = "Transform into a rabbit or rat."
		return level, items, itemAmounts, description
	end
}
