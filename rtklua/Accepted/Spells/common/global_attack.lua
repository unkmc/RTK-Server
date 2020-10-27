global_attack = {
	cast = function(player, target, damage, manacost, pcalign)
		local start = os.time() * 1000 + timeMS()
		if (not player:canCast(1, 1, 0)) then
			return 0
		end

		if not distanceSquare(player, target, 10) then
			return 0
		end

		-- maximum 10 tiles away in either direction (verified on NTK)

		if (player.magic < manacost) then
			player:sendMinitext("You do not have enough mana.")
			return 0
		end
		if (target.state == 1) then
			player:sendMinitext("It is already dead.")
			return 0
		end

		--10/11/12 are for the few zaps that are different animations when unaligned
		--but all become the same once alignment is chosen:
		------thunder bolt = 10, spark = 11, singe = 12.
		--13 is for taunt or other spells that play zap sound but no animation.
		if (player.baseClass == 1 and pcalign < 10) then
			pcalign = pcalign + 100
		end
		if (player.baseClass == 2 and pcalign < 10) then
			pcalign = pcalign + 200
		end

		if (pcalign == 0) then -- (__0) unaligned (zap)
			target:playSound(56)
			target:sendAnimation(4)
		elseif (pcalign == 1) then -- (__1) kwi-sin (zap)
			target:playSound(59)
			target:sendAnimation(17)
		elseif (pcalign == 2) then -- (__2) ming-ken (zap)
			target:playSound(57)
			target:sendAnimation(30)
		elseif (pcalign == 3) then -- (__3) ohaeng (zap)
			target:playSound(55)
			target:sendAnimation(4)
		elseif (pcalign == 10) then -- (_10) unaligned: thunder bolt
			target:playSound(55)
			target:sendAnimation(27)
		elseif (pcalign == 11) then -- (_11) unaligned: spark
			target:playSound(55)
			target:sendAnimation(28)
		elseif (pcalign == 12) then -- (_12) unaligned: singe
			target:playSound(55)
			target:sendAnimation(29)
		elseif (pcalign == 13) then -- (_13) zaps w/o animation (taunt)
			target:playSound(58)
		elseif (pcalign == 30) then -- (_30) mage unaligned: hellfire/inferno/doom's fire
			target:playSound(88)
			target:sendAnimation(8)
		elseif (pcalign == 31) then -- (_31) mage kwi-sin: hellfire/inferno/doom's fire
			target:playSound(88)
			target:sendAnimation(54)
		elseif (pcalign == 32) then -- (_32) mage ming-ken: hellfire/inferno/doom's fire
			target:playSound(88)
			target:sendAnimation(104)
		elseif (pcalign == 33) then -- (_33) mage ohaeng: hellfire/inferno/doom's fire
			target:playSound(88)
			target:sendAnimation(112)
		elseif (pcalign == 34) then -- (_34) mage dog: fissure
			target:playSound(88)
			target:sendAnimation(41)
		elseif (pcalign == 35) then -- (_35) mage dog: lava surge
			target:playSound(88)
			target:sendAnimation(42)
		elseif (pcalign == 36) then -- (_36) mage (il san) volcanic blast
			target:playSound(88)
			target:sendAnimation(43)
		elseif (pcalign == 40) then -- (_40) poet unaligned: retribution
			target:playSound(88)
			target:sendAnimation(51)
		elseif (pcalign == 41) then -- (_41) poet kwi-sin: retribution
			target:playSound(88)
			target:sendAnimation(100)
		elseif (pcalign == 42) then -- (_42) poet ming-ken: retribution
			target:playSound(88)
			target:sendAnimation(86)
		elseif (pcalign == 43) then -- (_43) poet ohaeng: retribution
			target:playSound(88)
			target:sendAnimation(114)
		elseif (pcalign == 99) then -- (99) Unaligned LS/WW
			target:playSound(88)
			target:sendAnimation(6)
		elseif (pcalign == 100) then -- (100) Unaligned DA/Berserk
			target:playSound(88)
			target:sendAnimation(9)
		elseif (pcalign == 101) then -- (101) warr kwi-sin: berserk/ww/assault/siege
			target:playSound(14)
			target:sendAnimation(67)
		elseif (pcalign == 102) then -- (102) warr ming-ken: berserk/ww/assault/siege
			target:playSound(87)
			target:sendAnimation(7)
		elseif (pcalign == 103) then -- (103) warr ohaeng: berserk/ww/assault/siege
			target:playSound(87)
			target:sendAnimation(60)
		elseif (pcalign == 104) then -- (104) warr unaligned: slash
			target:playSound(30)
			target:sendAnimation(31)

			-- KaTT made all this pretty damn confusing by making new entries for vitas (below)
			-- without removing the old entries (above). I do not really have the patience
			-- to properly fix all of this at the moment, so for now:
			
			-- Spell (all alignments) --> pcalign
			-- Berserk 			--> 119
			-- Whirlwind 		--> 125
			-- Desperate Attack --> 120
			-- Lethal Strike	--> 201

			-- KaTT Edits
		elseif (pcalign == 119) then -- (UNALIGNED BERSERK)
			target:playSound(14)
			target:sendAnimation(9)
		elseif (pcalign == 120) then -- (UNALIGNED BERSERK)
			target:playSound(88)
			target:sendAnimation(6)
		elseif (pcalign == 121) then -- (OHAENG DA/BERSERK)
			target:playSound(87)
			target:sendAnimation(7)
		elseif (pcalign == 122) then -- (MING DA/BERSERK)
			target:playSound(87)
			target:sendAnimation(32)
		elseif (pcalign == 123) then -- (KWI DA/BERSERK)
			target:playSound(94)
			target:sendAnimation(68)
		elseif (pcalign == 124) then -- (UNALIGNED LS/WW)
			target:playSound(88)
			target:sendAnimation(7)
		elseif (pcalign == 125) then -- (OHAENG LS/WW)
			target:playSound(102)
			target:sendAnimation(60)
		elseif (pcalign == 126) then -- (MING LS/WW)
			target:playSound(88)
			target:sendAnimation(67)
		elseif (pcalign == 127) then -- (KWI LS/WW)
			target:playSound(88)
			target:sendAnimation(69)
		elseif (pcalign == 200) then -- (200) rogue unaligned: DA/LS/FB
			target:playSound(88)
			target:sendAnimation(9)
		elseif (pcalign == 201) then -- (201) rogue kwi-sin: DA/LS/FB
			target:playSound(102)
			target:sendAnimation(67)
		elseif (pcalign == 202) then -- (202) rogue ming-ken: DA/LS/FB
			target:playSound(88)
			target:sendAnimation(32)
		elseif (pcalign == 203) then -- (203) rogue ohaeng: DA/LS/FB
			target:playSound(88)
			target:sendAnimation(68)
		elseif (pcalign == 204) then -- (204) rogue/warrior KWI WW
			target:playSound(88)
			target:sendAnimation(69)
		elseif (pcalign == 251) then -- (251) kwi-sin (zap) [class over-ride]
			target:playSound(59)
			target:sendAnimation(17)
		elseif (pcalign == 252) then -- (252) ming-ken (zap) [class over-ride]
			target:playSound(57)
			target:sendAnimation(30)
		elseif (pcalign == 253) then -- (253) ohaeng (zap) [class over-ride]
			target:playSound(55)
			target:sendAnimation(4)
		elseif (pcalign == 400) then -- (400) dart trap
			target:sendAnimation(12)
		elseif (pcalign == 401) then -- (401) death trap
			target:sendAnimation(44)
		else -- default unaligned zap.
			target:playSound(56)
			target:sendAnimation(4)
		end

		if target.blType == BL_MOB then
			local threat = threat.getHighestThreat(target)
			player:setThreat(target.ID, threat + damage)
		elseif target.blType == BL_PC then
			if (not player:canPK(target)) then
				player:sendMinitext("You cannot attack that target.")
				return 0
			end
		end

		player.magic = player.magic - manacost
		player:sendStatus()
		player:sendAction(6, 35)

		target.attacker = player.ID
		target:removeHealthExtend(damage, 1, 1, 1, 1, 0)
		target:sendStatus()

		if target.id ~= player.id and target.blType == BL_PC then
			return 2
		end
		broadcast(4, "global attack: " .. (os.time() * 1000 + timeMS()) - start)
		return 1
	end
}
