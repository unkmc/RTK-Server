local _waypointId = "yon"

YonNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local opts = {
			"Buy",
			"Sell",
			"Crafting Skills",
			"Joy of Weaving",
			"Weaving Specialization"
		}

		if player.quest["wind_armor"] ~= 0 then
			table.insert(opts, "Weave Magical Net")
		end

		if (not Waypoint.isEnabled(player, _waypointId)) then
			table.insert(opts, "Waypoint")
		end

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Buy" then
			local items = YonNpc.buyItems(npc)
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				items
			)
		elseif choice == "Sell" then
			local items = YonNpc.sellItems(npc)
			player:sellExtend("What are you willing to sell today?", items)
		elseif choice == "Crafting Skills" then
			generalNPC.crafting_skills(player, npc)
		elseif choice == "Joy of Weaving" then
			YonNpc.joy_of_weaving(player, npc)
		elseif choice == "Weaving Specialization" then
			YonNpc.weaving_specialization(player, npc)
		elseif choice == "Weave Magical Net" then
			YonNpc.weaveMagicalNet(player, npc)
		elseif choice == "Waypoint" then
			Waypoint.add(player, npc, _waypointId)
		end
	end),

	buyItems = function(npc)
		local items = {}

		-- verified on NTK (what do you sell) responded with "I don't sell anything."
		return items
	end,

	sellItems = function(npc)
		local sellItems = {"cloth", "wool", "weaving_tools"}

		-- verified on NTK she only buys Weaving tools, Wool, and Cloth. (what do you buy)
		return sellItems
	end,

	joy_of_weaving = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{
				"I would be happy to tell you about weaving! Weaving requires three things: steady hands, some wool, and good weaving equipment.",
				"You can get wool from sheep.\nYou'll have to see a woodworker in order to acquire your own weaving tools, but I can loan you the rest of the things you need. As for the steady hands, those come with practice.",
				"Just say 'weave' to me when you're ready to give it a try!"
			},
			0
		)
	end,

	weaving_specialization = function(player, npc)
		Tools.configureDialog(player, npc)

		if crafting.checkSpecializationLegend(player, "weaving") then
			player:dialogSeq({"You have already specialized in Weaving."}, 0)
			return
		end

		crafting.checkSpecialization(player, npc, "smelting")
		crafting.checkSpecialization(player, npc, "gemcutting")

		player:dialogSeq({"Weavers can make cloth from wool. Do you want to specialize in weaving? ((You need to be specialized to become better than 'Accomplished.'))"}, 1)

		crafting.addSpecialization(player, npc, "weaving")
	end,

	weaveMagicalNet = function(player, npc)
		Tools.configureDialog(player, npc)
		local fineClothDialog = {graphic = convertGraphic(1633, "item"), color = 0}

		local chance = math.random(1, 10)

		if player:hasItem("fine_cloth", 10) ~= true or player:hasItem("red_potion", 1) ~= true or player:hasItem(
			"fine_weaving_tools",
			1
		) ~= true then
			player:dialogSeq({"You do not have the required items to weave the magical net. You need (10) Fine cloth, (1) Red potion, (1) Fine weaving tools"}, 0)
		end

		if chance == 1 then
			if player.quest["magical_net_created"] == 1 then
				player:dialogSeq({"You have already created a magical net."}, 0)
				return
			end

			player:removeItem("fine_cloth", 10, 9)
			player:removeItem("red_potion", 1, 9)
			player:addItem("magical_net", 1)
			player:addKarma(1)
			player.quest["magical_net_created"] = 1
			player:dialogSeq({fineClothDialog, "You have succeeded."}, 0)
		else
			player:removeItem("fine_cloth", 10, 9)
			player:removeItem("red_potion", 1, 9)
			player:dialogSeq({"You failed in this very difficult task."}, 0)
		end
	end,

	onSayClick = async(function(player, npc)
		local yonDialog = Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if speech == "weave" then
			Tools.checkKarma(player)

			local item = Item("wool")
			local woolDialog = {graphic = item.icon, color = item.iconC}

			local item2 = Item("weaving_tools")
			local weavingToolsDialog = {graphic = item2.icon, color = item2.iconC}

			if player.quest["tutorial_quest"] == 13 then
				if player.quest["visited_yon_and_weaved"] == 1 then
					player:dialogSeq(
						{
							yonDialog,
							"Please return to your tutor with the cloth."
						},
						1
					)

					return
				end

				player:dialogSeq(
					{
						woolDialog,
						"So you want to make some cloth for your Student cap? Well I can help you."
					},
					1
				)

				player:dialogSeq(
					{
						weavingToolsDialog,
						"Usually I don't let people weave without their own tools, but since you are new to the land I will let you use mine."
					},
					1
				)

				if player.quest["given_yons_weaving_tools"] == 0 then
					player:addItem("weaving_tools", 1)
					player.quest["given_yons_weaving_tools"] = 1
					return
				end

				if player:hasItem("wool", 1) ~= true then
					player:dialogSeq(
						{
							woolDialog,
							"But before we even get that far... you need some wool! Go back to the center of the Wilderness and collect some wool.",
							"When you have collected some, come back to me again."
						},
						1
					)
					return
				elseif player:hasItem("wool", 1) == true and player:hasItem("weaving_tools", 1) == true then
					-- has wool & weaving tools
					player:removeItem("wool", 1)
					player:removeItem("weaving_tools", 1)
					player:addItem("cloth", 1)
					player.quest["visited_yon_and_weaved"] = 1
					player:dialogSeq(
						{
							yonDialog,
							"You take a few moments with Yon's weaving tools and craft one piece of cloth. You return the borrowed weaving tools."
						},
						1
					)
					return
				elseif player:hasItem("weaving_tools", 1) ~= true then
					player:dialogSeq(
						{
							yonDialog,
							"What happened to the pair of weaving tools that I let you borrow?  You do realize I need them back, right?"
						},
						1
					)
					return
				end

				return
			end

			crafting.craftingDialog(player, npc, speech)

			return
		end

		if speech == "twine" then
			Tools.checkKarma(player)

			if player.quest["wool_twine"] == 1 then
				player:dialogSeq({"Ah, there is the wool, give it to me and I will quickly spin it into twine for you."}, 1)

				if player:hasItem("wool", 10) ~= true then
					player:dialogSeq({"Where is the wool? Without 10 Wool I can't make you any twine."}, 0)
					return
				end

				player:removeItem("wool", 10)
				player:addItem("wool_twine", 1)
				player:dialogSeq({"There you go, your own roll of twine. I hope that's all you need, but if you want more you can always come back to me."}, 0)

				return
			end

			if player.quest["wool_twine"] == 0 then
				player.quest["wool_twine"] = 1
				player:dialogSeq(
					{
						"Wool twine? Yes, its extremely easy to make. You just twist and stretch the wool for a while, but not so much as if you wanted to make thread.",
						"If you have 10 Wool I can quickly make you some twine."
					},
					0
				)
			end

			return
		end

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end)
}
