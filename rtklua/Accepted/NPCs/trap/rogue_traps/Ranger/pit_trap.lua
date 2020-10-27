pit_trap = {
	click = function(block, npc)
		local owner = Player(npc.owner)

		--local damage = 58883 -- did 58883 at 0 AC.   Caster's health was 58k, mana was 32,231.  Target's health was around 130k base.
		-- changing this so it scales with vita and mana rather than static to match the method for spy assassinate
		local damage = (owner.maxHealth *.5) + (owner.maxMagic *.5)
		damage = calculateDamage(block, damage)

		if (block.blType == BL_PC) then
			-- Carnage etc.
			if block.state == 1 then
				return
			end
			if not block:canPK(block) then
				return
			end
			block:sendMinitext("CHOMP!")
		end

		if (block.health < damage and block.health > 1) then
			damage = block.health - 1
		elseif (block.health == 1) then
			damage = 0
		end

		block.attacker = npc.owner
		block:removeHealth(damage)
		block:sendAnimation(44)

		-- big teeth

		--local playa = block:getBlock(npc.owner)
		removeTrapItem(npc)
		npc:delete()
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
