ambush_rogue = {
	cast = function(player)
		local mobTarget = getTargetFacing(player, BL_MOB)
		local pcTarget = getTargetFacing(player, BL_PC)
		local npcTarget = getTargetFacing(player, BL_NPC)
		
		local target = mobTarget
		
		if (target == nil) then
			target = pcTarget
		end

		if (target == nil) then
			target = npcTarget
		end

		if (target == nil) then
			return
		end

		if (player.blType == BL_PC or player.blType == BL_MOB) then
			if (not player:canCast(1, 1, 0)) then
				return
			end

			-- Buya Library Caverns
			if (player.m == 6592 and player.y <= 11) then
				return
			end

			-- Buya Library Caverns
			if (player.m == 6599 and player.y >= 11) then
				return
			end
		end

		local canAmbush = canAmbush(player, target)

		if (player.blType == BL_PC) then -- if caster is a player
			if (player.ambushTimer < ((os.time() * 1000) + timeMS())) then
				player.ambushTimer = (((os.time() * 1000) + timeMS()) + ((player.attackSpeed * 1000) / 50))
				player:sendAction(1, 15)
				player:swingTarget(target)
			end
		elseif (player.blType == BL_MOB) then -- if caster is a mob
			if (canAmbush) then
				player:talk(2, "Ambush~~~!")
				player:attack(target.ID)
			end
		end
	end,

	requirements = function(player)
		local level = 38
		local items = {"acorn", "fox_blade", 0}
		local itemAmounts = {180, 1, 400}
		local description = "Leap over your enemy to face their back while attacking."
		return level, items, itemAmounts, description
	end
}

displacement_rogue = {
	cast = function(player)
		ambush_rogue.cast(player)
	end,

	requirements = function(player)
		return ambush_rogue.requirements(player)
	end
}

waylay_rogue = {
	cast = function(player)
		ambush_rogue.cast(player)
	end,

	requirements = function(player)
		return ambush_rogue.requirements(player)
	end
}

reflect_rogue = {
	cast = function(player)
		ambush_rogue.cast(player)
	end,

	requirements = function(player)
		return ambush_rogue.requirements(player)
	end
}
