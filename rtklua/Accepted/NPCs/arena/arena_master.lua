ArenaMasterNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"War paint"}

		local menu = player:menuString("Hello! How can I help you today?", opts)

		if menu == "War paint" then
			general_npc_funcs.warPaint(player, npc)
		end
	end)
}
