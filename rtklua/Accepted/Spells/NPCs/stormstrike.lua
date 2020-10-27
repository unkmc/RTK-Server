stormstrike = {
	cast = function(player, target)
		if target.state ~= 1 then
			-- dead

			target:sendAnimation(4, 3)
			target:sendMinitext(player.name .. " casts Stormstrike on you!")
			target.attacker = target.ID
			target:removeHealthExtend(
				math.ceil(target.health *.50),
				1,
				1,
				1,
				1,
				0
			)
		end
	end
}
