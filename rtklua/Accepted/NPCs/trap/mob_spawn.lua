MobSpawnNpc = {
	click = function(block, npc)
		if (block.blType == BL_PC) then
			if block.state == 1 then
				return
			end
			local message = "You stepped on a trap!"

			if (npc.m >= 90 and npc.m <= 96) then
				-- kug spider cave spawning trapdoor spiders
				block:spawn(102, block.x, block.y, 1)

				--MobSpawnNpc.spawnMob(block, npc, 102)
			end

			if (npc.m >= 410 and npc.m <= 419) then
				-- buya scorp cave spawning scorpion lurker
				block:spawn(555, block.x, block.y, 1)

				--MobSpawnNpc.spawnMob(block, npc, 102)
			end

			if (npc.m == 135) then
				-- northern ogre Ice Canyon
				local chance = math.random(1, 3)

				if chance == 1 then
					-- boss roll
					MobSpawnNpc.spawnMob(block, npc, 152)

					-- ice ogres
				else
					MobSpawnNpc.spawnMob(block, npc, 149)

					-- northern ogres
				end
			end

			if (npc.m == 136) then
				-- northern ogre Sacred Grove
				local lastDeath = 0
				local bossAlive = 0
				lastDeath = getMapRegistry(npc.m, "lastDeathCitelam")
				local mobBlock = npc:getObjectsInSameMap(BL_MOB)
				for z = 1, #mobBlock do
					if (mobBlock[z].yname == "ogre_citelam") then
						bossAlive = 1
					end
				end
				if os.time() >= lastDeath + 1800 and bossAlive == 0 then
					local chance = math.random(1, 10)
					if chance == 1 then
						-- boss roll
						block:spawn(153, block.x, block.y, 1)

						-- citelam
						MobSpawnNpc.spawnMob(block, npc, 151)

						-- ice panthers
					else
						MobSpawnNpc.spawnMob(block, npc, 151)

						-- ice panthers
					end
				else
					--npc:talk(0,"--------------")
					--npc:talk(0,"not enough time")
					--npc:talk(0,"current time: "..os.time())
					--npc:talk(0,"time can spawn: "..lastDeath + 600.." ")
					MobSpawnNpc.spawnMob(block, npc, 151)

					-- ice panthers
				end
			end
			if (npc.m == 140) then
				-- northern ogre Crystaline Isle
				local lastDeath = 0
				local bossAlive = 0
				lastDeath = getMapRegistry(npc.m, "lastDeathMaletic")
				local mobBlock = npc:getObjectsInSameMap(BL_MOB)
				for z = 1, #mobBlock do
					if (mobBlock[z].yname == "ogre_maletic") then
						bossAlive = 1
					end
				end
				if os.time() >= lastDeath + 1800 and bossAlive == 0 then
					local chance = math.random(1, 10)
					if chance == 1 then
						-- boss roll
						block:spawn(154, block.x, block.y, 1)

						-- Maletic
						MobSpawnNpc.spawnMob(block, npc, 152)

						-- ice ogres
					else
						MobSpawnNpc.spawnMob(block, npc, 149)

						-- northern ogres
					end
				else
					--npc:talk(0,"--------------")
					--npc:talk(0,"not enough time")
					--npc:talk(0,"current time: "..os.time())
					--npc:talk(0,"time can spawn: "..lastDeath + 900000)
					MobSpawnNpc.spawnMob(block, npc, 149)

					-- northern ogres
				end
			end

			if (npc.m >= 200 and npc.m <= 208) then
				-- rabbit 1
				message = "Rabbits ambush you!"
				if npc.m ~= 208 then
					RabbitSpawnNpc.spawnRabbitMob1(npc, block, npc.m)
				else
					if npc.y > 23 then
						-- bottom half
						RabbitSpawnNpc.spawnRabbitMob1(npc, block, npc.m)
					else
						RabbitSpawnNpc.spawnRabbitSentsMob1(npc, block, npc.m)
					end
				end
			end
			if (npc.m >= 3200 and npc.m <= 3208) then
				-- rabbit 2
				message = "Rabbits ambush you!"

				if npc.m ~= 3208 then
					RabbitSpawnNpc.spawnRabbitMob2(npc, block, npc.m)
				else
					if npc.y > 23 then
						-- bottom half
						RabbitSpawnNpc.spawnRabbitMob2(npc, block, npc.m)
					else
						RabbitSpawnNpc.spawnRabbitSentsMob2(npc, block, npc.m)
					end
				end
			end
			if (npc.m >= 4200 and npc.m <= 4208) then
				-- rabbit 3
				message = "Rabbits ambush you!"
				if npc.m ~= 4208 then
					RabbitSpawnNpc.spawnRabbitMob3(npc, block, npc.m)
				else
					if npc.y > 23 then
						-- bottom half
						RabbitSpawnNpc.spawnRabbitMob3(npc, block, npc.m)
					else
						RabbitSpawnNpc.spawnRabbitSentsMob3(npc, block, npc.m)
					end
				end
			end

			if (npc.m == 203 or npc.m == 205 or npc.m == 208) then
				local chance = math.random(1, 10)
				local rabtimer = getMapRegistry(npc.m, "lastDeath")
				if chance == 1 and (os.time() >= (rabtimer + 1500)) then
					if (npc.m == 208) then
						if npc.y >= 23 then
							message = "You have Found the Mythic Hare!"
							block:spawn(522, block.x, block.y, 1)
						end
					elseif (npc.m == 205) then
						if block.mapRegistry["hopswap"] % 2 == 0 then
							message = "You have Found the Mythic Hare!"
							block:spawn(522, block.x, block.y, 1)
						else
							message = "You have Found the Hare Witch!"
							block:spawn(523, block.x, block.y, 1)
						end
						block.mapRegistry["hopswap"] = block.mapRegistry["hopswap"] + 1
					else
						message = "You have Found the Hare Witch!"
						block:spawn(523, block.x, block.y, 1)
					end
				end
			end
			if (npc.m == 3203 or npc.m == 3205 or npc.m == 3208) then
				local chance = math.random(1, 10)
				local rabtimer = getMapRegistry(npc.m, "lastDeath")
				if chance == 1 and (os.time() >= (rabtimer + 1500)) then
					if (npc.m == 3208) then
						if npc.y >= 23 then
							message = "You have Found the Divine Rabbit!"
							block:spawn(527, block.x, block.y, 1)
						end
					elseif (npc.m == 3205) then
						local hopswap = math.random(1, 2)
						if hopswap == 1 then
							message = "You have Found the Divine Rabbit!"
							block:spawn(527, block.x, block.y, 1)
						else
							message = "You have Found the Rabbit Witch!"
							block:spawn(528, block.x, block.y, 1)
						end
					else
						message = "You have Found the Rabbit Witch!"
						block:spawn(528, block.x, block.y, 1)
					end
				end
			end
			if (npc.m == 4203 or npc.m == 4204 or npc.m == 4205 or npc.m == 4208) then
				local chance = math.random(1, 10)
				local rabtimer = getMapRegistry(npc.m, "lastDeath")
				if chance == 1 and (os.time() >= (rabtimer + 1500)) then
					if (npc.m == 4208) then
						if npc.y >= 23 then
							message = "You have Found the Spirit Rabbit!"
							block:spawn(533, block.x, block.y, 1)
						end
					elseif (npc.m == 4205) then
						local hopswap = math.random(1, 2)
						if hopswap == 1 then
							message = "You have Found the Spirit Rabbit!"
							block:spawn(533, block.x, block.y, 1)
						else
							message = "You have Found the Rabbit Avenger!"
							block:spawn(534, block.x, block.y, 1)
						end
					else
						message = "You have Found the Rabbit Avenger!"
						block:spawn(534, block.x, block.y, 1)
					end
				end
			end

			if (npc.m >= 100 and npc.m <= 110) then
				-- tiger 1
				message = "Tigers ambush you!"

				if (npc.m == 110) then
					TigerSpawnNpc.spawnTigerSentries(npc, block, npc.m, 804)
				elseif (npc.m == 109) then
					local chance = math.random(1, 10)

					if chance == 1 then
						TigerSpawnNpc.spawnTigerBigMob1(npc, block, npc.m)
					else
						TigerSpawnNpc.spawnTigerMob1(npc, block, npc.m)
					end
				else
					TigerSpawnNpc.spawnTigerMob1(npc, block, npc.m)
				end
			end

			if (npc.m >= 3100 and npc.m <= 3110) then
				-- tiger 2
				message = "Tigers ambush you!"

				if (npc.m == 3110) then
					TigerSpawnNpc.spawnTigerSentries(npc, block, npc.m, 805)
				elseif (npc.m == 3109) then
					local chance = math.random(1, 10)

					if chance == 1 then
						TigerSpawnNpc.spawnTigerBigMob2(npc, block, npc.m)
					else
						TigerSpawnNpc.spawnTigerMob2(npc, block, npc.m)
					end
				else
					TigerSpawnNpc.spawnTigerMob2(npc, block, npc.m)
				end
			end

			if (npc.m >= 4100 and npc.m <= 4110) then
				-- tiger 3
				message = "Tigers ambush you!"

				if (npc.m == 4110) then
					TigerSpawnNpc.spawnTigerSentries(npc, block, npc.m, 806)
				elseif (npc.m == 4109) then
					local chance = math.random(1, 10)

					if chance == 1 then
						TigerSpawnNpc.spawnTigerBigMob3(npc, block, npc.m)
					else
						TigerSpawnNpc.spawnTigerMob3(npc, block, npc.m)
					end
				else
					TigerSpawnNpc.spawnTigerMob3(npc, block, npc.m)
				end
			end

			if (npc.m == 105) then
				-- Tiger's Revenge / Tiger 1 Boss Spawn
				local mobBlock = npc:getObjectsInSameMap(BL_MOB)
				local chance = math.random(1, 10)
				local bossAlive = 0
				for z = 1, #mobBlock do
					if (mobBlock[z].yname == "mythic_tiger") then
						bossAlive = 1
					end
				end

				if chance == 1 and bossAlive == 0 then
					message = "You have found the Mythic Tiger!"
					block:spawn(340, block.x, block.y, 1) -- Mythic Tiger
					block:spawn(math.random(294, 297), block.x, block.y, 1)
				end
			end

			if (npc.m == 109) then
				-- Dark Pen / Tiger 1 Boss Spawn
				local chance = math.random(1, 10)
				if chance == 1 then
					message = "You have walked into a well planned ambush!"
					block:spawn(341, block.x, block.y, 1) -- Tiger Warrior
					block:spawn(math.random(294, 297), block.x, block.y, 1)
				end
			end
			if (npc.m == 3105) then
				-- Tiger's Revenge / Tiger 2 Boss Spawn
				local mobBlock = npc:getObjectsInSameMap(BL_MOB)
				local chance = math.random(1, 10)
				local bossAlive = 0
				for z = 1, #mobBlock do
					if (mobBlock[z].yname == "divine_tiger") then
						bossAlive = 1
					end
				end
				if chance == 1 and bossAlive == 0 then
					message = "You have found the Divine Tiger!"
					block:spawn(345, block.x, block.y, 1)-- Divine Tiger
					block:spawn(math.random(342, 344), block.x, block.y, 1)
				end
			end
			if (npc.m == 3109) then
				-- Dark Pen / Tiger 2 Boss Spawn
				local chance = math.random(1, 10)
				if chance == 1 then
					message = "You have walked into a well planned ambush!"
					block:spawn(346, block.x, block.y, 1) -- Tiger Slasher
					block:spawn(math.random(342, 344), block.x, block.y, 1)
				end
			end
			if (npc.m == 4105) then
				-- Tiger's Revenge / Tiger 3 Boss Spawn
				local mobBlock = npc:getObjectsInSameMap(BL_MOB)
				local chance = math.random(1, 10)
				local bossAlive = 0
				for z = 1, #mobBlock do
					if (mobBlock[z].yname == "spirit_tiger") then
						bossAlive = 1
					end
				end
				if chance == 1 and bossAlive == 0 then
					message = "You have found the Spirit Tiger!"
					block:spawn(350, block.x, block.y, 1) -- Spirit Tiger
					block:spawn(math.random(347, 349), block.x, block.y, 1)
				end
			end
			if (npc.m == 4109) then
				-- Dark Pen / Tiger 3 Boss Spawn
				local chance = math.random(1, 10)
				if chance == 1 then
					message = "You have walked into a well planned ambush!"
					block:spawn(351, block.x, block.y, 1) -- Tiger Avenger
					block:spawn(math.random(347, 349), block.x, block.y, 1)
				end
			end

			block:sendMinitext(message)

			removeTrapItem(npc)
			npc:delete()
		end
	end,
	spawnMob = function(block, npc, mob)
		local passCheck = getPass(block.m, block.x + 1, block.y)
		local blockCheck = block:getObjectsInCell(
			block.m,
			block.x + 1,
			block.y,
			BL_ALL
		)
		if (passCheck == 0 and #blockCheck == 0 and not getWarp(
			block.m,
			block.x + 1,
			block.y
		)) then
			npc:spawn(mob, block.x + 1, block.y, 1)
		else
			npc:spawn(mob, block.x, block.y, 1)
		end

		passCheck = getPass(block.m, block.x - 1, block.y)
		blockCheck = block:getObjectsInCell(
			block.m,
			block.x - 1,
			block.y,
			BL_ALL
		)

		if (passCheck == 0 and #blockCheck == 0 and not getWarp(
			block.m,
			block.x - 1,
			block.y
		)) then
			npc:spawn(mob, block.x - 1, block.y, 1)
		else
			npc:spawn(mob, block.x, block.y, 1)
		end

		passCheck = getPass(block.m, block.x, block.y - 1)
		blockCheck = block:getObjectsInCell(
			block.m,
			block.x,
			block.y - 1,
			BL_ALL
		)

		if (passCheck == 0 and #blockCheck == 0 and not getWarp(
			block.m,
			block.x,
			block.y - 1
		)) then
			npc:spawn(mob, block.x, block.y - 1, 1)
		else
			npc:spawn(mob, block.x, block.y, 1)
		end

		passCheck = getPass(block.m, block.x, block.y + 1)
		blockCheck = block:getObjectsInCell(
			block.m,
			block.x,
			block.y + 1,
			BL_ALL
		)

		if (passCheck == 0 and #blockCheck == 0 and not getWarp(
			block.m,
			block.x,
			block.y + 1
		)) then
			npc:spawn(mob, block.x, block.y + 1, 1)
		else
			npc:spawn(mob, block.x, block.y, 1)
		end
	end,

	endAction = function(npc, owner)
		removeTrap(npc)
	end
}
