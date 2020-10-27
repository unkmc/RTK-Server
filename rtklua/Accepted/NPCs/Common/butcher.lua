ButcherNpc = {
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
			ButcherNpc.buy(player, npc)
		elseif choice == "Sell" then
			ButcherNpc.sell(player, npc)
		end
	end),

	buy = function(player, npc)
		local items = ButcherNpc.buyItems(npc)

		if npc.mapTitle == "Lien's Shop" then
			table.insert(items, "tigers_heart")
		end

		if npc.mapTitle == "Lien's Shop" or npc.mapTitle == "Hallow Pass" then
			local prices = {}
			for i = 1, #items do
				table.insert(prices, math.floor(Item(items[i]).price * 1.2))
			end
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				items,
				prices
			)
		else
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				items
			)
		end
	end,

	sell = function(player, npc)
		local items = ButcherNpc.sellItems()

		if npc.mapTitle == "Lien's Shop" then
			table.insert(items, "bird_meat")
			table.insert(items, "tiger_meat")
			table.insert(items, "tigers_heart")
			table.insert(items, "splendid_tiger_pelt")
			table.insert(items, "dragons_liver")
		end

		if npc.mapTitle == "Lien's Shop" or npc.mapTitle == "Hallow Pass" then
			local prices = {}

			for i = 1, #items do
				table.insert(prices, math.floor(Item(items[i]).sell * 1.2))
			end

			player:sellExtend(
				"What are you willing to sell today?",
				items,
				prices
			)
		else
			player:sellExtend("What are you willing to sell today?", items)
		end
	end,

	buyItems = function(npc)
		local buyItems = {
			"acorn",
			"meat_scrap",
			"meat",
			"rabbit_meat",
			"wolf_meat",
			"bears_liver"
		}

		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = {
			"acorn",
			"chestnut",
			"meat_scrap",
			"meat",
			"rabbit_meat",
			"fine_rabbit_meat",
			"rat_meat",
			"wolf_meat",
			"wolf_pelt",
			"fox_fur",
			"red_fox_fur",
			"light_fox_fur",
			"fox_tail",
			"bears_liver",
			"snake_meat",
			"fine_snake_meat",
			"beef",
			"lean_beef",
			"chicken_meat",
			"horse_meat",
			"rare_pork",
			"green_squirrel_pelt"
		}
		return sellItems
	end
}
