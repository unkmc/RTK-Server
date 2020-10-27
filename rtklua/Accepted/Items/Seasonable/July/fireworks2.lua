fireworks2 = {
	use = function(player)
		player:addNPC(
			"fireworks2",
			player.m,
			player.x,
			player.y,
			0,
			11,
			3000,
			player.ID,
			"Fireworks 2"
		)
	end,

	action = function(block, owner)
		local anim = 337

		--387
		local x, y = block.x, block.y
		local reg = block.registry["anim"]

		if reg >= 11 then
			block.registry["anim"] = 0
		else
			if reg == 0 then
				block:sendAnimationXY(anim, x, y - 1)
				block.registry["anim"] = 1
			end
			if reg == 1 then
				block:sendAnimationXY(anim, x - 1, y - 2)
				block:sendAnimationXY(anim, x + 1, y - 2)
				block.registry["anim"] = 2
			end
			if reg == 2 then
				block:sendAnimationXY(anim, x - 2, y - 3)
				block:sendAnimationXY(anim, x + 2, y - 3)
				block.registry["anim"] = 3
			end
			if reg == 3 then
				block:sendAnimationXY(anim, x - 3, y - 3)
				block:sendAnimationXY(anim, x + 3, y - 3)
				block.registry["anim"] = 4
			end
			if reg == 4 then
				block:sendAnimationXY(anim, x - 4, y - 2)
				block:sendAnimationXY(anim, x + 4, y - 2)
				block.registry["anim"] = 5
			end

			if reg == 5 then
				block:sendAnimationXY(anim, x - 4, y - 1)
				block:sendAnimationXY(anim, x + 4, y - 1)
				block.registry["anim"] = 6
			end
			if reg == 6 then
				block:sendAnimationXY(anim, x - 4, y)
				block:sendAnimationXY(anim, x + 4, y)
				block.registry["anim"] = 7
			end
			if reg == 7 then
				block:sendAnimationXY(anim, x - 3, y + 1)
				block:sendAnimationXY(anim, x + 3, y + 1)
				block.registry["anim"] = 8
			end
			if reg == 8 then
				block:sendAnimationXY(anim, x - 2, y + 2)
				block:sendAnimationXY(anim, x + 2, y + 2)
				block.registry["anim"] = 9
			end
			if reg == 9 then
				block:sendAnimationXY(anim, x - 1, y + 3)
				block:sendAnimationXY(anim, x + 1, y + 3)
				block.registry["anim"] = 10
			end
			if reg == 10 then
				block:sendAnimationXY(anim, x, y + 4)
				block.registry["anim"] = 11
			end
		end
	end,

	endAction = function(block)
		block:delete()
	end
}

an = function(block, id, x, y)
	block:sendAnimationXY(id, x, y)
end
