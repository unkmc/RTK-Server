CarnageHallShopNpc = {
	click = async(function(player, npc)
		local opts = {"Buy", "Sell", "Send me home"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accommodate some of the things you need. What would you like?",
				CarnageHallShopNpc.buyItems(npc)
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				CarnageHallShopNpc.sellItems(npc)
			)
		elseif choice == "Send me home" then
			local confirm = player:menuSeq(
				"Are you sure you wish to leave?",
				{"Yes", "No"},
				{}
			)

			if confirm == 1 then
				player.gfxDye = 0
				player:returnToInn()
			end
		end
	end),

	buyItems = function(npc)
		local buyItems = {"bears_liver", "antler", "herb_pipe"}

		return buyItems
	end,

	sellItems = function(npc)
		local buyItems = CarnageHallShopNpc.buyItems(npc)
		return buyItems
	end
}
