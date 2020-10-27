chance_rogue = {
	cast = function(player)
		local magicCost = 1000
		local aether = 62000
		local duration = 19000

		if player.gmLevel > 0 then
			aether = 0
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.registry["chanceX"] == 0 then
			player.registry["chanceX"] = player.x
			player.registry["chanceY"] = player.y
		end
		player.registry["chanceGoldAmount"] = 0
		player:sendAction(6, 35)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Chance.")
		player:setAether("chance_rogue", 62000)
	end,

	while_cast = function(player)
		local remaining = player:getDuration("chance_rogue")
		if remaining >= 9000 then
			-- 10 seconds elasped
			local magicCost = 200
			if player.magic < magicCost then
				player:setDuration("chance_rogue", 0)
			else
				player.magic = player.magic - magicCost
				player:sendStatus()
			end
		end
	end,

	uncast = function(player)
		player.registry["chanceX"] = 0
		player.registry["chanceY"] = 0
		player.registry["chanceGoldAmount"] = 0
	end,

	after_drop_gold_while_aether = function(player)
		local goldAmount = 0
		local groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if player:canLoot(groundItems[i]) and groundItems[i].id <= 3 then
					-- gold
					goldAmount = goldAmount + groundItems[i].amount
				end
			end
		else
			return
		end

		player.registry["chanceGoldAmount"] = player.registry[
			"chanceGoldAmount"
		] + goldAmount

		if player.registry["chanceGoldAmount"] >= 170 then
			local rand = math.random(1, 100)
			if (rand > 45) then
				invoke.cast(player)
			else
				dishearten.cast(player, player)
			end
			player.registry["chanceX"] = 0
			player.registry["chanceY"] = 0
		end
		if player.registry["chanceGoldAmount"] == 170 then
			groundItems[1]:delete()
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Take a chance to cast Invoke or Dishearten."
		return level, items, itemAmounts, description
	end
}

randomness_rogue = {
	cast = function(player)
		local magicCost = 1000
		local aether = 62000
		local duration = 19000

		if player.gmLevel > 0 then
			aether = 0
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.registry["chanceX"] == 0 then
			player.registry["chanceX"] = player.x
			player.registry["chanceY"] = player.y
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Randomness.")
		player:setAether("randomness_rogue", 62000)
	end,

	while_cast = function(player)
		local remaining = player:getDuration("randomness_rogue")
		if remaining >= 9000 then
			-- 10 seconds elasped
			local magicCost = 200
			if player.magic < magicCost then
				player:setDuration("randomness_rogue", 0)
			else
				player.magic = player.magic - magicCost
				player:sendStatus()
			end
		end
	end,

	uncast = function(player)
		player.registry["chanceX"] = 0
		player.registry["chanceY"] = 0
		player.registry["chanceGoldAmount"] = 0
	end,

	after_drop_gold_while_aether = function(player)
		local goldAmount = 0
		local groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if player:canLoot(groundItems[i]) and groundItems[i].id <= 3 then
					-- gold
					goldAmount = goldAmount + groundItems[i].amount
				end
			end
		else
			return
		end

		player.registry["chanceGoldAmount"] = player.registry[
			"chanceGoldAmount"
		] + goldAmount

		if player.registry["chanceGoldAmount"] >= 170 then
			local rand = math.random(1, 100)
			if (rand > 45) then
				invoke.cast(player)
			else
				dishearten.cast(player, player)
			end
			player.registry["chanceX"] = 0
			player.registry["chanceY"] = 0
		end
		if player.registry["chanceGoldAmount"] == 170 then
			groundItems[1]:delete()
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Take a chance to cast Invoke or Dishearten."
		return level, items, itemAmounts, description
	end
}

natures_choice_rogue = {
	cast = function(player)
		local magicCost = 1000
		local aether = 62000
		local duration = 19000

		if player.gmLevel > 0 then
			aether = 0
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.registry["chanceX"] == 0 then
			player.registry["chanceX"] = player.x
			player.registry["chanceY"] = player.y
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Nature's choice.")
		player:setAether("natures_choice_rogue", 62000)
	end,

	while_cast = function(player)
		local remaining = player:getDuration("natures_choice_rogue")
		if remaining >= 9000 then
			-- 10 seconds elasped
			local magicCost = 200
			if player.magic < magicCost then
				player:setDuration("natures_choice_rogue", 0)
			else
				player.magic = player.magic - magicCost
				player:sendStatus()
			end
		end
	end,

	uncast = function(player)
		player.registry["chanceX"] = 0
		player.registry["chanceY"] = 0
		player.registry["chanceGoldAmount"] = 0
	end,

	after_drop_gold_while_aether = function(player)
		local goldAmount = 0
		local groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if player:canLoot(groundItems[i]) and groundItems[i].id <= 3 then
					-- gold
					goldAmount = goldAmount + groundItems[i].amount
				end
			end
		else
			return
		end

		player.registry["chanceGoldAmount"] = player.registry[
			"chanceGoldAmount"
		] + goldAmount

		if player.registry["chanceGoldAmount"] >= 170 then
			local rand = math.random(1, 100)
			if (rand > 45) then
				invoke.cast(player)
			else
				dishearten.cast(player, player)
			end
			player.registry["chanceX"] = 0
			player.registry["chanceY"] = 0
		end
		if player.registry["chanceGoldAmount"] == 170 then
			groundItems[1]:delete()
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Take a chance to cast Invoke or Dishearten."
		return level, items, itemAmounts, description
	end
}

trial_by_fire_rogue = {
	cast = function(player)
		local magicCost = 1000
		local aether = 62000
		local duration = 19000

		if player.gmLevel > 0 then
			aether = 0
		end
		if player.magic < magicCost then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.registry["chanceX"] == 0 then
			player.registry["chanceX"] = player.x
			player.registry["chanceY"] = player.y
		end

		player:sendAction(6, 35)
		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Trial by fire.")
		player:setAether("trial_by_fire_rogue", 62000)
	end,

	while_cast = function(player)
		local remaining = player:getDuration("trial_by_fire_rogue")
		if remaining >= 9000 then
			-- 10 seconds elasped
			local magicCost = 200
			if player.magic < magicCost then
				player:setDuration("trial_by_fire_rogue", 0)
			else
				player.magic = player.magic - magicCost
				player:sendStatus()
			end
		end
	end,

	uncast = function(player)
		player.registry["chanceX"] = 0
		player.registry["chanceY"] = 0
		player.registry["chanceGoldAmount"] = 0
	end,

	after_drop_gold_while_aether = function(player)
		local goldAmount = 0
		local groundItems = player:getObjectsInCell(
			player.m,
			player.x,
			player.y,
			BL_ITEM
		)

		if #groundItems > 0 then
			for i = 1, #groundItems do
				if player:canLoot(groundItems[i]) and groundItems[i].id <= 3 then
					-- gold
					goldAmount = goldAmount + groundItems[i].amount
				end
			end
		else
			return
		end

		player.registry["chanceGoldAmount"] = player.registry[
			"chanceGoldAmount"
		] + goldAmount

		if player.registry["chanceGoldAmount"] >= 170 then
			local rand = math.random(1, 100)
			if (rand > 45) then
				invoke.cast(player)
			else
				dishearten.cast(player, player)
			end
			player.registry["chanceX"] = 0
			player.registry["chanceY"] = 0
		end
		if player.registry["chanceGoldAmount"] == 170 then
			groundItems[1]:delete()
		end
	end,

	requirements = function(player)
		local level = 99
		local items = {0}
		local itemAmounts = {200000}
		local description = "Take a chance to cast Invoke or Dishearten."
		return level, items, itemAmounts, description
	end
}
