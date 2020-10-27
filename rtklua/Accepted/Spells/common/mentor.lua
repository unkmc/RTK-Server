mentor = {
	cast = async(function(player)
		local t = {
			graphic = convertGraphic(core.look, "monster"),
			color = core.lookColor
		}
		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = 0

		local magic = 100
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local pcs = player:getObjectsInArea(BL_PC)

		local choice = player:inputSeq(
			"Who would you like to mentor?",
			"",
			"",
			{},
			{}
		)

		if choice == "" then
			return
		end
		if string.lower(choice) == string.lower(player.name) then
			player:dialog("You can't mentor yourself.", {})
			return
		end

		local target = Player(choice)

		if target == nil then
			player:dialog("Player is not valid or not online.", {})
			return
		end

		if not distanceSquare(player, target, 3) then
			player:popUp(target.name .. " must be near you when you ask to mentor.")
			return
		end

		if target.level < 3 or target.level > 8 then
			if target:hasLegend("mentored_by") then
				player:dialog(target.name .. " has already been mentored!", {})
				return
			end
			if target.registry["mentor"] ~= player.ID and target.registry["mentor"] ~= 0 then
				player:dialog(target.name .. " is not your protege!", {})
				return
			end

			if target.level >= 15 then
				if target.registry["mentor"] == player.ID then
					local choice_a = player:menuSeq(
						"You may complete mentoring someone at level 15. Do you wish to continue?",
						{"Yes, that's fine.", "No, absolutely not."},
						{}
					)

					if choice_a == 1 then
						player.registry["mentored"] = player.registry[
							"mentored"
						] + 1
						target.registry["mentor"] = 0

						if player:hasLegend("mentored") then
							player:removeLegendbyName("mentored")
						end

						player:addLegend(
							"Mentored " .. player.registry["mentored"] .. " new players",
							"mentored",
							3,
							1
						)

						if target:hasLegend("being_mentored_by") then
							target:removeLegendbyName("being_mentored_by")
						end
						target:addLegend(
							"Mentored by $player (" .. curT() .. ")",
							"mentored_by",
							3,
							1,
							player.ID
						)

						player:dialog(
							"This culminates your mentorship of " .. target.name .. ". Hopefully they have learned much from your teachings.",
							{}
						)
						target:dialog(
							"This culminates your mentorship under " .. player.name .. ". Hopefully you have learned much from their teachings.",
							{}
						)
					end
					return
				end
			else
				player:dialog(
					target.name .. " must be between the levels of 3 and 8 to accept a mentor.",
					{}
				)
			end
		else
			if target:hasLegend("mentored_by") then
				player:dialog(target.name .. " has already been mentored!", {})
				return
			end
			if target.registry["mentor"] ~= 0 then
				if target.registry["mentor"] == player.ID then
					player:dialog(
						target.name .. " is already being mentored by you!",
						{}
					)
				end
				if target.registry["mentor"] ~= player.ID then
					player:dialog(
						target.name .. " is already being mentored by someone else!",
						{}
					)
				end
				return
			end

			if target.level < 3 then
				player:dialogSeq(
					{
						t,
						"The player must be at least level 3 to accept your mentorship."
					},
					0
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"Mentoring someone in the lands of RetroTK is a great way to show your knowledge of the game and support for the community.",
					"You may begin mentoring someone as long as they have reached the 3rd insight and have not exceeded the 8th insight.",
					"The proposed mentoree must also be free from another's mentorship.",
					"After you have taught your mentoree much, you may culminate the mentorship when the mentoree has reached the 15th insight."
				},
				1
			)
			local choice = player:menuSeq(
				"Are you sure you would like to offer mentorship to " .. target.name .. "?",
				{"Yes", "No"},
				{}
			)
			if choice == 1 then
				target:freeAsync()
				target.registry["proposer"] = player.ID
				mentor.prompt(target)
			end
		end
	end),

	prompt = async(function(target)
		local proposer = Player(target.registry["proposer"])
		local accept = target:menuSeq(
			proposer.name .. " would like to offer you mentorship. Do you accept?",
			{"Yes! I need guidance.", "No, I must decline."},
			{"close"}
		)

		if accept == 1 then
			if proposer == nil then
				return
			end

			target.registry["proposer"] = 0
			target.registry["mentor"] = proposer.ID
			target:addLegend(
				"Being mentored by $player",
				"being_mentored_by",
				1,
				128,
				proposer.ID
			)

			proposer:dialog(
				target.name .. " accepts your offer of mentorship!. Please guide them until level 15 where you will need to cast this spell again to end the mentorship",
				{}
			)
		elseif accept == 2 then
			target.registry["proposer"] = 0

			proposer:dialog(target.name .. " regretably must decline.", {})

			return
		end
	end),

	requirements = function(player)
		local level = 40
		local items = {}
		local itemAmounts = {}

		if player.baseClass == 1 then
			-- warrior
			table.insert(items, Item("maxcaliber").id)
		elseif player.baseClass == 2 then
			-- rogue
			table.insert(items, Item("moonblade").id)
		elseif player.baseClass == 3 then
			-- mage
			table.insert(items, Item("deaths_head").id)
		elseif player.baseClass == 4 then
			-- poet
			table.insert(items, Item("wicked_staff").id)
		end

		table.insert(itemAmounts, 1)
		table.insert(items, 0)
		table.insert(itemAmounts, 1000)
		local desc = "This spell can be used to mentor a newbie."
		return level, items, itemAmounts, desc
	end
}
