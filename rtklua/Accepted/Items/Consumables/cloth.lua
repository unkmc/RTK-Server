cloth = {
	on_drop = function(player, item)
		if player.mapTitle == "Dae Shore" and player.x >= 69 and player.x <= 77 and player.y >= 0 and player.y <= 39 then
			local t = {graphic = convertGraphic(838, "item"), color = 0}
			player.npcGraphic = t.graphic
			player.npcColor = t.color
			player.dialogType = 0
			player.lastClick = player.ID

			if math.random(1, 10) == 1 then
				player:addItem("salt_block", 1)
				player:removeItem("cloth", 1, 1)
				player.fakeDrop = 1
				player:dialogSeq({t, "You found a salt block."}, 0)
			end
		end
	end
}
