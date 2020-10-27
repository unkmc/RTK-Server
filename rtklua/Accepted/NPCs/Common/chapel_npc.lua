ChapelNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell", "Buy Engagement Ring"}

		if player:hasLegend("engaged") and not player:hasLegend("married") and not player:hasLegend("forged_blood_oath") and not player:hasLegend("sealed_blood_oath") and player.registry[
			"partner1"
		] ~= 0 and player.registry["partner2"] ~= 0 then
			table.insert(opts, "Break Off Engagement")
		end

		if player:hasLegend("engaged") and not player:hasLegend("married") and not player:hasLegend("forged_blood_oath") and not player:hasLegend("sealed_blood_oath") and player.registry[
			"partner1"
		] ~= 0 and player.registry["partner2"] ~= 0 then
			table.insert(opts, "Marriage")
		end

		if player:hasLegend("married") and not player:hasLegend("engaged") and not player:hasLegend("forged_blood_oath") and not player:hasLegend("sealed_blood_oath") then
			table.insert(opts, "Divorce")
		end

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				ChapelNpc.buyItems()
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				ChapelNpc.sellItems()
			)
		elseif menu == "Buy Engagement Ring" then
			if os.time() < player.registry["engagement_timer"] then
				player:dialogSeq(
					{
						t,
						"Whoa! Weren't you just here? Let your heart cool a bit from your last love."
					},
					0
				)
				return
			end

			if player:hasLegend("married") or player:hasLegend("engaged") or player:hasLegend("forged_blood_oath") or player:hasLegend("sealed_blood_oath") then
				player:dialogSeq(
					{
						t,
						"Whoa! Your heart is already committed to someone else."
					},
					0
				)
				return
			end

			local choice = player:menuSeq(
				"Have you met one you hope to one day marry?",
				{
					"Yes, I am very much in love!",
					"You mean I'm expected to LOVE them?"
				},
				{}
			)

			if choice == 1 then
				local choice2 = player:menuSeq(
					"The engagement ring will cost you " .. Item("engagement_ring").price .. " gold. Do you wish to buy one?",
					{
						"No price is too high for my love.",
						"That much?!? Forget it!"
					},
					{}
				)

				if choice2 == 1 then
					local buyPrice = Item("engagement_ring").price

					if player.money < buyPrice then
						player:dialogSeq(
							{
								t,
								"Come back when you can afford to make the commitment."
							},
							1
						)
						return
					end

					player:removeGold(buyPrice)
					player:addItem("engagement_ring", 1)
					if not player:hasSpell("propose") then
						player:addSpell("propose")
					end
					player.registry["engagement_timer"] = os.time() + 86400

					-- current time + 24 hrs
					player:dialogSeq(
						{
							t,
							"To propose, cast this spell near your beloved. Then follow the directions. Make sure you have your ring with you!"
						},
						0
					)
					return
				elseif choice2 == 2 then
					player:dialogSeq(
						{t, "Come back when your heart is ready."},
						0
					)
					return
				end
			elseif choice == 2 then
				player:dialogSeq({t, "Come back when your heart is ready."}, 0)
				return
			end
		elseif menu == "Break Off Engagement" then
			player:dialogSeq(
				{
					t,
					"How sad this is necessary. At least you reached this decision before marriage."
				},
				1
			)

			local var = player:menuSeq(
				"Are you sure you want to end the engagement?",
				{
					"Yes, it is necessary (You will lose some XP)",
					"No, I need to consider further."
				},
				{}
			)

			if var == 1 then
				local penalty = player.baseMagic * 1000

				if penalty > 4294967295 then
					penalty = 4294967295
				end

				if player.exp < penalty then
					player.exp = 0
				else
					player.exp = player.exp - penalty
				end

				player:removeLegendbyName("engaged")
				player.registry["partner1"] = 0
				player.registry["partner2"] = 0
				player:sendStatus()
				player:dialogSeq({t, "It is done."}, 0)
				return
			elseif var == 2 then
				player:dialogSeq(
					{t, "I hope you can salvage your relationship."},
					0
				)
				return
			end
		elseif menu == "Marriage" then
			if (os.time() < player.registry["marriage_timer"] and not Config.shotgunWeddingEnabled) then
				player:dialogSeq(
					{
						t,
						"You have engaged too recently. Please return in " .. playerTimerValues(
							player,
							"marriage_timer"
						)
					},
					0
				)
				return
			end

			local proposer = Player(player.registry["partner1"])
			local proposee = Player(player.registry["partner2"])

			if proposer == nil or proposee == nil then
				player:dialogSeq(
					{
						t,
						"Both parties must be present for the ceremony to commence"
					},
					0
				)
				return
			end

			if proposer:hasLegend("married") then
				player:dialogSeq({t, "The person is already married."}, 0)
				return
			end

			if proposer:hasLegend("sealed_blood_oath") or proposer:hasLegend("forged_blood_oath") then
				player:dialogSeq(
					{t, "The person is already in a blood union."},
					0
				)
				return
			end

			if player.registry["partner2"] ~= player.ID then
				-- this logic returns true if player accessing menu is the person who orignally proposed the marriage
				player:dialogSeq(
					{t, "The proposee should start the marriage ceremony."},
					0
				)
				return
			end

			local choice = player:menuSeq(
				"Are you certain you wish to devote yourself to this man or woman for life?",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				-- Yes
				ChapelNpc.marriageprompt(proposer, proposee)
			elseif choice == 2 then
				-- No
				player:dialogSeq(
					{t, "Come back when you are firm in your resolve to marry."},
					0
				)
			end
		elseif menu == "Divorce" then
			--if player.gmLevel == 0 then player:dialogSeq({t,"Disabled until further notice."},0) return end

			player:dialogSeq(
				{
					t,
					"Oh no! You made a horrible mistake!",
					"However, I can help you get that divorce you want."
				},
				1
			)

			local expCost = player.baseHealth * 2550
			local choice = player:menuString(
				"It will cost " .. Tools.formatNumber(expCost) .. " experience. Are you sure you want this divorce?",
				{"Yes", "No"}
			)

			if choice == "Yes" then
				if player.exp < expCost then
					player:dialogSeq(
						{
							t,
							"Hmmm.. you don't have the experience to divorce, but there is something else you can offer."
						},
						1
					)

					local vitaPenalty = 8000
					local manaPenalty = 4000
					local stat = ""

					local choice2 = player:menuSeq(
						"Perhaps some physical suffering would be sufficient?",
						{
							"Sacrifice " .. vitaPenalty .. " Vita",
							"Sacrifice " .. manaPenalty .. " Mana",
							"I'd rather not."
						},
						{}
					)
					local penalty = 0

					if choice2 == 1 then
						stat = "Vita"
						penalty = vitaPenalty
					elseif choice2 == 2 then
						stat = "Mana"
						penalty = manaPenalty
					end

					local confirm = player:menuSeq(
						"It will cost you " .. Tools.formatNumber(penalty) .. " base " .. stat .. " as a penalty. Continue?",
						{"Yes, do it", "No, nevermind"},
						{}
					)

					if confirm == 1 then
						if choice2 == 1 and player.baseHealth < vitaPenalty then
							player:dialogSeq(
								{
									t,
									"You need to gain more experience in your health before you can make this sacrifice."
								},
								0
							)
							return
						end

						if choice2 == 2 and player.baseMagic < manaPenalty then
							player:dialogSeq(
								{
									t,
									"You need to gain more experience in your magic before you can make this sacrifice."
								},
								0
							)
							return
						end

						player.partner = 0
						player:removeLegendbyName("married")
						player:removeItem("love", 1)

						if choice2 == 1 then
							player.baseHealth = player.baseHealth - penalty
						elseif choice2 == 2 then
							player.baseMagic = player.baseMagic - penalty
						end

						player.registry["baseHealth"] = player.baseHealth
						player.registry["baseMagic"] = player.baseMagic

						player:calcStat()

						player:dialogSeq({t, "You are now divorced."}, 0)
						return
					end

					return
				elseif player.exp >= expCost then
					local confirmXPLoss = player:menuSeq(
						"It will cost you " .. Tools.formatNumber(expCost) .. " experience as a penalty. Continue?",
						{"Yes, do it", "No, nevermind"},
						{}
					)

					if confirmXPLoss == 1 then
						player.exp = player.exp - expCost
						player:sendStatus()
						player.partner = 0
						player:removeLegendbyName("married")
						player:removeItem("love", 1)
						player:dialogSeq({t, "You are now divorced."}, 0)
						return
					end
				end
			elseif choice == "No" then
				player:dialogSeq(
					{
						t,
						"Patience and love will save your marriage.\n\nDivorce is not something to take lightly."
					},
					0
				)
				return
			end
		end
	end),

	marriageprompt = async(function(proposer, proposee)
		local choice = proposer:menuSeq(
			"Do you, " .. proposer.name .. " take " .. proposee.name .. " as your partner?",
			{"I do. (you will lose much xp if you divorce)", "I don't."},
			{}
		)

		if choice == 1 then
			proposer:sendMinitext("I now pronounce you (married)")
			proposee:sendMinitext("I now pronounce you (married)")

			proposer:removeLegendbyName("engaged")
			proposer:addLegend(
				"Married to $player (" .. curT() .. ")",
				"married",
				6,
				1,
				proposee.ID
			)

			proposee:removeLegendbyName("engaged")
			proposee:addLegend(
				"Married to $player (" .. curT() .. ")",
				"married",
				6,
				1,
				proposer.ID
			)

			proposer.registry["partner1"] = 0
			proposer.registry["partner2"] = 0
			proposee.registry["partner1"] = 0
			proposee.registry["partner2"] = 0

			proposer.registry["marriage_timer"] = 0
			proposee.registry["marriage_timer"] = 0

			proposer.partner = proposee.ID
			proposee.partner = proposer.ID

			proposer:addItem("love", 1)
			proposee:addItem("love", 1)

			proposer:dialog("Congratulations you are both now married.", {})
			proposee:dialog("Congratulations you are both now married.", {})
		elseif choice == 2 then
			proposer:sendMinitext("It seems that your partner is not sure of this marriage.")
			proposer:freeAsync()
			proposer:dialog("What but love can last forever?", {})
		end
	end),

	buyItems = function()
		local buyItems = {
			"love",
			"cooked_fish",
			"rose_petals"
		}

		return buyItems
	end,

	sellItems = function()
		if (Config.bossDropSalesEnabled) then
			local sellItems = {
				"fragile_rose",
				"purified_water"
			}

			return sellItems
		else
			return {}
		end
	end
}
