burn = {
	cast = function(player, target)
		local duration = 75000

		if player.blType == BL_PC then
			local magicCost = 200
			if (player.magic < magicCost) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			if (target.blType == BL_MOB) then
				if target:checkIfCast(venoms) then
					player:sendMinitext("Another spell of this type is already cast.")
					return
				end
				target:setDuration("burn", duration)
				target:sendAnimation(1)
				target.attacker = player.ID
			elseif (target.blType == BL_PC and player:canPK(target)) then
				if target:checkIfCast(venoms) then
					player:sendMinitext("Another spell of this type is already cast.")
					return
				end
				target:setDuration("burn", duration)
				target:sendAnimation(1)
			end

			player:sendAction(6, 35)
			player:playSound(24)
			player.magic = player.magic - magicCost
			player:sendMinitext("You cast Burn.")
			player:sendMinitext("Calling Burn.")
			player:sendStatus()
		elseif player.blType == BL_MOB then
			if target:checkIfCast(venoms) then
				return
			end
			target:setDuration("burn", duration)
			target:sendAnimation(1)
		end
	end,

	while_cast = function(target)
		local damage = 1000

		if (target.blType == BL_PC) then
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		elseif target.blType == BL_MOB then
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end
		end
	end
}
