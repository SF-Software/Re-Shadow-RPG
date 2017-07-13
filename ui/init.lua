
local BASE =(...) .. "."
local ui = {draw_queue = {n = 0}}


ui.clean = {}
function ui.clean:update()	
	ui.draw_queue.n = 0
end
function ui:init(theme)
	self.theme = theme or require(BASE .. 'default_theme')
end
function ui:draw()
	love.graphics.push('all')
	for i = self.draw_queue.n, 1, - 1 do
		self.draw_queue[i]()
	end
	love.graphics.pop()
end

function ui:registerDraw(callback, x, y, w, h)
	self.draw_queue = self.draw_queue or {n = 0}
	self.draw_queue.n = self.draw_queue.n + 1
	self.draw_queue[self.draw_queue.n] = function()
		love.graphics.push("all")
		
		if w and h then
			love.graphics.setScissor(x, y, w, h)
		end
		love.graphics.translate(x, y)
		callback()
		love.graphics.pop()
		
	end
end
function ui:with_theme(theme, key, callback)
	if not callback then
		callback = key
		local old_t = self.theme
		self.theme = theme
		callback(self)
		self.theme = old_t
	else
		local old_t = self.theme[key]
		self.theme[key] = theme
		callback(self)
		self.theme[key] = old_t
	end
	
end

return setmetatable({
	window = require(BASE .. 'window'),
	selectbox = require(BASE .. 'selectbox')
}, {__index = ui}) 