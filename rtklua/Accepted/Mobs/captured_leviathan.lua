captured_leviathan = {
	move = function(mob, target)
		mob.side = math.random(0, 3)
		mob:sendSide()
	end,

	attack = function(mob, target)
		--mob_ai_basic.attack(mob, target)
	end,

	on_attacked = function(mob, attacker)
		mob.attacker = attacker.ID
		mob:sendAnimation(301)
		attacker:playSound(353)
		mob_ai_basic.on_attacked(mob, attacker)
	end
}
