inspire_valor = {
	cast = function(player)
		local magic = 1000
		local duration = 112000
		local aether = 25000

		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("Your will is too weak.")
			return
		end
		player.magic = player.magic - magic
		player:sendStatus()

		player:sendAction(6, 30)
		player:setAether("inspire_valor", aether)

		player:sendMinitext("You cast Inspire valor.")

		local targets = player:getObjectsInArea(BL_PC)

		for i = 1, #targets do
			if distanceSquare(player, targets[i], 10) then
				if targets[i].ID ~= player.ID then
					targets[i]:removeDuras(mights)
					targets[i]:setDuration("inspire_valor", duration)
					targets[i]:sendAnimation(11, 30)
					targets[i]:sendMinitext(player.name .. " cast Inspire valor on you.")
					targets[i]:calcStat()
				end
			end
		end

		player:playSound(12)
	end,

	recast = function(block)
		block.might = might.might + 3
		block:sendStatus()
	end,

	uncast = function(block)
		block.might = block.might - 3
		block:sendStatus()
	end,

	requirements = function(player)
		local level = 99
		local items = {"lean_beef", "electra", 0}
		local itemAmounts = {10, 10, 15000}
		local description = "Raise morale of all about you."
		return level, items, itemAmounts, description
	end
}
