local _resurrect = function(player, npc)
	Tools.configureDialog(player, npc)

	if (player.state ~= 1) then
		return
	end

	local rez = player:menuSeq(
		"Ah, another of the fallen come for my aid. Are you ready to return to the world of the living?",
		{"Yes", "No"},
		{}
	)

	if (rez ~= 1) then
		return
	end

	player.state = 0
	player.health = player.maxHealth
	player.magic = player.maxMagic
	player:sendStatus()
	player:updateState()
	player:dialogSeq({"So shall it be! Keep yourself safe and free from harm."}, 0)
end

local _showTotemAnimals = function(player, npc)
	local totems = {
		[0] = "Red Phoenix, mighty Ju Jak",
		[1] = "White Tiger, crafty Baekho",
		[2] = "Black Turtle, great Hyun moo",
		[3] = "Blue Dragon, fearsome Chung ryong"
	}

	local playerTotem = totems[player.totem]

	player:dialogSeq(
		{
			"You wish to learn of the totem animals, do you? The four totems are divine beings of great power.",
			"Ah, I see you worship the " .. playerTotem .. ". ((Press the letter s then page down to find your totem animal. You will see the word Nation and next to that will tell your totem.))",
			"Each animal rules a certain time of day. During an animal's time of day, all of his followers, and all of those grouped with his followers, learn more quickly. ((Experience bonus))"
		},
		1
	)

	local chungRyong = {graphic = convertGraphic(165, "monster"), color = 0}
	local baekho = {graphic = convertGraphic(162, "monster"), color = 0}
	local hyunMoo = {graphic = convertGraphic(164, "monster"), color = 0}
	local juJak = {graphic = convertGraphic(163, "monster"), color = 0}

	local descriptions = {
		chungRyong = "The Blue Dragon rules the East and thus the rising sun. His time of day is dawn. ((Hours 04 to 09))",
		baekho = "The White Tiger dwells in the West. He controls dusk, as the Sun enters his domain. ((Hours 15 to 21))",
		juJak = "The Red Phoenix rules the South. During the heat of noon, he is at his strongest. ((Hours 10 to 15))",
		hyunMoo = "The Black Turtle dwells in the North. Under the cover of midnight, he blesses his followers. ((Hours 22 to 03))"
	}

	player:dialogSeq({chungRyong, descriptions.chungRyong}, 1)
	player:dialogSeq({baekho, descriptions.baekho}, 1)
	player:dialogSeq({juJak, descriptions.juJak}, 1)
	player:dialogSeq({hyunMoo, descriptions.hyunMoo}, 1)
	Tools.configureDialog(player, npc)

	player:dialogSeq(
		{
			"By visiting the shrine of a totem animal, you may decide to worship it if you offer a suitable donation. These shrines can be found in the Wilderness.",
			"You can reaffirm your worship every 7 days ((21 hours)). Frequent worship of your totem animal will doubtless improve your Karma."
		},
		1
	)
end

local _questCheck = function(player, totemIndex)
	if (player.baseClass ~= 4 or player.quest["sun_armor"] ~= 3) then
		return
	end

	-- Poet Sun 3 quest for totems

	if (totemIndex == 3 and player.quest["sun_armor_ntotem"] == 0) then -- Chung Ryong
		player.quest["sun_armor_ntotem"] = 1
	end

	if (totemIndex == 1 and player.quest["sun_armor_ntotem"] == 1) then -- Baekho
		player.quest["sun_armor_ntotem"] = 2
	end

	if (totemIndex == 0 and player.quest["sun_armor_ntotem"] == 2) then -- Ju Jak
		player.quest["sun_armor_ntotem"] = 3
	end

	if (totemIndex == 2 and player.quest["sun_armor_ntotem"] == 3) then -- Hyun Moo
		player.quest["sun_armor_ntotem"] = 4
	end
end

local _worship = function(player, totemIndex)
	local timer = "totem_worship_daily_timer"
	local forceKarma = "totem_worship_karma_force"
	local worshipCount = "totem_total_worships"

	if (os.time() < player.registry[timer]) then
		player:dialogSeq({"You have worshipped a totem animal within the last 7 days ((21 hours))."}, 0)
		return
	end

	local totems = {
		[0] = {key = "ju_jak_key", name = "Ju Jak", type = "phoenix"},
		[1] = {key = "baekho_key", name = "Baekho", type = "tiger"},
		[2] = {key = "hyun_moo_key", name = "Hyun Moo", type = "turtle"},
		[3] = {key = "chung_ryong_key", name = "Chung Ryong", type = "dragon"}
	}

	local totem = totems[totemIndex]

	local choice1 = player:menuSeq(
		"Do you wish to worship " .. totem.name .. "?",
		{"Yes", "No"},
		{}
	)

	if (choice1 ~= 1) then
		player:dialogSeq({"Then begone with you."}, 0)
		return
	end

	local opts = {
		{item = totem.key, description = totem.name .. " key", amount = 1, karma = 0.25},
		{item = "gold_acorn", description = "Gold acorns", amount = 5, karma = 0.25},
		{item = "gold_acorn", description = "Gold acorn", amount = 1, karma = 0.125}
	}

	local choice2 = 3

	if (player.totem ~= totemIndex) then
		choice2 = player:menuSeq(
			"You must prove your devotion to " .. totem.name .. ".  Which do you offer?",
			{
				"I offer a " .. totem.name .. " key.",
				"I offer five Gold acorns.",
				"I have nothing to offer."
			},
			{}
		)

		if (choice2 == 3) then
			player:dialogSeq({"Then begone with you."}, 0)
			return
		end
	end

	local opt = opts[choice2]

	if (player:hasItem(opt.item, opt.amount) ~= true) then
		player:dialogSeq({"Return when you have the " .. opt.description .. "."}, 0)
		return
	end

	player:removeItem(opt.item, opt.amount)
	player.registry[timer] = os.time() + 75600 -- 21 IRL hours

	local chance = math.random(5)

	if (chance == 1 or player.registry[forceKarma] >= 5) then
		player:addKarma(opt.karma)
		player.registry[forceKarma] = 0
	else
		player.registry[forceKarma] = player.registry[forceKarma] + 1
	end

	_questCheck(player, totemIndex)
	player.totem = totemIndex
	player:sendMinitext("You worship the mighty " .. totem.name .. ".")
	player.registry[worshipCount] = player.registry[worshipCount] + 1
	player:calcStat()
	player:dialogSeq({totem.name .. " accepts your devotion."}, 0)
end

local _requestHelmet = function(player, totemIndex)
	local fishies = {
		"fish",
		"small_fish",
		"scrawny_fish",
		"tiny_fish",
		"tasty_fish",
		"large_fish",
		"delicious_fish"
	}

	local totems = {
		[0] = {id = "ju_jak", name = "Ju Jak", description = "mighty phoenix", subpath = 8, cost = "a Ju Jak key, one Fine metal, and 7,000 coins", items = {"fine_metal"}},
		[1] = {id = "baekho", name = "Baekho", description = "crafty tiger", subpath = 7, cost = "a Baekho key, one fish, and 7,000 coins", items = fishies},
		[2] = {id = "hyun_moo", name = "Hyun Moo", description = "great turtle", subpath = 9, cost = "a Hyun Moo key, one Fine cloth, and 7,000 coins", items = {"fine_cloth"}},
		[3] = {id = "chung_ryong", name = "Chung Ryong", description = "fearsome dragon", subpath = 6, cost = "a Chung Ryong key, 7,000 coins, and you must slay the Blood wolf"},
	}

	local totem = totems[totemIndex]

	if (player.totem ~= totemIndex) then
		player:dialogSeq({"You are not one who follows the " .. totem.description .. "."}, 0)
		return
	end

	if (player.class ~= totem.subpath) then
		player:dialogSeq({"The " .. totem.description .. " will not grant a helmet to one who has not attained mastery of his totem."}, 0)
		return
	end

	player:dialogSeq({"So ye who follows the " .. totem.description .. ", " .. totem.name .. ", wishes a helmet?"}, 1)

	local buychoice = player:menuSeq(
		"The cost of his protection is " .. totem.cost .. ". Do you wish to continue?",
		{
			"Yes, I would like the helmet.",
			"No, I do not wish to purchase one now."
		},
		{}
	)

	if (buychoice ~= 1) then
		player:dialogSeq({"Perhaps another time then."}, 0)
		return
	end

	local key = totem.id .. "_key"

	if (player:hasItem(key, 1) ~= true) then
		player:dialogSeq({"Return when you have the " .. totem.name .. " key."}, 0)
		return
	end

	if (player.money < 7000) then
		player:dialogSeq({"Return when you have the required gold."}, 0)
		return
	end

	if (player.totem == 3) then
		if (player:killCount("blood_wolf") == 0) then
			player:dialogSeq({"Return when you have slain the Blood wolf."}, 0)
			return
		end

		player:flushKills("blood_wolf")
	else
		local item

		for i = 1, #totem.items do
			if (player:hasItem(totem.items[i], 1) == true) then
				item = totem.items[i]
				break
			end
		end

		if (not item) then
			player:dialogSeq({"Return when you have " .. totem.cost .. "."}, 0)
			return
		end

		player:removeItem(item, 1)
	end

	local helm = totem.id .. "_helm"

	if (player.sex == 1) then
		helm = helm .. "et"
	end

	player:removeItem(key, 1)
	player:addItem(helm, 1, 0, player.ID)
	player:dialogSeq({"There you are. May it protect you well"}, 0)
end

local _sellItems = function(player, totemIndex)
	local totemIds = {"ju_jak", "baekho", "hyun_moo", "chung_ryong"}
	local itemId = totemIds[totemIndex]
	local price = math.floor(Item(itemId).sell * 1.2)

	player:sellExtend(
		"What are you willing to sell today?",
		{itemId},
		{price}
	)
end

local _showClickMenu = function(player, npc, totemIndex)

	Tools.configureDialog(player, npc)

	local totemNames = {
		[0] = "Ju Jak",
		[1] = "Baekho",
		[2] = "Hyun Moo",
		[3] = "Chung Ryong"
	}

	local totemName = totemNames[totemIndex]

	local opts = {
		"Totem Animals",
		"Worship " .. totemName,
		totemName .. " helmet"
	}

	if (Config.bossDropSalesEnabled) then
		table.insert(opts, "Sell")
	end

	local choice = player:menuSeq(
		"Hello! How can I help you today?",
		opts,
		{}
	)

	-- Totem Animals
	if choice == 1 then
		_showTotemAnimals(player, npc)
		return
	end

	-- Worship
	if choice == 2 then
		_worship(player, totemIndex)
		return
	end

	-- Helmet
	if choice == 3 then
		_requestHelmet(player, totemIndex)
		return
	end

	-- Sell items
	if (choice == 4) then
		_sellItems(player, totemIndex)
		return
	end
end

local _forgiveCheck = function(player, npc, totemIndex)
	Tools.configureDialog(player, npc)

	local totemMessages = {
		[0] = "The Soaring Bird forgives you.",
		[1] = "The Stealthful Tiger releases you.",
		[2] = "The Great Turtle blesses you.",
		[3] = "The Powerful Dragon pardons you."
	}

	local totemMsg = totemMessages[totemIndex]
	local forgiveTotem = "forgiveTotem"

	if (player.registry[forgiveTotem] == totemIndex) then
		player:sendMinitext(totemMsg)
		player.registry[forgiveTotem] = player.registry[forgiveTotem] + 1
	else
		player:sendMinitext("Your plea falls on deaf ears. Seek out another totem.")
		return
	end

	if (player.registry[forgiveTotem] < 4) then
		player:dialogSeq({"Please visit another totem to seek further forgiveness."}, 0)
		return
	end

	player.registry["forgiveTotem"] = 0

	if (player.quest["needsForgiveWarriorShieldTotem"] == 1) then
		player.quest["needsForgiveWarriorShieldTotem"] = 0
		player:sendMinitext("You have been forgiven for being a killer.")
	else
		player:dialogSeq({"You have been forgiven."}, 0)
	end
end

local _enableBaekdu = function(player)
	player:removeItem("chung_ryongs_might", 1)
	player.quest["instance"] = 8
	player:sendAnimation(3)
	player:sendMinitext("Your soul has been infused.")
	player:dialogSeq({"You may now travel to Mount Baekdu. Good luck."}, 0)
end

local _baekduCheck = function(player)
	if (player.quest["instance"] == 6) then
		if (player:hasItem("combined_map", 1) == true and
			player:hasItem("chung_ryongs_might", 1) == true) then

			if (player.totem == 3) then
				player:dialogSeq(
					{
						"Welcome disciple of Chung Ryong. It is good to see you.",
						"You wish to infuse your soul with the essence of a dragon?",
						"Stand still."
					},
					1
				)

				_enableBaekdu(player)
				return
			else
				player.quest["instance"] = 7

				player:dialogSeq(
					{
						"So you wish to travel to the sacred Baekdu mountain?",
						"Because you are not a disciple of Chung Ryong, it will cost you.",
						"Bring me Chung Ryong's key and I will infuse your soul with the essence."
					},
					0
				)

				return
			end
		end
	end

	if (player.quest["instance"] == 7) then
		if (player:hasItem("combined_map", 1) == true and
			player:hasItem("chung_ryongs_might", 1) == true and
			player:hasItem("chung_ryong_key", 1) == true) then

			player:dialogSeq({"You have done well. Stand still."}, 1)
			player:removeItem("chung_ryong_key", 1)
			_enableBaekdu(player)
		else
			player:dialogSeq({"Bring me Chung Ryong's key and I will infuse your soul with the essence."}, 1)
		end
	end
end

local _onSayClick = function(player, npc, totemIndex)
	Tools.configureDialog(player, npc)

	local speech = string.lower(player.speech)

	if (speech == "forgive" or speech == "forgiveness") then
		_forgiveCheck(player, npc)
		return
	end

	if (totemIndex == 3 and speech == "chung ryong's might" or speech == "might") then
		_baekduCheck(player)
		return
	end
end

local _totemIndexByName = {
	["BaekhoNpc"] = 1, -- Baekho
	["ChungRyongNpc"] = 3, -- Chung Ryong
	["HyunMooNpc"] = 2, -- Hyun Moo
	["JuJakNpc"] = 0  -- Ju Jak
}

BaekhoNpc = {
	click = async(function(player, npc)
		_resurrect(player, npc)
		_showClickMenu(player, npc, _totemIndexByName[npc.yname])
	end),

	questCheck = function(player, totem)
		_questCheck(player, totem)
	end,

	forgiveCheck = async(function(player, npc)
		_forgiveCheck(player, npc, _totemIndexByName[npc.yname])
	end),

	onSayClick = async(function(player, npc)
		_onSayClick(player, npc, _totemIndexByName[npc.yname])
	end)
}

HyunMooNpc = {
	click = async(function(player, npc)
		_resurrect(player, npc)
		_showClickMenu(player, npc, _totemIndexByName[npc.yname])
	end),

	questCheck = function(player, totem)
		_questCheck(player, totem)
	end,

	forgiveCheck = async(function(player, npc)
		_forgiveCheck(player, npc, _totemIndexByName[npc.yname])
	end),

	onSayClick = async(function(player, npc)
		_onSayClick(player, npc, _totemIndexByName[npc.yname])
	end)
}

ChungRyongNpc = {
	click = async(function(player, npc)
		_resurrect(player, npc)
		_showClickMenu(player, npc, _totemIndexByName[npc.yname])
	end),

	questCheck = function(player, totem)
		_questCheck(player, totem)
	end,

	forgiveCheck = async(function(player, npc)
		_forgiveCheck(player, npc, _totemIndexByName[npc.yname])
	end),

	onSayClick = async(function(player, npc)
		_onSayClick(player, npc, _totemIndexByName[npc.yname])
	end)
}

JuJakNpc = {
	click = async(function(player, npc)
		_resurrect(player, npc)
		_showClickMenu(player, npc, _totemIndexByName[npc.yname])
	end),

	questCheck = function(player, totem)
		_questCheck(player, totem)
	end,

	forgiveCheck = async(function(player, npc)
		_forgiveCheck(player, npc, _totemIndexByName[npc.yname])
	end),

	onSayClick = async(function(player, npc)
		_onSayClick(player, npc, _totemIndexByName[npc.yname])
	end)
}
