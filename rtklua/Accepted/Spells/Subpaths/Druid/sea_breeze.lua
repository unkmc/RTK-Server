sea_breeze = {
	cast = function(player)
		local heal = 600
		local aethers = 75000
		local magicCost = 1500

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
		player:setAether("sea_breeze", aethers)
		player:sendMinitext("You cast Sea breeze.")

		local targets = player:getObjectsInArea(BL_ALL)

		if #targets > 0 then
			for i = 1, #targets do
				if distanceSquare(player, targets[i], 10) then
					if targets[i].blType == BL_PC or targets[i].blType == BL_MOB then
						if targets[i].blType == BL_PC then
							targets[i]:sendMinitext(player.name .. " cast Sea breeze on you.")
						end
						targets[i]:sendAnimation(15, 5)
						targets[i].attacker = player.ID
						targets[i]:addHealthExtend(heal, 0, 0, 0, 0, 0)
					end
				end
			end
			player:playSound(708)
		end
	end,

	requirements = function(player)
		local level = 33
		local items = {"rat_meat", "rabbit_meat"}
		local itemAmounts = {30, 20}
		local description = "Transform into a rabbit or rat."
		return level, items, itemAmounts, description
	end
}
