assassinate = {
	cast = function(player)
		-- notes: only takes vita if there is a valid target, always takes the mana no matter what.    It also does the graphic, no matter what.
		local aethers = 50000

		-- 50s
		local anim = 31

		local talktype = 0

		local magicCost = 4000

		if (not player:canCast(1, 1, 0)) then
			return
		end

		if player.gmLevel > 0 then
			aethers = 0
			magicCost = 0
		end

		if (player.magic < magicCost) then
			player:sendMinitext("Your will is too weak.")
			return
		end

		local damage = math.ceil((player.health * 0.25) + (player.magic * 1.25))

		-- non critical
		local crit = math.ceil((player.health * 1.25) + (player.magic * 6.25))

		-- critical

		player.magic = player.magic - magicCost
		player:sendStatus()
		player:sendMinitext("You cast Assassinate.")

		player:setAether("assassinate", aethers)
		player:sendAction(1, 30)

		local rand = math.random(1, 100)
		if rand <= 5 then
			damage = crit
			talktype = 1
		end

		-- crits show up as yellow text, not blue

		local targetpc = getTargetFacing(player, BL_PC)
		local targetmob = getTargetFacing(player, BL_MOB)

		if targetpc ~= nil and player:canPK(targetpc) then
			player.health = math.ceil(player.health * (2 / 3))
			player:sendStatus()
			targetpc:sendAnimation(anim, 30)
			targetpc:playSound(14)
			targetpc.attacker = player.ID
			targetpc:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			targetpc:sendStatus()
			targetpc:sendMinitext(player.name .. " attacks you with Assassinate spell.")
			player:talk(talktype, player.name .. ": Ka~~!")
		elseif targetmob ~= nil then
			player.health = math.ceil(player.health * (2 / 3))
			player:sendStatus()
			local threat = threat.getHighestThreat(targetmob)
			player:setThreat(targetmob.ID, threat + damage)
			targetmob:sendAnimation(anim, 30)
			targetmob:playSound(14)
			targetmob.attacker = player.ID
			targetmob:removeHealthExtend(damage, 1, 1, 1, 1, 0)
			targetmob:sendStatus()
			player:talk(talktype, player.name .. ": Ka~~!")
		else
			if player.side == 0 then
				player:sendAnimationXY(anim, player.x, player.y - 1)
			elseif player.side == 1 then
				player:sendAnimationXY(anim, player.x + 1, player.y)
			elseif player.side == 2 then
				player:sendAnimationXY(anim, player.x, player.y + 1)
			elseif player.side == 3 then
				player:sendAnimationXY(anim, player.x - 1, player.y)
			end
		end
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
