son_kal = {
	--poet vita attack
	--Monk stats equipped,  89 M, 98 G, 149 W.   13708 vita, ~13k mana
	cast = function(player)
		--local aethers = 50000 -- 50s
		local aethers = 10000

		-- changed to help balance with other paths and give monks some "hybrid" utility, aethers are low enough to matter, but not too high they will just be solo machines
		local anim = 7
		if player.gmLevel > 0 then
			aethers = 0
		end

		local magicCost = 1000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		-- edited 5/3 to add scaling to this spell
		-- needs to scale in damage so monks have something special
		local damage = 1250 + math.ceil(player.health * 0.1) -- does 10% vita
		player.health = math.ceil(player.health * 0.9)

		-- takes 10% vita
		player.magic = player.magic - magicCost

		player:setAether("son_kal", aethers)
		player:sendAction(1, 30)

		player:talk(2, "Son-Kal~!")

		local targetpc = getTargetFacing(player, BL_PC)
		local targetmob = getTargetFacing(player, BL_MOB)

		if targetpc ~= nil and player:canPK(targetpc) then
			targetpc:sendAnimation(anim, 30)
			targetpc:playSound(14)
			targetpc.attacker = player.ID
			targetpc:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			targetpc:sendStatus()
		end

		if targetmob ~= nil then
			local threat = threat.getHighestThreat(targetmob)
			player:setThreat(targetmob.ID, threat + damage)
			targetmob:sendAnimation(anim, 30)
			targetmob:playSound(14)
			targetmob.attacker = player.ID
			targetmob:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			targetmob:sendStatus()
		end

		player:sendStatus()
		player:sendMinitext("You cast Son-Kal.")
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
