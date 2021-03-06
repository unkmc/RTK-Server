balance_recognition = {
	cast = async(function(player)
		local t = {graphic = convertGraphic(803, "item"), color = 0}

		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = player.ID

		local aethers = 5000
		local magicCost = 100

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player.gmLevel > 0 then
			aethers = 0
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("balance_recognition", aethers)

		local input = player:inputLetterCheck(player:inputSeq(
			"Whom is it that has caught your eye?",
			"The one known as",
			"has caught my eye",
			{},
			{}
		))
		local target = Player(input)

		if target == nil then
			player:dialogSeq({t, "That player is currently not online."}, 0)
			return
		end
		if target.ID == player.ID then
			player:dialogSeq({t, "You cannot provide your own recognition."}, 0)
			return
		end

		local opts = {
			"Keeper recognition",
			"Disruptor recognition",
			"Remove recognition"
		}
		local legendMarkyname = {"keeper_of_balance", "disruptor_of_balance"}
		local legendMarks = {"Keeper of Balance", "Disruptor of Balance"}
		local choice = player:menuString(
			"What do you wish to bestow on them?",
			opts
		)

		if choice == "Keeper recognition" then
			target:removeLegendbyName("disruptor_of_balance")
			target:removeLegendbyName("keeper_of_balance")
			target:addLegend(
				"Keeper of Balance, Marked by $player",
				"keeper_of_balance",
				11,
				1,
				player.ID
			)
			player:dialogSeq(
				{
					t,
					target.name .. " has been recognized as a \"Keeper of Balance\""
				},
				0
			)
			return
		elseif choice == "Disruptor recognition" then
			target:removeLegendbyName("keeper_of_balance")
			target:removeLegendbyName("disruptor_of_balance")
			target:addLegend(
				"Disruptor of Balance, Marked by $player",
				"disruptor_of_balance",
				11,
				4,
				player.ID
			)
			player:dialogSeq(
				{
					t,
					target.name .. " has been recognized as a \"Disruptor of Balance\""
				},
				0
			)
			return
		elseif choice == "Remove recognition" then
			local foundLegendMarks = {}
			for i = 1, #legendMarkyname do
				if target:hasLegend(legendMarkyname[i]) then
					table.insert(foundLegendMarks, legendMarks[i])
				end
			end

			local lmChoice = player:menuString(
				"Which recognition would you like to remove?",
				foundLegendMarks
			)

			for i = 1, #legendMarks do
				if lmChoice == legendMarks[i] then
					player:removeLegendbyName(legendMarkyname[i])
					break
				end
			end

			player:dialogSeq(
				{
					t,
					target.name .. " has had their recognition removed for " .. lmChoice
				},
				0
			)
			return
		end
	end),
	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}
