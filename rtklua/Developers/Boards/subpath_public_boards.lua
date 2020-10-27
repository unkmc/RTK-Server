subpath_public_boards = {
	check = function(player)
		local item = player:getInventoryItem(player.invSlot)
		local class = item.look

		local del = 0
		local write = 0

		if player.class == class and player:hasLegend("elder") then
			del = 1
			write = 1
			player.boardNameVal = 4

			-- Elder title
		end

		player.boardDel = del
		player.boardWrite = write
	end
}

barbarian_runes_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
kwanhonsagje_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
ancient_parchment_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
knowledge_of_wealth_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
ranger_code_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
spys_journal_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
divine_chronicles_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
shu_jing_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
chieko_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
tomes_of_the_earth_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
the_wandering_monk_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
graced_by_the_muse_board = {
	check = function(player)
		subpath_public_boards.check(player)
	end
}
