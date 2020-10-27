peck = {
	cast = function(block, target)
		if not target:hasDuration("peck") then
			if target.blType == BL_PC then
				target:sendMinitext(block.name .. " attacks you with Peck spell.")
			end
			target:setDuration("peck", 5000)
			target.blind = true
			target:updateState()
		end
	end,
	while_cast = function(block)
		block.blind = true
	end,

	uncast = function(block)
		block.blind = false
		block:updateState()
	end
}
