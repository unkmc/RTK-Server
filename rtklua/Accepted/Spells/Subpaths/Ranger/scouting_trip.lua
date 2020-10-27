scouting_trip = {
	cast = async(function(player)
		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local aethers = 25000000

		-- 25000s
		local magicCost = 2000

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player.gmLevel > 0 then
			aethers = 0
			magicCost = 0
		end

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("scouting_trip", aethers)

		local choice = player:menuString(
			"What do you wish to do?",
			{"Mark a person", "Remove a mark"}
		)

		if choice == "Mark a person" then
			local input = player:inputLetterCheck(player:inputSeq(
				"Who will be granted the mark?",
				"The noble",
				"has been scouting with me",
				{},
				{}
			))
			local target = Player(input)

			if target == nil then
				player:dialogSeq({t, "That player is currently not online."}, 0)
				return
			end
			if target.ID == player.ID then
				player:dialogSeq(
					{t, "You cannot provide your own recognition."},
					0
				)
				return
			end
			if not distanceSquare(player, target, 10) then
				player:dialogSeq({t, "That person is not near you."}, 0)
				return
			end

			target.registry["scouted_with_rangers"] = target.registry[
				"scouted_with_rangers"
			] + 1
			target:removeLegendbyName("scouted_with_rangers")
			target:addLegend(
				"Scouted with Rangers " .. target.registry[
					"scouted_with_rangers"
				] .. " times, marked by $player (" .. curT() .. ")",
				"scouted_with_rangers",
				12,
				1,
				player.ID
			)

			player:dialogSeq(
				{t, target.name .. " has been recognized for scouting."},
				1
			)

			target:freeAsync()
			target:dialogSeq(
				{t, "You have been recognized for scouting with the Rangers."},
				0
			)
		elseif choice == "Remove a mark" then
			local input = player:inputLetterCheck(player:inputSeq(
				"Who will have their mark removed?",
				"The noble",
				"needs their mark removed.",
				{},
				{}
			))
			local target = Player(input)

			if target == nil then
				player:dialogSeq({t, "That player is currently not online."}, 0)
				return
			end
			if target.ID == player.ID then
				player:dialogSeq(
					{t, "You cannot provide your own recognition."},
					0
				)
				return
			end
			if not distanceSquare(player, target, 10) then
				player:dialogSeq({t, "That person is not near you."}, 0)
				return
			end

			target.registry["scouted_with_rangers"] = 0
			target:removeLegendbyName("scouted_with_rangers")

			player:dialogSeq(
				{t, target.name .. " has had their mark removed."},
				1
			)

			target:freeAsync()
			target:dialogSeq(
				{
					t,
					"You have had your mark removed for Scouting with Rangers by " .. player.name .. "."
				},
				0
			)
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
