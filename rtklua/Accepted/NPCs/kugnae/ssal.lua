SsalNpc = {
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
		local items = {}
		local itemStrings = {"basic_sickle"}

		for i = 1, #itemStrings do
			table.insert(items, Item(itemStrings[i]).id)
		end

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				items
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", items)
		end
	end),

	buyItems = function()
		local buyItems = {}
		local strings = {"basic_sickle"}
		for i = 1, #strings do
			table.insert(buyItems, Item(strings[i]).id)
		end

		return buyItems
	end,

	sellItems = function()
		local sellItems = SsalNpc.buyItems()
		return sellItems
	end
}
