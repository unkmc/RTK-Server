sonhi_pass = {
	use = function(player)
		local width = 13
		local height = 15
		local note = "To whom this may concern, please allow the bearer of this pass access to all Sonhi areas so they may complete a task I have given them.\n\nKaMing"

		player:paperpopup(width, height, note)
	end
}
