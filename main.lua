--------------------------------------------
-- Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local tick = require "base.tick"
local scene_manager = require "base.scene_manager"
local utils = require "lib.utils"
local title = require "scene.title"
local ui = require 'ui'
local registerEvents = require 'base.register_events'

--------------------------------------------
-- load @ love
--------------------------------------------
function love.load()
	tick.rate = 1 / 60
	NotoSansCJK_30 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 30)
	NotoSansCJK_40 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 40)
	NotoSansCJK_60 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 60)
	ui:init()
	
	registerEvents(ui.clean)
	registerEvents(scene_manager)
	registerEvents(ui)
	registerEvents({draw = function()
		love.graphics.print("Current FPS: " .. tostring(love.timer.getFPS()), 10, 10)
	end})
	
	scene_manager:push(title)
end
