duel_request = {
	click = function(player, target)
		target.registry["duel_initiator"] = player.ID
		target:freeAsync()
		duel_request.ask(target)
	end,

	ask = async(function(player)
		local initiator = Player(player.registry["duel_initiator"])

		local choice = player:menuString(
			initiator.name .. " would like to duel with you. Accept?",
			{"Yes", "No"},
			{}
		)

		if choice == "Yes" then
			initiator:msg(
				0,
				player.name .. " has accepted your duel request. Duel will begin in 30 seconds.",
				initiator.ID
			)
			player:msg(
				0,
				"You have accepted " .. initiator.name .. "'s request to duel. The duel will begin in 30 seconds.",
				player.ID
			)
		end
	end)
}
