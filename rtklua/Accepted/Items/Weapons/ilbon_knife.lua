ilbon_knife = {
	on_swing = function(player)
		local mob = getTargetFacing(player, BL_MOB)
		local pc = getTargetFacing(player, BL_PC)

		if mob ~= nil then
			if math.random(1, 100) <= 4 then
				kamikaze.cast(player, mob)
			end
		end

		if pc ~= nil then
			if math.random(1, 100) <= 4 and player:canPK(pc) then
				kamikaze.cast(player, pc)
			end
		end
	end
}
