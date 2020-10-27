mapTypes = {
	"green_squirrel_map",
	"lobsters_map",
	"haunted_house_map",
	"mythic_dragon_map",
	"mythic_snake_map",
	"mythic_rabbit_map",
	"mythic_monkey_map",
	"mythic_sheep_map",
	"mythic_ox_map"
}

mapMods = {
	"increased_mob_health",
	"decreased_player_health",
	"increased_player_armor",
	"decreased_player_armor",
	"increased_player_exp",
	"area_contains_bosses",
	"area_inhabited_by_ghosts",
	"area_inhabited_by_skeletons",
	"area_inhabited_by_goblins",
	"no_regeneration"
}
mapModStrings = {
	"+% more monster life",
	"-% less player health",
	"+# player AC",
	"-# player AC",
	"+% player experience",
	"Area contains # bosses",
	"Area inhabited by ghosts",
	"Area inhabited by skeletons",
	"Area inhabited by goblins",
	"Player unable to regenerate vita or mana"
}

mapMods2 = {
	{
		yname = "increased_mob_health",
		text = "+% more monster life",
		expmodifier = 0,
		range = {}
	},
	{
		yname = "increased_mob_damage",
		text = "+% more monster damage",
		expmodifier = 0,
		range = {}
	},
	{
		yname = "increased_player_exp",
		text = "+% player experience",
		expmodifier = 0,
		range = {}
	},
	{
		yname = "chance_drop_ambers",
		text = "Chance to drop ambers",
		expmodifier = 0,
		range = {1, 25}
	},
	{
		yname = "chance_drop_dark_ambers",
		text = "Chance to drop Dark Ambers",
		expmodifier = 0,
		range = {1, 25}
	},
	{
		yname = "chance_drop_yellow_ambers",
		text = "Chance to drop Yellow Ambers",
		expmodifier = 0,
		range = {1, 7}
	},
	{yname = "teeming", text = "Teeming", expmodifier = -33, range = {}},
	{yname = "healing", text = "Healing", expmodifier = 5, range = {}},
	{yname = "raging", text = "Raging", expmodifier = 10, range = {}}

	--[[
	,
	{
		yname = "decreased_player_health",
		text = "-% less player health",
		expmodifier = 5,
		range = {5,50}
	},
	{
		yname = "increased_player_armor",
		text = "+# player AC",
		expmodifier = 5,
		range = {5,50}
	},
	{
		yname = "decreased_player_armor",
		text = "-# player AC",
		expmodifier = 0,
		range = {5,50}
	},
	{
		yname = "area_contains_bosses",
		text = "Area contains # bosses",
		expmodifier = 5,
		range = {1,25}
	},
	{
		yname = "area_inhabited_by_ghosts",
		text = "Area inhabited by ghosts",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "area_inhabited_by_skeletons",
		text = "Area inhabited by skeletons",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "area_inhabited_by_goblins",
		text = "Area inhabited by goblins",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "no_regeneration",
		text = "Player unable to regenerate vita or mana",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "bolstering",
		text = "Bolstering",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "bursting",
		text = "Bursting",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "explosive",
		text = "Explosive",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "grievous",
		text = "Grievous",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "necrotic",
		text = "Nectroic",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "quaking",
		text = "Quaking",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "raging",
		text = "Raging",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "healing",
		text = "Healing",
		expmodifier = 5,
		range = {}
	},
	{
		yname = "teeming",
		text = "Teeming",
		expmodifier = 0,
		range = {}
	},
	{
		yname = "volcanic",
		text = "Volcanic",
		expmodifier = 5,
		range = {}
	}
	]]
	--
}

maps = {
	use = function(player)
		local item = player:getInventoryItem(player.invSlot)
		local mapMods = getMapModifiers(item.custom)

		if #mapMods == 0 then
			return
		end

		local modifiers = {}
		local values = {}

		for i = 1, #mapMods do
			if (i % 2 == 0) then
				table.insert(values, mapMods[i])
			elseif (i % 2 == 1) then
				table.insert(modifiers, mapMods[i])
			end
		end

		local text = "<b>T" .. item.dura .. " " .. item.name .. "\n"
		for i = 1, #modifiers do
			text = text .. "" .. maps.formatModifierString(
				modifiers[i],
				values[i]
			) .. "\n"
		end

		local width = 15
		local height = 15
		player:paperpopup(width, height, text)

		--player:popUp(text)
	end,

	formatModifierString = function(modifier, value)
		local text = ""

		for i = 1, #mapMods2 do
			if modifier == mapMods2[i].yname then
				text = mapMods2[i].text
			end
		end

		text = string.gsub(text, "%%", value .. "%%")
		text = string.gsub(text, "#", value)

		return text
	end,

	getExpMod = function(modifier)
		for i = 1, #mapMods2 do
			if (mapMods2[i].yname == modifier) then
				return mapMods2[i].expmodifier
			end
		end
		return 0
	end,

	getBaseModifiers = function(map, skill, player)
		-- this function used to define the basic attributes that will be on a given map type

		local modifiers, values = {}, {}

		local minval = 1
		local maxval = 5
		local tier = 1

		if skill == "novice" then
			minval = 5
			maxval = 10
			tier = 1
		elseif skill == "apprentice" then
			minval = 10
			maxval = 15
			tier = 2
		elseif skill == "accomplished" then
			minval = 15
			maxval = 20
			tier = 3
		elseif skill == "adept" then
			minval = 20
			maxval = 25
			tier = 4
		elseif skill == "talented" then
			minval = 25
			maxval = 30
			tier = 5
		elseif skill == "skilled" then
			minval = 30
			maxval = 35
			tier = 6
		elseif skill == "expert" then
			minval = 35
			maxval = 40
			tier = 7
		elseif skill == "master" then
			minval = 40
			maxval = 45
			tier = 8
		end

		local health = math.random(minval, maxval)
		local damage = math.random(minval, maxval)
		local experience = 0

		if (crafting.getSkillValue(player, "cartography") >= 0) then
			local rand = math.random(1, 2)
			if rand == 1 then
				local mod = math.random(4, #mapMods2)
				table.insert(modifiers, mapMods2[mod].yname)
				if (#mapMods2[mod].range > 0) then
					table.insert(
						values,
						math.random(
							mapMods2[mod].range[1],
							mapMods2[mod].range[2]
						)
					)
				else
					table.insert(values, 0)
				end
			end
		end

		if (crafting.getSkillValue(player, "cartography") >= 4) then
			local rand = math.random(1, 2)
			if rand == 1 then
				local mod = math.random(4, #mapMods2)
				table.insert(modifiers, mapMods2[mod].yname)
				if (#mapMods2[mod].range > 0) then
					table.insert(
						values,
						math.random(
							mapMods2[mod].range[1],
							mapMods2[mod].range[2]
						)
					)
				else
					table.insert(values, 0)
				end
			end
		end

		if (crafting.getSkillValue(player, "cartography") >= 8) then
			local rand = math.random(1, 2)
			if rand == 1 then
				local mod = math.random(4, #mapMods2)
				table.insert(modifiers, mapMods2[mod].yname)
				if (#mapMods2[mod].range > 0) then
					table.insert(
						values,
						math.random(
							mapMods2[mod].range[1],
							mapMods2[mod].range[2]
						)
					)
				else
					table.insert(values, 0)
				end
			end
		end

		if #modifiers > 0 then
			for i = 1, #modifiers do
				experience = experience + maps.getExpMod(modifiers[i])
			end
		end

		experience = experience + health
		experience = experience + (damage / 4)
		experience = math.floor(experience)

		table.insert(modifiers, "increased_mob_health")
		table.insert(modifiers, "increased_mob_damage")
		table.insert(modifiers, "increased_player_exp")

		table.insert(values, health)
		table.insert(values, damage)
		table.insert(values, experience)

		return modifiers, values, tier
	end
}
