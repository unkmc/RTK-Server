mudang_recognition = {
	requirements = function(player)
		local level = 99
		local items = {"shaman_talisman", "fox_blade", "ink", 0}
		local itemAmounts = {1, 1, 1, 25000}
		local description = "Recognizes a community member."
		return level, items, itemAmounts, description
	end
}
