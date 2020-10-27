shape_shifter = {
	requirements = function(player)
		local level = 99
		local items = {"holy_ring", "sen_glove", "cursed_staff", 0}
		local itemAmounts = {1, 1, 1, 15000}
		local description = "Shift your shape."
		return level, items, itemAmounts, description
	end
}
