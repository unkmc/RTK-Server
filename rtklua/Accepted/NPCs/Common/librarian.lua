LibrarianNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Talk to Librarian"}
		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				LibrarianNpc.buyItems()
			)
		elseif menu == "Sell" then
			player:sellExtend("What are you willing to sell today?", LibrarianNpc.sellItems())
		elseif menu == "Talk to Librarian" then
			LibrarianNpc.onSayClick(player, npc)
		end
	end),

	buyItems = function()
		local buyOpts = {
			"legend",
			"divine_chronicles",
			"graced_by_the_muse",
			"the_wandering_monk",
			"tomes_of_the_earth",
			"ranger_code",
			"kwanhonsagje"
		}

		return buyOpts
	end,

	sellItems = function()
		local sellItems = LibrarianNpc.buyItems()

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "key_to_earth")
			table.insert(sellItems, "key_to_fire")
			table.insert(sellItems, "key_to_wind")
			table.insert(sellItems, "key_to_heaven")
			table.insert(sellItems, "key_to_pond")
			table.insert(sellItems, "key_to_thunder")
			table.insert(sellItems, "key_to_water")
			table.insert(sellItems, "key_to_mountain")
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

		if speech == "ironheart" or speech == "jadespear" then
			Tools.checkKarma(player)

			if player.quest["tutorial_quest"] == 5 then
				player:dialogSeq(
					{
						t,
						"Hello there, I see you have met my friend the Tutor. I hope he is doing well these days.",
						"This is the great library of the kingdom, here we store the knowledge of the ages.",
						"One of the prized items citizens come here for is the \"Legends\", a scroll that tells the great tales.",
						"Unfortunately, this item is very expensive, but perhaps when you are richer you will be able to get your own."
					},
					1
				)

				player:dialogSeq(
					{
						t,
						"... or better yet... make your own legend to be told in the scroll!",
						"Ah, what dreams, what wonders. Well, I must get back to work now. See you around, I hope to hear tales of your adventures soon.",
						"You should go back to the tutor now, and continue to learn more, he has so much to teach you."
					},
					1
				)

				player.quest["talked_to_tutor"] = 1
			end
		end

		if speech == "legend" and npc.mapTitle == "Pond's Library" then
			Tools.checkKarma(player)

			if not player:hasLegend("lost_legend") then
				player:dialogSeq(
					{t, "I really have no idea what you are talking about."},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"So you have the legend, I hope it helps you with all you need.",
					"What's that? You can't read it? Let me see...",
					"I can read it just fine, are you blind?",
					"Perhaps your mind is just not open to seeing beyond the surface of the paper.",
					"Seek out the light of life, when it is young, and then you will see what you need to see."
				},
				0
			)
		end

		if speech == "special collections" and npc.mapTitle == "Pond's Library" and player.quest[
			"spy_trials"
		] == 8 then
			local choices = {
				"The Rabbit Watchers",
				"Sleds and Snow",
				"Night Breeze"
			}
			player:dialogSeq(
				{
					t,
					"** Pond lays out some books of different colors and shapes **",
					"These are our special collections from Sanhae."
				},
				0
			)
			if os.time() < player.quest["spy_library_timer"] + 7200 then
				player:dialogSeq(
					{
						t,
						"Sorry, haven't heard anything from the other branches. Perhaps come back later."
					},
					0
				)
				return
			end
			local choice = player:menuSeq(
				"What kind of information are you looking for?",
				choices,
				{}
			)
			if choice == 3 then
				local jewels = {
					graphic = convertGraphic(1588, "item"),
					color = 0
				}
				player.quest["spy_trials"] = 9
				player:dialogSeq(
					{
						t,
						"Ah yes, this has been a popular one lately, and you're the second person today to ask for it!",
						"Although, you're much better dressed. Take a seat, and I'll get it for you."
					},
					0
				)
				player:dialogSeq(
					{
						jewels,
						"Word is that the Imperial Jewels are being transported by a special envoy from Buya to Nagnang for a diplomatic ceremony to build trust between the nations.",
						"We need to know who has them currently and logistics of their transport."
					},
					0
				)
				player:dialogSeq(
					{
						t,
						"And of course, they shouldn't get to the Nangen palace.",
						"We've observed him drinking outside the Buyan taverns during the night for the last week.",
						"You'll need a way to get Hwan to a quiet place to interrogate him. Our Buyan potion shop associate, Baegil, should be able to give you something.",
						"Ask him how to best receive our Special Guest"
					},
					0
				)
				return
			else
				player.quest["spy_library_timer"] = os.time()
				player:dialogSeq(
					{
						t,
						"Unfortunately, I think that one is on loan right now. Check back if you need something different..."
					},
					0
				)
			end
		end

		if speech == "special collections" and npc.mapTitle == "Pond's Library" and player.quest[
			"spy_trials"
		] == 9 then
			local jewels = {graphic = convertGraphic(1588, "item"), color = 0}
			player:dialogSeq(
				{
					t,
					"Ah yes, this has been a popular one lately, and you're the second person today to ask for it!",
					"Although, you're much better dressed. Take a seat, and I'll get it for you."
				},
				0
			)
			player:dialogSeq(
				{
					jewels,
					"Word is that the Imperial Jewels are being transported by a special envoy from Buya to Nagnang for a diplomatic ceremony to build trust between the nations.",
					"We need to know who has them currently and logistics of their transport."
				},
				0
			)
			player:dialogSeq(
				{
					t,
					"And of course, they shouldn't get to the Nangen palace.",
					"We've observed him drinking outside the Buyan taverns during the night for the last week.",
					"You'll need a way to get Hwan to a quiet place to interrogate him. Our Buyan potion shop associate, Baegil, should be able to give you something.",
					"Ask him how to best receive our Special Guest"
				},
				0
			)
			return
		end

		if speech == "legend" and npc.mapTitle == "Buya Library" then
			Tools.checkKarma(player)

			if player.quest["wind_armor"] == 0 then
				player:dialogSeq(
					{
						t,
						"Hrmmm... sorry, I don't know what you are talking about."
					},
					0
				)
				return
			end

			player.quest["wind_lake_cavern"] = 1

			player:dialogSeq(
				{
					t,
					"The lost legend of the winds? Yes, I know of it, but who are you to ask?",
					"Can you even imagine the cost of such knowledge to  yourself, and the world around you?",
					"But... perhaps it is time. I fear the secret has already been stolen from its vault by others, who would use it for the advancement of evil.",
					"I can not tell you all, for the journey is part of the key, remember to learn all you can on this trip, as you should always do in life.",
					"All you need to know from me is that deep within the caverns under the library is the answer you seek.",
					"Go now, and let nothing stop you from your goals."
				},
				0
			)

			--player:dialogSeq({t,"I am permitting you to pass into the Library Caverns, please take a lantern and be safe."},0)
		end

		if speech == "map" or speech == "fragment" or speech == "map fragment" then
			if player.quest["instance"] == 4 then
				player:dialogSeq(
					{
						t,
						"Here we go. It looks to be a map of some mountains north of here.",
						"Maybe someone with deep historical knowledge will be able to help you."
					},
					1
				)
			end
			if player.quest["instance"] == 3 then
				if player:hasItem("map_fragment", 5) == true then
					player:removeItem("map_fragment", 5)
					player:addItem("combined_map", 1)
					player.quest["instance"] = 4
					player:dialogSeq(
						{
							t,
							"Here we go. It looks to be a map of some mountains north of here.",
							"Maybe someone with deep historical knowledge will be able to help you."
						},
						1
					)
				else
					player:dialogSeq(
						{t, "Did you get more pieces of this map?"},
						1
					)
				end
			end
			if player.quest["instance"] == 2 then
				if player:hasItem("purified_water", 1) == true then
					player:removeItem("purified_water", 1)
					player.quest["instance"] = 3
					player:dialogSeq(
						{
							t,
							"Ah yes here we go, the piece is coming in more clear.",
							"It seems to be piece of a much larger map.",
							"Go collect for me 4 more pieces and we can put together a map to see where this goes."
						},
						1
					)
				else
					player:dialogSeq(
						{t, "Come back to me when you get some purified water."},
						1
					)
				end
			end
			if player:hasItem("map_fragment", 1) == true and player.quest["instance"] == 1 then
				player.quest["instance"] = 2
				player:dialogSeq(
					{
						t,
						"What is this? You were sent by Elder Zephyr to find out more about this map?",
						"It seems pretty dirty. Let's try and clean it up",
						"Go gather some purified water and come back to me. I will use great care on this precious piece."
					},
					1
				)
			end
		end
	end)
}
