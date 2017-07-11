--------------------------------------------
-- exitConfirm @ scene
-- @ SF Software
--------------------------------------------
local scene_manager = require "lib.scene_manager"
local utils = require "lib.utils"

local exitConfirm = {}

local pos = {}
local focus = 1

function exitConfirm:enter()
	titleImage = love.graphics.newImage("resource/images/title-origin.jpg")
	title = {
		love.graphics.newText(NotoSansCJK_60, "Re: Shadow RPG")
	}
	titleBtns = {
		love.graphics.newText(NotoSansCJK_30, "Start"),
		love.graphics.newText(NotoSansCJK_30, "Load"),
		love.graphics.newText(NotoSansCJK_30, "Settings"),
		love.graphics.newText(NotoSansCJK_30, "Exit")
	}
	confirmMsg = {
		love.graphics.newText(NotoSansCJK_40, "Are you going to exit?")
	}
	confirmBtns = {
		love.graphics.newText(NotoSansCJK_30, "Yes"),
		love.graphics.newText(NotoSansCJK_30, "No")
	}
	clock = 20
	focus = 1
end

function exitConfirm:update()
	local x, y = love.mouse.getPosition()
	clock = clock - 1
	if clock < 5 then
		clock = 5
	end
	focus = utils.select(pos, x, y) or focus
end

function exitConfirm:draw()
	love.graphics.setColor(255, 255, 255, 255 / 20 * clock)
	love.graphics.draw(titleImage)
	utils.drawList(title, 0.35)
	pos = utils.drawList(titleBtns, 0.8, 0.15)
	love.graphics.line(pos[4].x[1], pos[4].y[2], pos[4].x[2], pos[4].y[2])
	love.graphics.setColor(0, 0, 0)
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
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

function exitConfirm:mousepressed(x, y, button, istouch)
	if button == 1 then
		local ret = utils.select(pos, x, y)
		if ret == 1 then
			love.event.quit()
		elseif ret == 2 then
			scene_manager:pop()
		end
	end
end

return exitConfirm 