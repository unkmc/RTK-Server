iconViewer = async(function(player, str)
	if (str == nil) then
		str = "n"
	end

	local buffer = "nothing"

	while buffer ~= "" do
		local x = player.registry["gfx_icons"]
		local y = player.registry["gfx_icons_color"]
		local t = {graphic = convertGraphic(x, "item"), color = y}

		player.npcGraphic = t.graphic
		player.npcColor = t.color

		player:dialogSeq({t, "Icon #: " .. x .. "\nColor #: " .. y}, 1)
		if (str == "n") then
			player.registry["gfx_icons"] = player.registry["gfx_icons"] + 1
			iconViewer(player, "n")
		elseif (str == "p") then
			player.registry["gfx_icons"] = player.registry["gfx_icons"] - 1
			iconViewer(player, "p")
		elseif (str == "nc") then
			player.registry["gfx_icons_color"] = player.registry[
				"gfx_icons_color"
			] + 1
			iconViewer(player, "nc")
		elseif (str == "pc") then
			player.registry["gfx_icons_color"] = player.registry[
				"gfx_icons_color"
			] - 1
			iconViewer(player, "pc")
		end
	end
end)
