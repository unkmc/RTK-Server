merchant_treasure = {
	requirements = function(player)
		local level = 99
		local items = {"blood", "scribes_book", "merchant_token", 0}
		local itemAmounts = {1, 1, 1, 100000}
		local description = "Marks a treasure spot to be found."
		return level, items, itemAmounts, description
	end
}
