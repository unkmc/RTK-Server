SalonNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if npc.mapTitle == "Kugnae Salon" then
			SalonNpc.mainFuncs(player, npc)
		elseif npc.mapTitle == "Buya Salon" then
			local opts = {"Buya Hair Salon", "Scalp massage"}

			local choice = player:menuString(
				"Hello! How can I help you today?",
				opts
			)

			if choice == "Buya Hair Salon" then
				SalonNpc.mainFuncs(player, npc)
			elseif choice == "Scalp massage" then
				general_npc_funcs.scalpMassage(player, npc)
			end
		elseif npc.mapTitle == "Nagnang Salon" then
			SalonNpc.mainFuncs(player, npc)
		end
	end),

	mainFuncs = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player:getEquippedItem(EQ_HELM) ~= nil then
			local equippedmsg = ""

			if npc.mapTitle == "Kugnae Salon" then
				equippedmsg = "You'll have to remove your headpiece before I can work on your hair!"
			elseif npc.mapTitle == "Buya Salon" then
				if player.sex == 0 then
					equippedmsg = "Woah there man.. I can't work on your hair 'til you, like, take off your headwear, ya know?"
				elseif player.sex == 1 then
					equippedmsg = "Woah there miss.. I can't work on your hair 'til you, like, take off your headwear, ya know?"
				end
			elseif npc.mapTitle == "Nagnang Salon" then
				equippedmsg = "You'll have to remove your headpiece before I can work on your hair!"
			end

			player:dialogSeq({t, equippedmsg}, 0)
			return
		end

		local opts = {}
		local salutation = ""
		local msg = ""

		if npc.mapTitle == "Kugnae Salon" then
			msg = "Certainly! Please have a seat over here and we'll see what I can do."
		elseif npc.mapTitle == "Buya Salon" then
			msg = "No problem. Sit down in my chair here and we'll take care of you."
		end

		-- ON NTK FEMALE CHARACTERS CANNOT HAVE BEARDS
		--[[if player.sex == 0 then
		opts = {"A hair cut, please.","I'd like a new hairdye.","I'm here for a shave.","I want a new beard","I'm here to redeem a voucher."}
		salutation = "sir"
	elseif player.sex == 1 then
		opts = {"A hair cut, please.","I'd like a new hairdye."}
		salutation = "miss"
	end]]
		--

		-- below is revised for RTK eff 05-21-19

		opts = {
			"A hair cut, please.",
			"I'd like a new hairdye.",
			"I'm here for a shave.",
			"I want a new beard",
			"I'm here to redeem a voucher."
		}

		if player.sex == 0 then
			salutation = "sir"
		elseif player.sex == 1 then
			salutation = "miss"
		end

		local choice = ""

		if npc.mapTitle == "Kugnae Salon" or npc.mapTitle == "Buya Salon" then
			choice = player:menuString(
				"Welcome to my salon, " .. salutation .. ". How can I help you today?",
				opts
			)
			player:dialogSeq({t, msg}, 1)
		elseif npc.mapTitle == "Nagnang Salon" then
			choice = player:menuString(
				"You're here to get your hair cut, eh?",
				opts
			)
		end

		if choice == "A hair cut, please." then
			general_npc_funcs.haircut(player, npc)
		elseif choice == "I'd like a new hairdye." then
			general_npc_funcs.hairdye(player, npc)
		elseif choice == "I'm here for a shave." then
			general_npc_funcs.shave(player, npc)
		elseif choice == "I want a new beard" then
			general_npc_funcs.beard(player, npc)
		end
	end,
}
