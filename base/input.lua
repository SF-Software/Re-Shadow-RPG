local input = {}
local key_status = {}
function input:update()
	for k, v in key_status do
		key_status[k] = v + 1
	end
end
function input:keypressed(key)
	
end
function input:keyreleased(key)
	table.remove(key_status, key)
end
return input 