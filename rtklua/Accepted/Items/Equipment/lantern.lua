lantern = {
	onEquip = function(player)
		player:sendMinitext("Your lantern burns brightly.")
	end,

	while_equipped = function(player)
		if (os.time() % 30 == 0) then
			--60 seconds
			player:deductDura(EQ_SHIELD, math.random(5, 10))
		end
	end
}
