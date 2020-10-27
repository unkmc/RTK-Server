f4npc = {
	click = async(function(player, npc)
		local t = {graphic = convertGraphic(3, "monster"), color = 3}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local opts = {}
		local opts2 = {}
		local opts3 = {}
		local deathPileFound = 0
		local string = "Hello " .. player.name .. "! How can I help you today?"

		player:talk(0, "clicked")
	end)
}
