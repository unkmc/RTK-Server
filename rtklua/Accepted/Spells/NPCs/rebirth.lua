rebirth = {
	cast = function(player, target)
		if target.state == 1 then
			-- dead
			target.state = 0
		end

		if target.blType == BL_PC then
			target:sendMinitext(player.name .. " casts Rebirth on you!")
		end
		target.attacker = target.ID
		target:addHealthExtend(target.maxHealth, 1, 1, 1, 1, 0)
	end,

	while_cast = function(block)
	end,
	recast = function(target)
	end,
	uncast = function(block)
	end
}
