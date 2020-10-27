new_years_npc2 = {
	action = function(npc)
		-- 569/570 (lv1) 571/572 (lv2) 573/574 (lv3)
		-- 575 (lv1 boss) 576 (lv2 boss) 577 (lv3 boss)
		--[[
        MobSpawnHandlerNpc.handleSpawn(npc, 59001, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59002, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59003, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59004, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59005, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59006, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59007, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59008, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59009, {569,570}, {16,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59011, {575}, {1}, 900, 8, 6, 14, 8)
        MobSpawnHandlerNpc.handleSpawn(npc, 59012, {571,572}, {12,10}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59015, {571,572}, {24,18}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59016, {571,572}, {18,21}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59017, {571,572}, {18,21}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59018, {576}, {1}, 900, 7, 20, 9, 22)
        MobSpawnHandlerNpc.handleSpawn(npc, 59019, {573,574}, {24,21}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59020, {573,574}, {23,22}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59021, {573,574}, {22,23}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59022, {573,574}, {21,24}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59023, {573,574}, {20,25}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59024, {573,574}, {20,26}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59025, {573,574}, {20,26}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59026, {573,574}, {18,28}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59027, {573,574}, {20,28}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59028, {573,574}, {14,12}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59029, {573,574}, {24,26}, 240)
        MobSpawnHandlerNpc.handleSpawn(npc, 59030, {577}, {1}, 900, 9, 11, 23, 19)
		]]
		--
	end,

	click = async(function(player, npc)
		local t = {
			graphic = convertGraphic(npc.look, "monster"),
			color = npc.lookColor
		}
		player.npcGraphic = t.graphic
		player.npcColor = t.color
		player.dialogType = 0
		player.lastClick = npc.ID

		if player.level < 20 then
			player:dialogSeq(
				{
					t,
					"You are too young for anything I have to offer, return when you are level 20."
				},
				0
			)
			return
		end

		if npc.m ~= 41 then
			if player:hasItem("annual_pass", 1) == true then
				player:dialogSeq({t, "You have all that I can offer you!"}, 1)
				return
			end
			if player:hasLegend("year_of_the_pig") and player:hasItem("annual_pass", 1) ~= true then
				player:addItem("annual_pass", 1, 0, 0, os.time() + 3628800)
				player:dialogSeq(
					{t, "It seems you lost your pass... let me help you out."},
					1
				)
				return
			end
			player:dialogSeq(
				{
					t,
					"You've made it far, adventurer.",
					"I have an item here that will permit you to pass these portals.",
					"It will allow you to enter this place every day, until it closes.",
					"If you bring me 1 Scribe's book and 20 Ambers, I will let you have it.",
					"I would also accept a Hyun moo key in place of the Scribe's book."
				},
				1
			)
			local whichitem = "scribes_book"
			if player:hasItem("scribes_book", 1) ~= true then
				whichitem = "hyun_moo_key"
			end
			if player:hasItem(whichitem, 1) == true and player:hasItem("amber", 20) == true then
				player:removeItem(whichitem, 1)
				player:removeItem("amber", 20)
				if player:hasItem("annual_ticket", 1) == true then
					player:removeItem("annual_ticket", 1)
				end
				player:addItem("annual_pass", 1, 0, 0, os.time() + 3628800)
				player:addLegend(
					"Celebrated the year of the Pig (" .. curT() .. ")",
					"year_of_the_pig",
					144,
					9
				)
				player:dialogSeq(
					{
						t,
						"Excellent! Thank you for your efforts, I'll warn you, below this area",
						"Many dangers await! Proceed with caution."
					},
					1
				)
			end
			return
		end

		if player:hasItem("annual_ticket", 1) == true or player:hasItem(
			"annual_pass",
			1
		) == true then
			player:warp(59000, 33, 75)
			return
		end

		player:dialogSeq(
			{
				t,
				"Greetings, adventurer! To celebrate this coming year of the Pig, the Jade Citadel is open.",
				"If you would like to enter, bring me 20 snake meat and I will give you a pass."
			},
			1
		)
		if player:hasItem("snake_meat", 20) == true then
			local hasRoom = false
			for i = 0, player.maxInv - 1 do
				if player:getInventoryItem(i) == nil then
					hasRoom = true
					break
				end
			end
			if hasRoom ~= true then
				player:dialogSeq(
					{
						t,
						"You have no room for this, make some room and talk to me again."
					},
					0
				)
				return
			end
			player:removeItem("snake_meat", 20)
			player:addItem("annual_ticket", 1, 0, 0, os.time() + 86400)
			player:dialogSeq(
				{t, "Thank you so much! Here is your pass, it lasts for 1 day."},
				1
			)
		end
	end)
}
received_fortune = {
	cast = function(player)
		player:setAether("received_fortune", 10000)
		player:sendStatus()
		return
	end
}
good_fortune = {
	use = function(player)
		if not (player.m >= 59000 and player.m <= 59030) then
			player:sendMinitext("This cannot be used here.")
			return
		end
		if player.state == 1 then
			player:sendMinitext("Spirit's can't do that.")
			return
		end
		if player:hasAether("received_fortune") == true then
			player:sendMinitext("You must wait to do this.")
			return
		end
		received_fortune.cast(player)
		if math.random(1, 25) == 1 then
			if (player.m >= 59000 and player.m <= 59011) then
				player:spawn(575, player.x, player.y + 1, 1, player.m)
			elseif (player.m >= 59012 and player.m <= 59018) then
				player:spawn(576, player.x, player.y + 1, 1, player.m)
			elseif (player.m >= 59019 and player.m <= 59030) then
				player:spawn(577, player.x, player.y + 1, 1, player.m)
			end
		else
			local amount = 1
			if (player.m >= 59000 and player.m <= 59011) then
				local themob = math.random(569, 570)
				player:spawn(themob, player.x, player.y + 1, amount, player.m)
			elseif (player.m >= 59012 and player.m <= 59018) then
				local themob = math.random(571, 572)
				player:spawn(themob, player.x, player.y + 1, amount, player.m)
			elseif (player.m >= 59019 and player.m <= 59030) then
				local themob = math.random(573, 574)
				player:spawn(themob, player.x, player.y + 1, amount, player.m)
			end
		end
		player:removeItem("good_fortune", 1)
	end
}

rich_fortune = {
	use = function(player)
		if player.state == 1 then
			player:sendMinitext("Spirit's can't do that.")
			return
		end
		if player:hasAether("received_fortune") == true then
			player:sendMinitext("You must wait to do this.")
			return
		end
		received_fortune.cast(player)
		local loots = {}
		if player.sex == 0 then
			loots = {
				"wool",
				"cloth",
				"metal",
				"ore_poor",
				"ore_med",
				"ore_high",
				"ore_very_high",
				"ginko_wood",
				"amber",
				"dark_amber",
				"yellow_amber",
				"military_fork",
				"fine_steel_dagger",
				"coat_scale_mail",
				"coat_war_platemail",
				"coat_waistcoat",
				"coat_armor",
				"coat_garb",
				"coat_clothes",
				"coat_robes",
				"coat_mantle",
				"coat_heavy_plate"
			}
		else
			loots = {
				"wool",
				"cloth",
				"metal",
				"ore_poor",
				"ore_med",
				"ore_high",
				"ore_very_high",
				"ginko_wood",
				"amber",
				"dark_amber",
				"yellow_amber",
				"military_fork",
				"fine_steel_dagger",
				"coat_scale_dress",
				"coat_war_dress",
				"coat_blouse",
				"coat_armor_dress",
				"coat_dress",
				"coat_skirt",
				"coat_gown",
				"coat_drapery",
				"coat_heavy_plate"
			}
		end
		if player.level >= 50 then
			if player.baseClass == 1 then
				table.insert(loots, "titanium_glove")
			end
			if player.baseClass == 2 then
				table.insert(loots, "whisper_bracelet")
			end
			if player.baseClass == 3 then
				table.insert(loots, "holy_ring")
			end
			if player.baseClass == 4 then
				table.insert(loots, "sen_glove")
			end
		end
		if player.level >= 80 then
			if player.baseClass == 1 then
				table.insert(loots, "electra")
			end
			if player.baseClass == 2 then
				table.insert(loots, "steelthorn")
			end
			if player.baseClass == 3 then
				table.insert(loots, "star_staff")
			end
			if player.baseClass == 4 then
				table.insert(loots, "titanium_lance")
			end
		end
		if player.level >= 70 and player.sex == 0 and math.random(1, 95) == 1 then
			if player.baseClass == 1 then
				table.insert(loots, "star_war_platemail")
			end
			if player.baseClass == 2 then
				table.insert(loots, "star_armor")
			end
			if player.baseClass == 3 then
				table.insert(loots, "star_clothes")
			end
			if player.baseClass == 4 then
				table.insert(loots, "star_mantle")
			end
		end
		if player.level >= 70 and player.sex == 1 and math.random(1, 95) == 1 then
			if player.baseClass == 1 then
				table.insert(loots, "star_war_dress")
			end
			if player.baseClass == 2 then
				table.insert(loots, "star_armor_dress")
			end
			if player.baseClass == 3 then
				table.insert(loots, "star_skirt")
			end
			if player.baseClass == 4 then
				table.insert(loots, "star_drapery")
			end
		end
		if player.level >= 80 and math.random(1, 10) == 1 then
			if player.baseClass == 1 then
				table.insert(loots, "spike")
			end
			if player.baseClass == 2 then
				table.insert(loots, "blood")
			end
			if player.baseClass == 3 then
				table.insert(loots, "surge")
			end
			if player.baseClass == 4 then
				table.insert(loots, "charm")
			end
		end
		if player.level == 99 and math.random(1, 225) == 1 then
			if player.baseClass == 1 then
				table.insert(loots, "enchanted_spike")
			end
			if player.baseClass == 2 then
				table.insert(loots, "enchanted_blood")
			end
			if player.baseClass == 3 then
				table.insert(loots, "enchanted_surge")
			end
			if player.baseClass == 4 then
				table.insert(loots, "enchanted_charm")
			end
		end
		if player.karma > 10 and math.random(1, 250000) == 666 then
			table.insert(loots, "zibong_blade")
		end
		local directive = #loots * 2
		local rewarded = loots[math.random(1, 4)]
		for l = 1, #loots do
			local roll = math.random(1, directive)
			if roll == 2 then
				rewarded = loots[l]
				break
			end
			if l % 4 == 0 then
				directive = directive + math.floor(#loots * 0.8)
			end
		end
		player:removeItem("rich_fortune", 1)
		local spoil = Item(rewarded).stackAmount
		if spoil > 1 and player:hasItem(rewarded, spoil) == true then
			player:sendMinitext("You would have received " .. spoil .. " " .. Item(rewarded).name .. " but you already had too many!")
			return
		end
		player:sendMinitext("You received " .. spoil .. " " .. Item(rewarded).name)
		player:addItem(rewarded, spoil)
	end
}

new_years_mob1 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", 1)
				end
			end
		end
	end
}

new_years_mob2 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", 1)
				end
			end
		end
	end
}

new_years_mob3 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", 1)
				end
			end
		end
	end
}

new_years_mob4 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", 1)
				end
			end
		end
	end
}

new_years_mob5 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", math.random(1, 2))
				end
			end
		end
	end
}

new_years_mob6 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_basic.on_attacked(mob, attacker)
	end,

	move = function(mob, target)
		mob_ai_basic.move(mob, target)
	end,

	attack = function(mob, target)
		mob_ai_basic.attack(mob, target)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 40) == 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("good_fortune", math.random(1, 2))
				end
			end
		end
	end
}

new_years_boss1 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 0)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 0)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 2)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 16) < 4 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("rich_fortune", 1)
				end
			end
		end
		mob_ai_mythic.after_death(mob)
	end
}

new_years_boss2 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 1)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 1)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 2)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 12) < 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("rich_fortune", 1)
				end
			end
		end
		mob_ai_mythic.after_death(mob)
	end
}

new_years_boss3 = {
	on_spawn = function(mob)
		local stats = getNewYearsMob(mob)
		mob.look = stats.look
		mob.lookColor = stats.color
		mob:updateState()
	end,
	on_healed = function(mob, healer)
		mob_ai_basic.on_healed(mob, healer)
	end,

	on_attacked = function(mob, attacker)
		mob_ai_mythic.on_attacked(mob, attacker, 2)
	end,

	move = function(mob, target)
		mob_ai_mythic.move(mob, target, 2)
	end,

	attack = function(mob, target)
		mob_ai_mythic.attack(mob, target, 0)
	end,

	after_death = function(mob, attacker)
		local targets = mob:getObjectsInMap(mob.m, BL_PC)
		for i = 1, #targets do
			if math.random(1, 8) < 5 then
				if not (targets[i].afkTime > 1) and targets[i].state ~= 1 then
					targets[i]:addItem("rich_fortune", math.random(1, 2))
				end
			end
		end
		mob_ai_mythic.after_death(mob)
	end
}

getNewYearsMob = function(mob)
	local npclook = NPC("Annual Avatar").look

	local returningInfo = {look = 0, color = 0}

	if npclook == 131 then
		--rabbit
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 125, color = 13}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 197, color = 30}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 197, color = 11}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 21, color = 16}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 21, color = 10}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 650, color = 12}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 441, color = 2}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 131, color = 24}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 131, color = 18}
		end
	elseif npclook == 136 then
		--monkey
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 126, color = 29}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 126, color = 30}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 268, color = 1}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 268, color = 22}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 127, color = 4}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 127, color = 31}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 136, color = 8}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 136, color = 7}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 136, color = 22}
		end
	elseif npclook == 138 then
		--dog
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 18, color = 29}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 104, color = 30}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 93, color = 1}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 95, color = 22}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 103, color = 4}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 198, color = 31}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 138, color = 21}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 138, color = 10}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 138, color = 21}
		end
	elseif npclook == 137 then
		--rooster
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 121, color = 11}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 121, color = 11}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 124, color = 11}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 196, color = 11}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 28, color = 11}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 1397, color = 11}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 137, color = 9}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 137, color = 20}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 137, color = 30}
		end
	elseif npclook == 128 then
		--rat
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 90, color = 12}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 91, color = 13}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 120, color = 11}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 199, color = 31}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 318, color = 23}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 318, color = 25}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 128, color = 31}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 128, color = 21}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 128, color = 19}
		end
	elseif npclook == 134 then
		--horse
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 17, color = 6}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 17, color = 9}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 17, color = 12}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 17, color = 13}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 17, color = 10}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 17, color = 11}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 134, color = 16}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 134, color = 24}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 134, color = 10}
		end
	elseif npclook == 129 then
		--ox
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 27, color = 7}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 152, color = 7}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 27, color = 13}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 152, color = 13}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 27, color = 10}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 152, color = 11}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 129, color = 3}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 129, color = 8}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 129, color = 19}
		end
	elseif npclook == 139 then
		--pig
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 20, color = 6}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 20, color = 9}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 19, color = 9}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 122, color = 4}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 153, color = 10}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 1396, color = 10}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 139, color = 31}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 139, color = 24}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 139, color = 6}
		end
	elseif npclook == 133 then
		--snake
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 26, color = 16}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 33, color = 14}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 33, color = 16}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 184, color = 15}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 184, color = 31}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 617, color = 25}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 133, color = 2}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 133, color = 21}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 133, color = 26}
		end
	elseif npclook == 135 then
		--sheep
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 173, color = 11}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 173, color = 30}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 173, color = 10}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 173, color = 31}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 173, color = 23}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 173, color = 24}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 135, color = 3}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 135, color = 20}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 135, color = 16}
		end
	elseif npclook == 130 then
		--tiger
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 29, color = 20}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 621, color = 10}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 621, color = 17}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 107, color = 20}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 107, color = 31}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 29, color = 30}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 130, color = 21}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 130, color = 22}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 130, color = 2}
		end
	elseif npclook == 132 then
		--dragon
		if mob.yname == "new_years_mob1" then
			returningInfo = {look = 108, color = 30}
		elseif mob.yname == "new_years_mob2" then
			returningInfo = {look = 108, color = 0}
		elseif mob.yname == "new_years_mob3" then
			returningInfo = {look = 186, color = 30}
		elseif mob.yname == "new_years_mob4" then
			returningInfo = {look = 186, color = 31}
		elseif mob.yname == "new_years_mob5" then
			returningInfo = {look = 1842, color = 0}
		elseif mob.yname == "new_years_mob6" then
			returningInfo = {look = 1842, color = 8}
		elseif mob.yname == "new_years_boss1" then
			returningInfo = {look = 132, color = 0}
		elseif mob.yname == "new_years_boss2" then
			returningInfo = {look = 132, color = 20}
		elseif mob.yname == "new_years_boss3" then
			returningInfo = {look = 132, color = 28}
		end
	end
	return returningInfo
end

onScriptedTilesJadeCitadel = function(player)
	--[[
    if player:hasItem("annual_pass",1) == true then return end

    if player.m == 59001 and player.y == 17 then
        if player.x == 30 or player.x == 31 then player:warp(player.m,player.x,18) end
    elseif player.m == 59014 and player.y == 19 then
        if player.x == 17 or player.y == 18 then player:warp(player.m,player.x,20) end
    end
	]]
	--
end
