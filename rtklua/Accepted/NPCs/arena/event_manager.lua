EventManagerNpc = {
	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		local opts = {
			"Deposit Money",
			"Deposit Item",
			"Withdraw Money",
			"Withdraw Item",
			"Fix Item",
			"Fix All Items",
			"Enter Carnage"
		}

		local choice = player:menuString(
			"Hello! How can I help you today?",
			opts
		)

		if choice == "Fix Item" then
			player:repairExtend()
		elseif choice == "Fix All Items" then
			player:repairAll(npc)
		elseif choice == "Deposit Item" then
			player:showBankDeposit(npc)
		elseif choice == "Deposit Money" then
			player:bankAddMoney(npc)
		elseif choice == "Withdraw Item" then
			player:showBankWithdraw(npc)
		elseif choice == "Withdraw Money" then
			player:bankWithdrawMoney(npc)
		end

		if choice == "Enter Carnage" then
			local cost = 0

			if (player.level >= 6 and player.level <= 35) then
				cost = 200

				-- "Carnage: Adventure (6-35)"
			elseif (player.level >= 36 and player.level <= 65) then
				cost = 500

				-- "Carnage: Heroes (36-65)"
			elseif (player.level >= 66 and player.level <= 85) then
				cost = 1000

				-- "Carnage: Glory (66-85)"
			elseif (player.level >= 86 and player.level <= 98) then
				cost = 5000

				-- "Carnage: Legends (86-98)"
			elseif (player.level >= 99) then
				cost = 8000
				if (player.baseHealth >= 50000 or player.baseMagic >= 25000) then
					cost = 12500
				end
				if (player.baseHealth >= 160000 or player.baseMagic >= 80000) then
					cost = 16000
				end
			end

			local agree1 = player:menuSeq(
				"Have you read and agreed to the Carnage rules in the guide and for this battle?",
				{"Yes", "No"},
				{}
			)

			if agree1 == 1 then
				--yes

				local agree2 = player:menuSeq(
					"You agree to abide by the host's decisions?",
					{"Yes", "No"},
					{}
				)

				if agree2 == 1 then
					local agree3 = player:menuSeq(
						"You have read and agree to the Carnage rules in the guide and wish to join this battle?",
						{"Yes to all that", "I'm not sure"},
						{}
					)

					if agree3 == 1 then
						local agree4 = player:menuSeq(
							"Since you agreed to all that, the fee is " .. Tools.formatNumber(cost) .. " gold to join this carnage, do you accept?",
							{"Shut up and take my money.", "No, nevermind."},
							{}
						)

						if agree4 == 1 then
							-- finally yes to everything

							if player.money < cost then
								player:dialogSeq(
									{
										t,
										"You do not have enough gold to participate in " .. minigames.eventNameLookUp(core.gameRegistry["minigameEventId"]) .. ". Come back when you have more gold."
									},
									0
								)
								return
							end

							player:removeGold(cost)
							player:flushDuration(1)
							player.registry["carnagePart"] = player.registry[
								"carnagePart"
							] + 1
							player:removeLegendbyName("carnagePart")
							player:addLegend(
								"Participated in " .. player.registry[
									"carnagePart"
								] .. " Carnages",
								"carnagePart",
								1,
								128
							)
							local warp = math.random(1, 4)
							if (warp == 1) then
								player:warp(3010, 4, 20)
							end
							if (warp == 2) then
								player:warp(3010, 12, 20)
							end
							if (warp == 3) then
								player:warp(3010, 20, 20)
							end
							if (warp == 4) then
								player:warp(3010, 28, 20)
							end
							player:calcStat()
						elseif agree4 == 2 then
							-- no
							return
						end
					elseif agree3 == 2 then
						return
					end
				elseif agree2 == 2 then
					return
				end
			elseif agree1 == 2 then
				-- no

				return
			end
		end
	end),

	checkEventReqs = function(player, npc, eventid)
		local accept = true

		if (eventid == 11 and (player.level < 6 or player.level > 35)) then
			accept = false
		end
		if (eventid == 12 and (player.level < 36 or player.level > 65)) then
			accept = false
		end
		if (eventid == 13 and (player.level < 66 or player.level > 85)) then
			accept = false
		end
		if (eventid == 14 and (player.level < 86 or player.level > 98)) then
			accept = false
		end
		if (eventid == 15) then
			-- ancients (99 to non-wasabi)
			if player.level < 99 or player.mark ~= 0 then
				accept = false
			end
			if player.baseHealth > 49999 or player.baseMagic > 24999 then
				accept = false
			end
		end
		if (eventid == 16) then
			-- avatars (wasabi to 160k/80k)
			if player.level < 99 or player.mark >= 2 then
				accept = false
			end
			if player.baseHealth < 50000 and player.baseMagic < 25000 then
				accept = false
			end
		end
		if (eventid == 17) then
			-- celestial (160k/80k+)
			if player.level < 99 or player.mark >= 4 then
				accept = false
			end
			if player.baseHealth < 160000 and player.baseMagic < 80000 then
				accept = false
			end
		end

		return accept
	end
}
