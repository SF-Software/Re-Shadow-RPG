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
	love.window.setTitle("Re: Shadow RPG")
	NotoSansCJK_30 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 30)
	NotoSansCJK_40 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 40)
	NotoSansCJK_60 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 60)
	ui:init("ffixxpws")
	
	registerEvents(ui)
	registerEvents(scene_manager)
	
	scene_manager:push(title)
end

--------------------------------------------
-- update @ love
--------------------------------------------
function love.update()
	ui:window(0, 0, 128, 128)
end 