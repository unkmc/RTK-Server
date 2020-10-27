wind_walk = {
	onAction = function(player, action)
		local mob = player:getObjectsInMap(player.m, BL_MOB)

		if #mob > 0 then
			for i = 1, #mob do
				if mob[i].yname == "wind_walk" then
					if mob[i].owner == player.ID then
						mob[i]:sendAction(action, 20)
					end
				end
			end
		end
	end,

	move = function(mob, target)
		local moved = true
		local c1, c2 = math.random(0, 20), math.random(0, 10)

		if (mob.paralyzed == true or mob.sleep ~= 1) then
			return
		end
		threat.calcHighestThreat(mob)

		if target == nil then
			if c1 <= 3 then
				mob.side = c1
				mob:sendSide()
			else
				if c1 < c2 then
					if not mob.snare and not mob.blind then
						moved = mob:move()
					end
				end
			end
			return
		else
			if target.state ~= 1 and target.state ~= 2 then
				if (not mob.snare and not mob.blind) then
					moved = FindCoords(mob, target)
				end
				if mob:moveIntent(target.ID) == 1 then
					mob.state = MOB_HIT
				end
			end
		end
	end,

	attack = function(mob, target)
		local moved = true

		if (mob.paralyzed or mob.sleep ~= 1) then
			return
		end

		if target == nil then
			mob.state = MOB_ALIVE
			return
		else
			threat.calcHighestThreat(mob)
			if target.state ~= 1 and target.state ~= 2 then
				moved = FindCoords(mob, target)
				if mob:moveIntent(target.ID) == 1 then
					mob:attack(target.ID)
				end
			else
				mob.state = MOB_ALIVE
			end
		end
	end,

	on_attacked = function(mob, attacker)
		mob:removeHealth(mob.health)
		mob:playSound(73)
	end,

	before_death = function(mob)
		mob:sendAnimationXY(292, mob.x, mob.y)
	end,

	cast = function(player)
		local same = {}
		local pc = player:getObjectsInMap(player.m, BL_PC)
		local mob = player:getObjectsInMap(player.m, BL_MOB)

		--Player(4):talk(0,""..#mob)
		if #mob > 0 then
			for i = 1, #mob do
				if mob[i].yname == "wind_walk" then
					table.insert(same, mob[i].ID)
				end
			end
		end
		if #same > 20 then
			anim(player)
			player:sendMinitext("Can't over than 20 clones in 1 map")
			return false
		end
		player:spawn("wind_walk", player.x, player.y, 1)
		get = player:getObjectsInCell(player.m, player.x, player.y, BL_MOB)
		if #get > 0 then
			for i = 1, #get do
				if get[i].yname == "wind_walk" then
					if player.gfxClone == 0 then
						clone.equip(player, get[i])
						if player.registry["show_title"] == 1 then
							get[i].gfxName = player.title .. " " .. player.name
						else
							get[i].gfxName = player.name
						end
					else
						clone.gfx(player, get[i])
						get[i].gfxName = player.gfxName
					end
					get[i].gfxClone = 1
					get[i].side = player.side
					get[i]:sendSide()
					get[i].owner = player.ID
					get[i]:setDuration("wind_walk", 60000, player.ID)
					player.state = 0
					player:updateState()
				end
			end
		end
		if #pc > 0 then
			for i = 1, #pc do
				pc[i]:refresh()
			end
		end
	end,

	while_cast = function(block, caster)
		if caster ~= nil then
			local target = block:getBlock(caster.attacker)

			if target ~= nil then
				if target.state ~= 1 and target.state ~= 2 then
					block.target = target.ID
				end
			end
		end
	end,

	uncast = function(block)
		block:sendAnimationXY(292, block.x, block.y)
		block:playSound(73)
		block:removeHealth(block.health)
	end,

	swing = function(player)
		local mob = player:getObjectsInMap(player.m, BL_MOB)

		if #mob > 0 then
			for i = 1, #mob do
				if mob[i].yname == "wind_walk" and mob[i].owner == player.ID then
					if mob[i].paralyzed or mob[i].sleep ~= 1 then
						return
					else
						if not mob[i].blind and not mob[i].snare then
							mob[i]:sendAction(1, 20)
						end
					end
				end
			end
		end
	end,

	say = function(player)
		local speech = string.lower(player.speech)
		local mob = player:getObjectsInMap(player.m, BL_MOB)

		if #mob > 0 then
			for i = 1, #mob do
				if mob[i].yname == "wind_walk" and mob[i].owner == player.ID then
					if string.match(speech, "/(.+)") ~= nil then
						return
					else
						mob[i]:talk(0, player.name .. ": " .. speech)
					end
				end
			end
		end
	end,

	click = async(function(player, mob)
		local owner = mob:getBlock(mob.owner)
		local healthCost = player.health *.5

		if owner == nil then
			return
		else
			if mob.owner == player.ID then
				swap(player, mob)
				player.side = mob.side
				player.health = player.health - healthCost
				player:sendStatus()
				player:sendSide()
			end
		end
	end)
}
