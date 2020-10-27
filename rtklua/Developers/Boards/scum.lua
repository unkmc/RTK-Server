scum = {
	check = function(player)
		local del = 0
		local write = 0

		if player.gmLevel == 99 then
			del = 1
			write = 1
		end

		player.boardDel = del
		player.boardWrite = write
	end
}
