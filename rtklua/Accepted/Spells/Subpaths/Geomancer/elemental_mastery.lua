elemental_mastery = {
	cast = async(function(player)
		local magicCost = 2000
		local duration = 120000

		if not player:canCast(1, 1, 0) then
			return
		end
		if player:hasDuration("elemental_mastery") then
			player:sendMinitext("Spell already cast.")
			return
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local disguise = 0

		local opts = {
			"Water manifest",
			"Fire manifest",
			"Earth manifest",
			"Metal manifest",
			"Wood manifest"
		}
		local choice = player:menuString(
			"Which element do you choose to manifest?",
			opts
		)

		if choice == "Water manifest" then
			disguise = 325
		elseif choice == "Fire manifest" then
			disguise = 519
		elseif choice == "Earth manifest" then
			disguise = 186
		elseif choice == "Metal manifest" then
			disguise = 248
		elseif choice == "Wood manifest" then
			disguise = 192
		end

		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()

		player:setDuration("elemental_mastery", duration)
	end),

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}
