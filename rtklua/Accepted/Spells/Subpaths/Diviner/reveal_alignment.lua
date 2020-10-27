reveal_alignment = {
	-- RP Spell (no proof of existing on NTK) -- 3 options for Light, Dark, and Gray
	-- Alignment of Yin, Alignment of Yang, Alignment of Yin and Yang (these legend marks do exist). all have "revealed by (diviner name)."

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
