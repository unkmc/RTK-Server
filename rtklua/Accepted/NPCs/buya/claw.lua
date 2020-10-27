ClawNpc = {
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if speech == "i lost my tiger mail" then
			player:dialogSeq(
				{
					t,
					"Oh? So you've lost your tiger mail, huh? I will have to reteach you the ways of the tiger."
				},
				1
			)

			local choice = player:menuSeq(
				"Are you sure you wish to relearn the ways of the tiger? (this will reset your quest progress)",
				{"Yes", "No"},
				{}
			)

			if choice == 1 then
				player.quest["tiger_armor"] = 0
				player:dialogSeq(
					{
						t,
						"Ah, so we are going to begin again. Please say \"Chongun\" when you are ready to start again."
					},
					0
				)
				return
			end
			return
		end

		if speech == "chongun" then
			Tools.checkKarma(player)

			if player.baseClass ~= 1 then
				player:dialogSeq({t, "Sorry I cannot help your kind."}, 0)
				return
			end

			player:dialogSeq(
				{
					t,
					"In former lives, I was a mighty Chongun, that would put your contemporaries to shame.",
					"You seek my essence? You wish to become as powerful and invincible as the tiger?",
					"Then you must use that essence within yourself. Do NOT hand me anything. Just have it on you."
				},
				1
			)

			if player.quest["tiger_armor"] == 0 then
				-- just starting out
				if player.level < 5 then
					player:dialogSeq(
						{t, "Return when you have reached level 5."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {Item("antler"), Item("war_platemail")}
					neededItemAmounts = {1, 1}
					armor = Item("tiger_mail")
				elseif player.sex == 1 then
					neededItems = {Item("antler"), Item("spring_war_dress")}
					neededItemAmounts = {1, 1}
					armor = Item("tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(neededItems[2].yname, neededItemAmounts[2]) ~= true then
					player:dialogSeq(
						{
							t,
							"Fetch an " .. neededItems[1].name .. " and " .. neededItems[
								2
							].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 664
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 10
				player:dialogSeq(
					{t, "Return when you have reached level 10."},
					0
				)
			end

			if player.quest["tiger_armor"] == 10 then
				-- level 10 quest
				if player.level < 10 then
					player:dialogSeq(
						{t, "Return when you have reached level 10."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("gold_acorn"),
						Item("jade_war_platemail"),
						Item("tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("jade_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("gold_acorn"),
						Item("summer_war_dress"),
						Item("tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("jade_tigress")
				end

				if (player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or
					player:hasItem(neededItems[2].yname, neededItemAmounts[2]) ~= true or
					player:hasItem(neededItems[3].yname, neededItemAmounts[3]) ~= true) then
					
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 2556
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 20
				player:dialogSeq(
					{t, "Return when you have reached level 20."},
					0
				)
			end

			if player.quest["tiger_armor"] == 20 then
				-- level 20 quest
				if player.level < 20 then
					player:dialogSeq(
						{t, "Return when you have reached level 20."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("fox_blade"),
						Item("royal_war_platemail"),
						Item("jade_tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("royal_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("fox_blade"),
						Item("autumn_war_dress"),
						Item("jade_tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("royal_tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(
					neededItems[2].yname,
					neededItemAmounts[2]
				) ~= true or player:hasItem(
					neededItems[3].yname,
					neededItemAmounts[3]
				) ~= true then
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 11200
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 30
				player:dialogSeq(
					{t, "Return when you have reached level 30."},
					0
				)
			end

			if player.quest["tiger_armor"] == 30 then
				-- level 30 quest
				if player.level < 30 then
					player:dialogSeq(
						{t, "Return when you have reached level 30."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("amber"),
						Item("sky_war_platemail"),
						Item("royal_tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("sky_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("amber"),
						Item("winter_war_dress"),
						Item("royal_tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("sky_tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(
					neededItems[2].yname,
					neededItemAmounts[2]
				) ~= true or player:hasItem(
					neededItems[3].yname,
					neededItemAmounts[3]
				) ~= true then
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 34784
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 40
				player:dialogSeq(
					{t, "Return when you have reached level 40."},
					0
				)
			end

			if player.quest["tiger_armor"] == 40 then
				-- level 40 quest
				if player.level < 40 then
					player:dialogSeq(
						{t, "Return when you have reached level 40."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("moonblade"),
						Item("ancient_war_platemail"),
						Item("sky_tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("ancient_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("moonblade"),
						Item("ancient_war_dress"),
						Item("sky_tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("ancient_tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(
					neededItems[2].yname,
					neededItemAmounts[2]
				) ~= true or player:hasItem(
					neededItems[3].yname,
					neededItemAmounts[3]
				) ~= true then
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 70344
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 50
				player:dialogSeq(
					{t, "Return when you have reached level 50."},
					0
				)
			end

			if player.quest["tiger_armor"] == 50 then
				-- level 50 quest
				if player.level < 50 then
					player:dialogSeq(
						{t, "Return when you have reached level 50."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("maxcaliber"),
						Item("blood_war_platemail"),
						Item("ancient_tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("blood_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("maxcaliber"),
						Item("blood_war_dress"),
						Item("ancient_tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("blood_tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(
					neededItems[2].yname,
					neededItemAmounts[2]
				) ~= true or player:hasItem(
					neededItems[3].yname,
					neededItemAmounts[3]
				) ~= true then
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 178032
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 60
				player:dialogSeq(
					{t, "Return when you have reached level 60."},
					0
				)
			end

			if player.quest["tiger_armor"] == 60 then
				-- level 60 quest
				if player.level < 60 then
					player:dialogSeq(
						{t, "Return when you have reached level 60."},
						0
					)
					return
				end

				local neededItems = {}
				local neededItemAmounts = {}

				if player.sex == 0 then
					neededItems = {
						Item("electra"),
						Item("earth_war_platemail"),
						Item("blood_tiger_mail")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("earth_tiger_mail")
				elseif player.sex == 1 then
					neededItems = {
						Item("electra"),
						Item("earth_war_dress"),
						Item("blood_tigress")
					}
					neededItemAmounts = {1, 1, 1}
					armor = Item("earth_tigress")
				end

				if player:hasItem(neededItems[1].yname, neededItemAmounts[1]) ~= true or player:hasItem(
					neededItems[2].yname,
					neededItemAmounts[2]
				) ~= true or player:hasItem(
					neededItems[3].yname,
					neededItemAmounts[3]
				) ~= true then
					player:dialogSeq(
						{
							t,
							"For the next armor, bring a " .. neededItems[1].name .. ", " .. neededItems[
								2
							].name .. ", and your " .. neededItems[3].name
						},
						0
					)
					return
				end

				player:removeItem(neededItems[1].yname, neededItemAmounts[1], 9)
				player:removeItem(neededItems[2].yname, neededItemAmounts[2], 9)
				player:removeItem(neededItems[3].yname, neededItemAmounts[3], 9)

				player:addItem(armor.yname, 1)

				local exp = player.exp - 428544
				if exp < 0 then
					exp = 0
					player.exp = exp
				end
				player:sendStatus()

				player.quest["tiger_armor"] = 70
				player:dialogSeq(
					{
						t,
						"You have seen what I know for I have only lived on earth. Perhaps a celestial being elsewhere would know more."
					},
					0
				)
			end

			if player.quest["tiger_armor"] == 70 then
				player:dialogSeq(
					{
						t,
						"You have seen what I know for I have only lived on earth. Perhaps a celestial being elsewhere would know more."
					},
					0
				)
				return
			end
		end

		if player.level >= 99 then
			if speech == "dragon" then
				player.quest["claw_soe"] = 1
				player:dialogSeq(
					{
						t,
						"Dragons you say? I know a little about them, all sorts of dragons.",
						"There is your regular dragon, like the ones you meet in Mythic, and then there are the special ones."
					},
					0
				)
			end

			if speech == "earth dragon" then
				player.quest["claw_soe"] = 2
				player:dialogSeq(
					{
						t,
						"Oh yes, the Earth dragons. Once a very mighty breed, and one of the immortal types of dragon.",
						"There use to be hundreds of them in the world, and they spread terror wherever they went.",
						"Eventually we found that we could not vanquish the last ones, as they were too strong, and could only capture them in shards."
					},
					0
				)
			end

			if speech == "shard" and player.quest["claw_soe"] >= 2 then
				player.quest["claw_soe"] = 3
				player:dialogSeq(
					{
						t,
						"A shard was a weapon that Baegi designed. If you want to know mroe you will have to ask him about them."
					},
					0
				)
			end
		end
	end)
}
