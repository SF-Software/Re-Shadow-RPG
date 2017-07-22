--------------------------------------------
-- exitConfirm @ scene
-- @ SF Software
--------------------------------------------
local scene_manager = require "base.scene_manager"
local utils = require "lib.utils"

local exitConfirm = {}

local pos = {}
local focus = 1

function exitConfirm:enter()
	confirmMsg = {
		love.graphics.newText(NotoSansCJK_40, "Are you going to exit?")
	}
	confirmBtns = {
		love.graphics.newText(NotoSansCJK_30, "Yes"),
		love.graphics.newText(NotoSansCJK_30, "No")
	}
	clock = 0
	focus = 1
end

function exitConfirm:update()
	local x, y = love.mouse.getPosition()
	if clock <= 14 then
		clock = clock + 1
	end
	focus = utils.select(pos, x, y) or focus
end

function exitConfirm:draw()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	love.graphics.setColor(0, 0, 0, 255 / 20 * clock)
	love.graphics.polygon("fill",
		0, 0, 0, height,
		width, height, width, 0)
	love.graphics.setColor(0, 0, 0)
	love.graphics.polygon("fill",
		width * 0.2, height * 0.3, width * 0.2, height * 0.6,
		width * 0.8, height * 0.6, width * 0.8, height * 0.3)
	love.graphics.setColor(255, 255, 255)
	utils.drawList(confirmMsg, 0.4)
	pos = utils.drawList(confirmBtns, 0.5, 0.4)
	if focus and utils.inRange(focus, 1, #pos) then
		love.graphics.line(pos[focus].x[1], pos[focus].y[2], pos[focus].x[2], pos[focus].y[2])
	end
end

local function process()
	if focus == 1 then
		love.event.quit()
	elseif focus == 2 then
		scene_manager:pop()
	end
end

function exitConfirm:mousepressed(x, y, button, istouch)
	if button == 1 then
		process()
	end
end

function exitConfirm:keypressed(key)
	if key == "left" and focus > 1 then
		focus = focus - 1
	elseif key == "right" and focus < 2 then
		focus = focus + 1
	elseif key == "return" then
		return process()
	end
end


return exitConfirm 