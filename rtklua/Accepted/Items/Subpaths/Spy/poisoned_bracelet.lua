poisoned_bracelet = {
	use = function(player)
		player:removeItem("poisoned_bracelet", 1)
		local targetFacing = getTargetFacing(player, BL_MOB)
		if targetFacing ~= nil then
			if targetFacing.yname == "spy_mob_1" then
				player:sendMinitext("You deliver a swift poke as you glide past the courtier, who slumps to the ground and begings foaming at the mouth.")
				targetFacing:talk(0, "Imperial Courtier: Guards! Guards! Help!")
				targetFacing:removeHealth(500000)
				player:sendAnimationXY(84, targetFacing.x, targetFacing.y, 1)
				poisoned_bracelet_spell.cast(player)
				player.registry["poisoned_bracelet"] = 1
			end
			if targetFacing.yname == "spy_mob_2" then
				player:sendMinitext("You deliver a swift poke with the bracelet as you glide past the courtier, he turns to and looks at your bracelet.")
				targetFacing:talk(0, "Imperial Courtier: I-I knew iiiit....")
				targetFacing:removeHealth(500000)
				player:sendAnimationXY(84, targetFacing.x, targetFacing.y, 1)
				poisoned_bracelet_spell.cast(player)
				player.registry["poisoned_bracelet"] = 2
			end
		else
			player:sendMinitext("The bracelet slips out of your hand and breaks.")
			player.registry["poisoned_bracelet"] = 3
			poisoned_bracelet_spell.cast(player)
		end
	end
}

poisoned_bracelet_spell = {
	cast = function(player)
		player:setDuration("poisoned_bracelet_spell", 12000)
	end,
	while_cast = function(player)
		if player:getDuration("poisoned_bracelet_spell") == 5000 and player.registry[
			"poisoned_bracelet"
		] == 1 then
			local mobs = player:getObjectsInArea(BL_MOB)
			if #mobs > 0 then
				for z = 1, #mobs do
					local rand = math.random(1, 3)
					if rand == 1 then
						mobs[z]:talk(0, "Imperial Courtier: What was that?!")
					end
					if rand == 2 then
						mobs[z]:talk(
							0,
							"Imperial Courtier: Did you see what that was?"
						)
					end
					if rand == 3 then
						mobs[z]:talk(
							0,
							"Imperial Courtier: I think someone just died!"
						)
					end
				end
			end
		end
		if player:getDuration("poisoned_bracelet_spell") == 9000 and player.registry[
			"poisoned_bracelet"
		] == 2 then
			player:msg(
				0,
				"Imperial Courtier: *choking* Others know.....",
				player.ID
			)
		end
		if player:getDuration("poisoned_bracelet_spell") == 5000 and player.registry[
			"poisoned_bracelet"
		] == 2 then
			player:talk(
				0,
				"" .. player.name .. ": Poor guy must have had too much to drink, I shall fetch more water."
			)
		end
	end,
	uncast = function(player)
		player:warp(2534, 40, 70)
		if player.registry["poisoned_bracelet"] == 1 then
			player:sendMinitext("You quickly make your escape without being seen.")
		end
		if player.registry["poisoned_bracelet"] == 2 then
			local handwritten_note = {
				graphic = Item("handwritten_note").icon,
				color = Item("poisoned_bracelet").iconC
			}
			player.registry["spy_assassination"] = player.registry[
				"spy_assassination"
			] + 1
			player:removeLegendbyName("spy_assassination")
			player:addLegend(
				"Assassinated " .. player.registry["spy_assassination"] .. " targets",
				"spy_assassination",
				22,
				128
			)
			player.quest["spy_trials"] = 7
			player:addItem("handwritten_note", 1)
			player:dialogSeq(
				{
					handwritten_note,
					"** A handwritten-note appears in your pocket **"
				},
				0
			)
		end
		player.registry["poisoned_bracelet"] = 0
	end
}
