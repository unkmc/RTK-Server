kawlanas_guard = {
	cast = function(player)
		player:sendMinitext("You are protected by a great force.")
		player:sendMinitext("You cast Kawlana's guard.")
		player:sendMinitext("You cast Kawlana's secret.")
	end,

	uncast = function(player)
		player:sendMinitext("Your protection fades.")
	end,

	requirements = function(player)
		local level = 35
		local items = {}
		local itemAmounts = {}
		local desc = "This spell is used to approach a group member."
		return level, items, itemAmounts, desc
	end
}
