gambling = {
	cast = async(function(player)
		local magicCost = 120
		local aethers = 30000

		if player.gmLevel ~= 0 then
			aethers = 0
		end

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setAether("gambling", aethers)

		local item = Item("coins_1")

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local input = player:inputLetterCheck(player:inputSeq(
			"Who shall be gambling?",
			"The player known as",
			"will be gambling.",
			{},
			{}
		))
		local target = Player(input)

		if target == nil then
			player:dialogSeq({t, "That player is not online."}, 0)
			return
		end

		if not distanceSquare(player, target, 6) then
			player:dialogSeq({t, "That player is not close enough to you."}, 0)
			return
		end

		local goldAmounts = {1000, 10000, 100000}
		local goldChoices = {"1,000 Gold", "10,000 Gold", "100,000 Gold"}
		local goldChoice = player:menuSeq(
			"They will wager the amount of",
			goldChoices,
			{}
		)

		target:freeAsync()
		gambling.presentOffer(target, player, goldAmounts[goldChoice])
	end),

	presentOffer = async(function(player, merchant, amount)
		local item = Item("coins_1")

		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local confirm = player:menuSeq(
			"A merchant is willing to assist you in your gamble of " .. Tools.formatValue(amount) .. " Gold. You and your opponent will each put in that amount and the winner will receive double back. Do you accept?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if player.money < amount then
				player:dialogSeq({t, "You do not have enough gold."}, 0)
				return
			end
			merchant:freeAsync()
			gambling.confirmOffer(merchant, player, amount)

			-- returns back to mercahnt to type in the name of next person
		end
	end),

	confirmOffer = async(function(player, target1, amount)
		local item = Item("coins_1")
		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local input = player:inputLetterCheck(player:inputSeq(
			"Who will be trying their luck against this person?",
			"The one known as",
			"will be gambling.",
			{},
			{}
		))
		local target2 = Player(input)

		if target2 == nil then
			player:dialogSeq({t, "That player is not online."}, 0)
			return
		end

		if not distanceSquare(player, target2, 6) then
			player:dialogSeq({t, "That player is not close enough to you."}, 0)
			return
		end

		if target1.ID == target2.ID then
			player:dialogSeq(
				{t, "The person cannot gamble against themselves."},
				0
			)
			return
		end

		target2:freeAsync()
		gambling.presentOffer2(target2, target1, player, amount)
	end),

	presentOffer2 = async(function(player, otherPlayer, merchant, amount)
		local item = Item("coins_1")
		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local confirm = player:menuSeq(
			"A merchant is willing to assist you in your gamble of " .. Tools.formatValue(amount) .. " Gold. You and your opponent will each put in that amount and the winner will receive double back. Do you accept?",
			{"Yes", "No"},
			{}
		)

		if confirm == 1 then
			if player.money < amount then
				player:dialogSeq({t, "You do not have enough gold."}, 0)
				return
			end
			merchant:freeAsync()
			gambling.run(merchant, player, otherPlayer, amount)

			-- returns back to mercahnt to type in the name of next person
		end
	end),

	run = async(function(player, target1, target2, amount)
		local item = Item("coins_1")
		local t = {graphic = item.icon, color = item.iconC}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		player:dialogSeq(
			{t, "Both parties agreed to this gamble. Proceed to finish."},
			1
		)

		if target1 == nil or target2 == nil then
			player:dialogSeq({t, "One of the parties logged."}, 0)
			return
		end

		if target1.money < amount then
			player:dialogSeq(
				{
					t,
					target1.name .. " tried to cheat, they no longer have the money they were offering to gamble."
				},
				0
			)
			return
		end
		if target2.money < amount then
			player:dialogSeq(
				{
					t,
					target2.name .. " tried to cheat, they no longer have the money they were offering to gamble."
				},
				0
			)
			return
		end

		local roll1 = math.random(1, 100)
		local roll2 = math.random(1, 100)

		if roll1 > roll2 then
			target1:sendAnimation(2, 3)
			target1:sendMinitext("You win.")
			target2:sendMinitext("You lose.")
			target1:addGold(amount)
			target2:removeGold(amount)
		elseif roll2 > roll1 then
			target2:sendAnimation(2, 3)
			target1:sendMinitext("You lose.")
			target2:sendMinitext("You win.")
			target1:removeGold(amount)
			target2:addGold(amount)
		else
			target1:sendMinitext("There was a tie, so no gold removed.")
			target2:sendMinitext("There was a tie, so no gold removed.")
			player:dialogSeq(
				{t, "There was a tie. No gold removed from either party."},
				0
			)
		end
	end),

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {1000}
		local description = "A simple game of chance."
		return level, items, itemAmounts, description
	end
}
