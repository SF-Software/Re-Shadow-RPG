local assets_manager = require('lib.assets_manager')

local selectbox = {distance = 30, font = assets_manager.fonts["NotoSansCJKtc-Regular"], font_size = "20"}

local function active(self, x, y, text, w)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(self.font)
	love.graphics.line(x, y + self.font:getHeight(), x + self.font:getWidth(text), y + self.font:getHeight())
	love.graphics.print(text, 2, 0)
end
local function inactive(self, x, y, text, w)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setFont(self.font)
	love.graphics.print(text, x + 2, y)
end
local function disabled(self, x, y, text, w)
	love.graphics.setColor(128, 128, 128)
	love.graphics.setFont(self.font)
	love.graphics.print(text, x + 2, y)
end
local function disabled_active(self, x, y, text, w)
	love.graphics.setColor(128, 128, 128)
	love.graphics.setFont(self.font)
	love.graphics.print(text, x + 2, y)
	love.graphics.setColor(0, 0, 0)
	love.graphics.line(x, y + self.font:getHeight(), x + self.font:getWidth(text), y + self.font:getHeight())
end


function selectbox:draw(items, row, col, width, height, index)
	local item_width =(width -(col - 1) * self.hori_space) / col
	local item_height = self.font:getHeight()
	
	for r = 0, row - 1 do
		for c = 0, col - 1 do
			
		end
	end
end

return selectbox 