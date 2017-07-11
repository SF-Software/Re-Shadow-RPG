
local all_callbacks = {'draw', 'errhand', 'update'}
for k in pairs(love.handlers) do
	all_callbacks[#all_callbacks + 1] = k
end

return function(self, callback)
	local registry = {}
	callbacks = callbacks or all_callbacks
	for _, f in ipairs(callbacks) do
		registry[f] = love[f] or __NULL__
		if self[f] then
			love[f] = function(...)
				registry[f](...)
				return self[f](self, ...)
			end
		end
	end
end 