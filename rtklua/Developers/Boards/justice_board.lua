justice = {
	check = function(player)
		local del = 0
		local write = 6

		player.boardDel = del
		player.boardWrite = write
	end,

	write = function(player)
		local headers = {
			"Defendent :",
			"When :",
			"Where :",
			"What :",
			"Evidence :",
			"Description :",
			"Your name: "
		}
		local questions = {
			"Name of person who comitted the crime.",
			"When was the crime committed?",
			"What crime did they commit?",
			"What proof do you have that they committed the crime?",
			"Explain exactly what happened, the more details you give the better.",
			"What is your name?"
		}
		local inputLines = {1, 1, 1, 1, 3, 3, 1}

		player:sendBoardQuestions(headers, questions, inputLines)
	end,
}
