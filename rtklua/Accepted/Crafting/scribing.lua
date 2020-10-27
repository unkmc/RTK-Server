scribing = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "scribe" then
			if not crafting.checkSkillLegend(player, "scribing") then
				player:dialogSeq(
					{
						t,
						"You are not a scribe, I can't let you work with my scribing tools."
					},
					0
				)
				return
			end

			local tWhitePaper = {
				graphic = convertGraphic(281, "item"),
				color = 0
			}
			local tMoonPaper = {
				graphic = convertGraphic(281, "item"),
				color = 0
			}
			local tInk = {graphic = convertGraphic(283, "item"), color = 0}
			local tAmber = {graphic = convertGraphic(429, "item"), color = 0}
			local tDarkAmber = {
				graphic = convertGraphic(318, "item"),
				color = 0
			}
			local tWhiteAmber = {
				graphic = convertGraphic(428, "item"),
				color = 0
			}

			local itemsReq = {}
			local itemsReqAmounts = {}

			local scrolls = {"scroll_of_protection"}
			local scrollNames = {"Scroll of Protection"}
			local chosenScroll = ""

			if crafting.checkSkillLevel(player, "scribing", "apprentice") then
				table.insert(scrolls, "scroll_of_invocation")
				table.insert(scrollNames, "Scroll of Invocation")
			end
			if crafting.checkSkillLevel(player, "scribing", "accomplished") then
				table.insert(scrolls, "scroll_of_defense")
				table.insert(scrollNames, "Scroll of Defense")
			end
			if crafting.checkSkillLevel(player, "scribing", "talented") then
				table.insert(scrolls, "scroll_of_immortality")
				table.insert(scrollNames, "Scroll of Immortality")
			end

			if #scrolls == 1 then
				chosenScroll = "scroll_of_protection"
			else
				local choice = player:menuSeq(
					"Which task shall you attempt?",
					scrollNames,
					{}
				)
				chosenScroll = scrolls[choice]
			end

			if chosenScroll == "scroll_of_protection" then
				if player:hasItem("white_paper", 1) ~= true then
					player:dialogSeq(
						{
							tWhitePaper,
							"You need a sheet of white paper for this scroll."
						},
						0
					)
					return
				end

				if player:hasItem("ink", 1) ~= true then
					player:dialogSeq({tInk, "You need ink to write with."}, 0)
					return
				end
				if player:hasItem("amber", 1) ~= true then
					player:dialogSeq(
						{
							tAmber,
							"You need an amber to focus the magical energies."
						},
						0
					)
					return
				end

				itemsReq = {"white_paper", "ink", "amber"}
				itemsReqAmounts = {1, 1, 1}
			elseif chosenScroll == "scroll_of_invocation" then
				if player:hasItem("white_paper", 3) ~= true then
					player:dialogSeq(
						{
							tWhitePaper,
							"You need 3 sheets of white paper for this scroll."
						},
						0
					)
					return
				end
				if player:hasItem("ink", 1) ~= true then
					player:dialogSeq({tInk, "You need ink to write with."}, 0)
					return
				end
				if player:hasItem("dark_amber", 1) ~= true then
					player:dialogSeq(
						{
							tAmber,
							"You need a dark amber to focus the magical energies."
						},
						0
					)
					return
				end

				itemsReq = {"white_paper", "ink", "dark_amber"}
				itemsReqAmounts = {3, 1, 1}
			elseif chosenScroll == "scroll_of_defense" then
				if player:hasItem("moon_paper", 1) ~= true then
					player:dialogSeq(
						{
							tMoonPaper,
							"You need a sheet of moon paper for this scroll."
						},
						0
					)
					return
				end
				if player:hasItem("ink", 1) ~= true then
					player:dialogSeq({tInk, "You need ink to write with."}, 0)
					return
				end
				if player:hasItem("white_amber", 2) ~= true then
					player:dialogSeq(
						{
							tAmber,
							"You need 2 white ambers to focus the magical energies."
						},
						0
					)
					return
				end

				itemsReq = {"moon_paper", "ink", "white_amber"}
				itemsReqAmounts = {1, 1, 2}
			elseif chosenScroll == "scroll_of_immortality" then
				if player:hasItem("moon_paper", 3) ~= true then
					player:dialogSeq(
						{
							tMoonPaper,
							"You need 3 sheets of moon paper for this scroll."
						},
						0
					)
					return
				end
				if player:hasItem("purple_potion", 1) ~= true then
					player:dialogSeq(
						{tInk, "You need a Purple potion for this scroll."},
						0
					)
					return
				end
				if player:hasItem("well_crafted_white_amber", 4) ~= true then
					player:dialogSeq(
						{
							tAmber,
							"You need 4 Well cftd wt ambers to focus the magical energies."
						},
						0
					)
					return
				end

				itemsReq = {
					"moon_paper",
					"purple_potion",
					"well_crafted_white_amber"
				}
				itemsReqAmounts = {3, 1, 4}
			end

			for i = 1, #itemsReq do
				-- remove items
				player:removeItem(itemsReq[i], itemsReqAmounts[i], 9)
			end

			local tScroll = {
				graphic = Item(chosenScroll).icon,
				color = Item(chosenScroll).iconC
			}

			crafting.skillChanceIncrease(player, npc, "scribing")

			if math.random(1, 5) == 1 then
				-- success
				player:addItem(chosenScroll, 1)
				player:dialogSeq({tScroll, "You were successful."}, 0)
			else
				player:dialogSeq(
					{tScroll, "Your efforts were unsuccessful."},
					0
				)
			end
		end
	end
}
