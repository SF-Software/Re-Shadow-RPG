--------------------------------------------
-- title @ scene
-- @ SF Software
--------------------------------------------
local scene_manager = require "lib.scene_manager"
local utils = require "lib.utils"
local exitConfirm = require "scene.exitConfirm"
local map = require "scene.map"

module(..., package.seeall)

local pos = {}
local focus = 1
local clock = 0

function enter()
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
	focus = 1
	clock = 0
end

function update(x, y)
	if clock < 30 then
		clock = clock + 1
	end
	focus = select(pos, x, y) or focus
end

function draw()
	love.graphics.setColor(255, 255, 255, 255 / 30 * clock)
	love.graphics.draw(titleImage)
	utils.drawList(title, 0.35)
	pos = utils.drawList(titleBtns, 0.8, 0.15)
	if focus and inRange(focus, 1, #pos) then
		love.graphics.line(pos[focus].x[1], pos[focus].y[2], pos[focus].x[2], pos[focus].y[2])
	end
end

function onMousePress(button, x, y)
	if button == 1 then
		local ret = select(pos, x, y)
		if ret == 1 then
			return scene_manager.push(map)
		elseif ret == 2 then
		elseif ret == 3 then
		elseif ret == 4 then
			return scene_manager.push(exitConfirm)
		end
	end
end