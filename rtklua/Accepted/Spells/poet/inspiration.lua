inspiration_poet = {
	cast = function(player, target)
		local inGroup = false

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		for i = 1, #player.group do
			if target.ID == player.group[i] then
				inGroup = true
				break
			end
		end

		if inGroup == true then
			local mana = target.magic
			target.magic = 0
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Inspiration on you.")

			player.magic = player.magic + mana
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Inspiration.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 35
		local items = {"purple_ring", 0}
		local itemAmounts = {1, 1000}
		local description = "Takes mana away from group member and adds it to the caster."
		return level, items, itemAmounts, description
	end
}
draw_energy_poet = {
	cast = function(player, target)
		local inGroup = false

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		for i = 1, #player.group do
			if target.ID == player.group[i] then
				inGroup = true
				break
			end
		end

		if inGroup == true then
			local mana = target.magic
			target.magic = 0
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Draw Energy on you.")

			player.magic = player.magic + mana
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Draw Energy.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 35
		local items = {"purple_ring", 0}
		local itemAmounts = {1, 1000}
		local description = "Takes mana away from group member and adds it to the caster."
		return level, items, itemAmounts, description
	end
}
harness_power_poet = {
	cast = function(player, target)
		local inGroup = false

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		for i = 1, #player.group do
			if target.ID == player.group[i] then
				inGroup = true
				break
			end
		end

		if inGroup == true then
			local mana = target.magic
			target.magic = 0
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Harness Power on you.")

			player.magic = player.magic + mana
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Harness Power.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 35
		local items = {"purple_ring", 0}
		local itemAmounts = {1, 1000}
		local description = "Takes mana away from group member and adds it to the caster."
		return level, items, itemAmounts, description
	end
}
combine_focus_poet = {
	cast = function(player, target)
		local inGroup = false

		if not player:canCast(1, 1, 0) then
			return
		end

		if (target.state == 1) then
			player:sendMinitext("That cannot save them now.")
			return
		end

		for i = 1, #player.group do
			if target.ID == player.group[i] then
				inGroup = true
				break
			end
		end

		if inGroup == true then
			local mana = target.magic
			target.magic = 0
			target:sendStatus()
			target:sendMinitext(player.name .. " casts Combine Focus on you.")

			player.magic = player.magic + mana
			player:sendAction(6, 20)
			player:playSound(22)
			player:sendMinitext("You cast Combine Focus.")
			player:sendStatus()
		end
	end,

	requirements = function(player)
		local level = 35
		local items = {"purple_ring", 0}
		local itemAmounts = {1, 1000}
		local description = "Takes mana away from group member and adds it to the caster."
		return level, items, itemAmounts, description
	end
}
