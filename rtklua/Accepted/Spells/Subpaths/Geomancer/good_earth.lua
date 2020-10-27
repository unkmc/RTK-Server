good_earth = {
	cast = function(player)
		--14
		local duration = 125000
		local aethers = 125000

		if player.gmLevel > 0 then
			aethers = 0
		end

		local manaCost = 100

		if not player:canCast(1, 1, 0) then
			return
		end
		if player.magic < manaCost then
			player:sendMinitext("Your will is too weak.")
			return
		end
		good_earth.setASVTraps(player)
		player:setAether("good_earth", aethers)
		player:setDuration("good_earth", duration)
	end,

	while_cast_1500 = function(player)
		local manaCost = 100

		local duration = player:getDuration("good_earth")

		if duration >= 90000 then
			if player.magic < manaCost then
				player:sendMinitext("Your will is too weak.")
				player:setDuration("good_earth", 0)
				return
			end
			player.magic = player.magic - 100
			player:sendStatus()
		end
	end,

	setASVTraps = function(player)
		local m = player.m

		for x = player.x - 1, player.x + 1 do
			for y = player.y - 1, player.y + 1 do
				if x > 0 and y > 0 and x < getMapXMax(m) and y < getMapYMax(m) then
					local npc = player:getObjectsInCell(m, x, y, BL_NPC)
					local passCheck = getPass(m, x, y)
					local objCheck = getObject(m, x, y)

					if #npc == 0 and passCheck == 0 and objCheck == 0 then
						-- empty good tile
						player:addNPC(
							"GoodEarthAsvTrapNpc",
							m,
							x,
							y,
							2,
							1000,
							20000
						)

						-- adds trap with 20s duration
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {Item("surge").id, Item("ju_jak_key").id, 0}
		local itemAmounts = {1, 1, 50000}
		local description = "Empower your mind."
		return level, items, itemAmounts, description
	end
}

GoodEarthAsvTrapNpc = {
	click = function(player)
		player:sendAnimation(18, 500)
		player:sendMinitext("It is peaceful here.")
		sanctuary.cast(player)
		harden_armor.cast(player)
		valor.cast(player)
	end,

	endAction = function(npc, owner)
		npc:delete()
	end
}
