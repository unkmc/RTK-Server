TalonNpc = {
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
		--if player.class == 1 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 14) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
		--	table.insert(opts, "Join the Chongunate")
		--end

		if player.quest["subpath_trials"] == 19 then
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
	onSayClick = async(function(player, npc, speech)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID
		local speech = string.lower(player.speech)
		if speech == "special order" then
			if player.class == 2 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 19) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
				if player.quest["spy_trials"] == 0 then
					player.quest["subpath_trials"] = 19
					player.quest["spy_trials"] = 1
					player:dialogSeq(
						{
							t,
							"Ugh, you're the second person they've sent today for this special order... Well then, you can tell your people that I've already sent it along.",
							"It wasn't easy or safe coming into that stuff, but it's on the way to get prepared. You might be able to intercept it before that other guy.",
							"Maybe our smithy associate, Gruff, at his shop in the northern valley will know about the Special Delivery.",
							"** Talon hands you a small token embossed with a raven **",
							"Give this to him to show you're an affiliate of ours."
						},
						0
					)
				elseif player.quest["spy_trials"] == 1 then
					player:dialogSeq(
						{
							t,
							"** Turns his head away from you when you mention those words **"
						},
						0
					)
				end
			end
		end
	end),
}
