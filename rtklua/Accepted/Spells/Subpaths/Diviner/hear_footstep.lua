hear_footstep_diviner = {
	cast = function(player)
		local magic = 0
		local duration = 32000
		local aethers = 60000

		if (not player:canCast(1, 0, 0)) then
			-- dead
			return
		end

		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magic
		player:sendStatus()
		player:sendAnimation(11, 5)
		player:setDuration("hear_footstep_diviner", duration)
		player:setAether("hear_footstep_diviner", aethers)
		player:sendMinitext("You cast Hear footstep.")
	end,
	while_cast = function(player)
		if os.time() % 5 == 0 then
			-- every 5 seconds
			local pcs = player:getObjectsInSameMap(BL_PC)

			for i = 1, #pcs do
				if pcs[i].state == 2 and distanceSquare(player, pcs[i], 4) and pcs[i].ID ~= player.ID then
					-- invis and within 4 tiles
					player:sendMinitext(pcs[i].name .. " is hidden in the area.")
				end
			end
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"fox_tail", "topaz"}
		local itemAmounts = {1, 1}
		local description = "Increases your weapon damage 9 times. Caster becomes invisible to everyone except group members. Spell uncast by hitting something or picking up items."
		return level, items, itemAmounts, description
	end
}
