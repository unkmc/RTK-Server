HareietteNpc = {
	click = async(function(player, npc)
		--player.registry["druid_quest"]=0
		--InstanceTestNpc.createInstance(player,npc,"druid_instance","Druid Trial")
		--[[
	local t = {graphic = convertGraphic(npc.look, "monster"), color = npc.lookColor}
	player.npcGraphic = t.graphic
	player.npcColor = t.color
	player.dialogType = 0
	player.lastClick = npc.ID

	local opts = {"Buy","Sell"}

	-- 1 - druid
	-- 2 - monk
	-- 3 - muse
	-- subpaths released = 0 means subpaths are out, 1 means we're working on it
	if player.class == 4 and (player.quest["subpath_trials"] == 0 or player.quest["subpath_trials"] == 13) and (player.gameRegistry["subpaths_released"] == 0 or player.gmLevel == 99) then
		table.insert(opts, "Join the Druids")
	end

	if player.quest["subpath_trials"] == 13 then
		table.insert(opts, "Abandon Trials")
	end

	local buysellopts = {} -- druids probably shouldn't sell meat

	local menu = player:menuString("Hello! How can I help you today?", opts)

	if menu == "Buy" then
		player:buyExtend("I think I can accomodate some of the things you need. What would you like?",buysellopts)
	elseif menu == "Sell" then
		player:sellExtend("What are you willing to sell today?",buysellopts)
	elseif menu == "Join the Druids" then
		if player.level < 50 then
			player:dialogSeq({t,"You are too young to join at this time."},0)
		end

		if not player:karmaCheck("dog") then
			player:dialogSeq({t,"Your soul is too impure. Improve your karma and return."},0)
			return
		end

		if player.quest["subpath_trials"] == 0 then
			local join = player:menuString("Do you wish to join the Druids?", {"Yes","No"})
			if join == "Yes" then
				player.quest["subpath_trials"] = 13
				player:dialogSeq({t,"Please complete my trials, to understand the ways of the Druids."},0)
			else
				player:dialogSeq({t,"Please do not waste my time."},0)
			end
		elseif player.quest["subpath_trials"] == 13 then
			local trialstable = {}
			if player:hasLegend("druid_trial_of_nature") == false then table.insert(trialstable, "Trial of Nature") end

			local trials = player:menuString("Do you wish to join the Druids?", trialstable)
			if trials == "Trial of Nature" then
				hariette.druid_trial_of_patience(player)
			end
		else
			player:dialogSeq({t,"You must abandon your other trials, before starting these."},0)
		end
	elseif menu == "Abandon Trials" then
		local abandon = player:menuString("Are you sure you want to abandon your trials?", {"Yes","No"})
		if abandon == "Yes" then
			player.quest["subpath_trials"] = 0
			player:removeLegendbyName("druid_trial_of_nature")
			player:dialogSeq({t,"Everything you have learned, has now been forgotten."},0)
		else
			return
		end
	end
	]]
		--
	end),
	druid_trial_of_nature = function(player)
	end,

	action = function(npc)
	end,

	buyItems = function()
		local buyItems = {}
		return buyItems
	end,

	sellItems = function()
		return self:buyItems()
	end
}
