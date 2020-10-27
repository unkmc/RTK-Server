warrior_board = {
	check = function(player)
		local del = 0
		local write = 0

		if player.tutor >= 1 then
			del, write = 1, 1
			if player:hasLegend("head_tutor") then
				player.boardNameVal = 2
			end
			if player:hasLegend("tutor") then
				player.boardNameVal = 3
			end
		end

		player.boardDel = del
		player.boardWrite = write
	end
}

rogue_board = {
	check = function(player)
		local del = 0
		local write = 0

		if player.tutor >= 1 then
			del, write = 1, 1
			if player:hasLegend("head_tutor") then
				player.boardNameVal = 2
			end
			if player:hasLegend("tutor") then
				player.boardNameVal = 3
			end
		end

		player.boardDel = del
		player.boardWrite = write
	end
}

mage_board = {
	check = function(player)
		local del = 0
		local write = 0

		if player.tutor >= 1 then
			del, write = 1, 1
			if player:hasLegend("head_tutor") then
				player.boardNameVal = 2
			end
			if player:hasLegend("tutor") then
				player.boardNameVal = 3
			end
		end

		player.boardDel = del
		player.boardWrite = write
	end
}

poet_board = {
	check = function(player)
		local del = 0
		local write = 0

		if player.tutor >= 1 then
			del, write = 1, 1
			if player:hasLegend("head_tutor") then
				player.boardNameVal = 2
			end
			if player:hasLegend("tutor") then
				player.boardNameVal = 3
			end
		end

		player.boardDel = del
		player.boardWrite = write
	end
}
