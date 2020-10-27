snare = {
	while_cast = function(block)
		block:sendAnimation(1)
		block.snare = true
	end,
	uncast = function(block)
		block.snare = false
	end,

	requirements = function(player)
		local level = 33
		local items = {}
		local itemAmounts = {}
		local description = "Used to morph into different animals. If you choose to join an alignment, your morph changes into 1 specific morph."
		return level, items, itemAmounts, description
	end
}
