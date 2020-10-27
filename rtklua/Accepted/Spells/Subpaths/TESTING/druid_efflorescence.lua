efflorescence = {
	on_spawn = function(mob)
		local pc = mob:getObjectsInCell(mob.m, mob.x, mob.y, BL_PC)
		if pc ~= nil then
			mob.owner = pc[1].ID
		end
		local owner = mob:getBlock(mob.owner)

		local check = mob:getObjectsInSameMap(BL_MOB)
		if #check > 0 then
			for z = 1, #check do
				if check[z].name == "Efflorescence" and check[z].owner == owner.ID and mob.ID ~= check[
					z
				].ID then
					check[z]:removeHealth(100)
				end
			end
		end

		if owner.side == 0 then
			mob:warp(mob.m, mob.x, mob.y - 1)
		end
		if owner.side == 1 then
			mob:warp(mob.m, mob.x + 1, mob.y)
		end
		if owner.side == 2 then
			mob:warp(mob.m, mob.x, mob.y + 1)
		end
		if owner.side == 3 then
			mob:warp(mob.m, mob.x - 1, mob.y)
		end
	end,
	on_healed = function(mob, healer)
	end,
	on_attacked = function(mob, attacker)
		if mob.pvp > 0 then
			mob:removeHealth(1)
		end
	end,

	move = function(mob, target)
		efflorescence.moveOrAttack(mob)
	end,

	attack = function(mob, target)
		efflorescence.moveOrAttack(mob)
	end,
	moveOrAttack = function(mob)
		mob.registry["timer"] = mob.registry["timer"] + 1
		if mob.registry["timer"] >= 20 then
			mob:removeHealth(100)
		end
		local owner = mob:getBlock(mob.owner)
		if owner.magic > owner.baseMagic *.01 then
			owner.magic = owner.magic - (owner.baseMagic *.01)
		else
			owner:sendMinitext("Your magic is too low.")
			return
		end
		local base = 500
		if owner.level == 99 then
			base = 2500
			if owner.mark == 1 then
				base = 5000
			elseif owner.mark == 2 then
				base = 10000
			elseif owner.mark == 3 then
				base = 25000
			end
		end
		for x = -2, 2 do
			for y = -2, 2 do
				local pc = mob:getObjectsInCell(
					mob.m,
					mob.x - x,
					mob.y - y,
					BL_PC
				)
				if #pc > 0 then
					local amount = math.ceil(base + (owner.maxMagic *.01671263278317))
					pc[1]:sendAnimation(133)
					pc[1].attacker = mob.owner
					pc[1]:addHealthExtend(amount, 0, 0, 0, 0, 0)
					pc[1]:sendStatus()
				end
			end
		end
		if owner.m ~= mob.m or owner.state == 1 then
			mob:removeHealth(100)
		end
		owner:sendStatus()
	end
}
