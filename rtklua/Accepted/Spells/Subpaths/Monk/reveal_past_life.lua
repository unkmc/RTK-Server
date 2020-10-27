reveal_past_life = {
	cast = async(function(player)
		-- RP MARKING SPELL

		-- POSSIBLE OUTCOMES:
		--[[

	Was an Ant in a Past life, revealed by xxxxx
	Was a Rabbit in a Past life, revealed by xxxxx
	Was a Butterfly in a Past life, revealed by xxxxx
	Was a Healer...
	Was Royalty...
	Was a Turtle...
	Was a Farmer...
	Was a Teacher...
	Was a Knight...
	Was a Criminal...
	Was a Racoon....

	]]
		--
	end),

	requirements = function(player)
		local level = 60
		local items = {"lotus_blossom"}
		local itemAmounts = {3}
		local description = "Reveals a Past Life"
		return level, items, itemAmounts, description
	end
}
