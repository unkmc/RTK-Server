local _leviathan = "leviathan"

local _showMenu = function(player)
	local opts = {"tainted_blade", "tainted_staff", "tainted_ring"}

	player:buyExtend(
		"What would you like to buy?",
		opts
	)
end

-- @TODO: Add option to repair cursed equipment

HermitNpc = {
	click = async(function(player, npc)
		Tools.configureDialog(player, npc)

		if (player.quest[_leviathan] < 3) then
			player:dialogSeq({"Who let you in here? Go away! I don't like strangers."}, 1)
			player:warp(2539, 22, 11)
			return
		end

		_showMenu(player)
	end),

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)

		local speech = string.lower(player.speech)

		if (speech == "dae-whan" and player.quest[_leviathan] < 3) then
			player:dialogSeq(
				{
					"Eh? So you are a friend of those big green guys to the south? Nice, peaceful folk they are. Leave me alone, and I leave them alone as well.",
					"My own kind has forsaken me. I devised a way to curse weapons with dark arts, corrupting them in exchange for formidable power. My companions feared my work and cast me out.",
					"They scattered my creations among monsters as deadly as the dark relics they now protect. I do not have the strength to reclaim them. I salvaged only the weakest of my designs, tainted and inferior.",
					"Still, even those may prove useful to you. The Leviathans took me in when no one else would. You helped them, so I will help you in return. Be wary. Wielding these items comes at a cost.",
				},
				1
			)

			player.quest[_leviathan] = 3
			_showMenu(player)
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
	end,
}
