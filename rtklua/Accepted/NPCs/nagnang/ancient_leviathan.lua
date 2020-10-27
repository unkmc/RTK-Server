AncientLeviathanNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level < 12 then
			player:dialogSeq(
				{t, "Come back when you've gained more insight."},
				0
			)
			return
		end

		if player:hasLegend("leviathan_sworn_enemy") then
			local choicea = player:menuSeq(
				"You have been rude to me and my kind. For that you will need to pay me 1 million coins for me to continue talking with you. Do you wish to do so?",
				{
					"Yes. I am sorry for my remark and will pay you.",
					"No. You are not worth the money."
				},
				{}
			)

			if choicea == 1 then
				if player.money < 1000000 then
					player:dialogSeq(
						{t, "Return to me when you have the gold."},
						0
					)
					return
				end

				player:removeGold(1000000)
				player:removeLegendbyName("leviathan_sworn_enemy")
				player:dialogSeq({t, "I forgive you."}, 0)
			elseif choicea == 2 then
				player:dialogSeq(
					{
						t,
						"Then GO! And never return as we do not want your help!"
					},
					0
				)
			end
		end

		if not player:hasLegend("leviathan_sworn_enemy") and not player:hasLegend("leviathan_freed") then
			if player.quest["leviathan"] == 1 then
				player:dialogSeq(
					{
						t,
						"Please go save my kindred with the talisman I gave you."
					},
					0
				)
				return
			end

			if player.quest["leviathan"] == 2 then
				player:addLegend(
					"Freed Leviathan (" .. curT() .. ")",
					"leviathan_freed",
					7,
					128
				)
				player:dialogSeq(
					{
						t,
						"I thank you with all my heart for saving even one of our young kind. You will always be a friend to the free Leviathans.",
						"In fact, there is one of your kind in a small hut northeast of here. He may be able to help you. He mistrusts strangers, but just tell him Dae-Whan has sent you."
					},
					1
				)
				return
			end

			player:dialogSeq(
				{
					t,
					"No! Please! Take no more of our kind!!!",
					"Oh, you are not Him. I am sorry for my greeting of you. But we have been losing our kind for months now to a man whom we are unable to destroy.",
					"He continues to come here from time to time to take our youngsters away and trains them to do his bidding at war.",
					"He was just here a few days ago, and has taken a new group of them to his training grounds. Where he forces them to work and slave until they are mindless monsters for him.",
					"I have spent many days making just one of these fragile talismans. My kind is bound by a spell in the cage. Only this talisman can free them."
				},
				1
			)

			local choice = player:menuSeq(
				"Would you be willing to help an old leviathan save his kindred?",
				{"Yes, I am honored.", "No. Your kind deserve their fate."},
				{}
			)

			if choice == 1 then
				player.quest["leviathan"] = 1

				-- begins quest
				player:addItem("leviathan_talisman", 1)
				player:dialogSeq(
					{
						t,
						"Thank you! Here is a talisman. It will only work once. Since they are so fragile and take so long to make, I will give you only one.",
						"You must step next to my captured kind. The talisman will then break the spell and fall to dust. And my kind will be transported back here."
					},
					1
				)
				player:dialogSeq(
					{
						t,
						"He moves his camp around from time to time but we believe it to be East of his homeland. If you go there and free even one of my kind, I will be grateful."
					},
					0
				)
			elseif choice == 2 then
				player:addLegend(
					"Sworn enemy of the Leviathans (" .. curT() .. ")",
					"leviathan_sworn_enemy",
					7,
					4
				)
				player:dialogSeq(
					{
						t,
						"Then GO! And never return as we do not want your help!"
					},
					0
				)
			end
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
	end,
}
