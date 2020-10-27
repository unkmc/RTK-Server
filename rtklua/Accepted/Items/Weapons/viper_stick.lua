viper_stick = {
	on_swing = function(player)
		local mob = getTargetFacing(player, BL_MOB)
		local pc = getTargetFacing(player, BL_PC)

		if mob ~= nil then
			if math.random(1, 100) <= 4 then
				if not mob:checkIfCast(paras) then
					player:sendMinitext("You cast paralyze.")
					mob:setDuration("paralyze", 2) -- @TODO: Might make more sense to cast Doze since Viper stick is a requirement for that spell
				end
			end
		end

		if pc ~= nil then
			if math.random(1, 100) <= 4 and player:canPK(pc) then
				if not player:canPK(pc) then
					return
				end
				if not pc:checkIfCast(paras) then
					player:sendMinitext("You cast paralyze.")
					pc:setDuration("paralyze", 2)
				end
			end
		end
	end
}
