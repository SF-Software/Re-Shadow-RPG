--------------------------------------------
-- Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local utils = require "lib.utils"
local title = require "scene.title"
local ui = require 'ui'


--------------------------------------------
-- scene @ main
--------------------------------------------
local scene = {}

--------------------------------------------
-- push @ main
--------------------------------------------
-- state: table
--------------------------------------------
function push(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene + 1] = state
	state.enter()
end

--------------------------------------------
-- pop @ main
--------------------------------------------
function pop()
	assert(#scene > 1, "Not able to pop.")
	scene[#scene] = nil
end

--------------------------------------------
-- switch @ main
--------------------------------------------
-- state: table
--------------------------------------------
function switch(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene] = state
	state.enter()
end

--------------------------------------------
-- inRange @ main
--------------------------------------------
-- var: number
-- left: number
-- right: number
-- ret: boolean
--------------------------------------------
function inRange(var, left, right)
	assert(type(var) == "number" and type(left) == "number" and type(right) == "number")
	return var >= left and var <= right
end

--------------------------------------------
-- select @ main
--------------------------------------------
-- t: table
-- x, y: position
-- ret: id
--------------------------------------------
function select(t, x, y)
	for i = 1, #t do
		if inRange(x, t[i].x[1], t[i].x[2]) and inRange(y, t[i].y[1], t[i].y[2]) then
			return i
		end
	end
end

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
	NotoSansCJK_30 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 30)
	NotoSansCJK_40 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 40)
	NotoSansCJK_60 = love.graphics.newFont("resource/fonts/NotoSansCJKtc-Regular.otf", 60)
	push(title)
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
	local x, y = love.mouse.getPosition()
	scene[#scene].update(x, y)
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
	if scene[#scene].draw then
		scene[#scene].draw()
	end
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
	if scene[#scene].onMousePress then
		scene[#scene].onMousePress(button, x, y)
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
	if scene[#scene].onMouseRelease then
		scene[#scene].onMouseRelease(button, x, y)
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
	if scene[#scene].onKeyPress then
		scene[#scene].onKeyPress(key)
	end
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
	if scene[#scene].onKeyRelease then
		scene[#scene].onKeyRelease(key)
	end
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
	if scene[#scene].onFocusChange then
		scene[#scene].onFocusChange(f)
	end
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
	-- to do
end
