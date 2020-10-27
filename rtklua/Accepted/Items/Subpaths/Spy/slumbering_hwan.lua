slumbering_hwan = {
	use = function(player)
		if player.m == 3519 and player.x == 12 and player.y == 13 then
			player.quest["spy_trials"] = 12
			player:removeItem("slumbering_hwan", 1)
			player:setTimer(2, 0)
			player:setDuration("hwan_spell", 0)
			player:freeAsync()
			hwan.interrogate(player)
		else
			player:sendMinitext("This does not look like a suitable place for an interrogation.")
		end
	end
}
