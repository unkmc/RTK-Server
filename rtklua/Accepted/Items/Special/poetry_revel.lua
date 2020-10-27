poetry_revel_1st_place = {
	use = function(player)
		player.registry["poetry_revel_1st"] = player.registry[
			"poetry_revel_1st"
		] + 1

		local times = player.registry["poetry_revel_1st"]

		if not player:hasLegend("poetry_revel_1st") then
			player:removeLegendbyName("poetry_revel_1st")
		end

		if times == 1 then
			player:addLegend(
				"First Place in Poetry Revel " .. times .. " time",
				"poetry_revel_1st",
				96,
				128
			)
		end
		if times > 1 then
			player:addLegend(
				"First Place in Poetry Revel " .. times .. " times",
				"poetry_revel_1st",
				96,
				128
			)
		end

		player:addKarma(math.random(0.25, 0.75))

		player:removeItem("poetry_revel_1st_place", 1)
	end
}
