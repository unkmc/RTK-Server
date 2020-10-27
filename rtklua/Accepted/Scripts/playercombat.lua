player_combat = {
	on_healed = function(player, healer)
		if (player.gfxDye == attacker.gfxDye) then
			if (player.m == 33 or player.m == 3011 or player.m == 3017) then
				healer.damage = 1
			end
		end

		player.attacker = healer.ID
		player:sendHealth(healer.damage, healer.critChance)
	end,

	on_attacked = function(player, attacker)
		if (player.gfxDye == attacker.gfxDye) then
			if (player.m == 33 or player.m == 3011 or player.m == 3017) then
				attacker.damage = 1
			end
		end

		player:playSound(1)
		player.attacker = attacker.ID
		player:sendHealth(attacker.damage, attacker.critChance)
	end
}

mob_combat = {
	on_healed = function(mob, healer)
		mob.attacker = healer.ID
		mob:sendHealth(healer.damage, healer.critChance)
	end,

	on_attacked = function(mob, attacker)
		local start = os.time() * 1000 + timeMS()

		mob.attacker = attacker.ID
		mob:sendHealth(attacker.damage, attacker.critChance)
		broadcast(4, "Mob Combat: " .. (os.time() * 1000 + timeMS()) - start)
	end
}
