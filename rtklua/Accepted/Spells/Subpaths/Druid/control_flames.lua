control_flames = {
	cast = function(player)
		local duration = 62000
		local aethers = 62000
		local magicCost = 1000

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

		player:setAether("control_flames", aethers)
	end,

	uncast = function(player)
		player.fakeDrop = 0
	end,

	on_drop_while_aether = function(player)
		local damage = 1200
		local magicCost = 800
		local item = player:getInventoryItem(player.invSlot)

		if item.yname == "acorn" then
			player:removeItem(item.yname, 1, 1)
			player.fakeDrop = 1

			if math.random(1, 4) == 1 then
				-- cast

				if player.magic < magicCost then
					player:sendMinitext("Your will is too weak.")
					return
				end

				local targets = getTargetsAround(player, BL_MOB)

				if #targets > 0 then
					for i = 1, #targets do
						targets[i].attacker = player.ID
						targets[i]:removeHealthExtend(damage, 1, 1, 1, 1, 0)
						targets[i]:sendAnimation(45, 25)
					end

					player.magic = player.magic - magicCost
					player:sendStatus()
					player:playSound(708)
					player:playSound(1)
					player:sendMinitext("You cast Wall of flames.")
				end
			end
		else
			player.fakeDrop = 0
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
