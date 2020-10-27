forsaken_staff = {
	on_swing = function(player)
		if not player.backstab and not player.flank then
			local pc = getTargetFacing(player, BL_PC)
			local mob = getTargetFacing(player, BL_MOB)

			if mob ~= nil then
				if math.random(1, 100) <= 4 then
					blind.cast(player, mob)
				end
			end

			if pc ~= nil then
				if math.random(1, 100) <= 4 and player:canPK(pc) then
					blind.cast(player, pc)
				end
			end
		else
			local flankTargets = {}
			local backstabTargets = {}

			if player.backstab then
				backstabTargets = getTargetsBackstab(player, BL_ALL)
			elseif player.flank then
				flankTargets = getTargetsFlank(player, BL_ALL)
			end

			if #backstabTargets > 0 then
				for i = 1, #backstabTargets do
					if math.random(1, 100) <= 4 then
						blind.cast(player, backstabTargets[i])
					end
				end
			end
			if #flankTargets > 0 then
				for i = 1, #flankTargets do
					if math.random(1, 100) <= 4 then
						blind.cast(player, flankTargets[i])
					end
				end
			end
		end
	end
}
