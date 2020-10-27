survive = {
	cast = function(player)
		local heal = 1000
		local magicCost = 600
		local aether = 5000
		local distance = 3

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		if player:hasAether("survive") then
			return
		end

		player:sendAction(6, 20)
		player:playSound(22)
		player:setAether("survive", aether)
		player:sendMinitext("You cast Survive.")
		player.magic = player.magic - magicCost
		player:sendStatus()

		for i = 1, #player.group do
			local target = Player(player.group[i])

			if distanceSquare(player, target, distance) then
				target.attacker = player.ID
				target:sendAnimation(5, 0)
				target:addHealthExtend(heal, 0, 0, 0, 0, 0)
				target:sendMinitext(player.name .. " casts Survive on you.")
			end
		end
	end,

	requirements = function(player)
		local level = 60
		local items = {"mountain_ginseng", "pearl_charm"}
		local itemAmounts = {10, 1}
		local description = "a healing spell that heals group members surrounding you for 100 vita"
		return level, items, itemAmounts, description
	end
}
