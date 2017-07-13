local assets_manager = require('lib.assets_manager')

local selection = {
	hori_space = 3,
	vert_space = 0,
	windowskin = assets_manager.images.windowskin["ffixxpws"],
	font = assets_manager.fonts["NotoSansCJKtc-Regular"],
	font_size = 20
}
local cursor_quad = love.graphics.newQuad(128, 64, 32, 32, 192, 128)
local function normal(self, x, y, text, w)
	local f = self.font(self.font_size)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(f)
	love.graphics.print(text, x + 2, y)
end

local function disabled(self, x, y, text, w)
	local f = self.font(self.font_size)
	love.graphics.setColor(128, 128, 128)
	love.graphics.setFont(f)
	love.graphics.print(text, x + 2, y)
end
local function draw_cursor(self, x, y, width, height, cursor)
	cursor.type = cursor.type or 1
	if cursor.type == 1 then
		love.graphics.draw(self.windowskin, cursor_quad, x, y, 0, width / 32, height / 32)
	elseif cursor.type == 2 then
	end
end

function selection:draw(items, row, col, item_width, item_height, width, height, cursor)
	local index = cursor.index
	local index_r = math.floor(index / col)
	local index_c = index % col
	local iw = item_width + self.hori_space
	local ih = item_height + self.vert_space
	local ixs, iys = index_c * iw, index_r * ih
	local ix, iy = ixs, iys
	if ix + item_width > width then
		ix = math.max(0, width - item_width)
	end
	if iy + item_height > height then		
		iy = math.max(0, height - item_height)
	end
	
	draw_cursor(self, ix, iy, item_width, item_height, cursor)
	
	local px = ix - ixs
	local py = iy - iys
	for r = 0, row - 1 do
		for c = 0, col - 1 do			
			normal(self, px + c * iw, py + r * ih, items[r * col + c + 1])
		end
	end
	
end

return selection 