local tick = require 'lib.tick'
local Gamestate = require 'lib.gamestate'

local ui_test = {}
-- ui up
local ui = require 'lib.ui'
function love.load()
    tick.framerate = 60
    tick.rate = 1 / 60
    Gamestate.registerEvents()
    Gamestate.switch(ui_test)
end
-- storage for text input
local input = {text = ""}

-- all the UI is defined in love.update or functions that are called from here
function ui_test.update(dt)
    -- put the layout origin at position (100,100)
    -- the layout will grow down and to the right from this point
    ui.layout:reset(100, 100)
    
    -- put an input widget at the layout origin, with a cell size of 200 by 30 pixels
    ui.Input(input, ui.layout:row(200, 30))
    
    -- put a label that displays the text below the first cell
    -- the cell size is the same as the last one (200x30 px)
    -- the label text will be aligned to the left
    ui.Label("Hello, " .. input.text, {align = "left"}, ui.layout:row())
    
    -- put an empty cell that has the same size as the last cell (200x30 px)
    ui.layout:row()
    
    -- put a button of size 200x30 px in the cell below
    -- if the button is pressed, quit the game
    if ui.Button("Close", ui.layout:row()).hit then
        love.event.quit()
    end
end

function ui_test.draw()
    -- draw the gui
    ui.draw()
end

function ui_test.textinput(t)
    -- forward text input to ui
    ui.textinput(t)
end

function ui_test.keypressed(key)
    -- forward keypresses to ui
    ui.keypressed(key)
end
