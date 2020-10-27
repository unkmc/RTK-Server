PyungPetNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {"Reincarnate", "Observe"}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Reincarnate" then
			general_npc_funcs.reincarnate(player, npc)
		elseif choice == "Observe" then
			general_npc_funcs.observe(player, npc)
		end
	end)
}
