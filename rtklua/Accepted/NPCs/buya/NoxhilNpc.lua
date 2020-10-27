local _waypointId = "islets"

NoxhilNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		if (Waypoint.isEnabled(player, _waypointId)) then
            player:sendMinitext("Welcome back, traveler.")
            return
		end

		local choice = player:menuString(
			"Hello! How may I help you today?",
			{"Waypoint"}
        )

		if choice == "Waypoint" then
            Waypoint.add(player, npc, _waypointId)
		end
	end),

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if (speech == "waypoint" and not Waypoint.isEnabled(player, _waypointId)) then
			Waypoint.add(player, npc, _waypointId)
			return
		end
	end),
}
