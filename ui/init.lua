
local BASE =(...) .. "."
local ui = {draw_queue = {n = 0}}
do
	local cx, cy = 0, 0
	local stack = {{cx, cy}}
	local o1 = love.graphics.push
	local o2 = love.graphics.pop
	function love.graphics.push(...)
		table.insert(stack, {cx, cy})
		o1(...)
	end
	function love.graphics.pop(...)		
		cx, cy = unpack(table.remove(stack))
		o2(...)
	end
	function love.graphics.translate_ex(x, y)
		cx = cx + x
		cy = cy + y
		love.graphics.translate(x, y)
	end
	function love.graphics.setScissor_ex(x, y, w, h)
		love.graphics.setScissor(x + cx, y + cy, w, h)
	end
end
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
		
		
		love.graphics.translate_ex(x, y)
		if w and h then
			love.graphics.setScissor_ex(0, 0, w, h)
		end
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
	selection = require(BASE .. 'selection')
}, {__index = ui}) 