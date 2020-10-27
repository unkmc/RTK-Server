venom = {
	cast = function(player, target)
		local duration = math.random(1000, 20000)

		if player.blType == BL_MOB then
			duration = 185000
		end

		if player.blType == BL_PC then
			local magicCost = 60
			if (player.magic < magicCost) then
				player:sendMinitext("Your will is too weak.")
				return
			end

			if (target.blType == BL_MOB) then
				if target:checkIfCast(venoms) then
					player:sendMinitext("Another spell of this type is already cast.")
					return
				end
				target:setDuration("venom", duration)
				target:sendAnimation(1)
				target.attacker = player.ID
			elseif (target.blType == BL_PC and player:canPK(target)) then
				if target:checkIfCast(venoms) then
					player:sendMinitext("Another spell of this type is already cast.")
					return
				end
				target:setDuration("venom", duration)
				target:sendAnimation(1)
			end

			player:sendAction(6, 35)
			player:playSound(24)
			player.magic = player.magic - magicCost
			player:sendMinitext("You cast Venom.")
			player:sendStatus()
		elseif player.blType == BL_MOB then
			if target:checkIfCast(venoms) then
				return
			end
			target:setDuration("venom", duration)
			target:sendAnimation(1)
		end
	end,

	while_cast = function(target)
		local damage = target.baseHealth *.01

		if (damage > 1000) then
			damage = 1000
		end
		if (damage < 1) then
			damage = 1
		end

		if (target.blType == BL_PC) then
			target:sendAnimation(1)

			if (target.health > damage) then
				target:removeHealthExtend(damage, 0, 0, 0, 0, 0)
			else
				target.health = 1
			end

			if os.time() % 2 == 0 then
				target:sendMinitext("Poison is spreading through your veins.")
			end
			target:sendAnimation(1, 5)
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
