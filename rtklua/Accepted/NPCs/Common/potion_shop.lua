PotionShopNpc = {
	on_spawn = function(npc)
		core.gameRegistry["red_potions_available"] = 2
	end,

	action = function(npc)
		core.gameRegistry["red_potions_available"] = 2
	end,

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

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		local buyopts = PotionShopNpc.buyItems(npc)
		local sellopts = PotionShopNpc.sellItems(npc)
		local maxAmounts = {}

		for i = 1, #buyopts do
			if buyopts[i] == "red_potion" then
				table.insert(
					maxAmounts,
					core.gameRegistry["red_potions_available"]
				)
			else
				table.insert(maxAmounts, 0)
			end
		end

		if menu == "Buy" then
			local boughtItem = player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyopts,
				{},
				maxAmounts
			)

			if boughtItem == nil then
				return
			end

			if Item(boughtItem[1]).yname == "red_potion" then
				local amount = boughtItem[2]
				if core.gameRegistry["red_potions_available"] - amount < 0 then
					core.gameRegistry["red_potions_available"] = 0
				else
					core.gameRegistry["red_potions_available"] = core.gameRegistry[
						"red_potions_available"
					] - 1
				end
			end
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellopts)
		end
	end),
	onSayClick = async(function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local speech = string.lower(player.speech)
		if speech == "special guest" and player.m == 28 and player.quest["spy_trials"] == 9 then
			player:dialogSeq(
				{
					t,
					"Ahhhhhhh, yes! I think I know what you need...",
					"This concoction is quick-acting but has a quick recovery. I need a Mountain Ginseng to finalize it, would you happen to have one?"
				},
				0
			)
			if player:hasItem("mountain_ginseng", 1) == true then
				player:removeItem("mountain_ginseng", 1)
				player:addItem("slumberquick", 1)
				player.quest["spy_trials"] = 10
				player.quest["spy_potion_timer"] = os.time()
				player:dialogSeq(
					{
						t,
						"Slip the Slumberquick into Hwan's drink. Once he's asleep, you'll only have four minutes to get him to the interrogation location before he wakes up.",
						"There is a tree in the middle of the Stealth Grotto that you could use to tie him up. No one can hear him scream down there, heh.",
						"Oh and if you need another vial, come back here and talk to me about our Special Guest again.",
						"It may take a bit to make though, this stuff is finnicky!"
					},
					0
				)
				return
			else
				return
			end
		end
		if speech == "special guest" and player.m == 28 and player.quest["spy_trials"] == 10 then
			if os.time() > player.quest["spy_potion_timer"] + 7200 then
				if player:hasItem("mountain_ginseng", 1) == true then
					player:removeItem("mountain_ginseng", 1)
					player:addItem("slumberquick", 1)
					player.quest["spy_potion_timer"] = os.time()
					player:dialogSeq(
						{
							t,
							"Slip the Slumberquick into Hwan's drink. Once he's asleep, you'll only have four minutes to get him to the interrogation location before he wakes up.",
							"There is a tree in the middle of the Stealth Grotto that you could use to tie him up. No one can hear him scream down there, heh.",
							"Oh and if you need another vial, come back here and talk to me about our Special Guest again.",
							"It may take a bit to make though, this stuff is finnicky!"
						},
						0
					)
					return
				else
					player:dialogSeq(
						{
							t,
							"I am going to need another Mountain Ginseng for this potion again."
						},
						0
					)
					return
				end
			else
				player:dialogSeq(
					{
						t,
						"Unfortunately, I am still preparing to make another. Please come back later."
					},
					0
				)
			end
		end
	end),

	buyItems = function(npc)
		local buyItems = {}
		local maxAmounts = {}
		local prices = {}

		if npc.mapTitle == "Baegil Shop" then
			if core.gameRegistry["red_potions_available"] > 0 then
				buyItems = {
					"yellow_potion",
					"blue_potion",
					"violet_potion",
					"brown_potion",
					"red_potion",
					"green_potion",
					"indigo_potion",
					"white_potion",
					"herb_pipe",
					"aged_wine",
					"moon_wine"
				}
				maxAmounts = {
					0,
					0,
					0,
					0,
					core.gameRegistry["red_potions_available"],
					0,
					0,
					0,
					0,
					0,
					0
				}
			else
				buyItems = {
					"yellow_potion",
					"blue_potion",
					"violet_potion",
					"brown_potion",
					"green_potion",
					"indigo_potion",
					"white_potion",
					"herb_pipe",
					"aged_wine",
					"moon_wine"
				}
			end
		elseif npc.mapTitle == "Bagai Shop" then
			if core.gameRegistry["red_potions_available"] > 0 then
				buyItems = {
					"yellow_potion",
					"blue_potion",
					"violet_potion",
					"brown_potion",
					"red_potion",
					"green_potion",
					"indigo_potion",
					"white_potion",
					"aged_wine",
					"thick_wine",
					"rich_wine"
				}
				maxAmounts = {
					0,
					0,
					0,
					0,
					core.gameRegistry["red_potions_available"],
					0,
					0,
					0,
					0,
					0,
					0
				}
			else
				buyItems = {
					"yellow_potion",
					"blue_potion",
					"violet_potion",
					"brown_potion",
					"green_potion",
					"indigo_potion",
					"white_potion",
					"aged_wine",
					"thick_wine",
					"rich_wine"
				}
			end
		end

		for i = 1, #buyItems do
			table.insert(prices, Item(buyItems[i]).price)
		end

		return buyItems, prices, maxAmounts
	end,

	sellItems = function(npc)
		local sellItems = PotionShopNpc.buyItems(npc)

		if core.gameRegistry["red_potions_available"] == 0 then
			table.insert(sellItems, "red_potion")
		end
		
		table.insert(sellItems, "ginseng_piece")
		table.insert(sellItems, "ginseng")
		table.insert(sellItems, "mountain_ginseng")

		return sellItems
	end
}
