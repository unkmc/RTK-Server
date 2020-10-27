inner_sect_recognition = {
	cast = async(function(player)
		-- Wu Xing [level], Chosen by
		-- Tiaoli
		-- Wu Wei
		--levels: Initiate, Apprentice, Follower, Sage, Master

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
		player:setAether("inner_sect_recognition", aethers)

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
			"Recognize for specialized training",
			"Remove recognition"
		}
		local disciplines = {"Wu Wei", "Wu Xing", "Tiaoli"}

		local levels = {"Initiate", "Apprentice", "Follower", "Sage", "Master"}

		local choice = player:menuString("What would you like to do?", opts)

		local icons = {145, 76, 122}
		local colors = {145, 5, 20}

		if choice == "Recognize for specialized training" then
			local discipline = player:menuString(
				"Which specialized training?",
				disciplines
			)
			local level = player:menuString(
				"Which level have they attained?",
				levels
			)
			local disciplineyname = string.gsub(discipline, " ", "_")

			local color = 0
			local icon = 0
			for i = 1, #disciplines do
				if disciplines[i] == discipline then
					color = colors[i]
					icon = icons[i]
				end
			end

			for i = 1, #levels do
				target:removeLegendbyName(string.lower(disciplineyname) .. "_" .. string.lower(levels[i]))
			end

			target:addLegend(
				discipline .. " " .. level .. ", Chosen by $player (" .. curT() .. ")",
				string.lower(disciplineyname) .. "_" .. string.lower(level),
				icon,
				color,
				player.ID
			)

			player:dialogSeq(
				{
					t,
					target.name .. " has been recognized as a " .. discipline .. " " .. level
				},
				1
			)

			target:freeAsync()
			target:dialogSeq(
				{
					t,
					"You have been recognized as a " .. discipline .. " " .. level
				},
				0
			)
		elseif choice == "Remove recognition" then
			local foundLegendMarks = {}

			for i = 1, #disciplines do
				for j = 1, #levels do
					local discipline = string.gsub(disciplines[i], " ", "_")
					local level = levels[j]
					local yname = string.lower(discipline .. "_" .. level)

					if player:hasLegend(yname) then
						table.insert(foundLegendMarks, disciplines[i])
					end
				end
			end

			local lmChoice = player:menuString(
				"Which recognition would you like to remove?",
				foundLegendMarks
			)

			for i = 1, #disciplines do
				if disciplines[i] == lmChoice then
					for j = 1, #levels do
						local discipline = string.gsub(disciplines[i], " ", "_")
						local level = levels[j]
						local yname = string.lower(discipline .. "_" .. level)
						player:removeLegendbyName(yname)
					end
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
