Player.allMythicCaveBosses = function(player, caveName)
	local mobs = {}

	if caveName == "rabbit" then
		mobs = {
			"mythic_hare",
			"hare_witch",
			"divine_rabbit",
			"rabbit_witch",
			"spirit_rabbit",
			"rabbit_avenger"
		}
	end

	if caveName == "monkey" then
		mobs = {
			"mythic_monkey",
			"monkey_mauler",
			"divine_monkey",
			"monkey_basher",
			"spirit_monkey",
			"monkey_avenger"
		}
	end

	if caveName == "rooster" then
		mobs = {
			"mythic_rooster",
			"rooster_swordsman",
			"divine_rooster",
			"rooster_barbarian",
			"spirit_rooster",
			"rooster_avenger"
		}
	end

	if caveName == "horse" then
		mobs = {
			"mythic_horse",
			"horse_do",
			"divine_horse",
			"horse_chongun",
			"spirit_horse",
			"horse_avenger"
		}
	end

	if caveName == "rat" then
		mobs = {
			"mythic_rat",
			"mighty_mouse",
			"divine_rat",
			"rat_lord",
			"spirit_rat",
			"rat_avenger"
		}
	end

	if caveName == "dog" then
		mobs = {
			"mythic_dog",
			"dog_assassin",
			"divine_dog",
			"dog_cutthroat",
			"spirit_dog",
			"dog_avenger"
		}
	end

	if caveName == "ox" then
		mobs = {
			"mythic_ox",
			"ox_gorer",
			"divine_ox",
			"ox_charger",
			"spirit_ox",
			"ox_avenger"
		}
	end

	if caveName == "pig" then
		mobs = {
			"mythic_boar",
			"boar_champion",
			"divine_pig",
			"pig_champion",
			"spirit_pig",
			"pig_avenger"
		}
	end

	if caveName == "sheep" then
		mobs = {
			"mythic_sheep",
			"sheep_veteran",
			"divine_sheep",
			"sheep_shepherd",
			"spirit_sheep",
			"sheep_avenger"
		}
	end

	if caveName == "snake" then
		mobs = {
			"mythic_snake",
			"snake_shaman",
			"divine_snake",
			"snake_mage",
			"spirit_snake",
			"snake_avenger"
		}
	end

	if caveName == "tiger" then
		mobs = {
			"mythic_tiger",
			"tiger_warrior",
			"divine_tiger",
			"tiger_slasher",
			"spirit_tiger",
			"tiger_avenger"
		}
	end

	if caveName == "dragon" then
		mobs = {
			"mythic_dragon",
			"dragon_mage",
			"divine_dragon",
			"dragon_slayer",
			"spirit_dragon",
			"dragon_avenger"
		}
	end

	return mobs
end

Player.allEnemyMythicCaveBosses = function(player, alliance)
	local alliances = {
		"Dragon",
		"Dog",
		"Rat",
		"Horse",
		"Rooster",
		"Rabbit",
		"Snake",
		"Pig",
		"Sheep",
		"Ox",
		"Tiger",
		"Monkey"
	}
	local enemies = {
		"Dog",
		"Dragon",
		"Horse",
		"Rat",
		"Rabbit",
		"Rooster",
		"Pig",
		"Snake",
		"Ox",
		"Sheep",
		"Monkey",
		"Tiger"
	}

	local enemy1
	local enemy2
	local enemy3

	for i = 1, #alliances do
		if alliance == alliances[i] then
			enemy1 = enemies[i]
			table.remove(alliances, i)
			table.remove(enemies, i)
			break
		end
	end

	for i = 1, #alliances do
		if player:hasLegend("lesser_alliance_" .. string.lower(alliances[i])) then
			enemy2 = enemies[i]
			table.remove(alliances, i)
			table.remove(enemies, i)
			break
		end
	end

	for i = 1, #alliances do
		if player:hasLegend("lesser_alliance_" .. string.lower(alliances[i])) then
			enemy3 = enemies[i]
			table.remove(alliances, i)
			table.remove(enemies, i)
			break
		end
	end

	if enemy1 == nil or enemy2 == nil or enemy3 == nil then
		player:dialogSeq({"You do not have enough lesser alliances."})
		return
	end

	return enemy1, enemy2, enemy3
end
