BaekduChestNpc = {
	on_spawn = function(npc)
		npc.subType = 0
		npc.look = 1640
		npc.lookColor = 0
		npc.side = 2
		npc:sendSide()
	end,

	click = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local pname = player.name

		-- @TODO: Update item lists

		local pGold = math.random(2150, 2650)
		local rAmber = math.random(8, 11)
		local dAmber = math.random(3, 5)
		local wAmber = math.random(1, 2)

		local itemsCommon = {
			"chung_ryong_key",
			"hyun_moo_key",
			"ju_jak_key",
			"baekho_key",
			"key_to_heaven",
			"key_to_fire",
			"key_to_water",
			"key_to_earth",
			"key_to_pond",
			"key_to_mountain",
			"key_to_wind",
			"key_to_thunder"
		}

		local itemsRare = {
			"electra",
			"steelthorn",
			"star_staff",
			"titanium_lance",
			"holy_ring",
			"whisper_bracelet",
			"titanium_glove",
			"sen_glove",
			"blood",
			"charm",
			"spike",
			"surge",
			"corrupted_ring",
			"corrupted_blade",
			"corrupted_staff",
			"enchanted_blood",
			"enchanted_spike",
			"enchanted_charm",
			"enchanted_surge"
		}

		local itemsUltraRare = {
			"star_armor",
			"star_armor_dress",
			"star_blouse",
			"star_clothes",
			"star_drapery",
			"star_dress",
			"star_garb",
			"star_gown",
			"star_helm",
			"star_helmet",
			"star_mail_dress",
			"star_mantle",
			"star_robes",
			"star_scale_mail",
			"star_skirt",
			"star_waistcoat",
			"star_war_dress",
			"star_war_platemail"
		}

		local itemsLegendary = {
			"flameblade",
			"flameblade",
			"sevenleaf_sword",
			"stone_axe",
			"stone_axe",
			"crystal_staff",
			"crystal_staff",
			"chaos_blade",
			"faerie_light"
		}

		local itemsCommonDesc = {
			"a Chung ryong key",
			"a Hyun moo key",
			"a Ju jak key",
			"a Baekho key",
			"a Key to heaven",
			"a Key to fire",
			"a Key to water",
			"a Key to earth",
			"a Key to pond",
			"a Key to mountain",
			"a Key to wind",
			"a Key to thunder"
		}

		local itemsRareDesc = {
			"an Electra",
			"a Steelthorn",
			"a Star-Staff",
			"a Titanium lance",
			"a Holy ring",
			"a Whisper bracelet",
			"a Titanium glove",
			"a Sen glove",
			"a Blood",
			"a Charm",
			"a Spike",
			"a Surge",
			"a Corrupted ring",
			"a Corrupted blade",
			"a Corrupted staff",
			"an Enchanted blood",
			"an Enchanted spike",
			"an Enchanted charm",
			"an Enchanted surge"
		}

		local itemsUltraRareDesc = {
			"a Star armor",
			"a Star armor dress",
			"a Star blouse",
			"a Star clothes",
			"a Star drapery",
			"a Star dress",
			"a Star garb",
			"a Star gown",
			"a Star helm",
			"a Star helmet",
			"a Star mail dress",
			"a Star mantle",
			"a Star robe",
			"a Star scale mail",
			"a Star skirt",
			"a Star waistcoat",
			"a Star war dress",
			"a Star war platemail"
		}

		local itemsLegendaryDesc = {
			"a Flameblade",
			"a Flameblade",
			"a Sevenleaf sword",
			"a Stone axe",
			"a Stone axe",
			"a Crystal staff",
			"a Crystal staff",
			"a Chaos blade",
			"a Faerie light"
		}

		local commonTable = math.random(1, #itemsCommon)
		local rareTable = math.random(1, #itemsRare)
		local ultraTable = math.random(1, #itemsUltraRare)
		local legendaryTable = math.random(1, #itemsLegendary)

		local commonChance = math.random(4) -- 75% chance (see below)
		local rareChance = math.random(10) -- 10% chance (see below)
		local ultraChance = math.random(100) -- 1% chance
		local legendaryChance = math.random(1, 100000) -- 0.0001% chance
		local itemsGained = 0

		if player.state == 1 then
			player:sendMinitext("How can you open a chest without hands?")
			return
		end

		if player.quest["baekdu_boss_killed"] == 0 then
			player:sendMinitext("You have already received your loot.")
			return
		end

		if player.quest["baekdu_boss_killed"] == 1 then
			player:addGold(pGold)
			player:addItem("amber", rAmber)
			player:addItem("dark_amber", dAmber)
			player:addItem("white_amber", wAmber)
			if commonChance <= 3 then
				-- chance to roll common loot
				player:addItem(itemsCommon[commonTable], 1)
				player:sendMinitext("You open the Abyssal Chest and receive " .. itemsCommonDesc[commonTable] .. "!")
				npc:talk(
					1,
					"[Mt Baekdu Chest]: " .. pname .. " received " .. itemsCommonDesc[
						commonTable
					] .. "!"
				)
				itemsGained = itemsGained + 1
			end

			if rareChance == 1 then
				-- chance to roll rare loot
				player:addItem(itemsRare[rareTable], 1)
				player:sendMinitext("You open the Abyssal Chest and receive " .. itemsRareDesc[rareTable] .. "!")
				npc:talk(
					1,
					"[Mt Baekdu Chest]: " .. pname .. " received " .. itemsRareDesc[
						rareTable
					] .. "!"
				)
				itemsGained = itemsGained + 1
			end

			if ultraChance == 1 then
				-- chance to roll ultra rare loot
				player:addItem(itemsUltraRare[ultraTable], 1)
				player:sendMinitext("You open the Abyssal Chest and receive " .. itemsUltraRareDesc[ultraTable] .. "!")
				npc:talk(
					1,
					"[Mt Baekdu Chest]: " .. pname .. " received " .. itemsUltraRareDesc[
						ultraTable
					] .. "!"
				)
				itemsGained = itemsGained + 1
			end

			if legendaryChance == 1 then
				-- chance to roll legendary loot
				player:addItem(itemsLegendary[legendaryTable], 1)
				player:sendMinitext("You open the Abyssal Chest and receive " .. itemsLegendaryDesc[legendaryTable] .. "!")
				npc:talk(
					1,
					"[Mt Baekdu Chest]: " .. pname .. " received " .. itemsLegendaryDesc[
						legendaryTable
					] .. "!"
				)
				itemsGained = itemsGained + 1
			end
			if itemsGained == 0 then
				player:sendMinitext("You open the Abyssal Chest, but it was empty!")

				--npc:sendAnimation(259)
				npc:talk(
					1,
					"[Mt Baekdu Chest]: Sorry " .. pname .. ", better luck next time!"
				)
				npc:sendAnimation(152)
				player:sendAction(12, 90)
			end

			if itemsGained > 0 then
				--player:talk(3,pname.. " items gained "..itemsgained.."!")
				player:sendAction(10, 90)
				player:sendAnimation(248)
				npc:sendAnimation(259)
				npc:playSound(123)
			end
			player.quest["baekdu_boss_killed"] = 0
		end
	end),

	onSayClick = async(function(player, npc)
		Tools.configureDialog(player, npc)
		local speech = string.lower(player.speech)

		if speech == "meow" then
			player:dialogSeq({"Meow?"}, 1)
		end
	end)
}
