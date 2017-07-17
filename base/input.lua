local input = {}
local key_status = {}
function input:update()
	for k, v in pairs(key_status) do
		key_status[k] = v + 1
	end
end
function input:keypressed(key)
	if not key_status[key] then
		key_status[key] = 0
	end
end
function input:keyreleased(key)
	key_status[key] = nil
end

function input.key_press(key)
	return key_status[key] ~= nil
end
function input.key_trigger(key)
	return key_status[key] == 1
end
function input.key_repeat(key, d)
	d = d or 4
	return key_status[key] ~= nil and(key_status[key] == 1 or(key_status[key] > 10 and key_status[key] % d == 0))
end

return input 