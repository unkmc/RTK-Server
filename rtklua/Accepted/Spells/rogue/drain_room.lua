drain_room = {
	cast = function(player)
		local duration = 30000
		local magicCost = 60

		if not player:canCast(1, 1, 0) then
			return
		end

		if player.magic < magicCost then
			return
		end

		local mobs = player:getObjectsInArea(BL_MOB)

		if next(mobs) ~= nil then
			for i = 1, #mobs do
				if mobs[i].maxHealth <= 1000 then
					mobs[i].attacker = player.ID
					mobs[i].healer = player.ID
					mobs[i].registry["to_heal"] = player.ID
					mobs[i]:sendAnimation(39, 5)
					mobs[i]:setDuration("drain_room", duration)
				end
			end
		end
	end,

	while_cast = function(mob)
		local player = Player(mob.registry["to_heal"])

		mob.attacker = player.ID

		local damage = math.random(30, 35)
		mob:sendAnimation(1, 5)
		mob:removeHealthExtend(damage, 0, 0, 0, 0, 0)

		player:sendAnimation(5, 5)
		player:addHealthExtend(damage, 0, 0, 0, 0, 0)
	end,

	requirements = function(player)
		local level = 80
		local item = {}
		local amounts = {}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = "Cast Drain Room to siphon all mob's health if they have less than 1k vita."
		return level, item, amounts, desc
	end
}
