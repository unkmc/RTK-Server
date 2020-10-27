enhanced_drink = {
	cast = function(player)
		local q = string.lower(player.question)

		local aethers = 112000
		local magic = 25

		player:setAether("enhanced_drink", aethers)
		player:sendAction(6, 30)

		if q == "water jug" then
			local found = false

			for i = 0, 52 do
				local item = player:getInventoryItem(i)

				if item ~= nil then
					if item.yname == "water_jug" then
						found = true
					end
				end
			end

			if found then
				player:sendMinitext("Red fog spreads around Water jug.")
			else
				player:sendMinitext("Oh! if only you had that.")
			end
		else
			player:sendMinitext("You can't imbibe that.")
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"muddy_potion", "aqua_potion", "brown_potion", 0}
		local itemAmounts = {1, 1, 1, 1000}
		local description = "Improve a brew."
		return level, items, itemAmounts, description
	end
}
