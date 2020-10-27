foodpreparation = {
	craft = function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local treqItem = {}
		local item = {}

		if speech:match("prepare ") then
			local words = {}

			local item, successItem = {}, {}

			local reqItemAmount = 0
			local successItemAmount = 0

			for word in speech:gmatch("%w+") do
				table.insert(words, word)
			end

			if words[2] == "beef" then
				item = Item("beef")
				successItem = Item("grilled_beef")
				reqItemAmount, successItemAmount = 1, 1
			elseif words[2] == "chicken" then
				item = Item("chicken_meat")
				successItem = Item("roast_chicken")
				reqItemAmount, successItemAmount = 1, 1
			elseif words[2] == "tiger" then
				item = Item("tiger_meat")
				successItem = Item("broiled_meat")
				reqItemAmount, successItemAmount = 1, 1
			elseif words[2] == "egg" then
				item = Item("egg")
				successItem = Item("fried_egg")
				reqItemAmount, successItemAmount = 1, 1
			elseif words[2] == "wheat" then
				item = Item("wheat")
				successItem = Item("flour")
				reqItemAmount, successItemAmount = 1, 1
			elseif words[2] == "fish" then
				item = Item("fish")
				successItem = Item("boiled_fish")
				reqItemAmount, successItemAmount = 1, 1
			end

			treqItem = {graphic = item.icon, color = item.iconC}

			if player:hasItem(item.yname, reqItemAmount) ~= true then
				if words[2] == "fish" then
					if player:hasItem("tiny_fish", reqItemAmount) == true then
						player:removeItem("tiny_fish", reqItemAmount, 9)

						if math.random(1, 10) == 1 then
							crafting.skillChanceIncrease(
								player,
								npc,
								"food preparation"
							)
							player:addItem(successItem.yname, successItemAmount)
							player:sendMinitext("You were successful.")
							return
						else
							player:sendMinitext("You failed in your attempt.")
							return
						end
					elseif player:hasItem("tasty_fish", reqItemAmount) == true then
						player:removeItem("tasty_fish", reqItemAmount, 9)

						if math.random(1, 10) == 1 then
							crafting.skillChanceIncrease(
								player,
								npc,
								"food preparation"
							)
							player:addItem(successItem.yname, successItemAmount)
							player:sendMinitext("You were successful.")
							return
						else
							player:sendMinitext("You failed in your attempt.")
							return
						end
					elseif player:hasItem("small_fish", reqItemAmount) == true then
						player:removeItem("small_fish", reqItemAmount, 9)

						if math.random(1, 10) == 1 then
							crafting.skillChanceIncrease(
								player,
								npc,
								"food preparation"
							)
							player:addItem(successItem.yname, successItemAmount)
							player:sendMinitext("You were successful.")
							return
						else
							player:sendMinitext("You failed in your attempt.")
							return
						end
					elseif player:hasItem("large_fish", reqItemAmount) == true then
						player:removeItem("large_fish", reqItemAmount, 9)

						if math.random(1, 10) == 1 then
							crafting.skillChanceIncrease(
								player,
								npc,
								"food preparation"
							)
							player:addItem(successItem.yname, successItemAmount)
							player:sendMinitext("You were successful.")
							return
						else
							player:sendMinitext("You failed in your attempt.")
							return
						end
					end
				end
				player:dialogSeq(
					{
						treqItem,
						"You have no " .. item.name .. " to prepare, come back when you have some."
					},
					0
				)
				return
			end

			player:removeItem(item.yname, reqItemAmount, 9)

			if math.random(1, 10) == 1 then
				crafting.skillChanceIncrease(player, npc, "food preparation")
				player:addItem(successItem.yname, successItemAmount)
				player:sendMinitext("You were successful.")
			else
				player:sendMinitext("You failed in your attempt.")
			end
		end
	end
}
