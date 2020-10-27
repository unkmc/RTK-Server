employ_troop = {
	cast = async(function(player)
		local t = {graphic = 0, color = 0}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0

		local magicCost = 1000
		local aethers = 600000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 25)
		player:playSound(22)
		player:sendMinitext("You cast Employ troop.")

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:setAether("employ_troop", aethers)

		local opts = {"Scout", "Spearman", "Swordsman"}
		if player.mark >= 2 then
			table.insert(opts, "Master")
		end

		local choice = player:menuString("Summon what?", opts)

		if choice == "Scout" then
			mobID = 699
		elseif choice == "Spearman" then
			mobID = 700
		elseif choice == "Swordsman" then
			mobID = 701
		elseif choice == "Master" then
			mobID = 702
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
