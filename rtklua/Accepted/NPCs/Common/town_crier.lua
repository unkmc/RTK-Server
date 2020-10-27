TownCrierNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {}

		if npc.mapTitle == "Kugnae" then
			table.insert(opts, "Move to Koguryo")
			table.insert(opts, "Koguryo Honor")
		end

		if npc.mapTitle == "Buya" then
			table.insert(opts, "Move to Buya")
			table.insert(opts, "Buya Defender")
		end

		if npc.mapTitle == "Nagnang" then
			table.insert(opts, "Move to Nagnang")
			table.insert(opts, "Nagnang Defender")
		end

		table.insert(opts, "Broadcast Event")
		table.insert(opts, "Wisdom clothes")

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts,
			{}
		)

		if choice == "Move to Koguryo" or choice == "Move to Buya" or choice == "Move to Nagnang" then
			local country = 0

			if npc.mapTitle == "Kugnae" then
				country = 1
			elseif npc.mapTitle == "Buya" then
				country = 2
			elseif npc.mapTitle == "Nagnang" then
				country = 3
			end

			general_npc_funcs.moveToCountry(player, npc, country)
		elseif choice == "Broadcast Event" then
			general_npc_funcs.broadcastEvent(player, npc)
		elseif choice == "Koguryo Honor" then
			TownCrierNpc.koguryoHonor(player, npc)
		elseif choice == "Buya Defender" then
			TownCrierNpc.buyaDefender(player, npc)
		elseif choice == "Nagnang Defender" then
			TownCrierNpc.nagnangDefender(player, npc)
		elseif choice == "Wisdom clothes" then
			general_npc_funcs.wisdomClothes(player, npc)
		end
	end),

	koguryoHonor = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		player:dialogSeq(
			{t, "Prince Mhul must first bestow this honor on you."},
			0
		)
	end,

	buyaDefender = function(player, npc)
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
				t,
				"Princess Lasahn must first accept your loyalty, then you will be a Buya defender."
			},
			0
		)
	end,

	nagnangDefender = function(player, npc)
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
				t,
				"Nagnang Defenders have the honor of wearing our kingdom's dye. Nagnang Royals must first accept your loyalty, then you'll be able to pledge to defend our kingdom."
			},
			0
		)
	end,

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
	end)
}
