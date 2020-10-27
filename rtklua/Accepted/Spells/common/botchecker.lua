botchecker = {
	cast = function(player)
		player:popUp("<b>Please read this carefully or your character will be jailed.\n\nYour character is being checked for AFK hunting.\n\nIf you closed the window accidentally, please wait for the next one to appear.\n\nYou will have 180 seconds to respond to the messages.\n\nIf you fail to answer the captcha within the time limit or logout, your character will automatically be jailed.")
		player:setDuration("botchecker", 195000)
		characterLog.bottingLog(
			player,
			"Botting check initiated on " .. player.name
		)
	end,
	while_cast = function(player)
		if #player:getCaptchaKey() == 0 then
			player:setDuration("botchecker", 0)
		end
		if player:getDuration("botchecker") == 180000 then
			player:sendURL(
				0,
				"https://tk0.retrotk.com/captcha/?name=" .. player.name .. "&key=" .. botcheck_hash[
					player.ID
				]
			)
			characterLog.bottingLog(
				player,
				"First Botting check window sent to " .. player.name
			)
		end
		if player:getDuration("botchecker") == 120000 then
			player:sendURL(
				0,
				"https://tk0.retrotk.com/captcha/?name=" .. player.name .. "&key=" .. botcheck_hash[
					player.ID
				]
			)
			characterLog.bottingLog(
				player,
				"Second Botting check window sent to " .. player.name
			)
		end
		if player:getDuration("botchecker") == 60000 then
			player:msg(
				0,
				"Final attempt. If you do not answer this, you will be jailed.",
				player.ID
			)
			player:sendURL(
				0,
				"https://tk0.retrotk.com/captcha/?name=" .. player.name .. "&key=" .. botcheck_hash[
					player.ID
				]
			)
			characterLog.bottingLog(
				player,
				"Third/Final Botting check window sent to " .. player.name
			)
		end
	end,
	uncast = function(player)
		if #player:getCaptchaKey() == 0 then
			player:unlock()
			characterLog.bottingLog(
				player,
				player.name .. " successfully answered the bot check and has been unlocked."
			)
		else
			player:sendURL(0, "https://tk0.retrotk.com/captcha/fail.php")
			player:warp(666, 3, 4)
			player:unlock()
			characterLog.bottingLog(
				player,
				player.name .. " warped to jail for AFK Botting."
			)
		end
	end
}
