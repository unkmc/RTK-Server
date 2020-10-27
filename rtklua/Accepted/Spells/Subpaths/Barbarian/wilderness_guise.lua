wilderness_guise = {
	cast = async(function(player)
		local magicCost = 30
		local duration = 1000

		if not player:canCast(1, 1, 0) then
			return
		end
		if player:hasDuration("wilderness_guise") then
			player:sendMinitext("Spell already cast.")
			return
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:setDuration("wilderness_guise", duration)

		player.npcGraphic = 0
		player.npcColor = 0
		player.dialogType = 0
		player.lastClick = player.ID

		local disguise = 0

		local opts = {"Wolf", "Rabbit", "Deer", "Sheep", "Thirsty ogre"}
		local choice = player:menuString(
			"Which guise would you like to use?",
			opts
		)

		if choice ~= nil then
			player:removeDuras(morphs)
			choice = string.lower(string.gsub(choice, " ", "_"))
			player:setDuration(choice .. "_guise", 300000)
			player:calcStat()
		end
	end),

	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Transform."
		return level, items, itemAmounts, description
	end
}

wolf_guise = {
	recast = function(player)
		local disguise = 23

		player:sendAnimation(3, 25)
		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end
}

rabbit_guise = {
	recast = function(player)
		local disguise = 21

		player:sendAnimation(3, 25)
		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end
}

deer_guise = {
	recast = function(player)
		local disguise = 89

		player:sendAnimation(3, 25)
		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end
}

sheep_guise = {
	recast = function(player)
		local disguise = 173

		player:sendAnimation(3, 25)
		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end
}

thirsty_ogre_guise = {
	recast = function(player)
		local disguise = 185

		player:sendAnimation(3, 25)
		player.disguise = disguise
		player.disguiseColor = player.armorColor
		player.state = 4
		player:updateState()
	end,

	uncast = function(player)
		if player.state ~= 1 then
			player.state = 0
			player:updateState()
		end

		player.disguise = 0
		player.disguiseColor = 0
	end
}
