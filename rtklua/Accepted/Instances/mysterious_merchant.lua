mysterious_merchant = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		--mob.target = 0

		mob.newMove = 500
		mob.state = MOB_ESCAPE

		if (attacker.damage >= mob.health) then
			if math.random(1, 1) == 1 then
				attacker:msg(
					0,
					mob.name .. " spawns a mysterious portal in an attempt to escape death",
					attacker.ID
				)
				mob:addNPC(
					"TreasurePortalNpc",
					mob.m,
					mob.x,
					mob.y,
					2,
					500,
					60000,
					0
				)
			end
		end

		mob_ai_basic.on_attacked(mob, attacker)

		RunAway(mob, attacker)
	end,

	move = function(mob, target)
		--mob_ai_basic.move(mob, target)
		RunAway(mob, target)
	end
}
