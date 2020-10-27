refresh_spell = {
	-- This is used solely to delete items under a player.. used for quests, do not delete.
	uncast = function(player)
		player:talk(0, "test")
		local item = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		item[1]:delete()
		player:refresh()
	end
}
