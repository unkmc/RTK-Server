leviathan = {
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		local t = {
			graphic = convertGraphic(mob.look, "monster"),
			color = mob.lookColor
		}
		attacker.npcGraphic = t.graphic
		attacker.npcColor = t.color
		attacker.dialogType = 0
		attacker.lastClick = mob.ID

		if not attacker:hasLegend("leviathan_sworn_enemy") and not attacker:hasLegend("leviathan_freed") then
			if attacker.quest["leviathan"] ~= 0 then
				-- on lev quest
				attacker:addLegend(
					"Sworn enemy of the Leviathans (" .. curT() .. ")",
					"leviathan_sworn_enemy",
					7,
					4
				)
				attacker:dialogSeq(
					{
						t,
						"You promised to not attack us! You are now a sworn enemy of the Leviathan."
					},
					0
				)
			end
		end

		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob)
		mob_ai_basic.after_death(mob)
	end
}
