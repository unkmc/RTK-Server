call_companion = {
	cast = async(function(player)
		local t = {graphic = 0, color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local magicCost = 2000
		local aethers = 420000

		-- 420s

		if player.gmLevel ~= 0 then
			aethers = 0
			magicCost = 0
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 25)
		player:playSound(22)
		player:sendMinitext("You cast Call companion.")

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("call_companion", aethers)

		local opts = {
			"Red wolf",
			"Green squirrel",
			"Black lobster",
			"Rabbit",
			"Fox",
			"Bear",
			"Tiger"
		}

		local choice = player:menuString(
			"Which creature do you wish to call?",
			opts
		)

		if choice == "Red wolf" then
			mobID = 708
		elseif choice == "Green squirrel" then
			mobID = 709
		elseif choice == "Black lobster" then
			mobID = 710
		elseif choice == "Rabbit" then
			mobID = 711
		elseif choice == "Fox" then
			mobID = 712
		elseif choice == "Bear" then
			mobID = 713
		elseif choice == "Tiger" then
			mobID = 714
		end

		cotw_SpawnSetThreat(player, mobID, 600)
	end),

	uncast = function(player)
	end,
	requirements = function(player)
		local level = 99
		local items = {"earth_scale_mail", "boiled_meat", 0}
		local itemAmounts = {1, 1, 10000}
		local description = "Bring a troop from the ranks."
		return level, items, itemAmounts, description
	end
}
