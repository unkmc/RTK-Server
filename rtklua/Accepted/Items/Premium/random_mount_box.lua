random_mount_i = {
	use = function(player)
		local mounts = {}
		local commonMounts, rareMounts, ultraRareMounts = random_mount_i.mounts()
		for i = 1, 5 do
			for j = 1, #commonMounts do
				table.insert(mounts, commonMounts[j])
			end
		end
		for i = 1, 3 do
			for j = 1, #rareMounts do
				table.insert(mounts, rareMounts[j])
			end
		end
		for i = 1, 1 do
			for j = 1, #ultraRareMounts do
				table.insert(mounts, ultraRareMounts[j])
			end
		end
		local givenMount = Item(mounts[math.random(1, #mounts)])
		if not player:hasSpace(givenMount.yname, 1) then
			player:sendMinitext("Your bag is full.")
			return
		end
		if player:hasItem("random_mount_i", 1) ~= true then
			return
		end
		broadcast(
			-1,
			player.name .. " opened Random Mount Box I and received " .. givenMount.name .. "!"
		)
		player:sendMinitext("You've opened your box and received " .. givenMount.name .. "!")
		player:addItem(givenMount.yname, 1)
		player:removeItem("random_mount_i", 1)
	end,

	mounts = function()
		local commonMounts = {
			"blue_bull_mount",
			"brown_bull_mount",
			"black_bull_mount",
			"white_bull_mount",
			"red_bull_mount",
			"brown_warthog_mount",
			"black_warthog_mount",
			"deer_horn",
			"argyle_deer_horn"
		}
		local rareMounts = {
			"fox_mount",
			"snow_fox_mount",
			"snow_winter_fox_mount",
			"black_winter_fox_mount",
			"ice_winter_fox_mount",
			"blue_tip_winter_fox_mount",
			"pink_winter_fox_mount",
			"purple_winter_fox_mount",
			"gold_winter_fox_mount",
			"night_winter_fox_mount",
			"brown_winter_fox_mount",
			"purple_tip_winter_fox_mount",
			"stealth_winter_fox_mount",
			"green_firetail_mount",
			"blue_firetail_mount",
			"brown_firetail_mount",
			"purple_firetail_mount",
			"black_firetail_mount",
			"dark_green_firetail_mount",
			"white_firetail_mount",
			"gold_firetail_mount",
			"red_firetail_mount",
			"stone_firetail_mount"
		}
		local ultraRareMounts = {
			"scorpion_mount",
			"black_scorpion_mount",
			"red_scorpion_mount"
		}
		return commonMounts, rareMounts, ultraRareMounts
	end
}

random_mount_ii = {
	use = function(player)
		local mounts = {}
		local commonMounts, rareMounts, ultraRareMounts = random_mount_ii.mounts()
		for i = 1, 4 do
			for j = 1, #commonMounts do
				table.insert(mounts, commonMounts[j])
			end
		end
		for i = 1, 3 do
			for j = 1, #rareMounts do
				table.insert(mounts, rareMounts[j])
			end
		end
		for i = 1, 2 do
			for j = 1, #ultraRareMounts do
				table.insert(mounts, ultraRareMounts[j])
			end
		end
		local givenMount = Item(mounts[math.random(1, #mounts)])
		if not player:hasSpace(givenMount.yname, 1) then
			player:sendMinitext("Your bag is full.")
			return
		end
		if player:hasItem("random_mount_ii", 1) ~= true then
			return
		end
		broadcast(
			-1,
			player.name .. " opened Random Mount Box II and received " .. givenMount.name .. "!"
		)
		player:sendMinitext("You've opened your box and received " .. givenMount.name .. "!")
		player:addItem(givenMount.yname, 1)
		player:removeItem("random_mount_ii", 1)
	end,

	mounts = function()
		local commonMounts = {
			"mountain_goat_pan_flute",
			"red_mountain_goat_pan_flute",
			"tourmaline_dragon_dog",
			"alexandrite_dragon_dog",
			"bamboo_dragon_dog",
			"peridot_dragon_dog",
			"rhodonite_dragon_dog",
			"sodalite_dragon_dog",
			"archon_dragon_dog",
			"jasper_dragon_dog",
			"phantom_dragon_dog",
			"sardonyx_dragon_dog",
			"onyx_dragon_dog",
			"tempest_dragon_dog",
			"raheem_dragon_dog",
			"ruby_dragon_dog",
			"forest_dragon_dog",
			"ivy_dragon_dog",
			"lazuli_dragon_dog",
			"aragonite_dragon_dog",
			"garnet_dragon_dog",
			"amethyst_dragon_dog",
			"bloodstone_dragon_dog",
			"topaz_dragon_dog",
			"earth_dragon_dog",
			"twilight_dragon_dog",
			"pig_mount",
			"brown_chicken_mount",
			"white_chicken_mount",
			"black_elephant_mount",
			"brown_elephant_mount",
			"maroon_elephant_mount",
			"green_elephant_mount",
			"slateblue_elephant_mount",
			"purple_lamb_mount",
			"grey_lamb_mount",
			"yellow_lamb_mount",
			"brown_lion_mount",
			"grey_lion_mount",
			"silver_lion_mount"
		}
		local rareMounts = {
			"fiery_winter_fox_mount",
			"forest_winter_fox_mount",
			"muddy_boots_mount",
			"headless_horsemans_horse",
			"fennec_mount",
			"pomeranian_mount",
			"green_ceratops_mount",
			"cyan_ceratops_mount",
			"red_ceratops_mount",
			"black_ceratops_mount",
			"eagle_mount",
			"green_rhino_mount",
			"blue_rhino_mount",
			"brown_rhino_mount",
			"purple_rhino_mount",
			"black_rhino_mount",
			"dark_green_rhino_mount",
			"white_rhino_mount",
			"gold_rhino_mount",
			"red_rhino_mount",
			"stone_rhino_mount"
		}
		local ultraRareMounts = {
			"blue_ninetails_mount",
			"brown_ninetails_mount",
			"purple_ninetails_mount",
			"black_ninetails_mount",
			"white_ninetails_mount",
			"gold_ninetails_mount",
			"red_ninetails_mount",
			"pegasus_mount",
			"zebra_mount",
		}
		return commonMounts, rareMounts, ultraRareMounts
	end
}

random_mount_iii = {}
