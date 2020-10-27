ping = {
	while_cast = function(player)
		player:talk(2, "Ping: " .. player.ping .. "ms")
	end,

	requirements = function(player)
		local level = 5
		local item = {0}
		local amounts = {50}
		local txt = "In order to learn this spell, you must bring me:\n\n"
		for i = 1, #item do
			txt = txt .. "" .. amounts[i] .. " " .. Item(item[i]).name .. "\n"
		end

		local desc = {"A spell to light the way for you and your party.", txt}
		return level, item, amounts, desc
	end
}
