barbarian_brew = {
	use = function(player)
		if not player:canAction(1, 1, 1) then
			return
		end
		if player.state == 1 then
			player:sendMinitext("Spirits can't do that.")
			return
		end

		stagger.cast(player)

		player:removeItem("barbarian_brew", 1, 6)
	end
}
