--------------------------------------------
-- Re: Shadow RPG
-- @ SF Software
--------------------------------------------

--------------------------------------------
-- load @ love
--------------------------------------------
-- This function gets called only once, when 
-- the game is started, and is usually where
-- you would load resources, initialize variables
-- and set specific settings. All those things 
-- can be done anywhere else as well, but doing
-- them here means that they are done once only,
-- saving a lot of system resources.
--------------------------------------------
function love.load()
	love.window.setTitle("Re: Shadow RPG")
	image = love.graphics.newImage("images/title.jpg")
end

--------------------------------------------
-- update @ love
--------------------------------------------
-- This function is called continuously and 
-- will probably be where most of your math
-- is done. 'dt' stands for "delta time" and
-- is the amount of seconds since the last 
-- time this function was called (which is 
-- usually a small value like 0.025714).
--------------------------------------------
function love.update()
end

--------------------------------------------
-- draw @ love
--------------------------------------------
-- love.draw is where all the drawing happens
-- (if that wasn't obvious enough already) and
-- if you call any of the love.graphics.draw 
-- outside of this function then it's not going
-- to have any effect. This function is also
-- called continuously so keep in mind that if
-- you change the font/color/mode/etc at the end
-- of the function then it will have a effect on
-- things at the beginning of the function.
--------------------------------------------
function love.draw()
	love.graphics.draw(image)
end

--------------------------------------------
-- mousepressed @ love
--------------------------------------------
-- This function is called whenever a mouse 
-- button is pressed and it receives the 
-- button and the coordinates of where it 
-- was pressed. The button can be any of
-- the button index that was pressed. 
-- This function goes very well along with
-- love.mousereleased.
--------------------------------------------
function love.mousepressed(x, y, button, istouch)
	if button == 1 then
	end
end

--------------------------------------------
-- mousereleased @ love
--------------------------------------------
-- This function is called whenever a mouse
-- button is released and it receives the
-- button and the coordinates of where it 
-- was released. You can have this function 
-- together with love.mousepressed or separate,
-- they aren't connected in any way.
--------------------------------------------
function love.mousereleased(x, y, button, istouch)
	if button == 1 then
	end
end

--------------------------------------------
-- keypressed @ love
--------------------------------------------
-- This function is called whenever a keyboard
-- key is pressed and receives the key that was
-- pressed. The key can be any of the constants.
-- This functions goes very well along with
-- love.keyreleased.
--------------------------------------------
function love.keypressed(key)
end

--------------------------------------------
-- keyreleased @ love
--------------------------------------------
-- This function is called whenever a keyboard
-- key is released and receives the key that 
-- was released. You can have this function 
-- together with love.keypressed or separate,
-- they aren't connected in any way.
--------------------------------------------
function love.keyreleased(key)
end

--------------------------------------------
-- focus @ love
--------------------------------------------
-- This function is called whenever the user
-- clicks off and on the LÖVE window. For 
-- instance, if they are playing a windowed
-- game and a user clicks on his Internet 
-- browser, the game could be notified and
-- automatically pause the game.
--------------------------------------------
function love.focus(f)
end

--------------------------------------------
-- quit @ love
--------------------------------------------
-- This function is called whenever the user
-- clicks the window's close button (often an X).
-- For instance, if the user decides they are 
-- done playing, they could click the close button.
-- Then, before it closes, the game can save its state.
--------------------------------------------
function love.quit()
end

--[[
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
]]