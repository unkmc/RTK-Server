ogre_message = {
	use = function(player)
		local width = 10
		local height = 15

		local charset = {}
		do
			-- [0-9a-zA-Z]
			for c = 1, 20 do
				table.insert(charset, string.char(32))
			end

			-- space
			for c = 48, 57 do
				table.insert(charset, string.char(c))
			end
			for c = 65, 90 do
				table.insert(charset, string.char(c))
			end
			for c = 97, 122 do
				table.insert(charset, string.char(c))
			end
		end

		local function randomString(length)
			if not length or length <= 0 then
				return ''
			end
			math.randomseed(os.clock() ^ 5)
			return randomString(length - 1) .. charset[math.random(1, #charset)]
		end

		local note = randomString(12)

		player:paperpopup(width, height, note)
	end
}
