natures_bloom = {
	cast = function(player)
		local aethers = 625000
		local magicCost = 200

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		player:sendAction(6, 25)
		player.magic = player.magic - magicCost
		player:sendStatus()

		player:setAether("natures_bloom", aethers)
	end,

	uncast = function(player)
		player.fakeDrop = 0
	end,

	on_drop_while_aether = function(player)
		local item = player:getInventoryItem(player.invSlot)
		local flowers = {
			"daffodil",
			"dawn_tulip",
			"dusk_blossom",
			"fallen_star",
			"golden_sunset",
			"greater_tulip",
			"heavens_bell",
			"lemon_flower",
			"mango_floret",
			"midnights_reign",
			"old_poppy",
			"orange_blossom",
			"pink_mugunghwa",
			"rose",
			"sunflower",
			"winedrop"
		}

		local flower = ""

		for i = 1, #flowers do
			if item.yname == flowers[i] then
				flower = flowers[i]
				break
			end
		end

		if flower ~= "" then
			-- found flower and item name matches
			player:removeItem(item.yname, 1, 1)
			player.fakeDrop = 1
			natures_bloom.spawnFlowers(player, flower)
		else
			player.fakeDrop = 0
		end
	end,

	spawnFlowers = function(player, flower)
		local distance = 4

		player:dropItemXY(flower, 1, 0, 0, player.m, player.x, player.y)
		for y = player.y - distance, player.y + distance do
			for x = player.x - distance, player.x + distance do
				if y < 0 then
					y = 0
				end
				if x < 0 then
					x = 0
				end
				if y > getMapYMax(player.m) then
					y = getMapYMax(player.m)
				end
				if x > getMapXMax(player.m) then
					x = getMapXMax(player.m)
				end

				--local blockCheck = player:getObjectsInCell(player.m,x,y,BL_ALL)
				local objCheck = getObject(player.m, x, y)
				local passCheck = getPass(player.m, x, y)
				local warpCheck = getWarp(player.m, x, y)

				if objCheck == 0 and passCheck == 0 and not warpCheck then
					-- tile is clear
					if math.random(1, 2) == 1 then
						player:dropItemXY(flower, 1, 0, 0, player.m, x, y)
					end
				end
			end
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {"wicked_staff", "antler", 0}
		local itemAmounts = {1, 20, 20000}
		local description = "Erupt flames from the ground to protect you."
		return level, items, itemAmounts, description
	end
}
