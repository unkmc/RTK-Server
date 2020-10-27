LonwikNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local options = {"Buy", "Sell"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			options
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				LonwikNpc.buyItems(npc)
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				LonwikNpc.sellItems(npc)
			)
		end
	end),

	buyItems = function(npc)
		local buyItems = {"sonhi_cloak", "sonhi_dress"}

		return buyItems
	end,

	sellItems = function(npc)
		buyItems = LonwikNpc.buyItems(npc)
		return buyItems
	end
}
