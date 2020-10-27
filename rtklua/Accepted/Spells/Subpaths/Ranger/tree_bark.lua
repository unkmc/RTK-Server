tree_bark = {
	-- Exactly same spell as Chongun Invincibility (harden body) but this one has longer duration but long aethers. Also has a higher fail rate (just keeping the same for now).
	cast = function(player)
		local duration = 12000

		-- 12s duration
		local aether = 300000

		-- 300s aethers
		local magicCost = 1500

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:checkIfCast(hardBodies) then
			player:sendMinitext("You already cast that spell.")
			return
		end

		local armor = 0

		if player.armor < -80 then
			armor = -80
		elseif player.armor > 70 then
			armor = 70
		else
			armor = player.armor
		end

		player:sendAction(6, 20)
		player.magic = player.magic - magicCost
		player:sendStatus()

		local successRate = (140 + armor) / 2

		local random = math.random(1, 100)

		if random < successRate then
			player:sendMinitext("Something went wrong.")
			return
		end

		player:playSound(5)
		player:sendMinitext("Harden body spell")
		player:sendMinitext("You cast Tree bark.")
		player:setDuration("tree_bark", duration)
		player:setAether("tree_bark", aether)

		player:sendAnimation(11, 3)
	end,

	uncast = function(player)
		player:sendMinitext("Your skin turns back to flesh.")
	end,

	requirements = function(player)
		local level = 99
		local items = {"moon_helm", "tigers_heart", "charm"}
		local itemAmounts = {1, 20, 1}
		local desc = "Makes you invincible briefly."
		return level, items, itemAmounts, desc
	end
}
