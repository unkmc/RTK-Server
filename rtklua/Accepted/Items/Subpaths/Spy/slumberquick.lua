slumberquick = {
	use = function(player)
		player:removeItem("slumberquick", 1)
		local targetFacing = getTargetFacing(player, BL_MOB)
		if targetFacing ~= nil then
			if targetFacing.yname == "spy_hwan" then
				targetFacing:delete()
				player:addItem("slumbering_hwan", 1)
				player.quest["spy_trials"] = 11
				player.mapRegistry["hwan"] = os.time()
				hwan_spell.cast(player)
				local potion = {
					graphic = convertGraphic(982, "item"),
					color = 0
				}
				player:dialogSeq(
					{
						potion,
						"** You wait only a moment for him to fall asleep. You need to haul his body towards the interrogation location. Be careful you do not take too long, or else he will wake up!"
					},
					0
				)
			end
		end
	end
}

hwan_spell = {
	cast = function(player)
		player:setDuration("hwan_spell", 240000)
		player:setTimer(2, 240)
	end,
	uncast = function(player)
		if player.quest["spy_trials"] == 11 then
			player:sendMinitext("Hwan escaped!")
			player:removeItem("slumbering_hwan", 1)
		end
	end
}
