elementalists_mark = {
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
		player:setAether("elementalists_mark", aethers)

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

		--if target.ID == player.ID then player:dialogSeq({t,"You cannot provide your own recognition."},0) return end

		local opts = {"Recognize as elemental mage", "Remove recognition"}
		local elements = {"Earth", "Fire", "Metal", "Water", "Wood"}

		local choice = player:menuString(
			"What do you wish to bestow on them?",
			opts
		)

		if choice == "Recognize as elemental mage" then
			local elementChoice = player:menuString("Which element?", elements)

			for i = 1, #elements do
				target:removeLegendbyName("recognized_as_" .. string.lower(elements[i]) .. "_mage")
			end

			target:addLegend(
				"Recognized as " .. elementChoice .. " Mage, by $player (" .. curT() .. ")",
				"recognized_as_" .. string.lower(elementChoice) .. "_mage",
				145,
				1,
				player.ID
			)
			player:dialogSeq(
				{
					t,
					target.name .. " has been recognized as a " .. elementChoice .. " Mage"
				},
				0
			)
			return
		elseif choice == "Remove recognition" then
			local foundLegendMarks = {}
			for i = 1, #elements do
				if target:hasLegend("recognized_as_" .. string.lower(elements[i]) .. "_mage") then
					table.insert(foundLegendMarks, elements[i])
				end
			end

			local lmChoice = player:menuString(
				"Which recognition would you like to remove?",
				foundLegendMarks
			)

			for i = 1, #elements do
				if lmChoice == elements[i] then
					target:removeLegendbyName("recognized_as_" .. string.lower(elements[i]) .. "_mage")
					break
				end
			end

			player:dialogSeq(
				{
					t,
					target.name .. " has had their " .. lmChoice .. " mage recognition removed."
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
