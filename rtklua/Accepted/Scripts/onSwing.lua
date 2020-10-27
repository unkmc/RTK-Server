onSwing = function(player)
	elixir.shoot(player)

	if player.m == 44175 then
		if rabbit_invasion_queue[1] == player.name and player.registry["rabbit_invasion"] == 1 then
			RabbitInvasionNpc.shoot(player)
		end
	end

	if player.m == 15050 then
		BomberWarNpc.bomb(player)
	elseif player.m == 15030 then
		if player.registry["sumo_war_team"] > 0 and player.gfxWeap == 65535 then
			SumoWarNpc.push(player)
		end
		return
	elseif player.m == 15020 then
		if player.registry["beach_war_team"] > 0 and player.gfxWeap == 20109 then
			BeachWarNpc.shoot(player)
		end
		return
	end
end
