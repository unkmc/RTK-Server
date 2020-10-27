gfx_switch = {
	cast = function(player)
		if player.gfxClone == 0 then
			clone.equip(player, player)
			player.gfxClone = 1
			if player.gmLevel > 0 then
				player:msg(4, "GFX : ON", player.ID)
			end
		else
			player.gfxClone = 0
			if player.gmLevel > 0 then
				player:msg(4, "GFX : OFF", player.ID)
			end
		end
		player:updateState()
	end,

	while_cast = function(player)
		player.gfxClone = 1
	end,

	uncast = function(player)
		player.gfxClone = 0
		player:updateState()
	end
}
