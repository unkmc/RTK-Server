local _waypointId = "forest_crossroads"

StelsiNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		if (Waypoint.isEnabled(player, _waypointId)) then
            player:sendMinitext("The ghost takes no notice of you.")
            return
		end

		local choice = player:menuString(
			"What do you ask of me?",
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

	move = function(npc, owner)
		local found
		local moved = true
		local oldside = npc.side
		local checkmove = math.random(0, 10)

		if (npc.retDist <= distanceXY(npc, npc.startX, npc.startY) and npc.retDist > 1 and npc.returning == false) then
			npc.returning = true
		elseif (npc.returning == true and npc.retDist > distanceXY(npc, npc.startX, npc.startY) and npc.retDist > 1) then
			npc.returning = false
		end

		if (npc.returning == true) then
			found = toStart(npc, npc.startX, npc.startY)
		else
			if (checkmove >= 4) then
				npc.side = math.random(0, 3)
				npc:sendSide()
				if (npc.side == oldside) then
					moved = npc:move()
				end
			end
		end

		if (found == true) then
			npc.returning = false
		end
	end
}
