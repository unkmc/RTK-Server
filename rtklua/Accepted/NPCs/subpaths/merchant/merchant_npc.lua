MerchantNpc = {
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

		if player.class == 2 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 11) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
			table.insert(opts, "Join Merchants")
		end

		if player.quest["subpath_trials"] == 11 then
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
		elseif menu == "Join Merchants" then
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
					"Do you wish to join the Merchants?",
					{"Yes", "No"}
				)
				if join == "Yes" then
					player.quest["subpath_trials"] = 11
					player:dialogSeq(
						{
							t,
							"Please complete my trials, to understand the ways of the Merchants."
						},
						0
					)
				else
					player:dialogSeq({t, "Please do not waste my time."}, 0)
				end
			elseif player.quest["subpath_trials"] == 11 then
			else
				player:dialogSeq(
					{
						t,
						"You must abandon your other trials, before starting these."
					},
					0
				)
			end
		end
	end),

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
	end,
}
