RingShopNpc = {
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

		local buyopts = RingShopNpc.buyItems(npc)
		local sellopts = RingShopNpc.sellItems(npc)

		local menu = player:menuString(
			"Hello! What would you like to do today?",
			opts
		)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buyopts
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", sellopts)
		end
	end),

	buyItems = function(npc)
		local buyItems = {
			"blue_ring",
			"red_ring",
			"purple_ring",
			"black_ring",
			"exorcist_ring"
		}

		return buyItems
	end,

	sellItems = function(npc)
		local sellItems = {
			"blue_ring",
			"red_ring",
			"purple_ring",
			"black_ring",
			"exorcist_ring",
			"quartz",
			"amethyst",
			"topaz",
			"mica",
			"small_amber_ring",
			"medium_amber_ring",
			"large_amber_ring",
			"small_dark_ring",
			"medium_dark_ring",
			"large_dark_ring",
			"small_yellow_ring",
			"medium_yellow_ring",
			"large_yellow_ring",
			"small_white_ring",
			"medium_white_ring",
			"large_white_ring",
			"small_baekho_ring",
			"medium_baekho_ring",
			"large_baekho_ring",
			"small_hyun_moo_ring",
			"medium_hyun_moo_ring",
			"large_hyun_moo_ring",
			"small_chung_ryong_ring",
			"medium_chung_ryong_ring",
			"large_chung_ryong_ring",
			"small_ju_jak_ring",
			"medium_ju_jak_ring",
			"large_ju_jak_ring",
			"plain_amber_bracelet",
			"luxury_amber_bracelet",
			"plain_dark_bracelet",
			"luxury_dark_bracelet",
			"plain_yellow_bracelet",
			"luxury_yellow_bracelet",
			"plain_white_braclet",
			"luxury_white_bracelet"
		}

		local ambers = {"amber", "dark_amber", "yellow_amber", "white_amber"}

		for i = 1, #ambers do
			table.insert(sellItems, ambers[i])
			table.insert(sellItems, "tarnished_" .. ambers[i])
			table.insert(sellItems, "crafted_" .. ambers[i])
			table.insert(sellItems, "well_crafted_" .. ambers[i])
		end

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "tao_stone")
			table.insert(sellItems, "pearl_charm")
		end

		return sellItems
	end,

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if npc.mapTitle == "Baegi Shop" then
			if speech == "shard" and player.quest["claw_soe"] == 3 then
				player:dialogSeq(
					{
						t,
						"I heard you were coming to ask me about this, so I have already started to get ready.",
						"The shards were basically a hollowed out Amethyst, with a magical enchantment to absorb the essence of the dragons."
					},
					1
				)

				if player:hasItem("amethyst", 1) ~= true then
					player:dialogSeq(
						{
							t,
							"I still have the tools I used to create them, but you will need to bring me an Amethyst to convert."
						},
						0
					)
					return
				end

				local choice = player:menuSeq(
					"I will need 2,000 gold for my time and effort, would you like me to change your Amethyst into a shard?",
					{"Yes", "No"},
					{}
				)

				if choice == 1 then
					if player.money < 2000 then
						player:dialogSeq(
							{
								t,
								"Very well, bring me 2,000 gold and we can get started."
							},
							0
						)
						return
					end

					player:removeGold(2000)
					player:removeItem("amethyst", 1)
					player:addItem("dragon_shard", 1)

					player:dialogSeq(
						{
							t,
							"There you go, only use it when you are around one of the great dragons, or it will shatter."
						},
						0
					)
				end
			end
		end
	end)
}
