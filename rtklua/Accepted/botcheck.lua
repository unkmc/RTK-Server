botcheck_hash = setmetatable({}, mt_2D)
botcheck = {
	init = function(player)
		local key = player.name .. os.time() .. "secretphraseonlyweknowandtheywillneverguess"
		player:setCaptchaKey(key)
		botcheck_hash[player.ID] = player:getCaptchaKey()
		player.registry["botcheck"] = 1
		botchecker.cast(player)
		for z = 1, #player.group do
			if Player(player.group[z]).m == player.m then
				Player(player.group[z]):setDuration("harden_body_poet", 195000)
			end
		end
		player:msg(
			0,
			"Please read this carefully or your character will be jailed.",
			player.ID
		)
		player:msg(
			0,
			"Your character is being checked for AFK hunting.",
			player.ID
		)
		player:msg(
			0,
			"If you closed the window accidentally, please wait for the next one to appear.",
			player.ID
		)
		player:msg(
			0,
			"You will have 180 seconds to respond to the messages.",
			player.ID
		)
		player:msg(
			0,
			"If you fail to answer the captcha within the time limit or logout, your character will automatically be jailed.",
			player.ID
		)
		player:lock()
	end
}
