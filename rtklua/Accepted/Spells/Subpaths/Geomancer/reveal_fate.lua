reveal_fate = {
	cast = async(function(player)
		local npc = NPC("Woodland Angel")

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq({t, "Complete but disabled."}, 0)

		local aethers = 7500000

		-- 7500s
		local magicCost = 100

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player.gmLevel > 0 then
			aethers = 0
		end

		local input = player:inputLetterCheck(player:input("Whom would you like to reveal their fate?"))

		local target = Player(input)

		if target == nil then
			player:dialogSeq({t, "That player is currently not online."}, 0)
			return
		end
		if target.ID == player.ID then
			player:dialogSeq({t, "You cannot reveal your own fate."}, 0)
			return
		end

		player.npcGraphic = 0
		player.npcColor = 0

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("reveal_fate", aethers)

		local choice = player:menuSeq(
			"Greetings Geomancer. How is the Chi aligned here?",
			{"It is disrupted", "It flows well"},
			{}
		)

		local marriedPositiveOutcome = {"Married for love"}
		local marriedNegativeOutcome = {
			"Married for items",
			"Married for power",
			"Married for money"
		}

		local positiveOutcomes = {
			"You stand out from those around you.",
			"You feel creative.",
			"Your coinpurse feels heavier.",
			"The gods smile upon you.",
			"You're better in your specialized skill.",
			"You gain knowledge towards the next level.",
			"You are able to endure more.",
			"You're a good friend, and it shows."
		}

		local negativeOutcomes = {
			"You feel that people do not notice you.",
			"You lose your train of thought and fail to be creative.",
			"Your coinpurse feels lighter.",
			"The gods frown upon you.",
			"You're worse in your specialized skill.",
			"You lose knowledge towards the next level.",
			"You become weak and a bit faint.",
			"You feel you have let a friend down."
		}

		local chosenOutcome = ""

		local max = 8
		if target.partner ~= 0 then
			max = 9
		end

		local rngChoice = math.random(1, max)

		if rngChoice < 9 then
			if choice == 2 then
				-- positive
				chosenOutcome = positiveOutcomes[rngChoice]
			elseif choice == 1 then
				-- negative
				chosenOutcome = negativeOutcomes[rngChoice]
			end
		else
			if choice == 2 then
				--pos
				chosenOutcome = marriedPositiveOutcome[1]
			elseif choice == 1 then
				--neg
				chosenOutcome = marriedNegativeOutcome[
					math.random(1, #marriedNegativeOutcome)
				]
			end
		end

		--player:talk(0,""..chosenOutcome)

		if chosenOutcome == "You stand out from those around you." then
			target.armorColor = 5
			target:updateState()
		elseif chosenOutcome == "You feel that people do not notice you." then
			target.armorColor = 0
			target:updateState()
		elseif chosenOutcome == "You feel creative." then
			target:setDuration("creative", 28800000)
		elseif chosenOutcome == "You lose your train of thought and fail to be creative." then
			dispell.cast(target)
		elseif chosenOutcome == "Your coinpurse feels heavier." then
			player.money = player.money + 10000
			player:sendStatus()
			player:sendMinitext("10,000 gold added.")
		elseif chosenOutcome == "Your coinpurse feels lighter." then
			if player.money < 10000 then
				player.money = 0
			else
				player.money = player.money - 10000
			end
			player:sendStatus()
			player:sendMinitext("10,000 gold removed.")
		elseif chosenOutcome == "The gods smile upon you." then
			player:addKarma(0.25)
		elseif chosenOutcome == "The gods frown upon you." then
			player:removeKarma(0.25)
		elseif chosenOutcome == "You're better in your specialized skill." or chosenOutcome == "You're worse in your specialized skill." then
			local skills = {
				"weaving",
				"gemcutting",
				"smelting",
				"woodworking",
				"jewelry making",
				"metalworking",
				"tailoring",
				"scribing",
				"potion making",
				"smelting",
				"mining",
				"woodcutting",
				"fishing"
			}

			if chosenOutcome == "You're better in your specialized skill." then
				for i = 1, #skills do
					if target.registry[skills[i]] > 0 then
						target.registry[skills[i]] = target.registry[skills[i]] + 5
						target:sendMinitext("You have gained some progress in " .. skills[i])
						break
					end
				end
			elseif chosenOutcome == "You're worse in your specialized skill." then
				for i = 1, #skills do
					if target.registry[skills[i]] > 10 then
						target.registry[skills[i]] = target.registry[skills[i]] - 5
						target:sendMinitext("You have lost some progress in " .. skills[i])
						break
					end
				end
			end
		elseif chosenOutcome == "You gain knowledge towards the next level." then
			if player.level < 99 then
				local exp = getXPforLevel(player.baseClass, player.level)
				local exp = exp - getXPforLevel(
					player.baseClass,
					player.level - 1
				)
				add = math.ceil(exp * 0.25)
				player:giveXP(add)
			elseif player.level == 99 then
				add = math.ceil(player.exp *.25)
				player:giveXP(add)
			end
			player:sendMinitext("You have gained some experience!")
			player:sendStatus()
		elseif chosenOutcome == "You lose knowledge towards the next level." then
			if player.level < 99 then
				local exp = getXPforLevel(player.baseClass, player.level)
				local exp = exp - getXPforLevel(
					player.baseClass,
					player.level - 1
				)
				local lost = math.ceil(exp * 0.25)
				if player.exp - lost < 0 then
					player.exp = 0
				else
					player.exp = player.exp - lost
				end
			elseif player.level == 99 then
				local lost = math.ceil(player.exp *.50)

				if player.exp - lost < 0 then
					player.exp = 0
				else
					player.exp = player.exp - lost
				end
			end
			player:sendStatus()
			player:sendMinitext("You have lost some experience!")
		elseif chosenOutcome == "You are able to endure more." then
			player.baseHealth = player.baseHealth + 25
			player.registry["baseHealth"] = player.baseHealth
			player:calcStat()
		elseif chosenOutcome == "You become weak and a bit faint." then
			if player.baseHealth < 25 then
				return
			end
			player.baseHealth = player.baseHealth - 25
			player.registry["baseHealth"] = player.baseHealth
			player:calcStat()
		elseif chosenOutcome == "You're a good friend, and it shows." then
			player:removeLegendbyName("needs_to_work_on_relationships")
			player:removeLegendbyName("proven_to_be_good_friend")
			player:addLegend(
				"Proven to be a good friend",
				"proven_to_be_good_friend",
				6,
				1
			)
		elseif chosenOutcome == "You feel you have let a friend down." then
			player:removeLegendbyName("needs_to_work_on_relationships")
			player:removeLegendbyName("proven_to_be_good_friend")
			player:addLegend(
				"Needs to work on relationships",
				"needs_to_work_on_relationships",
				1,
				1
			)
		elseif chosenOutcome == "Married for love" then
			player:removeLegendbyName("married_for_items")
			player:removeLegendbyName("married_for_power")
			player:removeLegendbyName("married_for_money")
			player:removeLegendbyName("married_for_love")
			player:addLegend("Married for love", "married_for_love", 6, 1)
		elseif chosenOutcome == "Married for items" then
			player:removeLegendbyName("married_for_items")
			player:removeLegendbyName("married_for_power")
			player:removeLegendbyName("married_for_money")
			player:removeLegendbyName("married_for_love")
			player:addLegend("Married for items", "married_for_items", 6, 1)
		elseif chosenOutcome == "Married for power" then
			player:removeLegendbyName("married_for_items")
			player:removeLegendbyName("married_for_power")
			player:removeLegendbyName("married_for_money")
			player:removeLegendbyName("married_for_love")
			player:addLegend("Married for power", "married_for_power", 6, 1)
		elseif chosenOutcome == "Married for money" then
			player:removeLegendbyName("married_for_items")
			player:removeLegendbyName("married_for_power")
			player:removeLegendbyName("married_for_money")
			player:removeLegendbyName("married_for_love")
			player:addLegend("Married for money", "married_for_money", 6, 1)
		end

		player.registry["performed_ba_gua_experiences"] = player.registry[
			"performed_ba_gua_experiences"
		] + 1
		player:removeLegendbyName("performed_ba_gua_experiences")
		player:addLegend(
			"Performed " .. player.registry["performed_ba_gua_experiences"] .. " Ba Gua experiences",
			"performed_ba_gua_experiences",
			145,
			128
		)

		target.registry["experienced_the_ba_gua"] = player.registry[
			"experienced_the_ba_gua"
		] + 1
		target:removeLegendbyName("experienced_the_ba_gua")
		target:addLegend(
			"Experienced the Ba Gua " .. player.registry[
				"experienced_the_ba_gua"
			] .. " times, assisted by $player (" .. curT() .. ")",
			"experienced_the_ba_gua",
			145,
			128,
			player.ID
		)

		target:freeAsync()
		target:dialogSeq({t, chosenOutcome}, 0)
	end),
	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}
