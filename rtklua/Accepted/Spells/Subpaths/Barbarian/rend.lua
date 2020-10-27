rend = {
	cast = function(player)
		local aethers = 87000

		-- 87 seconds seconds

		if player.gmLevel > 0 then
			aethers = 0
		end

		local magicCost = 3100

		if (not player:canCast(0, 1, 0)) then
			return
		end

		local damage = math.ceil(player.health * 2) + math.ceil(player.magic * 2)

		--player.health = 1
		player.health = player.maxHealth *.05

		-- changing this to 5%, it is still very dangerous
		player.magic = 0

		player:setAether("rend", aethers)
		player:sendAction(1, 30)

		player:talk(2, "Rraah~!")

		local target = getTargetFacing(player, BL_ALL)

		if target ~= nil then
			target.attacker = player.ID
			target:sendAnimation(31)

			if target.blType == BL_MOB then
				target.attacker = player.ID
				target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			elseif target.blType == BL_PC and player:canPK(target) then
				target.attacker = player.ID
				target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
				target:sendStatus()
				target:playSound(30)
				target:sendMinitext(player.name .. " cast Rend on you.")
			end
		end

		player:sendStatus()
		player:sendMinitext("You cast Rend.")
		player:sendMinitext("You can not touch the spirit world.")
	end,

	requirements = function(player)
		local l = 99
		local i = {
			Item("angels_tear").id,
			Item("dark_amber").id,
			Item("electra").id,
			0
		}
		local ia = {1, 20, 1, 10000}
		local d = "A massive attack that deals critical damage to an enemy."
		return l, i, ia, d
	end
}
