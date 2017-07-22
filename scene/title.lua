--------------------------------------------
-- title @ scene
-- @ SF Software
--------------------------------------------
local scene_manager = require "base.scene_manager"
local utils = require "lib.utils"
local ui = require "ui"

local exitConfirm = require "scene.exitConfirm"
local map = require "scene.map"
local ui_test = require 'scene.ui_test'
local title = {}

local pos = {}
local focus = 1
local clock = 0
local cursor = {index = 1}

function title:enter()
	titleImage = love.graphics.newImage("resource/images/title-origin.jpg")
	title = {
		love.graphics.newText(NotoSansCJK_60, "Re: Shadow RPG")
	}
	titleBtns = {
		love.graphics.newText(NotoSansCJK_30, "Start"),
		love.graphics.newText(NotoSansCJK_30, "UI Test"),
		love.graphics.newText(NotoSansCJK_30, "Settings"),
		love.graphics.newText(NotoSansCJK_30, "Exit")
	}
	focus = 1
	clock = 0
end

function title:update()
	ui:selection(120, 480, 560, 90, {
		items = {"Start", "UI Test", "Settings", "Exit"},
		item_height = 30,
		item_width = 140,
		columns = 4,
		rows = 1,
		cursor = cursor
	})
	local x, y = love.mouse.getPosition()
	if clock < 30 then
		clock = clock + 1
	end
	focus = utils.select(pos, x, y) or focus
end

function title:draw()
	love.graphics.setColor(255, 255, 255, 255 / 30 * clock)
	love.graphics.draw(titleImage)
	utils.drawList(title, 0.35)
	pos = utils.drawList(titleBtns, 0.8, 0.15)
	if focus and utils.inRange(focus, 1, #pos) then
		love.graphics.line(pos[focus].x[1], pos[focus].y[2], pos[focus].x[2], pos[focus].y[2])
	end
	
end

function title:mousepressed(x, y, button, istouch)
	if button == 1 then
		local ret = utils.select(pos, x, y)
		if ret == 1 then
			return scene_manager:push(map)
		elseif ret == 2 then
			return scene_manager:push(ui_test)
		elseif ret == 3 then
		elseif ret == 4 then
			return scene_manager:push(exitConfirm)
		end
	end
end

return title 