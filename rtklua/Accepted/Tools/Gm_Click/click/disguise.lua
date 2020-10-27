disguisee = {
	option = function(player, target)
		player.npcGraphic = convertGraphic(
			player.registry["gfx_dis"],
			"monster"
		)
		player.npcColor = player.registry["gfx_disC"]
		player.dialogType = 0
		local dis, text, dialog = "", "", "<b>[" .. target.name .. "'s Disguised]\n\nState    : " .. target.state .. " (" .. getStateInfo(target) .. ")\nDisguise : " .. player.registry[
			"gfx_dis"
		] .. "\nColor    : " .. player.registry["gfx_disC"] .. "\n"
		if target.state ~= 4 then
			dis = "OFF"
		else
			dis = "ON"
		end
		local opts = {
			"Browse Disguised look",
			"Browse Disguised Color",
			"Change Id and color to this look"
		}
		if target.state ~= 4 then
			table.insert(opts, "Transform target to monster")
		end
		table.insert(opts, "<< Back")
		option = player:menuString(dialog .. "Make your choice", opts)

		if option == "Transform target to monster" then
			target.state = 4
			target:updateState()
			target:sendMinitext("Transformed to monster!")
			player:sendMinitext("Done!!")
			disguisee.option(player, target)
		elseif option == "Browse Disguised look" then
			player.registry["browse_dis"] = 1
			player.registry["browse_disC"] = 0
			player.registry["gfx_dis"] = target.disguise
			player.registry["gfx_disC"] = target.disguiseC
			disguisee.browse(player, target)
		elseif option == "Browse Disguised Color" then
			player.registry["browse_dis"] = 0
			player.registry["browse_disC"] = 1
			player.registry["gfx_dis"] = target.disguise
			player.registry["gfx_disC"] = target.disguiseC
			disguisee.browse(player, target)
		elseif option == "Change Id and color to this look" then
			target.disguise = player.registry["gfx_dis"]
			target.disguiseC = player.registry["gfx_disC"]
			target:updateState()
			target:sendMinitext("Changed look!")
			player:sendMinitext("Done!!")
			disguisee.option(player, target)
		elseif option == "<< Back" then
			click.look(player, target, NPC(66))
		end
	end,

	browse = function(player, target)
		local name = "<b>[" .. target.name .. "'s disguise]\n\n"
		local dialog = "<b>[" .. target.name .. "'s Disguised]\n\nState    : " .. target.state .. " (" .. getStateInfo(target) .. ")\nDisguise : " .. player.registry[
			"gfx_dis"
		] .. "\nColor    : " .. player.registry["gfx_disC"] .. "\n"
		player.npcGraphic = convertGraphic(
			player.registry["gfx_dis"],
			"monster"
		)
		player.npcColor = player.registry["gfx_disC"]
		player.dialogType = 0

		local opts = {"Next >>", "Options", "To number", "<< Previous"}
		menu = player:menuSeq(dialog, opts, {})

		if menu == 1 then
			if player.registry["browse_dis"] == 1 and player.registry["browse_disC"] == 0 then
				if player.registry["gfx_dis"] > 1449 then
					player.registry["gfx_dis"] = 0
				else
					if player.registry["gfx_dis"] == 1341 or player.registry["gfx_dis"] == 1393 then
						player.registry["gfx_dis"] = player.registry["gfx_dis"] + 2
					else
						player.registry["gfx_dis"] = player.registry["gfx_dis"] + 1
					end
				end
			elseif player.registry["browse_dis"] == 0 and player.registry[
				"browse_disC"
			] == 1 then
				if player.registry["gfx_disC"] > 255 then
					player.registry["gfx_disC"] = 0
				else
					player.registry["gfx_disC"] = player.registry["gfx_disC"] + 1
				end
			end
			disguisee.browse(player, target, dialog)
		elseif menu == 2 then
			disguisee.option(player, target, dialog)
		elseif menu == 3 then
			ton = player:menuString(
				name .. "What do you want to change from target?",
				{"Disguise look", "Disguise Color"}
			)
			if ton ~= nil then
				if ton == "Disguise look" then
					player.registry["dis_num"] = 1
					player.registry["disC_num"] = 0
				elseif ton == "Disguise color" then
					player.registry["dis_num"] = 0
					player.registry["disC_num"] = 1
				end
				if player.registry["dis_num"] == 1 and player.registry["disC_num"] == 0 then
					temp = " look"
				elseif player.registry["dis_num"] == 0 and player.registry[
					"disC_num"
				] == 1 then
					temp = " color"
				end
				num = math.abs(tonumber(math.ceil(player:input(name .. "Enter disguise" .. temp .. " number\nMax: " .. tempp))))
				if num > 0 then
					if player.registry["dis_num"] == 1 and player.registry["disC_num"] == 0 then
						if num > 1449 then
							player:dialogSeq(
								{
									name .. "Invalid disguise look number!\n(Max: 1449)"
								},
								1
							)
							disguisee.browse(player, target)
						elseif num == 1341 or num == 1393 then
							player:dialogSeq(
								{
									name .. "Invalid disguise number!\nNote:\n1341 and 1393 disguise number cause crash on server!"
								},
								1
							)
							disguisee.browse(player, target)
						else
							target.disguise = num
							player:sendMinitext("Changed look!")
							disguisee.option(player, target)
						end
					elseif player.registry["dis_num"] == 0 and player.registry[
						"disC_num"
					] == 1 then
						if num > 255 then
							player:dialogSeq(
								{
									name .. "Invalid disguise" .. temp .. " number!\n(Max: " .. tempp .. ")"
								},
								1
							)
							disguisee.browse(player, target)
						end
					end
					target:updateState()
				end
			end
		elseif menu == 4 then
			if player.registry["browse_dis"] == 1 and player.registry["browse_disC"] == 0 then
				if player.registry["gfx_dis"] < 0 then
					player.registry["gfx_dis"] = 1449
				else
					if player.registry["gfx_dis"] == 1343 or player.registry["gfx_dis"] == 1395 then
						player.registry["gfx_dis"] = player.registry["gfx_dis"] - 2
					else
						player.registry["gfx_dis"] = player.registry["gfx_dis"] - 1
					end
				end
			elseif player.registry["browse_dis"] == 0 and player.registry[
				"browse_disC"
			] == 1 then
				if player.registry["gfx_disC"] < 0 then
					player.registry["gfx_disC"] = 255
				else
					player.registry["gfx_disC"] = player.registry["gfx_disC"] - 1
				end
			end
			disguisee.browse(player, target, dialog)
		end
	end
}

getStateInfo = function(player)
	if player.state == 0 then
		return "Alive"
	end
	if player.state == 1 then
		return "Death"
	end
	if player.state == 2 then
		return "Invisible"
	end
	if player.state == 3 then
		return "Mounted"
	end
	if player.state == 4 then
		return "Disguised"
	end
end
