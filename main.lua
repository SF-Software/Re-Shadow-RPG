local gamestate = require 'lib.gamestate'
local SceneTitle = require 'scene.title'
local ui = require 'ui'

function love.load(arg)
	ui.init("ffixxpws")
	ui.registerEvents()
	gamestate.registerEvents()
	gamestate.switch(SceneTitle)
end
