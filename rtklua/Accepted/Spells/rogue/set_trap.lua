set_trap = {
	cast = function(player)
		if not player:canCast(1, 1, 0) then
			return
		end

		local q = string.lower(player.question)
		local level = player.level

		local traps = {
			"Dart",
			"Snare",
			"Repeating dart",
			"Flash",
			"Spear",
			"Poison",
			"Death",
			"Sleep"
		}
		local levelreq = {26, 33, 44, 55, 66, 77, 88, 99}

		if q == "dart" and level >= 26 then
			set_dart_trap.cast(player)
		elseif q == "snare" and level >= 33 then
			set_snare_trap.cast(player)
		elseif q == "repeating" and level >= 44 then
			set_repeating_dart_trap.cast(player)
		elseif q == "flash" and level >= 55 then
			set_flash_trap.cast(player)
		elseif q == "spear" and level >= 66 then
			set_spear_trap.cast(player)
		elseif q == "poison" and level >= 77 then
			set_poison_trap.cast(player)
		elseif q == "death" and level >= 88 then
			set_death_trap.cast(player)
		elseif q == "sleep" and level >= 99 then
			set_sleep_trap.cast(player)
		else
			player:sendMinitext("Select:")
			for i = 1, #traps do
				if player.level >= levelreq[i] then
					if i ~= 3 then
						player:sendMinitext(traps[i] .. " trap")
					else
						player:sendMinitext(traps[i])
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 26
		local items = {"fine_rabbit_meat", 0}
		local itemAmounts = {2, 500}
		local description = "Allows you to set a trap of your choice as long as you meet the level requirements for the particular trap, beginning with Dart trap."
		return level, items, itemAmounts, description
	end
}
