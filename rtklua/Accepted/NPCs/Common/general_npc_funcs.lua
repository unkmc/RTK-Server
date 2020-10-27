general_npc_funcs = {
	setTitle = function(player, npc)
		if player.level < 75 then
			player:dialog(
				"Please return when you have reached the 75th insight.",
				{}
			)
		end

		local title = player:inputLetterCheck(player:inputSeq(
			"Your heart is in the right place. Which title shall you take?",
			"",
			"",
			{},
			{}
		))

		local strlen = string.len(title)

		if strlen > 12 then
			-- The string length of 12 was verified on NTK.  The only way to get a longer title (up to 16 characters) is to seek a Chongun who has Title of Nobility Spell.
			player:dialog(
				"Your entered title must be no greater than 12 characters.",
				{}
			)
			return
		end

		local totalcost = 200 * strlen

		local confirm = player:menuSeq(
			"For that title, " .. Tools.formatNumber(totalcost) .. " coins are required. You want to do that?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if player.money < totalcost then
				player:dialog(
					"You do not have the required " .. totalcost .. " gold to set this title.",
					{}
				)
				return
			end

			if player.title == title then
				player:dialog(
					"You would be wasting your money to set the same title twice.",
					{}
				)
				return
			end

			player:removeGold(totalcost)
			player.title = title
			player:sendMinitext("Your title has been changed to: " .. title)
			player:sendStatus()
		end
	end,

	checks = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local choiceA = player:menuSeq(
			"Greetings, and welcome to my shop. How can I help you today?",
			{"I need to buy a check.", "I need to cash a check."},
			{}
		)

		local checkopts = {
			"1,000 gold.",
			"5,000 gold.",
			"10,000 gold.",
			"50,000 gold.",
			"100,000 gold.",
			"500,000 gold.",
			"1,000,000 gold."
		}
		local checkAmounts = {1000, 5000, 10000, 50000, 100000, 500000, 1000000}
		local items = {
			"check_1000",
			"check_5000",
			"check_10000",
			"check_50000",
			"check_100000",
			"check_500000",
			"check_1000000"
		}

		if choiceA == 1 then
			-- buy check

			local choiceB = player:menuSeq(
				"Ah yes.. and how big a check would you like?",
				checkopts,
				{}
			)
			if player.money < checkAmounts[choiceB] then
				player:dialogSeq(
					{
						t,
						"Return when you have enough gold or choose a smaller check."
					},
					0
				)
				return
			end

			player:removeGold(checkAmounts[choiceB])
			player:addItem(items[choiceB], 1)

			player:dialogSeq(
				{
					t,
					"There you go. Just tell me if there is anything else I can do for you."
				},
				0
			)
			return
		elseif choiceA == 2 then
			-- cash check
			local choiceB = player:menuSeq(
				"Ah yes, and what check did you want to cash in?",
				checkopts,
				{}
			)

			if player:hasItem(items[choiceB], 1) ~= true then
				player:dialogSeq(
					{t, "You do not have a check in that amount."},
					0
				)
				return
			end

			player:addGold(checkAmounts[choiceB])
			player:removeItem(items[choiceB], 1, 9)

			player:dialogSeq({t, "There is your cash, glad to help."}, 0)

			return
		end
	end,

	warPaint = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local armor = player:getEquippedItem(EQ_ARMOR)
		local coat = player:getEquippedItem(EQ_COAT)

		local color = 0

		if armor == nil and coat == nil then
			player:dialogSeq(
				{
					t,
					"You need to have an armor or a coat equipped to see your war paint. You may continue but you will be unable to see your new colors until then."
				},
				1
			)
		else
			if armor ~= nil then
				color = Item(armor.id).lookC

				-- returns original color of the armor from item database (for bleaching back to normal)
			end

			if coat ~= nil then
				color = Item(coat.id).lookC

				-- returns original color of the armor from item database (for bleaching back to normal)
			end
		end

		clone.wipe(player)

		if player.armorColor ~= 0 then
			local choice = player:menuSeq(
				"You wish me to bleach your war paint for 10 gold?",
				{"Bleach me", "No"},
				{}
			)

			if choice == 1 then
				if player.money < 10 then
					player:dialogSeq(
						{t, "Return to me when you have enough gold."},
						0
					)
					return
				end

				player:removeGold(10)
				player.armorColor = 0
				player.gfxDye = 0
				player:refresh()

				player:dialogSeq({t, "It is done."}, 0)
				return
			elseif choice == 2 then
				player:dialogSeq({t, "As you wish."}, 0)
				return
			end
		elseif player.armorColor == 0 then
			-- not dyed

			if player.level == 99 then
				local dyes = {"Brown (1000 gold)"}
				local dyeCost = {1000}

				if player.baseHealth >= 50000 or player.baseMagic >= 25000 then
					table.insert(dyes, "Wasabi (5000 gold)")
					table.insert(dyeCost, 5000)
				end

				if player.baseHealth >= 160000 or player.baseMagic >= 80000 then
					table.insert(dyes, "Super Wasabi (12000 gold)")
					table.insert(dyeCost, 12000)
				end

				local choice = player:menuSeq(
					"Do you wish to consider a special dye, Great one?",
					{
						"Yes, please",
						"No, I am special enough without such dyes."
					},
					{}
				)

				if choice == 1 then
					-- saying yes to consider special dye
					local choice2 = player:menuSeq(
						"Which dye would you like, Great one?",
						dyes,
						{}
					)

					if player.money < dyeCost[choice2] then
						player:dialogSeq(
							{
								t,
								"If you cannot afford it, perhaps you are not so great afterall..."
							},
							0
						)
						return
					end

					player:removeGold(dyeCost[choice2])

					if choice2 == 1 then
						-- brown dye (you could use menuString here but then you will have to type out completely "Brown (1000 gold)"
						player.armorColor = 12

						-- brown
					elseif choice2 == 2 then
						player.armorColor = 16

						-- wasabi
					elseif choice2 == 3 then
						player.armorColor = 36

						-- super wasabi
					end
					player.gfxDye = 0
					player:refresh()
					player:dialogSeq({t, "It is done."}, 0)

					return
				end
			end

			--- default dialog text for everyone, including 99 unless they selected a special dye and hit the return statement above. If they chose to not dye theemselves, then they continue into the statements below

			local choice = player:menuSeq(
				"To engage in team battles you need a dye. It will cost you 20 coins, you want to do it?",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				-- yes
				if player.money < 20 then
					player:dialogSeq(
						{t, "Return to me when you have enough gold."},
						0
					)
					return
				end

				local teams = {
					"Hyun moo",
					"Ju jak",
					"Chung ryong",
					"Baekho",
					"Ash",
					"River",
					"Fire",
					"Snow"
				}
				local colors = {10, 21, 24, 11, 28, 17, 31, 29}

				local teamChoice = player:menuSeq(
					"Which team do you wish to join?",
					teams,
					{}
				)

				player:removeGold(20)

				player.armorColor = colors[teamChoice]
				player.gfxDye = 0
				player:refresh()

				player:dialogSeq(
					{
						t,
						"May the heavens favor a painless death.",
						"(Be sure to be able to group with your team. Press 'SHIFT G' to allow your Champion to group you.)",
						"(If you are the Champion, press 'g' to add or remove someone from your group.)"
					},
					0
				)
				return
			elseif choice == 2 then
				player:dialogSeq(
					{
						t,
						"You are not saying that 20 coins is too expensivve, are you? I can't make it any less expensive than that."
					},
					0
				)
				return
			end
		end
	end,

	wisdomClothes = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local items = {
			"chutze",
			"doolze",
			"setze",
			"netze",
			"dasutze",
			"yeoseutze",
			"yilgopze",
			"yeodulpze",
			"ahhopze",
			"yulze",
			"yeolhanbeunze",
			"yeoldoobeunze",
			"yeolsebeunze",
			"yeolnebeunze",
			"yeoldaseobeunze",
			"yeolyeoseobeunze",
			"yeolilgobbeunze",
			"yeolyeodeobeunze",
			"yeoahhopbeunze"
		}
		local itemType = ""

		if player.sex == 0 then
			-- male
			itemType = "robe"
		elseif player.sex == 1 then
			-- female
			itemType = "gown"
		end

		years = math.floor((os.time() - player.registry["firstTimeLogin"]) / 31557600)

		if years == 0 then
			player:dialogSeq(
				{
					t,
					"You are not yet ready to hold a " .. itemType .. " of wisdom. Come back later."
				},
				0
			)
			return
		end

		--player:talk(0,""..items[years].."_"..itemType)
		local item = Item(items[years] .. "_" .. itemType)

		if item == nil then
			return
		end

		-- 1 year = ChutZe gown or robe
		-- 2 year = DoolZe gown or robe
		-- 3 year = SetZe gown or robe
		-- 4 year = NetZe gown or robe
		-- 5 year = DaSutZe gown or robe
		-- 6 year = YeoSutZe gown or robe
		-- 7 year = YilGopZe gown or robe
		-- 8 year = YeoDulpZe gown or robe
		-- 9 year = AhHopZe gown or robe
		-- 10 year = YulZe gown or robe
		-- 11 year = YeolHanBeunZe gown or robe
		-- 12 year = YeolDooBeunZe gown or robe
		-- 13 year = YeolSeBeunZe gown or robe
		-- 14 year = YeolNeBeunZe gown or robe
		-- 15 year = YeolDaseoBeunZe gown or robe
		-- 16 year = YeolYeoSeoBeunZe gown or robe
		-- 17 year = YeolIlgobBeunZe gown or robe
		-- 18 year = YeolYeodeoBeunZe gown or robe
		-- 19 year = YeoAhHopBeunZe gown or robe

		local choice = player:menuSeq(
			"Ah, you have been here some time, can I interest you in a " .. item.name .. "?",
			{"Yes", "No"},
			{}
		)

		if choice == 1 then
			local subchoice = player:menuSeq(
				"I hate to even ask somebody of such wisdom, and who has been around our lands for so long, but I will need 100,000 gold to cover the expense of the material to make such a fine " .. itemType .. ". Are you willing to pay?",
				{"Yes, I am", "No, I am not"},
				{}
			)

			if subchoice == 1 then
				if player.money < 100000 then
					player:dialogSeq(
						{
							t,
							"I am very glad you are willing to pay, as soon as you have the gold come back and I will sell you one."
						},
						0
					)
					return
				end

				player:removeGold(100000)
				player:addItem(item.name, 1, 0, player.ID)
				player:dialogSeq(
					{
						t,
						"Here is your " .. item.name .. ", wear it with great pride."
					},
					0
				)
			elseif subchoice == 2 then
				player:dialogSeq(
					{
						t,
						"I am very sorry, but the material for these robes is very expensive. I must insist on the gold."
					},
					0
				)
			end
		end
	end,

	moveToCountry = function(player, npc, country)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level < 20 then
			player:dialogSeq(
				{
					t,
					"Hello! You are still too new to these lands to consider moving to another kingdom. Perhaps when you are ready."
				},
				0
			)
			return
		end

		if player.country ~= 0 and country ~= 0 then
			-- Aligned to kingdom already and trying to join another kingdom that is not wilderness
			player:dialogSeq(
				{
					t,
					"I cannot allow you to move here while you pledge your loyalty to another kingdom. Only someone who is neutral can join a kingdom."
				},
				0
			)
			return
		end

		if country == 0 then
			-- Wilderness

			if player.country == 0 then
				--already neutral
				player:dialogSeq({t, "Ah, the free life. Isn't it great?"}, 0)
				return
			end

			if player.country ~= 0 then
				player:dialogSeq(
					{
						t,
						"Welcome there city dweller. Isn't it wonderful out here?",
						"Would you like to leave the city behind, and become a member of the wilderness?",
						"Doing so means you will leave all that you have behind, your clan, your loyalties, your home, and your companions."
					},
					1
				)

				local subchoice = player:menuSeq(
					"Are you still interested in becoming Neutral?",
					{"No, I'd prefer not to.", "Yes, please."},
					{}
				)

				if subchoice == 2 then
					player:updateCountry(0)
					player.registry["home"] = 0
					player:sendStatus()

					--player:dialogSeq({t,"Welcome to the wilderness. ((Log out and back in for this change to take effect."},0)
					player:dialogSeq({t, "Welcome to the wilderness."}, 0)
					return
				end
			end
		end

		if country == 1 then
			-- move to kugnae city

			if player.country == 1 then
				player:dialogSeq({t, "Greetings, fellow Koguryian."}, 0)
				return
			end

			local choice = player:menuSeq(
				"Would you like to become a citizen of our lovely city, Kugnae?",
				{"No, thank you.", "Yes, very much."},
				{}
			)

			if choice == 2 then
				if player:hasItem("gold_acorn", 20) ~= true then
					player:dialogSeq(
						{
							t,
							"Kugnae requests 20 gold acorns as tribute to move, come back when you have that."
						},
						0
					)
					return
				end

				player:removeItem("gold_acorn", 20)
				player:updateCountry(country)
				player.registry["home"] = 0
				player:dialogSeq({t, "Welcome to Kugnae."}, 0)
			end
		end

		if country == 2 then
			-- move to buya city

			if player.country == 2 then
				player:dialogSeq({t, "Greetings, fellow Buyan."}, 0)
				return
			end

			local choice = player:menuSeq(
				"Would you like to become a citizen of our lovely city, Buya?",
				{"No, thank you.", "Yes, very much."},
				{}
			)

			if choice == 2 then
				if player:hasItem("gold_acorn", 20) ~= true then
					player:dialogSeq(
						{
							t,
							"Buya requests 20 gold acorns as tribute to move, come back when you have that."
						},
						0
					)
					return
				end

				player:removeItem("gold_acorn", 20)
				player:updateCountry(country)
				player.registry["home"] = 0
				player:dialogSeq({t, "Welcome to Buya."}, 0)
			end
		end

		if country == 3 then
			-- move to nagnang city

			if player.country == 3 then
				player:dialogSeq({t, "Greetings, fellow Nagnang citizen."}, 0)
				return
			end

			local choice = player:menuSeq(
				"Would you like to become a citizen of our lovely city, Nagnang?",
				{"No, thank you.", "Yes, very much."},
				{}
			)

			if choice == 2 then
				if player:hasItem("gold_acorn", 20) ~= true then
					player:dialogSeq(
						{
							t,
							"Nagnang requests 20 gold acorns as tribute to move, come back when you have that."
						},
						0
					)
					return
				end

				player:removeItem("gold_acorn", 20)
				player:updateCountry(country)
				player.registry["home"] = 0
				player:dialogSeq({t, "Welcome to Nagnang."}, 0)
			end
		end
	end,

	broadcastEvent = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level < 11 then
			player:dialogSeq(
				{
					t,
					"After you have reached level 11, you will be able to broadcast messages to the RetroTK community regarding an event you are hosting."
				},
				0
			)
			return
		end

		if player.registry["hostCommunityEventTimer"] > os.time() then
			player:dialogSeq(
				{
					t,
					"You have broadcasted to RetroTK recently. Please wait one day."
				},
				0
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"You may broadcast a message about an event you are hosting. You may do this once per day. The fee is 2,000 gold."
			},
			1
		)

		local choice = player:menuSeq(
			"Do you wish to pay 2,000 gold.",
			{"Yes", "No, I've changed my mind."},
			{}
		)

		if choice == 1 then
			if player.money < 2000 then
				player:dialogSeq({t, "Return when you have enough gold."}, 0)
				return
			end

			local events = {
				"Auction",
				"Giveaway",
				"Trivia contest",
				"My event is pretty complicated. I have",
				"   posted about it on Community Events."
			}
			local eventLocations = {
				"North gate",
				"East gate",
				"South gate",
				"West gate",
				"Palace"
			}
			local eventLocationChoice = 0

			local place = ""

			if player.region == 0 then
				place = "Kugnae"
			elseif player.region == 1 then
				place = "Buya"
			elseif player.region == 2 then
				place = "Mythic"
			else
				place = "Mythic"
			end

			local subchoice = player:menuSeq(
				"Which type of event are you announcing?",
				events,
				{}
			)

			if subchoice == 1 or subchoice == 2 or subchoice == 3 then
				eventLocationChoice = player:menuSeq(
					"Where should people assemble for this " .. events[
						subchoice
					],
					eventLocations,
					{}
				)
				broadcast(
					-1,
					player.name .. " is hosting a " .. events[subchoice] .. " at " .. place .. " " .. eventLocations[
						eventLocationChoice
					]
				)
			elseif subchoice == 4 or subchoice == 5 then
				local gender = ""
				if player.sex == 0 then
					gender = "his"
				elseif player.sex == 1 then
					gender = "her"
				end

				broadcast(
					-1,
					player.name .. " invites all to read about " .. gender .. " event on Community events"
				)
			end

			player:removeGold(2000)
			player.registry["hostCommunityEventTimer"] = os.time() + 86400
		end
	end,

	massExchange = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		--player:dialogSeq({t,"Disabled until further notice."},0)

		local goldAmount = 0

		local id = 0
		local amount = 0
		local engrave = ""
		local time = 0
		local owner = 0

		local bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable = player:bankItemsList()

		local itemsToTrade = {}

		player:dialogSeq(
			{
				t,
				"Greetings. This ability allows you to sell a large quantity of items directly from your bank to another person's bank.",
				"The person you are trading with must be close to you, and have the money on them, or items in their bank."
			},
			1
		)
		local input = player:inputSeq(
			"Who is the person you are trading with?",
			"I am trading with",
			"today.",
			{},
			{}
		)

		local tradee = Player(input)

		if tradee == nil then
			-- Online check
			player:dialogSeq(
				{
					t,
					"Sorry, I can't find " .. input .. " in the market. Ask them to come here to trade."
				},
				0
			)
			return
		end

		if tradee.m ~= player.m or not distanceSquare(player, tradee, 5) then
			-- Distance check
			player:dialogSeq(
				{
					t,
					"Sorry, I can't find " .. tradee.name .. " in the market. Ask them to come here to trade."
				},
				0
			)
			return
		end

		-- NTK sucks.... "You can't trade with an unregistered player or a player below level 11."

		if tradee.level < 11 then
			player:dialogSeq(
				{t, "You can't trade with a player below level 11."},
				0
			)
			return
		end

		if player.level < 11 then
			player:dialogSeq(
				{t, "You can't trade until you are level 11 or higher."},
				0
			)
			return
		end

		if player.name == tradee.name then
			player:dialogSeq({t, "You can't trade with yourself."}, 0)
			return
		end

		local goldChoice = player:menuSeq(
			"Will you be adding any gold to this trade?",
			{"Yes", "No"},
			{}
		)

		if goldChoice == 1 then
			goldAmount = player:inputNumberCheck(player:inputSeq("How much gold are you adding?", "I will add", "gold.", {}, {}))

			if goldAmount > player.money then
				player:dialogSeq({t, "You don't have that much gold."}, 0)
				return
			end
		end

		local itemChoice = player:menuSeq(
			"Do you wish to add an item?",
			{"Yes", "No"},
			{}
		)

		repeat

			if itemChoice == 1 then
				itemsToTrade, bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable = general_npc_funcs.massExchangeWithdraw(
					player,
					npc,
					itemsToTrade,
					bankItemTable,
					bankCountTable,
					bankOwnerTable,
					bankEngraveTable,
					bankTimerTable
				)

				itemChoice = player:menuSeq(
					"Do you wish to add another item?",
					{"Yes", "No"},
					{}
				)
			elseif itemChoice == 2 then
				break
			end
		until itemChoice == 2

		local itemString = ""

		itemString = itemString .. player.name .. " added " .. Tools.formatNumber(tonumber(goldAmount)) .. " gold.\n"

		if itemsToTrade ~= nil then
			for i = 1, #itemsToTrade do
				itemString = itemString .. itemsToTrade[i].amount .. " " .. Item(itemsToTrade[i].id).name .. "\n"
			end
		end

		player:dialogSeq({t, itemString}, 1)

		local confirm = player:menuSeq("Is that correct?", {"Yes", "No"}, {})

		if confirm == 1 then
			player:dialogSeq({t, "Ok, let me get the other traders list."}, 1)

			tradee:freeAsync()
			general_npc_funcs.counterTrade(
				tradee,
				player,
				npc,
				goldAmount,
				itemsToTrade
			)
		elseif confirm == 2 then
			player:dialogSeq({t, "Oh, then we better start again."}, 0)
			return
		end
	end,

	counterTrade = async(function(player, trader, npc, goldOffered, itemsOffered)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local goldAmount = 0

		local id = 0
		local amount = 0
		local engrave = ""
		local time = 0
		local owner = 0

		local bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable = player:bankItemsList()

		local itemsToTrade = {}

		local choice = player:menuSeq(
			trader.name .. " is trying to trade with you. Are you ready to trade?",
			{"Yes", "No"},
			{}
		)

		local itemsOfferedString = ""

		itemsOfferedString = itemsOfferedString .. trader.name .. " added " .. Tools.formatNumber(tonumber(goldOffered)) .. " gold.\n"

		if itemsOffered ~= nil then
			for i = 1, #itemsOffered do
				itemsOfferedString = itemsOfferedString .. itemsOffered[i].amount .. " " .. Item(itemsOffered[i].id).name .. "\n"
			end
		end

		player:dialogSeq({t, itemsOfferedString}, 1)

		local goldChoice = player:menuSeq(
			"Will you be adding any gold to this trade?",
			{"Yes", "No"},
			{}
		)

		if goldChoice == 1 then
			goldAmount = player:inputNumberCheck(player:inputSeq("How much gold are you adding?", "I will add", "gold.", {}, {}))

			if goldAmount > player.money then
				player:dialogSeq({t, "You don't have that much gold."}, 0)
				return
			end
		end

		local itemChoice = player:menuSeq(
			"Do you wish to add an item?",
			{"Yes", "No"},
			{}
		)

		repeat

			if itemChoice == 1 then
				itemsToTrade, bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable = general_npc_funcs.massExchangeWithdraw(
					player,
					npc,
					itemsToTrade,
					bankItemTable,
					bankCountTable,
					bankOwnerTable,
					bankEngraveTable,
					bankTimerTable
				)

				itemChoice = player:menuSeq(
					"Do you wish to add another item?",
					{"Yes", "No"},
					{}
				)
			elseif itemChoice == 2 then
				break
			end
		until itemChoice == 2

		local itemString = ""

		itemString = itemString .. player.name .. " added " .. Tools.formatNumber(tonumber(goldAmount)) .. " gold.\n"

		if itemsToTrade ~= nil then
			for i = 1, #itemsToTrade do
				itemString = itemString .. itemsToTrade[i].amount .. " " .. Item(itemsToTrade[i].id).name .. "\n"
			end
		end

		player:dialogSeq({t, itemString}, 1)

		player:dialogSeq(
			{t, "Ok, so you will get this:\n" .. itemsOfferedString},
			1
		)
		player:dialogSeq({t, "Ok, and you will give this:\n" .. itemString}, 1)

		local confirm = player:menuSeq(
			"Is that all correct?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			trader:freeAsync()
			general_npc_funcs.finalTrade(
				trader,
				player,
				npc,
				goldAmount,
				itemsToTrade,
				goldOffered,
				itemsOffered
			)
		elseif confirm == 2 then
			player:dialogSeq({t, "Oh, better start again then."}, 0)
		end
	end),

	finalTrade = async(function(player, trader, npc, goldOffered, itemsOffered, goldPlayerOffered, itemsPlayerOffered)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local goldAmount = 0

		local id = 0
		local amount = 0
		local engrave = ""
		local time = 0
		local owner = 0

		local itemString = ""

		itemString = itemString .. trader.name .. " added " .. Tools.formatNumber(tonumber(goldOffered)) .. " gold.\n"

		if itemsOffered ~= nil then
			for i = 1, #itemsOffered do
				itemString = itemString .. itemsOffered[i].amount .. " " .. Item(itemsOffered[i].id).name .. "\n"
			end
		end

		local itemsPlayerOfferedString = ""

		itemsPlayerOfferedString = itemsPlayerOfferedString .. player.name .. " added " .. Tools.formatNumber(tonumber(goldPlayerOffered)) .. " gold.\n"

		if itemsPlayerOffered ~= nil then
			for i = 1, #itemsPlayerOffered do
				itemsPlayerOfferedString = itemsPlayerOfferedString .. itemsPlayerOffered[
					i
				].amount .. " " .. Item(itemsPlayerOffered[i].id).name .. "\n"
			end
		end

		player:dialogSeq(
			{t, "The other trader has added this to the list:\n" .. itemString},
			1
		)
		player:dialogSeq(
			{
				t,
				"You are giving in exchange this:\n" .. itemsPlayerOfferedString
			},
			1
		)

		local confirm = player:menuSeq(
			"Is that all correct?",
			{"Yes", "No"},
			{}
		)

		if player == nil then
			return
		end
		if trader == nil then
			return
		end

		if confirm == 1 then
			player:dialogSeq({t, "Very well, let me make the exchange."}, 1)
			general_npc_funcs.completeTrade(
				player,
				trader,
				npc,
				goldOffered,
				itemsOffered,
				goldPlayerOffered,
				itemsPlayerOffered
			)
		end
	end),

	completeTrade = function(trader, tradee, npc, goldOffered, itemsOffered, goldPlayerOffered, itemsPlayerOffered)
		-- trader = original trade initiator, tradee = 2nd person in the trade
		local goldAmount = 0

		local id = 0
		local amount = 0
		local name = ""
		local realName = ""
		local time = 0
		local owner = 0

		local fraud = false

		-- check to make sure items are still present in banks --

		if itemsOffered ~= nil then
			for i = 1, #itemsOffered do
				local bankItem = tradee:retrieveBankItem(itemsOffered[i].id)

				if bankItem == nil then
					fraud = true
				end

				if bankItem[2] < itemsOffered[i].amount then
					fraud = true
				end
			end
		end

		if itemsPlayerOffered ~= nil then
			for i = 1, #itemsPlayerOffered do
				local bankItem = trader:retrieveBankItem(itemsPlayerOffered[i].id)

				if bankItem == nil then
					fraud = true
				end

				if bankItem[2] < itemsPlayerOffered[i].amount then
					fraud = true
				end
			end
		end

		---- check to make sure each individual in transaction still has the gold --
		if trader.money < goldPlayerOffered then
			fraud = true
		end

		if tradee.money < goldOffered then
			fraud = true
		end

		if fraud then
			trader:dialogSeq(
				{
					t,
					"Mass exchange cancelled due to attempted fraud. GMs notified."
				},
				0
			)
			tradee:dialogSeq(
				{
					t,
					"Mass exchange cancelled due to attempted fraud. GMs notified."
				},
				0
			)
			return
		end

		------------------------------------------------------

		--- handle gold --
		tradee:addGold(tonumber(goldPlayerOffered))
		tradee:sendMinitext("You have received " .. goldPlayerOffered .. " gold")
		trader:removeGold(tonumber(goldPlayerOffered))
		trader:sendMinitext("You gave " .. goldPlayerOffered .. " gold")

		trader:addGold(tonumber(goldOffered))
		trader:sendMinitext("You have received " .. goldOffered .. " gold")
		tradee:removeGold(tonumber(goldOffered))
		tradee:sendMinitext("You gave " .. goldOffered .. " gold")

		--- end handle gold --

		-- handle items --

		--[[trader:talk(0,"items offered from tradee")
	for i = 1, #itemsOffered do
		trader:talk(0,""..itemsOffered[i].id.." amt: "..itemsOffered[i].amount)
	end

	trader:talk(0,"items offered from trader")
	for i = 1, #itemsPlayerOffered do
		trader:talk(0,""..itemsPlayerOffered[i].id.." amt: "..itemsPlayerOffered[i].amount)
	end]]
		--

		if itemsOffered ~= nil then
			for i = 1, #itemsOffered do
				trader:bankDeposit(
					itemsOffered[i].id,
					itemsOffered[i].amount,
					itemsOffered[i].owner,
					itemsOffered[i].time,
					itemsOffered[i].realName
				)
				tradee:bankWithdraw(
					itemsOffered[i].id,
					itemsOffered[i].amount,
					itemsOffered[i].owner,
					itemsOffered[i].time,
					itemsOffered[i].realName
				)
			end
		end

		if itemsPlayerOffered ~= nil then
			for i = 1, #itemsPlayerOffered do
				trader:bankWithdraw(
					itemsPlayerOffered[i].id,
					itemsPlayerOffered[i].amount,
					itemsPlayerOffered[i].owner,
					itemsPlayerOffered[i].time,
					itemsPlayerOffered[i].realName
				)
				tradee:bankDeposit(
					itemsPlayerOffered[i].id,
					itemsPlayerOffered[i].amount,
					itemsPlayerOffered[i].owner,
					itemsPlayerOffered[i].time,
					itemsPlayerOffered[i].realName
				)
			end
		end

		characterLog.massExchangeWrite(
			trader,
			goldPlayerOffered,
			itemsPlayerOffered,
			tradee,
			goldOffered,
			itemsOffered
		)

		trader:sendMinitext("The trade is complete")
		tradee:sendMinitext("The trade is complete")
	end,

	massExchangeWithdraw = function(player, npc, itemsToTrade, bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable)
		local found = 0
		local amount = 0
		local counter = 0
		local next = next

		i = 1
		while i <= #bankItemTable do
			if (bankItemTable[i] == 0) then
				table.remove(bankItemTable, i)
				table.remove(bankCountTable, i)
				table.remove(bankOwnerTable, i)
				table.remove(bankEngraveTable, i)
				table.remove(bankTimerTable, i)
				i = i - 1
			end
			i = i + 1
		end

		local bankItemTableNames = {}
		for i = 1, #bankItemTable do
			table.insert(bankItemTableNames, Item(bankItemTable[i]).name)
		end

		for i = 1, #bankItemTableNames do
			if bankOwnerTable[i] ~= 0 then
				bankItemTableNames[i] = bankItemTableNames[i] .. " - BONDED"
			end
		end

		local sortedbankItemTable = sort_relative(
			bankItemTableNames,
			bankItemTable
		)
		local sortedbankCountTable = sort_relative(
			bankItemTableNames,
			bankCountTable
		)
		local sortedbankOwnerTable = sort_relative(
			bankItemTableNames,
			bankOwnerTable
		)
		local sortedbankEngraveTable = sort_relative(
			bankItemTableNames,
			bankEngraveTable
		)
		local sortedbankTimerTable = sort_relative(
			bankItemTableNames,
			bankTimerTable
		)

		bankItemTable = sortedbankItemTable
		bankCountTable = sortedbankCountTable
		bankOwnerTable = sortedbankOwnerTable
		bankEngraveTable = sortedbankEngraveTable
		bankTimerTable = sortedbankTimerTable

		if (#bankItemTable == 0) then
			player:dialogSeq({"Your bank is currently empty."})
			return false
		end

		local temp = player:buy(
			"What item do you want to add?",
			bankItemTable,
			bankCountTable,
			bankEngraveTable,
			bankOwnerTable,
			{},
			{},
			{}
		)

		for i = 1, 255 do
			if (Item(bankItemTable[i]).name == temp or bankEngraveTable[i] == temp) then
				found = i
				break
			end
		end

		if (found == 0) then
			return
		end

		if Item(bankItemTable[found]).exchangeable or Item(bankItemTable[found]).depositable then
			player:dialogSeq({"You cannot trade that item."})
			return
		end

		if (Item(bankItemTable[found]).stackAmount > 1 and bankCountTable[found] > 1) then
			amount = player:inputNumberCheck(player:input("How many shall you withdraw for the trade?"))

			if (amount > bankCountTable[found]) then
				amount = bankCountTable[found]
			end
		else
			amount = 1
		end

		if (amount <= 0) then
			return
		end

		local item = {
			id = bankItemTable[found],
			amount = amount,
			name = Item(bankItemTable[found]).name,
			owner = bankOwnerTable[found],
			realName = bankEngraveTable[found],
			time = bankTimerTable[found]
		}

		bankCountTable[found] = bankCountTable[found] - amount
		table.insert(itemsToTrade, item)

		i = 1
		while i <= #bankCountTable do
			if (bankCountTable[i] <= 0) then
				table.remove(bankItemTable, i)
				table.remove(bankCountTable, i)
				table.remove(bankOwnerTable, i)
				table.remove(bankEngraveTable, i)
				table.remove(bankTimerTable, i)
				i = i - 1
			end
			i = i + 1
		end

		return itemsToTrade, bankItemTable, bankCountTable, bankOwnerTable, bankEngraveTable, bankTimerTable
	end,

	freeWorldShout = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if os.time() < player.registry["gave_fragile_orb_of_world_shout_time"] then
			player:dialogSeq(
				{
					t,
					"You have received an fragile orb of world shout too recently."
				},
				0
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"This is an experimental feature and is temporary. Fragile Orb of World Shout will let you shout to the whole world once every hour, and it will last for 24 hours.",
				"Here is your free Fragile Orb of World Shout."
			},
			1
		)
		player.registry["gave_fragile_orb_of_world_shout_time"] = os.time() + 86400
		player:addItem("fragile_orb_of_world_shout", 1, 0, 0, os.time() + 86400)
	end,

	time = function(player)
		local monthString = ""

		local year = curYear()
		local month = math.abs(os.date("%m"))
		local day = curDay()
		local dayString = ""
		local dayNames = {"Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"}
		local dayNames2 = dayNames[(curDay() % 7) + 1]
		local time = curTime()
		local timeString = ""

		if month == 1 then
			monthString = "st"
		elseif month == 2 then
			monthString = "nd"
		elseif month == 3 then
			monthString = "rd"
		elseif month >= 4 then
			monthString = "th"
		end

		if day == 1 then
			dayString = "st"
		elseif day == 2 then
			dayString = "nd"
		elseif day == 3 then
			dayString = "rd"
		elseif day >= 4 then
			dayString = "th"
		end

		if time <= 12 then
			timeString = "a.m."
		elseif time > 12 then
			timeString = "p.m."
			time = time - 12
		end

		player:sendMinitext("Yuri " .. year .. ", " .. month .. "" .. monthString .. " Moon, " .. day .. "" .. dayString)
		player:sendMinitext(dayNames2 .. " " .. time .. " " .. timeString)
	end,

	reincarnate = function(player, npc)
		if player.state ~= 1 then
			player:dialog("You are already alive.", {})
			return
		end
		resurrect.cast(player)
	end,

	observe = function(player, npc)
		if player.state ~= 1 then
			local choice2 = player:menuSeq(
				"You have to be dead to observe. Do not worry, it will not hurt a bit. Are you ready?",
				{"Yes", "No"},
				{}
			)
			if choice2 == 1 then
				onDismount(player)
				player.state = 1
				player:flushDuration(1)
				player:updateState()
			end
		end
	end,

	novices = function(player, npc, choice)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local novices_opts = {
			"Help!",
			"Give me a quick tour, please.",
			"Keyboard commands",
			"Finding a place",
			"I'm lost!",
			"My character",
			"I died!",
			"I'm naked",
			"Food",
			"Money",
			"Choosing a Path",
			"Adventuring with others",
			"Joining a clan",
			"Joining a subpath",
			"Registering my character",
			"How can I contact RetroTKeborn staff?",
			"Show me other Help topics."
		}

		if choice == nil then
			choice = player:menuString(
				"Please select a help topic from the list below",
				novices_opts
			)
		end

		if choice == "Help!" then
			player:dialogSeq(
				{
					t,
					"If you have problems that prevent you from playing the game, please ask in the RTK discord for help resolving your problem",
					"If you are unsure what you need to do, try reading the Guide or Welcome to RetroTK boards.",
					"Asking other players politely is also another way to get some wonderful help."
				},
				1
			)
			general_npc_funcs.novices(player, npc)
		elseif choice == "Give me a quick tour, please." then
			local countries = {"Kugnae", "Buya", "Nagnang"}

			local countryChoice = player:menuString(
				"Which country would you like to visit?",
				countries
			)

			if countryChoice == "Kugnae" then
				local placeChoices = {
					"IronHeart's home (Tutorial)",
					"Inn",
					"Butcher",
					"Smith",
					"Seamster",
					"Seamstress",
					"Dawn Shaman",
					"Dusk Shaman",
					"Warrior's Guild",
					"Rogue's Guild",
					"Mage's Guild",
					"Poet's Guild",
					"Woodlands Alchemist",
					"Vagabond Alchemist",
					"Arena",
					"Jail",
					"Chapel",
					"Palace",
					"I'm done"
				}

				local placeChoice = player:menuString(
					"Where in Koguryo would you like to visit?",
					placeChoices
				)

				if placeChoice == "IronHeart's home (Tutorial)" then
					local tironheart = {
						graphic = convertGraphic(
							NPC("IronHeart").look,
							"monster"
						),
						color = NPC("IronHeart").lookColor
					}
					player:dialogSeq(
						{
							tironheart,
							"There are many things you need to learn in the world of RetroTKeborn. The tutor can teach you some of those things."
						},
						1
					)
					player:warp(36, 7, 6)
				elseif placeChoice == "Inn" then
					local tinn = {
						graphic = convertGraphic(NPC("Walsuk").look, "monster"),
						color = NPC("Walsuk").lookColor
					}
					player:dialogSeq(
						{
							tinn,
							"Meet your friends and store your precious items here. You can use a yellow scroll to return here, as well."
						},
						1
					)
					player:warp(2, 18, 6)
				elseif placeChoice == "Butcher" then
					local tbutcher = {
						graphic = convertGraphic(NPC("Ogi").look, "monster"),
						color = NPC("Ogi").lookColor
					}
					player:dialogSeq(
						{
							tbutcher,
							"You can sell acorns to the butcher. If you're a warrior, you can buy antlers or bear's livers for health."
						},
						1
					)
					player:warp(43, 6, 7)
				end

				--I'm done : It was my pleasure to be your guide. I hope you explore much more. Farewell.
			elseif countryChoice == "Buya" then
			elseif countryChoice == "Nagnang" then
			end
		elseif choice == "Keyboard commands" then
			local commands = {
				"Socializing",
				"Adventuring",
				"Looking at my character",
				"None of this"
			}

			local commandChoice = player:menuString(
				"What do you need help with?",
				commands
			)

			if commandChoice == "Socializing" then
				player:dialogSeq(
					{
						t,
						" Socializing\nSpeak <single quote>\nEmotion <colon>\nWhisper <shift><quote>\nBulletin boards<b>\nSee heroes <ctrl>+<w>\nBe sociable <shift>+<g>\nGain a group member <g>\nHistory <shift>+<uparrow>\nIgnore someone <F9>"
					},
					1
				)
			elseif commandChoice == "Adventuring" then
				player:dialogSeq(
					{
						t,
						" Adventuring\nUse an item <u>\nAttack <space>\nTake an item <comma>\nTake all <shift>+<comma>\nOpen/Close <o>\nLook <semi-colon>\nRide a horse <r>\nTake off <shift>+<t>\nDrop something <d>\nUse a talent <shift>+<z>"
					},
					1
				)
			elseif commandChoice == "Looking at my character" then
				player:dialogSeq(
					{
						t,
						"Get mail <b>\nGet parcel by going to messengers\nStatus <s>\nMore status <Page Down>\nOptions <F10>\nInventory <i>\nUse an object <u>\nUse a secret <shift>+<z>\nHand an object <h>\nHand many objects <shift>+<h>\nHand coins <h>,<backslash>"
					},
					1
				)
			elseif commandChoice == "None of this" then
				return
			end

			general_npc_funcs.novices(player, npc, choice)
		elseif choice == "Finding a place" then
			player:dialogSeq(
				{
					t,
					"Hello, you're looking for something it seems. I can help you find many places in the main cities."
				},
				1
			)

			local cities = {
				"Kugnae",
				"Buya",
				"Nagnang",
				"What do the numbers mean?",
				"I'm done"
			}

			local cityChoice = player:menuString(
				"Which city do you need directions for?",
				cities
			)

			if cityChoice == "Kugnae" then
				player:dialogSeq(
					{
						t,
						" Kugnae Shops\nInn 51,151\nButcher 41,131\nSmith 60,123\nSeamster 82,168\nSeamstress 83,160\nMessenger 95,48\nWood Alchemist 196,200\nVagbnd Alchemist 17,13\nDawn Shaman 198,94\nDusk Shaman 42,92"
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"Kugnae Halls\nTutorial 88,148\nWarrior's Guild 48,37\nRogue's Guild 22,188\nMage's Guild 169,63\nPoet's Guild 184,182\nArena 185,31\nJail/Justice 156,157\nChapel 153,188\nPalace 111,122"
					},
					1
				)
			elseif cityChoice == "Buya" then
				player:dialogSeq(
					{
						t,
						" Buya Shops\nInn 39,105\nButcher 39,129\nSmith 18,103\nSeamster 19,127\nSeamstress 19,119\nMessenger 97,131\nStorm Shaman 125,58\nFelis Shaman 29,57"
					},
					1
				)
				player:dialogSeq(
					{
						t,
						" Buya Halls\nTutorial 55,122\nWarrior's Guild 26,25\nRogue's Guild 21,88\nMage's Guild 126,35\nPoet's Guild 96,101\nArena 126,74\nJail/Justice 10,50\nChapel 73,102\nPalace 73,54"
					},
					1
				)
			elseif cityChoice == "Nagnang" then
				player:dialogSeq(
					{
						t,
						" Nagnang Shops\nButcher 38,129\nSmith 21,88\nSeamster 18,127\nSeamstress 19,119\nMessenger 96,131\nMountain Shaman 55,122\nArena 73,103"
					},
					1
				)
				player:dialogSeq(
					{
						t,
						" Nagnang Halls\nWarrior's Guild 29,57\nRogue's Guild 19,141\nMage's Guild 126,35\nPoet's Guild 96,101\nTavern of Wind 82,131\nTavern of Wood 87,143\nTavern of Water 97,122\nTavern of Fire 111,126\nTavern of Metal 127,131"
					},
					1
				)
			elseif cityChoice == "What do the numbers mean?" then
				player:dialogSeq(
					{
						t,
						"Move this scroll so that you can see the numbers in the lower right of your screen that indicate your coordinates.",
						"That is your position in this area. As you move East (right) the first number increases. As you move South (down) the second number increases.",
						"All these locations list the sets of numbers that are near their entrances. If you were looking for the Tutorial in Kugnae, for example, you would walk until those numbers read about 0095 0048."
					},
					1
				)
			end

			player:dialogSeq(
				{t, "If you need help using these numbers, let me know."},
				1
			)
			general_npc_funcs.novices(player, npc, choice)
		end
	end,

	changeFace = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local reject = "Ah, I see. Appear as thou wilt."

		local crime = player:menuString(
			"You're not wanted for a crime, are you?",
			{"Yes", "No"}
		)

		if crime == "Yes" then
			player:dialogSeq({t, reject}, 0)
			return
		elseif crime == "No" then
			-- maybe do some crime check here?

			if player.money < 3000 then
				player:dialogSeq(
					{
						t,
						"It will cost you 3,000 coins. Come back when you have that."
					},
					0
				)
				return
			end

			local cost = player:menuString(
				"It will cost you 3,000 coins. Do you wish to pay?",
				{"Yes", "No"}
			)

			if cost == "Yes" then
				player:dialogSeq(
					{
						t,
						"Choose the face you like. Please be careful as the change is permanent. Use the 'Previous' and 'Next' to go back and forth through the faces."
					},
					1
				)

				player.dialogType = 2
				player.lastClick = player.ID

				clone.equip(player, player)

				local faces = {
					200,
					201,
					202,
					203,
					204,
					205,
					206,
					207,
					208,
					209,
					210,
					211,
					212,
					213,
					214,
					215,
					216
				}

				local index = 1

				local menu = {
					"I want this one",
					"Forget this",
					"Next face",
					"Previous face"
				}
				local menuChoice = ""

				local str = "buff"

				while str == "buff" do
					--local face = faces[index]
					player.gfxFace = faces[index]

					menuChoice = player:menuString(
						"Do you like this face?",
						menu
					)

					if menuChoice == "I want this one" then
						if player.money < 3000 then
							player:dialogSeq(
								{
									t,
									"It will cost you 3,000 coins. Come back when you have that."
								},
								0
							)
							return
						end

						player.face = player.gfxFace
						player:removeGold(3000)
						player:dialogSeq(
							{
								t,
								"It's tricky to mold this flesh. Let's see how it looks."
							},
							1
						)
						player:sendAnimation(11, 5)
						player:updateState()
						return
					elseif menuChoice == "Next face" then
						index = index + 1
						if index > #faces then
							index = #faces
						end
						player.gfxFace = faces[index]
					elseif menuChoice == "Previous face" then
						index = index - 1
						if index < 1 then
							index = 1
						end
						player.gfxFace = faces[index]
					elseif menuChoice == "Nevermind" then
						player.state = 0
						return
					end

					--[[elseif menuChoice == "Next face" then
					player.gfxFace = player.gfxFace + 1
					if player.gfxFace > 238 then player.gfxFace = 238 end

				elseif menuChoice == "Previous face" then
					player.gfxFace = player.gfxFace - 1
					if player.gfxFace < 200 then player.gfxFace = 200 end

				end]]
					--
				end
			elseif cost == "No" then
				player:dialogSeq({t, reject}, 0)
				return
			end
		end
	end,

	changeGender = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		-- you must be unwed to change your gender.
		-- You must remove everything you are wearing before you can change your gender.

		if player:isEquipped() then
			-- player is equipped
			local choice = player:menuSeq(
				"You must remove everything you are wearing before you can change your gender. Remove your items now?\n(If you are full inventory, items WILL be dropped.)",
				{"Yes, strip me", "No, I can strip myself"},
				{}
			)

			if choice == 1 then
				-- strip
				for i = 0, 14 do
					player:stripEquip(i, 0, 1)
				end
			end
		end

		if player.money < 12000 then
			player:dialogSeq(
				{
					t,
					"You need 12,000 gold to change your gender, come back when you have the cash."
				},
				0
			)
			return
		end

		local confirm = player:menuString(
			"You realize you won't be able to wear the clothes that you normally do, do you not?",
			{"Yes", "No"}
		)

		if confirm == "Yes" then
			local confirmSexChange = ""

			if player.sex == 0 then
				-- male
				confirmSexChange = player:menuString(
					"Do you wish to become a woman?",
					{"Yes", "No"}
				)
			elseif player.sex == 1 then
				-- female
				confirmSexChange = player:menuString(
					"Do you wish to become a man?",
					{"Yes", "No"}
				)
			end

			if confirmSexChange == "Yes" then
				player:removeGold(12000)

				local text = ""
				if player.sex == 0 then
					player.sex = 1
					text = "seamstress's"
				elseif player.sex == 1 then
					player.sex = 0
					text = "seamster's"
				end

				player:sendAnimation(8, 5)
				player:updateState()

				player:dialogSeq(
					{
						t,
						"There, wow that was hard work.",
						"You can shop at the " .. text .. " shop now."
					},
					0
				)
				return
			end
		elseif confirm == "No" then
			player:dialogSeq({t, "Ok. Maybe you're better off as you are."}, 0)
			return
		end
	end,

	changeEyes = function(player, npc)
		local eyeChoice = player:menuString(
			"Not all eyes look the same when you change the color, are you sure you want to do this?",
			{"Yes", "No"}
		)

		if eyeChoice == "Yes" then
			if player.money < 5000 then
				player:dialogSeq(
					{
						t,
						"It will cost you 5,000 coins. Come back when you have that."
					},
					0
				)
				return
			end

			local cost = player:menuString(
				"It will cost you 5,000 coins. Do you wish to pay?",
				{"Yes", "No"}
			)

			if cost == "Yes" then
				player:dialogSeq(
					{
						t,
						"Choose the eyes you like. Please be careful as the change is permanent. Use the 'Previous' and 'Next' to go back and forth through the faces."
					},
					1
				)

				player.dialogType = 2
				player.lastClick = player.ID

				clone.equip(player, player)

				local menu = {
					"I want this one",
					"Forget this",
					"Next eye color",
					"Previous eye color"
				}
				local menuChoice = ""

				local str = "buff"

				while str == "buff" do
					menuChoice = player:menuString(
						"Do you like this eye color?",
						menu
					)

					if menuChoice == "I want this one" then
						player.faceColor = player.gfxFaceC
						player:removeGold(3000)
						player:dialogSeq(
							{
								t,
								"It's tricky to put in these new eyes. Let's see how it looks."
							},
							1
						)
						player:sendAnimation(11, 5)
						player:updateState()
						return
					elseif menuChoice == "Next eye color" then
						player.gfxFaceC = player.gfxFaceC + 1
						if player.gfxFaceC > 64 then
							player.gfxFaceC = 64
						end
					elseif menuChoice == "Previous eye color" then
						player.gfxFaceC = player.gfxFaceC - 1
						if player.gfxFaceC < 0 then
							player.gfxFaceC = 0
						end
					end
				end
			elseif cost == "No" then
				player:dialogSeq({t, reject}, 0)
				return
			end
		elseif eyeChoice == "No" then
			player:dialogSeq(
				{t, "I think your eyes look great just the way they are too!"},
				0
			)
			return
		end
	end,

	haircut = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		--if player.hair == 62 then -- bald
		--	player:dialogSeq({t,"Oooooh, look at all that scarring on the top of your head there. You didn't care for your hair well, so it fell out. I'm afraid there is nothing I can do for you until your hair grows back."},0)
		--return
		--end

		--[[if os.time() < player.registry["haircutTimer"] then
		player:dialogSeq({t,"Oh no. Your hair is so fine and wispy. You must have had work done recently."},1)

		local choice = player:menuSeq("Your hair might fall out! Wait until it grows some strength again, then come and see me.",{"Ok, I'll come back later.","I'm not worried, change my hair!!"},{})

		if choice == 2 then
			player:dialogSeq({t,"Alright. You certainly know what you want! Who am I to refuse such a determined customer.."},1)
		end
	end]]
		--

		if player.money < 2000 then
			player:dialogSeq(
				{
					t,
					"A hair cut will cost 2,000 coins. Come and see me when you can afford it."
				},
				0
			)
			return
		end

		if npc.mapTitle == "Kugnae Salon" then
			player:dialogSeq({t, "A hair cut will cost 2,000 coins."}, 1)
		elseif npc.mapTitle == "Buya Salon" then
			player:dialogSeq(
				{
					t,
					"2,000 clams will buy you some really far out styles, man.."
				},
				1
			)
		elseif npc.mapTitle == "Nagnang Salon" then
			player:dialogSeq({t, "A hair cut will cost 2,000 coins."}, 1)
		end

		local styles = {}
		local hairs = {}

		local index = 1

		player.dialogType = 2
		clone.equip(player, player)

		if npc.mapTitle == "Kugnae Salon" then
			if player.sex == 0 then
				styles = {
					"Long tied back",
					"Medium razorback",
					"Short razor cut",
					"Long tied slick hair",
					"Tarzan",
					"Sumo's do",
					"The Surf",
					"Floor sweeper",
					"Chopsticks"
				}
				hairs = {7, 22, 23, 52, 55, 58, 85, 53, 95}
			elseif player.sex == 1 then
				styles = {
					"Long, loose hair",
					"Pulled up bunches",
					"The Updo",
					"Long pig tails",
					"Long stylish pony tail",
					"Medium blunt cut",
					"Whale back",
					"Long horse tail",
					"Medium V cut",
					"The Flippy",
					"Pig tails",
					"Short cute bob",
					"Sweet rolls",
					"Two little braids",
					"Innocent with headband",
					"Long low ribbon",
					"The Floor sweeper",
					"Jane",
					"Kimono hair",
					"The Twisler",
					"Long elegant ponytail",
					"Long pinned weavey locks",
					"Teddy bear ears",
					"Left shoulder braid",
					"Medium under curls",
					"Walnut whip",
					"Tinker toys",
					"Medium ponytail",
					"Chopsticks",
					"Twisted medley",
					"Long lovely waves",
					"Long pocahontas braid"
				}
				hairs = {
					4,
					6,
					12,
					13,
					16,
					22,
					23,
					25,
					28,
					31,
					35,
					38,
					41,
					45,
					50,
					52,
					53,
					55,
					58,
					63,
					64,
					65,
					66,
					67,
					72,
					83,
					84,
					88,
					95,
					96,
					98,
					99
				}
			end
		elseif npc.mapTitle == "Buya Salon" then
			if player.sex == 0 then
				styles = {
					"Mullet with bandana",
					"Chieftain",
					"Leather weave",
					"Split curtain",
					"The Pineapple",
					"Widge cut with bandana",
					"Masked Bandit",
					"Mushroom cut",
					"Wing tips",
					"Buddha long top knot",
					"The Jester",
					"The ramp",
					"Afro",
					"Dread locks",
					"Retro cut",
					"Ice cream whip",
					"Fluff cut",
					"The Wooly hair",
					"Dual horns",
					"Swept out",
					"The Clown",
					"The Elvis",
					"Short snake tail"
				}
				hairs = {
					8,
					9,
					11,
					14,
					15,
					20,
					24,
					33,
					37,
					57,
					61,
					73,
					74,
					75,
					76,
					77,
					78,
					81,
					86,
					87,
					93,
					94,
					100
				}
			elseif player.sex == 1 then
				styles = {
					"Amazon",
					"Eggbeater",
					"Dread locks",
					"Veiled mask",
					"Fluff cut",
					"Girly tails",
					"Short and curly",
					"Mullet with bandana",
					"Cupie doll",
					"Long layered cut",
					"Short and sassy",
					"Rounded weave",
					"Soft waves",
					"Top bun",
					"Honey buns",
					"Bun with puppy tails",
					"Short cupie with tails",
					"Feathered with headband",
					"Short waves"
				}
				hairs = {
					9,
					74,
					75,
					24,
					78,
					92,
					5,
					8,
					18,
					54,
					20,
					79,
					82,
					34,
					91,
					27,
					30,
					39,
					44
				}
			end
		elseif npc.mapTitle == "Nagnang Salon" then
			if player.sex == 0 then
				styles = {
					"Love fringe",
					"Short fringe",
					"Mullet",
					"Ceasar cut",
					"Long ceasar",
					"West wing cut",
					"East wing cut",
					"Bald",
					"The Windmill",
					"Curlt top (short)",
					"Curl top with bandana",
					"Balding crew cut",
					"Notch cut",
					"Brush cut",
					"Buzz cut",
					"Curly crew cut",
					"Flat top",
					"Hedgehog",
					"Razor cut with bandana",
					"East swept with bangs",
					"Fire swept",
					"Prickly",
					"Short ruffled curltains",
					"Quiff",
					"The Pirate",
					"Bowl cut"
				}
				hairs = {
					174,
					2,
					1,
					3,
					10,
					17,
					49,
					19,
					21,
					69,
					26,
					36,
					40,
					43,
					46,
					47,
					48,
					51,
					56,
					59,
					60,
					68,
					71,
					80,
					90,
					70
				}
			elseif player.sex == 1 then
				styles = {
					"Pixie cut",
					"Curl top with bandana",
					"Short with body",
					"Pixie cute",
					"Page boy"
				}
				hairs = {10, 26, 32, 70, 42}
			end
		end

		local opts = {
			"Yes please!",
			"Next hair style",
			"Previous hair style",
			"Yes, but the color is not right."
		}

		local str = "buff"

		while str == "buff" do
			player.gfxHair = hairs[index]

			local optsChoice = player:menuString(
				"<b>Style: " .. styles[index] .. "\n\nIs this style acceptable?",
				opts
			)

			if optsChoice == "Yes please!" then
				local confirm = player:menuSeq(
					"The cost is 2,000 coins. Will you pay?",
					{"Here is 2,000.", "I refuse to pay."},
					{}
				)

				if confirm == 1 then
					if player.money < 2000 then
						player:dialogSeq(
							{
								t,
								"A hair cut will cost 2,000 coins. Come and see me when you can afford it."
							},
							0
						)
						return
					end

					player:dialogSeq(
						{
							t,
							"Excellent! Let me get my scissors..",
							"A snip here... [*snip*]  A snip there... [*snip*]"
						},
						1
					)
					player:removeGold(2000)

					--if os.time() < player.registry["haircutTimer"] then -- make bald
					--	player.hair = 62 -- bald
					--	player:updateState()
					--	player:dialogSeq({t,"Oh no! Your hair fell out! It was too fragile. I told you that you should have waited.. now see what happened? You'll be stuck like this until it grows back!"},0)
					--else
					player.hair = hairs[index]
					player:updateState()

					--player.registry["haircutTimer"] = os.time() + 10800 -- 3 hours
					player:dialogSeq(
						{t, "All done! Enjoy your new hairstyle!"},
						0
					)

					--end
				end
			elseif optsChoice == "Next hair style" then
				index = index + 1
				if index > #styles then
					index = #styles
				end
			elseif optsChoice == "Previous hair style" then
				index = index - 1
				if index < 1 then
					index = 1
				end
			elseif optsChoice == "Yes, but the color is not right." then
				player:dialogSeq(
					{
						t,
						"I understand. I will try my best to match your current haircolor after I finish cutting it. Come speak to me again after we are done if you would like a new hair color."
					},
					1
				)
			end
		end
	end,

	hairdye = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if npc.mapTitle ~= "Nagnang Salon" then
			player:dialogSeq(
				{
					t,
					"A new dye can breathe life into your spirit and invigorate your self image! It's just the thing to cheer up your day!"
				},
				1
			)
			player:dialogSeq(
				{
					t,
					"I can offer you any number of fine hair dyes for only a mere 2,000 coins."
				},
				1
			)
		else
			player:dialogSeq(
				{
					t,
					"A new dye eh? Yeah, I can help ya with that. I only offer good hair dye colors. If you don't like my selection then get lost."
				},
				1
			)
			player:dialogSeq(
				{t, "Hair dye costs 2,000 coins. Pay it or get out."},
				1
			)
		end

		if player.money < 2000 then
			player:dialogSeq(
				{t, "So come back when you have enough money, dearie!"},
				0
			)
			return
		end

		local index = 1
		local hairColors = {}
		local hairC = {}

		if npc.mapTitle == "Kugnae Salon" then
			hairColors = {
				"Black",
				"Silver",
				"Brown",
				"Sky blue",
				"Dark blue",
				"Royal blue",
				"Orange",
				"Red",
				"Green",
				"Scarlet"
			}
			hairC = {0, 1, 2, 8, 7, 24, 10, 11, 22, 21}
		elseif npc.mapTitle == "Buya Salon" then
			hairColors = {
				"Black",
				"Silver",
				"Brown",
				"Light brown",
				"Tan",
				"Blonde",
				"Orange",
				"Red",
				"Green",
				"Scarlet"
			}
			hairC = {0, 1, 2, 27, 25, 20, 10, 11, 22, 21}
		elseif npc.mapTitle == "Nagnang Salon" then
			hairColors = {
				"Black",
				"Silver",
				"Brown",
				"Orchid",
				"Purple",
				"Indigo",
				"Orange",
				"Red",
				"Green",
				"Scarlet"
			}
			hairC = {0, 1, 2, 3, 9, 29, 10, 11, 22, 21}
		end

		player.dialogType = 2
		clone.equip(player, player)

		local opts = {
			"Yes please!",
			"Next hair color",
			"Previous hair color",
			"Nevermind"
		}

		local str = "buff"

		while str == "buff" do
			player.gfxHairC = hairC[index]

			local optsChoice = player:menuString(
				"<b>Color: " .. hairColors[index] .. "\n\nIs this style acceptable?",
				opts
			)

			if optsChoice == "Yes please!" then
				local confirm = player:menuSeq(
					"That will be 2,000 coins. Will you pay?",
					{"Yes, here is the money.", "I won't pay that."},
					{}
				)

				if confirm == 1 then
					if player.money < 2000 then
						player:dialogSeq(
							{t, "Come back when you have the money."},
							0
						)
						return
					end

					player:dialogSeq(
						{t, "This is a very delicate procedure. Hold still.."},
						1
					)
					player:removeGold(2000)
					player.hairColor = hairC[index]
					player:updateState()

					player:dialogSeq(
						{t, "There! Now don't you look SOOO much better!"},
						0
					)

					-- Oh one more thing. Your hair is very fragile now. I would not suggest getting a dye or style change for awhile. It could cause your hair to fall out permanently!
				end
			elseif optsChoice == "Next hair color" then
				index = index + 1
				if index > #hairColors then
					index = #hairColors
				end
			elseif optsChoice == "Previous hair color" then
				index = index - 1
				if index < 1 then
					index = 1
				end
			elseif optsChoice == "nevermind" then
				return
			end
		end
	end,

	shave = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player:getEquippedItem(EQ_FACEACCTWO) == nil then
			player:dialogSeq({t, "Hey, you don't have a beard!"}, 0)
			return
		end

		local choices = {"I will pay that.", "I refuse to pay!"}

		if player.money < 2500 then
			player:dialogSeq({t, "Come back when you have 2,500 coins."}, 0)
			return
		end

		local choice = player:menuString(
			"It will cost 2500 coins to shave your beard off.",
			choices
		)

		if choice == "I will pay that." then
			player:dialogSeq({t, "Hold still for a moment.."}, 1)
			player:stripEquip(EQ_FACEACCTWO, 1, 0)
			player:removeGold(2500)

			player:dialogSeq(
				{t, "There, all done. Enjoy your newly shaven face!"},
				0
			)
		end
	end,

	beard = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player:getEquippedItem(EQ_FACEACCTWO) ~= nil then
			-- slot 14
			player:dialogSeq(
				{
					t,
					"You will need to shave your beard before you can get a new style!"
				},
				0
			)
			return
		end

		player:dialogSeq(
			{
				t,
				"A new beard? Oh you would look marvelous with one of my styles!",
				"You should know that my talents aren't free, and the hair growth potion costs me alot of money!\n\nI charge 2,500 for my services, and 11,000 for the use of the growth potion."
			},
			1
		)

		local choice = player:menuSeq(
			"The total for your new beard will be 13,500. Will you pay that?",
			{
				"Certainly, I will pay 13,500.",
				"No, that's outrageous! I refuse."
			},
			{}
		)

		local index = 1
		local beards = {}
		local beardItems = {
			"black_short_beard",
			"brown_short_beard",
			"black_full_beard",
			"brown_full_beard",
			"black_moustache",
			"brown_moustache",
			"black_whiskers",
			"brown_whiskers"
		}

		for i = 1, #beardItems do
			table.insert(beards, Item(beardItems[i]).name)
		end

		if choice == 1 then
			player.dialogType = 2
			clone.equip(player, player)

			local opts = {
				"Yes please!",
				"Next beard",
				"Previous beard",
				"Nevermind"
			}

			local str = "buff"

			while str == "buff" do
				player.gfxFaceAT = Item(beardItems[index]).look
				player.gfxFaceATC = Item(beardItems[index]).lookC

				local optsChoice = player:menuString(
					"<b>Beard style: " .. beards[index] .. "\n\nIs this style acceptable?",
					opts
				)

				if optsChoice == "Yes please!" then
					player:dialogSeq(
						{
							t,
							"Great! Let me get another bottle of my hair growth potion. Hold on just a second, sweetie."
						},
						1
					)
					local confirm = player:menuSeq(
						"You should know that this beard will be permanent. You won't be able to remove it until you come back here for a shave. Do you still want a new beard?",
						{
							"Yes, I understand beards are permanent.",
							"Hmmm, I can't remove it? On second thought.."
						},
						{}
					)

					if confirm == 1 then
						if player.money < 13500 then
							player:dialogSeq(
								{t, "Come back when you have the money."},
								0
							)
							return
						end

						player:forceEquip(
							Item(beardItems[index]).id,
							EQ_FACEACCTWO
						)

						player:dialogSeq(
							{
								t,
								"Alright, we're ready to begin! Hold still while I apply the potion.."
							},
							1
						)
						player:removeGold(13500)
						clone.wipe(player)
						player:updateState()

						player:dialogSeq(
							{t, "There! Now don't you look SOOO much better!"},
							0
						)
					end
				elseif optsChoice == "Next beard" then
					index = index + 1
					if index > #beards then
						index = #beards
					end
				elseif optsChoice == "Previous beard" then
					index = index - 1
					if index < 1 then
						index = 1
					end
				elseif optsChoice == "nevermind" then
					return
				end
			end
		elseif choice == 2 then
			player:dialogSeq({t, "Then my services are not for you."}, 0)
			return
		end
	end,

	scalpMassage = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{
				t,
				"Uhmmm maybe when you've actually, ya know, done something stressful in your life?"
			},
			0
		)

		--You don't look so good. Grab a soup bowl, rest up, and then we can reschedule!

		player:dialogSeq(
			{
				t,
				"I can make your stress melt away for just one easy payment of 50,000 coins!",
				"((This feature will reduce your mana by one point. Proceed only if you wish to lose one mana point))."
			},
			1
		)

		local choice = player:menuString("Do you proceed?", {"Yes", "No"})

		if choice == "Yes" then
			player:dialogSeq(
				{
					t,
					"Very nice! *he slaps his palms together and then begins drumming on your head*",
					"*Your head feels woozy, shaken-up, and worse than before*"
				},
				0
			)
		end
	end,
}
