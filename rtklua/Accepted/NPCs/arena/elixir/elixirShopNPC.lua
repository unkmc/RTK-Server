ElixirShopNpc = {
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

		if npc.mapTitle == "Elixir Hall" then
			table.insert(opts, "Leave")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		local buyItems = {"acorn"}
		local sellItems = {"acorn"}

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyItems
			)
		elseif choice == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellItems)
		elseif choice == "Leave" then
			clone.wipe(player)
			player.registry["elixirTeam"] = 0
			player:returnFunc()
		end
	end)
}
