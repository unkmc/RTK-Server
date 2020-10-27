MarketManagerNpc = {
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

		if speech == "special deal" and npc.mapTitle == "Nagnang Marketplace" and player.quest[
			"spy_trials"
		] == 6 then
			player.quest["underground_casino_quest"] = 0
			InstanceTestNpc.createInstance(
				player,
				npc,
				"underground_casino",
				"Underground Casino",
				1
			)
			player:dialogSeq(
				{t, "Step carefully down the pass here behind this booth..."},
				0
			)
		end
	end),
}
