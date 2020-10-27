potionmaking = {
	craft = function(player, npc, speech)
		if speech == "alchemy" then
			if not crafting.checkSkillLegend(player, "potion making") then
				player:dialogSeq(
					{
						t,
						"You are not an alchemist, I can't let you work with my alchemy tools."
					},
					0
				)
				return
			end

			local opts = {
				"Powder yellow amber",
				"Poison darts",
				"Brew purple potion"
			}
			local itemsReq = {}
			local itemsReqAmounts = {}
			local itemCreated = ""

			if crafting.checkSkillLevel(player, "potion making", "accomplished") then
				table.insert(opts, "Brew lime potion")
			end
			if crafting.checkSkillLevel(player, "potion making", "master") then
				table.insert(opts, "Brew black potion")
			end

			local choice = player:menuSeq(
				"Which task shall you attempt?",
				opts,
				{}
			)

			if choice == 1 then
				-- powder yellow amber
				itemsReq = {"yellow_amber"}
				itemsReqAmounts = {1}
				itemCreated = "powdered_yellow_amber"
			elseif choice == 2 then
				-- poison darts
				itemsReq = {
					"muddy_potion",
					"powdered_yellow_amber",
					"snake_meat"
				}
				itemsReqAmounts = {1, 3, 2}
				itemCreated = "dart_poison"
			elseif choice == 3 then
				-- purple potion
				itemsReq = {"rat_meat", "antler", "root_liquor"}
				itemsReqAmounts = {2, 1, 1}
				itemCreated = "purple_potion"
			elseif choice == 4 then
				-- lime potion
				itemsReq = {"aged_wine", "limestone", "fine_snake_meat"}
				itemsReqAmounts = {1, 3, 2}
				itemCreated = "lime_potion"
			elseif choice == 5 then
				-- black potion
				itemsReq = {"diamond", "red_potion", "splendid_tiger_pelt"}
				itemsReqAmounts = {1, 1, 2}
				itemCreated = "black_potion"
			end

			for i = 1, #itemsReq do
				if player:hasItem(itemsReq[i], itemsReqAmounts[i]) ~= true then
					local errMsg = ""
					local tItemReq = {
						graphic = Item(itemsReq[i]).icon,
						color = Item(itemsReq[i]).iconC
					}

					if itemsReq[i] == "yellow_amber" then
						errMsg = "You do not have any yellow ambers to powder."
					else
						errMsg = "You do not have " .. itemsReqAmounts[i] .. " " .. Item(itemsReq[i]).name .. "s"
					end
					player:dialogSeq({tItemReq, errMsg}, 0)
					return
				end
			end

			for i = 1, #itemsReq do
				player:removeItem(itemsReq[i], itemsReqAmounts[i], 9)
			end

			local tItemCreated = {
				graphic = Item(itemCreated).icon,
				color = Item(itemCreated).iconC
			}

			crafting.skillChanceIncrease(player, npc, "potion making")

			if math.random(1, 5) == 1 then
				-- success
				player:addItem(itemCreated, 1)
				player:dialogSeq({tItemCreated, "You were successful."}, 0)
			else
				player:dialogSeq(
					{tItemCreated, "Your efforts were unsuccessful."},
					0
				)
			end
		end
	end
}
