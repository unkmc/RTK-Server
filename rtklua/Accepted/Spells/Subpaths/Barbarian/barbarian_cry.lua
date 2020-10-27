barbarian_cry = {
	cast = function(player)
		local aethers = 1200000

		-- that's right, 1200 seconds

		if player.gmLevel > 0 then
			aethers = 0
		end

		local magicCost = 3100

		if (not player:canCast(0, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("You do not have enough mana.")
			return
		end

		local damage = math.ceil(player.health * 3)
		player.health = math.ceil(player.health * 0.33)
		player.magic = player.magic - magicCost

		player:setAether("barbarian_cry", aethers)
		player:sendAction(1, 30)

		player:talk(2, "TOWNIE~~!")

		local targetpc = getTargetFacing(player, BL_PC)
		local targetmob = getTargetFacing(player, BL_MOB)

		if targetpc ~= nil and player:canPK(targetpc) then
			global_zap.cast(player, targetpc, damage, 0, 0)
		end
		if targetmob ~= nil then
			global_zap.cast(player, targetmob, damage, 0, 0)
		end

		player:sendStatus()
		player:sendMinitext("You cast Townie.")
		player:sendMinitext("You can not touch the spirit world.")
		player:sendMinitext("You cast Barbarian cry.")
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
