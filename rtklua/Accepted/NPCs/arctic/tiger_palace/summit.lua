SummitNpc = {
	onSayClick = async(function(player, npc)
		local speech = string.lower(player.speech)

		if speech == "cleanse curse" or speech == "cleanse" then
			SummitNpc.changeAlignment(player, npc)
		end
	end),

	changeAlignment = function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level < 99 or player.baseHealth < 20000 or player.baseMagic < 10000 or player.alignment == 0 then
			-- below minimum stats or no alignment
			player:dialogSeq({t, "I am unable to help you."}, 0)
			return
		end

		player:dialogSeq(
			{
				t,
				"Hahaha.. so the great one returns to me, does he master?",
				"Got yourself into a spot of trouble, so you come running back to me?",
				"Yes, from this level of \"life\" I can see into your soul, I can see your soul is not pure.",
				"I take it you want me to help you again, after what you did to me?"
			},
			1
		)

		local choice = player:menuSeq(
			"Well, do you really want me to help you? You know it will cost you greatly.",
			{"Yes, I need help.", "No, I need no help."},
			{}
		)

		if choice == 1 then
			player.baseHealth = player.baseHealth - 10000
			player.baseMagic = player.baseMagic - 5000
			player.registry["baseHealth"] = player.baseHealth
			player.registry["baseMagic"] = player.baseMagic
			player.health = player.baseHealth
			player.magic = player.baseMagic
			player:calcStat()
			player:sendStatus()
			player:swapAlignment(0)

			player:dialogSeq({t, "You are now unaligned."}, 0)
		elseif choice == 2 then
			player:dialogSeq({t, "Come back to me if you change your mind."}, 0)
			return
		end
	end,

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
