
return function(ui, x, y, width, height, callback)
	local window = setmetatable({draw_queue = {n = 0}}, {__index = ui})
	if type(callback) == "function" then callback(window) end
	ui:registerDraw(function()
		ui.theme.window:draw(width, height)
		window:draw()
	end, x, y, width, height)	
end 