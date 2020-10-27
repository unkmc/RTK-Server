local _waypointId = "museum"

MuseumCaretakerNpc = {
	click = async(function(player, npc)
		local caretakerDialog = Tools.configureDialog(player, npc)

		local opts = {
			"Caretaker's Gift",
			"Donate to Museum"
		}

		if player.quest["tutorial_quest"] == 13 and player.quest["visited_yon_and_weaved"] == 1 then
			table.insert(opts, "Students cap")
		end

		if (Config.bossDropSalesEnabled) then
			table.insert(opts, "Sell")
		end

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		local dragontooth = Item("dragons_tooth")

		local dragonToothDialog = {
			graphic = dragontooth.icon,
			color = dragontooth.iconC
		}

		if choice == "Sell" then
			MuseumCaretakerNpc.sellItems(player)
		elseif choice == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		elseif choice == "Caretaker's Gift" then
			if player.quest["received_caretakers_gift"] == 1 then
				player:dialogSeq({caretakerDialog, "You have already received a Dragon's tooth in the past. One per person!"}, 0)
				return
			end

			player.quest["received_caretakers_gift"] = 1
			player:addItem("dragons_tooth", 1)

			player:dialogSeq(
				{
					caretakerDialog,
					"I hope you enjoyed your visit to the Museum! The Archons, the historian Qantao, and I have worked very hard to prepare it for you."
				},
				1
			)

			player:dialogSeq(
				{
					dragonToothDialog,
					"Here is a small, rare gift for you to remember your visit to the museum. It will turn you into a dragon for a short time! Use it on a special occasion, as it will vanish!"
				},
				1
			)
		elseif choice == "Donate to Museum" then
			local choice2 = player:menuSeq(
				"Donate gold to the Museum?",
				{
					"No thank you.",
					"Donate 50000 gold.",
					"Donate 5000 gold.",
					"Donate 500 gold."
				},
				{}
			)

			local gold
			local level

			if player:hasLegend("museum_contributor") then
				player:dialogSeq({caretakerDialog, "Thank you so much for your previous donation."}, 1)
				return
			end

			if choice2 == 1 then
				return
			elseif choice2 == 2 then
				gold = 50000
				level = "Benefactor"
			elseif choice2 == 3 then
				gold = 5000
				level = "Patron"
			elseif choice2 == 4 then
				gold = 500
				level = "Contributor"
			end

			if player.money < gold then
				player:dialogSeq({caretakerDialog, "Come back when you have enough gold."}, 1)
				return
			else
				player:removeGold(gold)
				player:addLegend(
					"Museum " .. level .. " (" .. curT() .. ")",
					"museum_contributor",
					3,
					1
				)

				player:dialogSeq({caretakerDialog, "Thank you for your generous donation! Please come visit again soon."}, 1)
				return
			end
		elseif choice == "Students cap" then
			if player:hasItem("cloth", 1) ~= true then
				player:dialogSeq({caretakerDialog, "Sorry young one, I know you are anxious to make your cap, but you need to make the cloth yourself so it fits you."}, 1)
				return
			else
				player:dialogSeq(
					{
						caretakerDialog,
						"Greetings. So you have come here looking to make a Student cap? First I need some cloth that you have made yourself.",
						"Ah, here we go. Now I learnt how to fold this from some of the historical documents I sent to the Library."
					},
					1
				)

				player:removeItem("cloth", 1, 9)
				player:addItem("student_cap", 1, 0, player.ID)
			end
		end
	end),

	sellItems = function(player)
		local items = {
			"key_to_earth",
			"key_to_fire",
			"key_to_wind",
			"key_to_heaven",
			"key_to_pond",
			"key_to_thunder",
			"key_to_water",
			"key_to_mountain"
		}

		local prices = {}

		for i = 1, #items do
			table.insert(prices, math.floor(Item(items[i]).sell * 1.2))
		end

		player:sellExtend(
			"What are you willing to sell today?",
			items,
			prices
		)
	end,

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if speech == "map" or speech == "fragment" or speech == "map fragment" then
			if player.quest["instance"] == 6 then
				player:dialogSeq({"This is it. Take this to the disciple of Chung Ryong and show them the essence"}, 1)
			end
			if player.quest["instance"] == 5 then
				if player:hasItem("dragon_essence", 5) == true then
					player:removeItem("dragon_essence", 5)
					player:addItem("chung_ryongs_might", 1)
					player.quest["instance"] = 6
					player:dialogSeq({"This is it. Take this to the disciple of Chung Ryong and show them the essence"}, 1)
				else
					player:dialogSeq({"Please do not waste my time. Come back to me when you have the essences."}, 1)
				end
			end

			if player:hasItem("combined_map", 1) == true and player.quest["instance"] == 4 then
				player.quest["instance"] = 5

				player:dialogSeq(
					{
						"You were sent here from the librarian? Interesting...",
						"This map is unlike anything I have ever seen. This must be the legendary heavenly mountain... Baekdu",
						"Unfortunately, you can not see the path because it has been hidden by ancient dragons.",
						"However, I can help you.",
						"If we infuse your soul with Chung Ryong's might, the path may be revealed to you, and passage will be granted.",
						"Go gather 5 rare essences from the mythical dragons and come back to me when you have them."
					},
					1
				)
			end
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end)
}
