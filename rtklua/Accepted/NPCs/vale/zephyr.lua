local _waypointId = "zephyr"

ZephyrNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local opts = {}

		if player.baseClass == 3 or player.baseClass == 4 then
			table.insert(opts, "Scribe Devotion")
			table.insert(opts, "Alchemy Devotion")
			table.insert(opts, "Scribe")
			table.insert(opts, "Alchemy")
		end

		if player.level >= 96 and player:hasLegend("understood_the_moon") and not player:hasLegend("captured_the_wind") then
			table.insert(opts, "Wind")
		end

		table.insert(opts, "Armor of the Winds")

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		if (Config.bossDropSalesEnabled) then
			table.insert(opts, "Sell")
		end

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Sell" then
			ZephyrNpc.sellItems(player)
		elseif menu == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		elseif menu == "Wind" then
			player:dialogSeq(
				{
					"Welcome, welcome, to the highest place in the Nexus where mortals can tread. It is not far from here that the winds themselves originate.",
					"Indeed, the legends are true. A pure soul can capture some of the winds essence, and combine it with clooth to form magical garments.",
					"Now, do not be mistaken. Armor formed from the winds is not the most protective. Still, it is a symbol of accomplishment and very battle capable apparel."
				},
				1
			)

			if player:karmaCheck("spirit") ~= true then
				player:dialogSeq({"Return to me when your soul is more noble."}, 0)
				return
			end

			player.quest["wind_armor"] = 1

			player:dialogSeq(
				{
					"A noble soul you have. Perhaps you will triumph over the clever winds. Though first you must find them.",
					"I hear that the Legends contain a tale of another who succeeded. Perhaps from that Legend you will find the answers you seek.",
					"Be warned, not all the legend has been found, and never will be. Such a powerful item was never to fall into the hands of evil.",
					"You will need to find one who knows of the lost legend if you ever hope to wear the armor of the winds!"
				},
				0
			)
		elseif menu == "Armor of the Winds" then
			ZephyrNpc.armorOfTheWinds(player, npc)
		elseif menu == "Scribe Devotion" then
			ZephyrNpc.scribeDevotion(player, npc)
		elseif menu == "Alchemy Devotion" then
			ZephyrNpc.alchemyDevotion(player, npc)
		elseif menu == "Scribe" then
			ZephyrNpc.scribe(player, npc)
		elseif menu == "Alchemy" then
			ZephyrNpc.alchemy(player, npc)
		end
	end),

	armorOfTheWinds = function(player, npc)
		Tools.configureDialog(player, npc)
		Tools.checkKarma(player)

		if player:hasLegend("captured_the_wind") then
			player:dialogSeq({"Hail, servant of the Winds!"}, 0)
			return
		end

		if player.quest["wind_armor"] == 0 or player.quest["min_kawlana"] == 0 or not player:karmaCheck("spirit") then
			player:dialogSeq({"I really have no idea what you are talking about."}, 0)
			return
		end

		local choice = player:dialogSeq(
			{
				"So, you think you are ready to take on the winds?",
				"It is not as easy as you may think. The beast you seek to capture is not an easy foe.",
				"I shall let you pass, and I wish you the best of luck."
			},
			1
		)

		if choice == true then
			-- player clicked next
			player.quest["kawlana_used"] = 0
			player.quest["kawlana_dropped"] = 0
			player:warp(1457, 8, 7)
			player:sendMinitext("Kawlana is the source of your power.")
		end
	end,

	scribeDevotion = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.level < 25) then
			player:dialogSeq({"You are not ready to devote to a craft yet, come back later."}, 0)
			return
		end

		if crafting.checkSkillLegend(player, "scribing") then
			player:dialogSeq({"You have already devoted yourself to the study of Scribing."}, 0)
			return
		end

		crafting.checkMentalSkill(player, npc, "potion making")

		player:dialogSeq({"Scribes can make magical scrolls that anyone can use. Typically these scrolls have defensive rituals inscribed upon them."}, 1)

		crafting.addMentalSkill(player, npc, "scribing")
	end,

	alchemyDevotion = function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.level < 25) then
			player:dialogSeq({"You are not ready to devote to a craft yet, come back later."}, 0)
			return
		end

		if crafting.checkSkillLegend(player, "potion making") then
			player:dialogSeq({"You have already devoted yourself to the study of potion making."}, 0)
			return
		end

		crafting.checkMentalSkill(player, npc, "scribing")

		player:dialogSeq({"Alchemists can make poisons for darts and a few different potions with unique effects."}, 1)

		crafting.addMentalSkill(player, npc, "potion making")
	end,

	scribe = function(player, npc)
		crafting.craftingDialog(player, npc, "scribe")
	end,

	alchemy = function(player, npc)
		crafting.craftingDialog(player, npc, "alchemy")
	end,

	sellItems = function(player)
		local items = {"scribes_pen", "scribes_book", "purified_water"}
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

		if speech == "capture the winds" then
			ZephyrNpc.armorOfTheWinds(player, npc)
		end

		if speech == "scribe" or speech == "alchemy" then
			crafting.craftingDialog(player, npc, speech)
		end

		if speech == "map" or speech == "fragment" or speech == "map fragment" then
			if player:hasItem("map_fragment", 1) == true and player.quest["instance"] == 0 then
				player.quest["instance"] = 1
				player:dialogSeq(
					{
						"Why must you always come to me when you find a new document?",
						"What is this? It's unlike anything I have ever seen.",
						"I would suggest seeking out another historian who might have more information about this."
					},
					1
				)
			end
			if player.quest["instance"] == 1 then
				player:dialogSeq({"Did you find anyone with information?"}, 1)
			end
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end)
}
