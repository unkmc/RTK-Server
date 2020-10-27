dagger_to_throat = {
	cast = function(player)
		local aethers = 1000000

		-- 1000s
		local duration = 20000

		-- 20s

		if player.gmLevel > 0 then
			aethers = 0
		end

		local magicCost = 5000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("dagger_to_throat", aethers)
		player:sendMinitext("You cast Dagger to throat.")

		local targetpc = getTargetFacing(player, BL_PC)

		if targetpc ~= nil then
			targetpc:sendMinitext("You feel the cold steel from a blade pressed to your neck. ((" .. player.name .. "))")
			targetpc:setDuration("dagger_to_throat", duration)
		end
	end,

	uncast = function(target)
		target:sendMinitext("Your anxiety subsides.")
	end,

	requirements = function(player)
		local l = 99
		local i = {
			Item("angels_tear").id,
			Item("dark_amber").id,
			Item("electra").id,
			0
		}
		local ia = {1, 20, 1, 10000}
		local d = "A massive attack that deals critical damage to an enemy."
		return l, i, ia, d
	end
}
