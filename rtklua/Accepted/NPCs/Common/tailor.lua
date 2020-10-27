TailorNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Unengrave cashshop item"}
		local buyopts = {
			"Peasant clothes",
			"Mage's short garb",
			"Mage's clothes",
			"Poet's robes",
			"Poet's mantles",
			"Rogue's clothes",
			"Other items"
		}

		local choice

		local pclothes = {
			Item("peasant_clothes").id,
			Item("spring_garb").id,
			Item("spring_robes").id,
			Item("merchant_armor").id,
			Item("merchant waistcoat").id
		}
		local mshortgarb = {
			Item("summer_garb").id,
			Item("royal_garb").id,
			Item("sky_garb").id,
			Item("leather_garb").id,
			Item("blood_garb").id,
			Item("earth_garb").id
		}
		local mclothes = {
			Item("farmer_clothes").id,
			Item("royal_clothes").id,
			Item("sky_clothes").id,
			Item("ancient_clothes").id,
			Item("family_clothes").id,
			Item("earth_clothes").id
		}
		local srobes = {
			Item("summer_robes").id,
			Item("autumn_robes").id,
			Item("winter_robes").id,
			Item("ancient_robes").id,
			Item("blood_robes").id,
			Item("earth_robes").id
		}
		local rclothes = {
			Item("farmer_waistcoat").id,
			Item("royal_waistcoat").id,
			Item("sky_waistcoat").id,
			Item("ancient_waistcoat").id,
			Item("blood_waistcoat").id,
			Item("earth_waistcoat").id
		}
		local pmantles = {
			Item("summer_mantle").id,
			Item("autumn_mantle").id,
			Item("winter_mantle").id,
			Item("ancient_mantle").id,
			Item("blood_mantle").id,
			Item("earth_mantle").id
		}
		local oitems = {Item("green_cloak").id, Item("wedding_cloak").id}

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Buy" then
			choice = player:menuString(
				"What do you want to buy today?",
				buyopts,
				{}
			)

			local choice2 = {}

			if choice == "Peasant clothes" then
				choice2 = pclothes
			elseif choice == "Mage's short garb" then
				choice2 = mshortgarb
			elseif choice == "Mage's clothes" then
				choice2 = mclothes
			elseif choice == "Poet's robes" then
				choice2 = srobes
			elseif choice == "Poet's mantles" then
				choice2 = pmantles
			elseif choice == "Rogue's clothes" then
				choice2 = rclothes
			elseif choice == "Spiritual mantles" then
				choice2 = pmantles
			elseif choice == "Other items" then
				choice2 = oitems
			end

			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				choice2
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				TailorNpc.sellItems()
			)
		end
	end),

	buyItems = function()
		local buyItems = {}

		local pclothes = {
			Item("peasant_clothes").id,
			Item("spring_garb").id,
			Item("spring_robes").id,
			Item("merchant_armor").id,
			Item("merchant waistcoat").id
		}
		local mshortgarb = {
			Item("summer_garb").id,
			Item("royal_garb").id,
			Item("sky_garb").id,
			Item("leather_garb").id,
			Item("blood_garb").id,
			Item("earth_garb").id
		}
		local mclothes = {
			Item("farmer_clothes").id,
			Item("royal_clothes").id,
			Item("sky_clothes").id,
			Item("ancient_clothes").id,
			Item("family_clothes").id,
			Item("earth_clothes").id
		}
		local srobes = {
			Item("summer_robes").id,
			Item("autumn_robes").id,
			Item("winter_robes").id,
			Item("ancient_robes").id,
			Item("blood_robes").id,
			Item("earth_robes").id
		}
		local rclothes = {
			Item("farmer_waistcoat").id,
			Item("royal_waistcoat").id,
			Item("sky_waistcoat").id,
			Item("ancient_waistcoat").id,
			Item("blood_waistcoat").id,
			Item("earth_waistcoat").id
		}
		local pmantles = {
			Item("summer_mantle").id,
			Item("autumn_mantle").id,
			Item("winter_mantle").id,
			Item("ancient_mantle").id,
			Item("blood_mantle").id,
			Item("earth_mantle").id
		}
		local oitems = {Item("green_cloak").id, Item("wedding_cloak").id}

		for i = 1, #pclothes do
			table.insert(buyItems, pclothes[i])
		end
		for i = 1, #mshortgarb do
			table.insert(buyItems, mshortgarb[i])
		end
		for i = 1, #mclothes do
			table.insert(buyItems, mclothes[i])
		end
		for i = 1, #srobes do
			table.insert(buyItems, srobes[i])
		end
		for i = 1, #rclothes do
			table.insert(buyItems, rclothes[i])
		end
		for i = 1, #oitems do
			table.insert(buyItems, oitems[i])
		end
		for i = 1, #pmantles do
			table.insert(buyItems, pmantles[i])
		end

		return buyItems
	end,

	sellItems = function()
		local sellItems = TailorNpc.buyItems()

		return sellItems
	end
}
