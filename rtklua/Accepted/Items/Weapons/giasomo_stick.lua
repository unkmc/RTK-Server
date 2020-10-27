giasomo_stick = {
	on_swing = function(player)
		local mob = getTargetFacing(player, BL_MOB)
		local pc = getTargetFacing(player, BL_PC)

		if mob ~= nil then
			if math.random(1, 100) <= 4 then
				player:sendMinitext("You cast Calling Giasomo.")
				cotw_giasomo_bird_poet.cast(player)
			end
		end

		if pc ~= nil then
			if math.random(1, 100) <= 4 and player:canPK(pc) then
				player:sendMinitext("You cast Calling Giasomo.")
				cotw_giasomo_bird_poet.cast(player)
			end
		end
	end
}
