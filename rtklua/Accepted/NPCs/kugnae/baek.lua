BaekNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Buy", "Sell"}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				BaekNpc.buyItems()
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				BaekNpc.sellItems()
			)
		end
	end),

	buyItems = function()
		local buyItems = {
			"clear_water_song",
			"sacred_poem",
			"war_poem",
			"moon_paper",
			"legend"
		}

		return buyItems
	end,

	sellItems = function()
		local sellItems = BaekNpc.buyItems()

		if (Config.bossDropSalesEnabled) then
			table.insert(sellItems, "chung_ryong_key")
			table.insert(sellItems, "baekho_key")
			table.insert(sellItems, "hyun_moo_key")
			table.insert(sellItems, "ju_jak_key")
		end

		return sellItems
	end,

	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		local baekDialog = Tools.configureDialog(player, npc)

		if speech == "chung ryong" or speech == "baekho" or speech == "ju jak" or speech == "hyun moo" then
			Tools.checkKarma(player)

			if player.level < 99 then
				player:dialogSeq(
					{
						baekDialog,
						"You are too young to be changing your mind on such matters. Return later, and we can talk again."
					},
					0
				)
				return
			end

			if player.class >= 10 then
				player:dialogSeq(
					{
						baekDialog,
						"You cannot join an NPC subpath while you belong to a PC subpath."
					},
					0
				)
				return
			end

			if (not player:karmaCheck("ox") and not Config.freeNpcSubpathsEnabled) then
				player:dialogSeq({baekDialog, "Come back when your karma is higher."}, 0)
				return
			end

			if (player.quest["blessed_by_watcher"] == 0 and not Config.freeNpcSubpathsEnabled) then
				-- not blessed
				player:dialogSeq({baekDialog, "You have not been blessed."}, 0)
				return
			end

			if (not player:hasLegend("dog_linguist") and not Config.freeNpcSubpathsEnabled) then
				return
			end

			if player.class > 4 then
				player:dialogSeq(
					{baekDialog, "You have already committed to a subpath."},
					0
				)
				return
			end

			-- only 4 basic paths

			if speech == "chung ryong" and player.class ~= 1 then
				return
			end
			if speech == "baekho" and player.class ~= 2 then
				return
			end
			if speech == "ju jak" and player.class ~= 3 then
				return
			end
			if speech == "hyun moo" and player.class ~= 4 then
				return
			end

			player:dialogSeq(
				{
					baekDialog,
					"Hmm... yes, I have studied the ways of the four totem animals. Do you wish to attain knowledge and power few mortals will know?",
					"You must be committed to serve the totem animals. Should you choose this arduous path, you will NEVER be able to join a subpath.",
					"To prove your devotion, you must make many sacrifices. First, you must bring to me a Favor from one of the Mythic animals.",
					"Then you must bring me ten hides from the most dreaded of caves, where the exits are not easily found and the enemies hide in shadows.",
					"Finally, you must sacrifice 1,000,000,000 experience to complete the most difficult studying involved."
				},
				1
			)

			local favors = {
				"dragons_favor",
				"roosters_favor",
				"dogs_favor",
				"horses_favor",
				"monkeys_favor",
				"oxs_favor",
				"pigs_favor",
				"rabbits_favor",
				"rats_favor",
				"sheeps_favor",
				"snakes_favor",
				"tigers_favor"
			}
			local favorFound = ""

			for i = 1, #favors do
				if player:hasItem(favors[i], 1) == true then
					favorFound = favors[i]
				end
			end

			if (favorFound == "" and not Config.freeNpcSubpathsEnabled) then
				-- no favvor found
				player:dialogSeq(
					{
						baekDialog,
						"If you ally with a Mythic animal, they will give you Favor."
					},
					0
				)
				return
			end

			if (not Config.freeNpcSubpathsEnabled) then
				player:removeItem(favorFound, 1, 9)
			end

			if (player:hasItem("splendid_tiger_pelt", 10) ~= true and not Config.freeNpcSubpathsEnabled) then
				player:dialogSeq(
					{
						baekDialog,
						"You have forgotten the hides! As punishment for failing to follow my instructions, you must now bring me another Favor as well."
					},
					0
				)
				return
			end

			if (not Config.freeNpcSubpathsEnabled) then
				player:removeItem("splendid_tiger_pelt", 10, 9)
			end

			if player.exp < 1000000000 then
				player:dialogSeq(
					{
						baekDialog,
						"You must have forgotten the experience needed! As punishment for failing to follow my instructions, you must now bring me another Favor as well as more hides."
					},
					0
				)
				return
			end

			player.exp = player.exp - 1000000000
			player:sendStatus()

			if not player:hasLegend("attained_totem_mastery") then
				player:addLegend(
					"Attained Totem Mastery (" .. curT() .. ")",
					"attained_totem_mastery",
					3,
					128
				)
			end

			if player.baseClass == 1 then
				player:updatePath(6, player.mark)
			end
			if player.baseClass == 2 then
				player:updatePath(7, player.mark)
			end
			if player.baseClass == 3 then
				player:updatePath(8, player.mark)
			end
			if player.baseClass == 4 then
				player:updatePath(9, player.mark)
			end

			player:calcStat()

			broadcast(
				-1,
				"[SUBPATH]: Congratulations to our newest " .. player.classNameMark .. " " .. player.name .. "!"
			)

			local tbook = {graphic = convertGraphic(20, "item"), color = 0}

			player:dialogSeq(
				{
					tbook,
					"You study for many days under the tutelage of Baek. You learn many rituals and legends."
				},
				1
			)
			player:dialogSeq(
				{
					baekDialog,
					"You are ready. You will now be able to learn new rituals from your Guildmaster. Go well, my friend!"
				},
				0
			)
		end

		if speech == "compass" then
			Tools.checkKarma(player)

			player:dialogSeq(
				{
					baekDialog,
					"Hello there, you're looking for a compass, huh?",
					"Well, I don't have the normal compasses, they are so dull.",
					"Seriously, who really needs a compass that only points one way?",
					"Everybody knows which way north is, it's to the north!",
					"No, no... my compasses have a real use. They show you how to get to some place.",
					"I don't bother with just the basic places, if you can't find Buya or Koguryo, then you just don't deserve to have eyes.",
					"Anyways, if there is some place you need to go tell me, and I can make a compass to get you there."
				},
				0
			)
		end

		if speech == "nagnag" then
			Tools.checkKarma(player)

			if player.quest["baek_compass"] == 0 then
				player.quest["baek_compass"] = 1
				player:dialogSeq(
					{
						baekDialog,
						"A compass to Nagnag's palace? They seem to be in high demand these days.",
						"Unfortunately, it is in such high demand that I have run out of parts for it.",
						"If you were to get the parts I need, I could show you what you need to do.",
						"Bring me a soup bowl, to hold the water in.",
						"A bit of fine metal, for the needle.",
						"Get that, and then come back to me."
					},
					0
				)
				return
			end

			if player.quest["baek_compass"] == 1 then
				if player:hasItem("soup_bowl", 1) ~= true then
					player:dialogSeq(
						{
							baekDialog,
							"Where is the soup bowl? Can't do anything without it, you know."
						},
						0
					)
					return
				end
				if player:hasItem("fine_metal", 1) ~= true then
					player:dialogSeq(
						{
							baekDialog,
							"I also need the Fine metal, my shipment hasn't arrived. Come back when you get some."
						},
						0
					)
					return
				end

				player:removeItem("soup_bowl", 1, 9)
				player:removeItem("fine_metal", 1, 9)
				player:addItem("nagnang_compass", 10)
				player:dialogSeq(
					{
						baekDialog,
						"Ahhh, now let me see, what were the directions again... 192... 284... 82... 76...",
						"A little water for the bowl, and we are done! There are a couple of them",
						"Good luck using it, the parts were not top of the line, so you can only use each one once.",
						"If you need another just tell me."
					},
					0
				)

				return
			end
		end
	end)
}
