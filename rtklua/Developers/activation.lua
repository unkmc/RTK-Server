sendEmail = function(player, email)
	-- load the smtp support
	local smtp = require("socket.smtp")

	-- Connects to server "localhost" and sends a message to users
	-- "fulano@example.com",  "beltrano@example.com",
	-- and "sicrano@example.com".
	-- Note that "fulano" is the primary recipient, "beltrano" receives a
	-- carbon copy and neither of them knows that "sicrano" received a blind
	-- carbon copy of the message.

	from = "<accounts@mornatales.com>"

	rcpt = "<" .. email .. ">"

	local success = false
	local key = generateKey(16)

	if (key == nil) then
		player:msg(
			0,
			"Error generating key. Please contact a GM for assistance.",
			player.ID
		)
		return
	end

	success = player:addActivationKey(key)

	if (success == false) then
		player:msg(
			0,
			"Error adding activation key to character. Please contact a GM for assistance.",
			player.ID
		)
		return
	end

	mesgt = {
		headers = {to = "<" .. email .. ">"},
		body = "Hello " .. player.name .. ",\n\nWelcome to MornaTK. Please enter the following key in the F1 menu -> Activate. Doing so will allow you to pick a path and progress past level 5.\n\nKEY: " .. key
	}

	r, e = smtp.send {
		from = from,
		port = 7819,
		rcpt = rcpt,
		source = smtp.message(mesgt)
	}

	if (e == false) then
		player:msg(
			0,
			"Error sending activation email. Please contact a GM for assistance.",
			player.ID
		)
		return
	end
end

generateKey = function(length)
	if length < 1 then
		return nil
	end

	-- Check for l < 1
	local key = ""

	-- Start string
	for i = 1, length do
		key = key .. string.char(math.random(33, 125))

		-- Generate random number from 32 to 126, turn it into character and add to string
	end

	return key
end

checkActivation = function(player, key)
	local success = player:checkActivationKey(key)

	if (success == false) then
		player:msg(
			0,
			"Key is invalid. If you are sure you copied the correct key, please resend authentication email under option F1 menu -> Activate.",
			player.ID
		)
		return false
	else
		player.actId = 1
		player:msg(
			0,
			"Congratulations on successfully registering for MornaTK. You can now progress past level 5 and may choose a path.",
			player.ID
		)
		return true
	end
end
