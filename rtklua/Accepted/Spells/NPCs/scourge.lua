scourge = {
	cast = function(block, target)
		local duration = 425000

		if target.state == 1 then
			return
		end

		if target:checkIfCast(curses) then
			return
		end
		if target:checkIfCast(protections) then
			return
		end

		target:setDuration("scourge", duration)
		target:sendAnimation(1, 0)

		if (target.blType == BL_MOB) then
			target.armor = target.armor + 50
			target.cursed = 1
		elseif (target.blType == BL_PC) then
			target:sendMinitext(block.name .. " attacks you with Scourge spell.")
			target:calcStat()
		end
	end,

	while_cast = function(block)
		if (block.blType == BL_MOB and block.charState ~= 2) then
			block:sendAnimation(34, 0)
		elseif (block.blType == BL_PC and block.state ~= 2) then
			block:sendAnimation(34, 0)
		end
	end,

	recast = function(target)
		target.armor = target.armor + 50
		target.cursed = 1
		target:SendStatus()
	end,

	uncast = function(target)
		target.armor = target.armor - 50
		target.cursed = 0
	end,
}
