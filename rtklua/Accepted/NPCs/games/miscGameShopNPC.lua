MiscGameShopNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell"}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				MiscGameShopNpc.buyItems()
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				MiscGameShopNpc.sellItems()
			)
		end
	end),

	buyItems = function()
		local buyItems = {"limestone", "obsidian"}

		return buyItems
	end,

	sellItems = function()
		return MiscGameShopNpc.buyItems()
	end
}
