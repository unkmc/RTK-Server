ClanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {
			"Buy",
			"Sell",
			"Deposit clan item",
			"Withdraw clan item",
			"Banking",
			"Transport",
			"Date & Time"
		}

		if os.time() >= player.registry["gave_fragile_orb_of_world_shout_time"] then
			table.insert(opts, "Free World Shout")
		end

		local choice = player:menuString("Hello! How can I help you today?", opts)

		if choice == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				InnNpc.buyItems()
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				InnNpc.sellItems()
			)
		elseif choice == "Deposit clan item" then
			player:showClanBankDeposit(npc)
		elseif choice == "Withdraw clan item" then
			player:showClanBankWithdraw(npc)
		elseif choice == "Banking" then
			bank.show_main_menu(player, npc)
		elseif choice == "Transport" then
			Waypoint.click(player, npc)
		elseif choice == "Date & Time" then
			general_npc_funcs.time(player)
		elseif choice == "Free World Shout" then
			general_npc_funcs.freeWorldShout(player, npc)
		end
	end),

	buyItems = function()
		local buyItems = {
			"apple",
			"wine",
			"thick_wine",
			"yellow_scroll",
			"soup_bowl",
			"comb",
			"rice_wine",
			"root_liquor"
		}

		return buyItems
	end,

	sellItems = function()
		local sellItems = InnNpc.buyItems()

		return sellItems
	end,

	onSayClick = async(function(player, npc)
		Waypoint.onSayClick()
	end)
}
