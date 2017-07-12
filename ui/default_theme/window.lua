local vec = require 'lib.vector'
local utils = require 'lib.utils'
local assets_manager = require('lib.assets_manager')

local window = {windowskin = assets_manager.images.windowskin["ffixxpws"]}



local quad = {
	background = love.graphics.newQuad(0, 0, 128, 128, 192, 128),
	border = {}
}
for i = 0, 3 do
	for j = 0, 3 do
		quad.border[i * 4 + j] = love.graphics.newQuad(128 + 16 * j, i * 16, 16, 16, 192, 128)
	end
end
local function pos_to_quad(vec)
	return quad.border[vec.y * 4 + vec.x]
end

local function drawborder(windowskin, src_start, dst_start, dst_end, vec)
	local sv = vec * 16
	repeat
		love.graphics.draw(windowskin, pos_to_quad(src_start), dst_start:unpack())
		dst_start = dst_start + sv
		src_start = src_start + vec
		if vec.x ~= 0 then src_start.x = limit(src_start.x, 1, 2) end
		if vec.y ~= 0 then src_start.y = limit(src_start.y, 1, 2) end
	until dst_end <= dst_start
end
local v00 = vec(0, 0)
local v30 = vec(3, 0)
local v03 = vec(0, 3)
local v10 = vec(1, 0)
local v01 = vec(0, 1)
local v33 = vec(3, 3)

function window:draw(width, height)
	love.graphics.draw(self.windowskin, quad.background, 2, 2, 0,(width - 4) / 128,(height - 4) / 128)		
	drawborder(self.windowskin, v00, v00, vec(width, 0), v10) --上
	drawborder(self.windowskin, v00, v00, vec(0, height), v01) --左
	drawborder(self.windowskin, v30, vec(width - 16, 0), vec(width - 16, height), v01) --右
	drawborder(self.windowskin, v03, vec(0, height - 16), vec(width, height - 16), v10) --下
	
	love.graphics.draw(self.windowskin, pos_to_quad(v33), width - 16, height - 16)
end
return window 