sacred_water = {
	on_drop = function(player)
		if player.mapTitle == "Subvoid" and player.quest["nangen_acolyte"] == 2 then
			local mob = getTargetFacing(player, BL_MOB)

			if mob ~= nil then
				if mob.yname == "the_infected" then
					player.quest["destroyed_infected"] = 1

					mob:talk(0, mob.name .. ": NUUUGHHH! I shall be reborn...")
					mob.attacker = player.ID
					mob:removeHealthExtend(mob.maxHealth, 0, 0, 0, 0, 0)
					player:removeItem("sacred_water", 1, 1)
					player.fakeDrop = 1
				end
			end
		end
	end
}
