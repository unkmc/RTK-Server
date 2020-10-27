gm_sage = {
	cast = function(player)
		if player.gmLevel ~= 99 then
			return
		end

		local string = "[GM " .. player.name .. "]: " .. player.question

		gmbroadcast(-1, string)
		characterLog.sage(player, player.question)
	end
}
