create_green_potion = {
	cast = function(player)
		local magicCost = 500
		local aethers = 3120000

		local limestone = Item("limestone")
		local fineSnakeMeat = Item("fine_snake_meat")

		tlimestone = {graphic = limestone.icon, color = limestone.iconC}
		tfineSnakeMeat = {
			graphic = fineSnakeMeat.icon,
			color = fineSnakeMeat.iconC
		}

		if player:hasItem("limestone", 1) ~= true then
			player:dialogSeq(
				{tlimestone, "Where did you put that limestone?"},
				0
			)
			return
		end
		if player:hasItem("fine_snake_meat", 1) ~= true then
			player:dialogSeq(
				{tfineSnakeMeat, "Where did you put that Fine Snake Meat?"},
				0
			)
			return
		end

		player:removeItem("limestone", 1)
		player:removeItem("fine_snake_meat", 1)
		player:addItem("lime_potion", 1)
		player:setAether("create_green_potion", aethers)
		player:sendMinitext("You create a lime potion.")
	end,
	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}
