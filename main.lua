--------------------------------------------
-- Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local scene_manager = require "lib.scene_manager"
local utils = require "lib.utils"
local title = require "scene.title"
local ui = require 'ui'
local registerEvents = require 'lib.register_events'

--------------------------------------------
-- load @ love
--------------------------------------------
function love.load()
	NotoSansCJK_30 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 30)
	NotoSansCJK_40 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 40)
	NotoSansCJK_60 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 60)
	ui:init("ffixxpws")
	
	
	registerEvents(scene_manager)
	registerEvents(ui)
	scene_manager:push(title)
end

--------------------------------------------
-- update @ love
--------------------------------------------
function love.update()
	ui:window(0, 0, 200, 100)
	ui:window(0, 100, 200, 500)
	ui:window(200, 0, 600, 600)
end 