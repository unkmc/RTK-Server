ArenaShopNpc = {
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

		if player.alignment > 0 then
			table.insert(opts, "Return to natural balance")
		end

		if npc.mapTitle == "Buchi Shop" or npc.mapTitle == "Nagnang Arena Shop" then
			table.insert(opts, "Reincarnate")
			table.insert(opts, "Observe")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				ArenaShopNpc.buyItems(npc)
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				ArenaShopNpc.sellItems(npc)
			)
		elseif choice == "Reincarnate" then
			general_npc_funcs.reincarnate(player, npc)
		elseif choice == "Observe" then
			general_npc_funcs.observe(player, npc)
		end
	end),

	buyItems = function(npc)
		local buyItems = {
			"bears_liver",
			"antler",
			"flash_dust",
			"flash_powder",
			"rogues_powder",
			"spark_powder",
			"moon_powder",
			"star_powder",
			"deadly_earth",
			"holy_dust",
			"holy_powder",
			"ice_shards",
			"shard_bomb",
			"shatter_bomb",
			"spys_explosives",
			"stealth_explosives",
			"stealth_powder",
			"sun_powder"
		}

		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = ArenaShopNpc.buyItems(npc)

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "magical_dust")
		end

		return sellItems
	end
}
