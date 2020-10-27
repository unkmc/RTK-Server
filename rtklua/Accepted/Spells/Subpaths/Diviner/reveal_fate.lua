reveal_fate = {
	-- RP Spell gives legend mark "Fortune revealed by (diviner name)"

	cast = async(function(player)
	end),

	requirements = function(player)
		local level = 60
		local items = {Item("acorn").id, Item("light_fox_fur").id, 0}
		local itemAmounts = {70, 20, 50}
		local description = "Assess target karma"
		return level, items, itemAmounts, description
	end
}
