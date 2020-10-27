guide = {
	check = function(player)
		local del = 0
		local write = 0

		if player.level >= 25 or player.gmLevel > 0 then
			write = 1
		end

		player.boardDel = del
		player.boardWrite = write
	end
}
