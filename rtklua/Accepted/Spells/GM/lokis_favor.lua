lokis_favor = {
	cast = function(player)
		if (not player:hasDuration("lokis_favor")) then
			player:setDuration("lokis_favor", 9999999)
		else
			player:setDuration("lokis_favor", 1)
		end
	end,
	while_cast_500 = function(player)
		player:swing()
		player:swing()
		if (not player:hasDuration("flank_warrior")) then
			flank_warrior.cast(player)
		end
		if (not player:hasDuration("backstab_warrior")) then
			backstab_warrior.cast(player)
		end
		if (not player:hasDuration("potence_warrior")) then
			potence_warrior.cast(player)
		end
		if (not player:hasDuration("bless_warrior")) then
			bless_warrior.cast(player)
		end
		if (not player:hasAether("chung_ryongs_rage")) then
			if (player:getDuration("chung_ryongs_rage") > 125000 or player:getDuration("chung_ryongs_rage") == 0) then
				chung_ryongs_rage.cast(player)
			end
		end
	end,
	uncast = function(player)
	end
}
