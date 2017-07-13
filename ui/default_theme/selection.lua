local assets_manager = require('lib.assets_manager')

local selection = {
	hori_space = 3,
	vert_space = 0,
	font = assets_manager.fonts["NotoSansCJKtc-Regular"],
	font_size = 20
}

local function active(self, x, y, text, w)
	local f = self.font(self.font_size)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(f)
	love.graphics.line(x, y + f:getHeight(), x + f:getWidth(text), y + f:getHeight())
	love.graphics.print(text, x + 2, y)
end
local function inactive(self, x, y, text, w)
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
local function disabled_active(self, x, y, text, w)
	local f = self.font(self.font_size)
	love.graphics.setColor(128, 128, 128)
	love.graphics.setFont(f)
	love.graphics.print(text, x + 2, y)
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(x, y + f:getHeight(), x + f:getWidth(text), y + f:getHeight())
end


function selection:draw(items, row, col, item_width, width, height, index)
	local item_height = self.font(self.font_size):getHeight()
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
	
	local px = ix - ixs
	local py = iy - iys
	for r = 0, row - 1 do
		for c = 0, col - 1 do
			if index == r * col + c then
				active(self, px + c * iw, py + r * ih, items[r * col + c + 1])
			else
				inactive(self, px + c * iw, py + r * ih, items[r * col + c + 1])
			end
		end
	end
end

return selection 