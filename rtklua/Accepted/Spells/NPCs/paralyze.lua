paralyze = {
	while_cast = function(block)
		block:sendAnimation(1)
		block.paralyzed = true
	end,
	uncast = function(block)
		block.paralyzed = false
	end,
}
