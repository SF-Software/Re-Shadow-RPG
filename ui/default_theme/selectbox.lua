local assets_manager = require('lib.assets_manager')

local selectbox = {
	hori_space = 3,
	vert_space = 5,
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


function selectbox:draw(items, row, col, item_width, width, height, index)
	local item_height = self.font(self.font_size):getHeight()
	local index_r = math.floor(index / col)
	local index_c = index % col
	local iw = item_width + self.hori_space
	local ih = item_height + self.vert_space
	local ixs, iys = index_c * iw - self.hori_space, index_r * ih - self.vert_space
	local ix, iy = ixs, iys
	
	
	if ix + item_width > width then
		ix = math.max(self.hori_space, width - item_width + self.hori_space)
	end
	if iy + item_height > height then
		iy = math.max(self.vert_space, height - item_height + self.vert_space)
	end
	local px = ix - ixs
	local py = iy - iys
	print(px, py)
	for r = 0, row - 1 do
		for c = 0, col - 1 do
			if index == r * col + c + 1 then
				active(self, px + c * iw - self.hori_space, py + r * ih - self.vert_space, items[r * col + c + 1])
			else
				inactive(self, px + c * iw - self.hori_space, py + r * ih - self.vert_space, items[r * col + c + 1])
			end
		end
	end
end

return selectbox 