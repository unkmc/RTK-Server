follow = {
	cast = function(player, target)
		target:setDuration("follow", 60000, player.ID)
		player:sendMinitext("You force " .. target.name .. " to follow you.")
		target:sendMinitext("" .. player.name .. " has forced you to follow them.")
	end,

	while_cast = function(player, caster)
		local m, x, y = caster.m, caster.x, caster.y

		if caster.side == 0 then
			y = y + 1
		elseif caster.side == 1 then
			x = x - 1
		elseif caster.side == 2 then
			y = y - 1
		elseif caster.side == 3 then
			x = x + 1
		end

		player:warp(m, x, y)
	end,

	uncast = function(player, caster)
		--player:talk(0,""..caster.name)
		--caster:sendMinitext(""..player.name.." stops following you.")
	end
}
