MagistrateNpc = {
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

		-- 1 - chongun
		-- 2 - barbarian
		-- 3 - do
		-- subpaths released = 0 means subpaths are out, 1 means we're working on it
		if player.class == 1 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 14) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
			table.insert(opts, "Join the Chongunate")
		end

		if player.quest["subpath_trials"] == 14 then
			table.insert(opts, "Abandon Trials")
		end

		local buysellopts = {
			"rabbit_meat",
			"meat_scrap",
			"horse_meat",
			"antler",
			"bears_liver",
			"tigers_heart"
		}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "Buy" then
			player:buyExtend(
				"I think I can accomodate some of the things you need. What would you like?",
				buysellopts
			)
		elseif menu == "Sell" then
			player:sellExtend(
				"What are you willing to sell today?",
				buysellopts
			)
		elseif menu == "Join the Chongunate" then
			if player.level < 50 then
				player:dialogSeq(
					{t, "You are too young to join at this time."},
					0
				)
			end

			if not player:karmaCheck("dog") then
				player:dialogSeq(
					{
						t,
						"Your soul is too impure. Improve your karma and return."
					},
					0
				)
				return
			end

			if player.quest["subpath_trials"] == 0 then
				local join = player:menuString(
					"Do you wish to join the Chongunate?",
					{"Yes", "No"}
				)
				if join == "Yes" then
					player.quest["subpath_trials"] = 14
					player:dialogSeq(
						{
							t,
							"Please complete my trials, to understand the ways of the Chongun."
						},
						0
					)
				else
					player:dialogSeq({t, "Please do not waste my time."}, 0)
				end
			elseif player.quest["subpath_trials"] == 14 then
				local trialstable = {}
				if player:hasLegend("chongun_trial_of_honor") == false then
					table.insert(trialstable, "Trial of Honor")
				end
				if player:hasLegend("chongun_trial_of_valor") == false then
					table.insert(trialstable, "Trial of Valor")
				end
				if player:hasLegend("chongun_trial_of_wisdom") == false then
					table.insert(trialstable, "Trial of Wisdom")
				end
				if player:hasLegend("chongun_trial_of_patience") == false then
					table.insert(trialstable, "Trial of Patience")
				end

				local trials = player:menuString(
					"Do you wish to join the Chongunate?",
					trialstable
				)
				if trials == "Trial of Patience" then
					MagistrateNpc.chongun_trial_of_patience(player)
				end
				if trials == "Trial of Honor" then
					MagistrateNpc.chongun_trial_of_honor(player)
				end
				if trials == "Trial of Wisdom" then
					MagistrateNpc.chongun_trial_of_wisdom(player)
				end
				if trials == "Trial of Valor" then
					MagistrateNpc.chongun_trial_of_valor(player)
				end
			else
				player:dialogSeq(
					{
						t,
						"You must abandon your other trials, before starting these."
					},
					0
				)
			end
		elseif menu == "Abandon Trials" then
			local abandon = player:menuString(
				"Are you sure you want to abandon your trials?",
				{"Yes", "No"}
			)
			if abandon == "Yes" then
				player.quest["subpath_trials"] = 0
				player.quest["patience_start"] = 0
				player.quest["chongun_valor"] = 0
				player.quest["chongun_valor_rabbit1"] = 0
				player.quest["chongun_valor_rabbit2"] = 0
				player.quest["chongun_valor_rabbit3"] = 0
				player.quest["chongun_valor_monkey1"] = 0
				player.quest["chongun_valor_monkey2"] = 0
				player.quest["chongun_valor_monkey3"] = 0
				player.quest["chongun_valor_dog1"] = 0
				player.quest["chongun_valor_dog2"] = 0
				player.quest["chongun_valor_dog3"] = 0
				player:removeLegendbyName("chongun_trial_of_patience")
				player:removeLegendbyName("chongun_trial_of_honor")
				player:removeLegendbyName("chongun_trial_of_valor")
				player:removeLegendbyName("chongun_trial_of_wisdom")
				player:dialogSeq(
					{t, "Everything you have learned, has now been forgotten."},
					0
				)
			else
				return
			end
		end
	end),
	chongun_trial_of_patience = function(player)
		if player.quest["patience_start"] == 0 then
			player.quest["patience_start"] = os.time()
			player:dialogSeq(
				{
					t,
					"In order to pass the trial of patience, you must wait 3 days. Return to me once you have completed it."
				},
				0
			)
		else
			if os.time() > player.quest["patience_start"] + 259200 then
				if player:hasLegend("chongun_trial_of_patience") == false then
					player:addLegend(
						"Passed the Chongun trial of Patience",
						"chongun_trial_of_patience",
						17,
						15
					)
				end
				player:dialogSeq({t, "You have done well."}, 0)
			else
				player:dialogSeq({t, "You have not passed this trial."}, 0)
			end
		end
	end,
	chongun_trial_of_honor = function(player)
		local diag = {
			t,
			"As a Chongun, we honor and support our kingdoms, and the people within them. Please seek out and complete 10 minor quests."
		}

		if (player.quest["minorquestcomplete"] >= 10) then
			if player:hasLegend("chongun_trial_of_honor") == false then
				player:addLegend(
					"Passed the Chongun trial of Honor",
					"chongun_trial_of_honor",
					17,
					15
				)
			end
			table.insert(diag, "You have done well.")
		else
			table.insert(
				diag,
				"Please come back when you have completed this task."
			)
		end

		player:dialogSeq(diag, 0)
	end,
	chongun_trial_of_valor = function(player)
		-- kill rabbit, monkey and dog bosses
		local diag = {
			t,
			"In order to prove your strength and valor, please go slay the keeper of luck, keeper of roses and keeper of battle protection."
		}

		if player.quest["chongun_valor"] == 0 then
			player.quest["chongun_valor_rabbit1"] = player:killCount("hare_witch")
			player.quest["chongun_valor_rabbit2"] = player:killCount("rabbit_witch")
			player.quest["chongun_valor_rabbit3"] = player:killCount("rabbit_avenger")

			player.quest["chongun_valor_monkey1"] = player:killCount("monkey_mauler")
			player.quest["chongun_valor_monkey2"] = player:killCount("monkey_basher")
			player.quest["chongun_valor_monkey3"] = player:killCount("monkey_avenger")

			player.quest["chongun_valor_dog1"] = player:killCount("dog_assassin")
			player.quest["chongun_valor_dog2"] = player:killCount("dog_cutthroat")
			player.quest["chongun_valor_dog3"] = player:killCount("dog_avenger")

			player.quest["chongun_valor"] = 1
		end

		if player.quest["chongun_valor"] == 1 then
			local rabbit = false
			local monkey = false
			local dog = false

			if player.quest["chongun_valor_rabbit1"] > player:killCount("hare_witch") or player.quest[
				"chongun_valor_rabbit2"
			] > player:killCount("rabbit_witch") or player.quest[
				"chongun_valor_rabbit3"
			] > player:killCount("rabbit_avenger") then
				rabbit = true
			end

			if player.quest["chongun_valor_monkey1"] > player:killCount("monkey_mauler") or player.quest[
				"chongun_valor_monkey2"
			] > player:killCount("monkey_basher") or player.quest[
				"chongun_valor_monkey3"
			] > player:killCount("monkey_avenger") then
				monkey = true
			end

			if player.quest["chongun_valor_dog1"] > player:killCount("dog_assassin") or player.quest[
				"chongun_valor_dog2"
			] > player:killCount("dog_cutthroat") or player.quest[
				"chongun_valor_dog3"
			] > player:killCount("dog_avenger") then
				dog = true
			end

			if rabbit and monkey and dog then
				player.quest["chongun_valor_rabbit1"] = 0
				player.quest["chongun_valor_rabbit2"] = 0
				player.quest["chongun_valor_rabbit3"] = 0

				player.quest["chongun_valor_monkey1"] = 0
				player.quest["chongun_valor_monkey2"] = 0
				player.quest["chongun_valor_monkey3"] = 0

				player.quest["chongun_valor_dog1"] = 0
				player.quest["chongun_valor_dog2"] = 0
				player.quest["chongun_valor_dog3"] = 0
				if player:hasLegend("chongun_trial_of_valor") == false then
					player:addLegend(
						"Passed the Chongun trial of Valor",
						"chongun_trial_of_valor",
						17,
						15
					)
				end
				table.insert(diag, "You have done well.")
			else
				table.insert(
					diag,
					"Please come back when you have completed this task."
				)
			end
		end

		player:dialogSeq(diag, 0)
	end,
	chongun_trial_of_wisdom = function(player)
		-- complete questionaire
	end,

	action = function(npc)
	end,

	buyItems = function()
		local buyItems = {
			"rabbit_meat",
			"meat_scrap",
			"horse_meat",
			"antler",
			"bears_liver",
			"tigers_heart"
		}
		return buyItems
	end,

	sellItems = function()
		return self:buyItems()
	end
}
