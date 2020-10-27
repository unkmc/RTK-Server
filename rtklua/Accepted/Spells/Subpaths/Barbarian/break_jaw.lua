break_jaw = {
	cast = function(player)
		local aethers = 150000

		-- 150s
		local duration = 60000

		if player.gmLevel > 0 then
			aethers = 0
		end

		local magicCost = 600

		if (not player:canCast(1, 1, 0)) then
			return
		end

		player:setAether("break_jaw", aethers)
		player:sendAction(1, 30)
		player:sendStatus()
		player:sendMinitext("You cast Break jaw.")

		local target = getTargetFacing(player, BL_ALL)

		if target ~= nil then
			if target.blType == BL_PC then
				if not target:hasDuration("break_jaw") then
					target:sendAnimation(44)
					target:setDuration("break_jaw", duration)
					target:sendMinitext(player.name .. " lands a swift blow to your jaw.")
				end
			end
		end
	end,

	uncast = function(block)
		block:sendMinitext("Your jaw feels better.")
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
