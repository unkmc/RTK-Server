restore_poet = {
	cast = function(player, target)
		local magic = 1000
		local amount = math.ceil(player.magic * 1.5)
		if (not player:canCast(1, 1, 0)) then
			return
		end
		if (player.magic < magic) then
			player:sendMinitext("You do not have enough mana.")
			return
		end
		target.attacker = player.ID
		target:addHealthExtend(amount, 0, 0, 0, 0, 0)
		player.magic = math.ceil(player.magic * (2 / 3))
		player:setAether("restore_poet", 10000)
		target:playSound(4)
		target:sendAnimation(5)
		target:sendStatus()
		player:sendStatus()
		player:sendAction(6, 35)
		player:sendMinitext("You cast Restore.")
	end,
	requirements = function(player)
		local level = 99
		local items = {}
		local itemAmounts = {}
		local description = "Heals a target for 150% caster mana, removes 1/3 of caster mana."
		return level, items, itemAmounts, description
	end
}
