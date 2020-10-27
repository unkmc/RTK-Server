SaerounNpc = {
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
				SaerounNpc.buyItems(npc)
			)
		elseif choice == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				SaerounNpc.sellItems(npc)
			)
		end
	end),

	buyItems = function(npc)
		local buyItems = {
			"little_red_mantle",
			"blue_necklace",
			"black_bandanna",
			"purple_bandanna",
			"white_bandanna",
			"brown_bandanna",
			"green_bandanna",
			"pink_bandanna",
			"pink_headband",
			"green_headband",
			"black_headband",
			"white_headband",
			"blue_headband",
			"red_headband"
		}

		local sellItems = {
			"little_red_mantle",
			"blue_necklace",
			"black_bandanna",
			"purple_bandanna",
			"white_bandanna",
			"brown_bandanna",
			"green_bandanna",
			"pink_bandanna",
			"pink_headband",
			"green_headband",
			"black_headband",
			"white_headband",
			"blue_headband",
			"red_headband",
			"teal_bandanna",
			"navy_bandanna",
			"darkpurple_bandanna",
			"orange_bandanna",
			"babyblue_bandanna",
			"lava_bandanna",
			"star_bandanna"
		}

		return buyItems
	end,

	sellItems = function(npc)
		buyItems = SaerounNpc.sellItems(npc)
		return buyItems
	end
}
