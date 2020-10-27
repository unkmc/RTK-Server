bugs_board = {
	check = function(player)
		local del = 0
		local write = 6
		player.boardDel = del
		player.boardWrite = write
	end,

	write = function(player)
		local headers = {"What :", "Where :", "When :", "Description :"}
		local questions = {
			"Short decription of bug",
			"Where were you when this bug happened?",
			"When did this bug happen?",
			"Please explain exactly what happened, the more details you give the better."
		}
		local inputLines = {2, 2, 2, 10}

		player:sendBoardQuestions(headers, questions, inputLines)
	end
}
