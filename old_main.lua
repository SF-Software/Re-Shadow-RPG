--------------------------------------------
-- Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local utils = require "lib.utils"

--------------------------------------------
-- scene @ main
--------------------------------------------
local scene = {}
--------------------------------------------
-- switch @ main
--------------------------------------------
-- state: string or table
-- func: function (condition checker)
--------------------------------------------
function switch(state, func)
	if type(state) == "table" and type(func) == "function" then
		for i = 1, #state do
			if func(i) then
				assert(scene[state[i]])
				current = state[i]
				if(scene[current].switch) then
					scene[current].switch()
				end
				break
			end
		end
	elseif type(state) == "string" then
		assert(scene[state])
		current = state
		if(scene[current].switch) then
			scene[current].switch()
		end
	end
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
-- shader @ scene
--------------------------------------------
scene.shader = {load = function()
	-- do sth
end}
--------------------------------------------
-- title @ scene
--------------------------------------------
scene.title = {
	load = function()
		titleImage = love.graphics.newImage("resource/images/title-origin.jpg")
		title = {love.graphics.newText(NotoSansCJK_60, "Re: Shadow RPG")}
		titleBtns = {love.graphics.newText(NotoSansCJK_30, "Start"), love.graphics.newText(NotoSansCJK_30, "Load"), love.graphics.newText(NotoSansCJK_30, "Settings"), love.graphics.newText(NotoSansCJK_30, "Exit")}
		switch("title")
		scene.title.focus = 1
	end,
	switch = function()
		clock = 0
	end,
	update = function(x, y)
		pos = scene.title.pos
		clock = clock + 1
		if clock > 30 then
			clock = 30
		end
		if pos then
			for i = 1, #pos do
				if inRange(x, pos[i].x[1], pos[i].x[2]) and inRange(y, pos[i].y[1], pos[i].y[2]) then
					scene.title.focus = i
					break
				end
			end
		end
	end,
	draw = function()
		love.graphics.setColor(255, 255, 255, 255 / 30 * clock)
		love.graphics.draw(titleImage)
		utils.drawList(title, 0.35)
		scene.title.pos = utils.drawList(titleBtns, 0.8, 0.15)
		pos = scene.title.pos
		focus = scene.title.focus
		if focus and inRange(focus, 1, #pos) then
			love.graphics.line(pos[focus].x[1], pos[focus].y[2], pos[focus].x[2], pos[focus].y[2])
		end
	end,
	onMousePress = function(button, x, y)
		pos = scene.title.pos
		if button == 1 then
			switch(
			{"start", "selectData", "settings", "exitConfirm"},
			function(id)
				return inRange(x, pos[id].x[1], pos[id].x[2]) and inRange(y, pos[id].y[1], pos[id].y[2])
			end
			)
		end
	end
}

--------------------------------------------
-- exitConfirm @ scene
--------------------------------------------
scene.exitConfirm = {
	load = function()
		confirmMsg = {love.graphics.newText(NotoSansCJK_40, "Are you going to exit?")}
		confirmBtns = {love.graphics.newText(NotoSansCJK_30, "Yes"), love.graphics.newText(NotoSansCJK_30, "No")}
	end,
	switch = function()
		clock = 20
		scene.exitConfirm.focus = 1
	end,
	update = function(x, y)
		pos = scene.exitConfirm.pos
		clock = clock - 1
		if clock < 5 then
			clock = 5
		end
		if pos then
			for i = 1, #pos do
				if inRange(x, pos[i].x[1], pos[i].x[2]) and inRange(y, pos[i].y[1], pos[i].y[2]) then
					scene.exitConfirm.focus = i
					break
				end
			end
		end
	end,
	draw = function()
		love.graphics.setColor(255, 255, 255, 255 / 20 * clock)
		love.graphics.draw(titleImage)
		utils.drawList(title, 0.35)
		pos = utils.drawList(titleBtns, 0.8, 0.15)
		love.graphics.line(pos[4].x[1], pos[4].y[2], pos[4].x[2], pos[4].y[2])
		love.graphics.setColor(0, 0, 0)
		local width = love.graphics.getWidth()
		local height = love.graphics.getHeight()
		love.graphics.polygon("fill", width * 0.2, height * 0.3, width * 0.2, height * 0.6, width * 0.8, height * 0.6, width * 0.8, height * 0.3)
		love.graphics.setColor(255, 255, 255)
		utils.drawList(confirmMsg, 0.4)
		scene.exitConfirm.pos = utils.drawList(confirmBtns, 0.5, 0.4)
		pos = scene.exitConfirm.pos
		focus = scene.exitConfirm.focus
		if focus and inRange(focus, 1, #pos) then
			love.graphics.line(pos[focus].x[1], pos[focus].y[2], pos[focus].x[2], pos[focus].y[2])
		end
	end,
	onMousePress = function(button, x, y)
		pos = scene.exitConfirm.pos
		if button == 1 then
			switch(
			{"exit", "title"},
			function(id)
				return inRange(x, pos[id].x[1], pos[id].x[2]) and inRange(y, pos[id].y[1], pos[id].y[2])
			end
			)
		end
	end
}
--------------------------------------------
-- exit @ scene
--------------------------------------------
scene.exit = {switch = function()
	love.event.quit()
end}

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
	for k, v in pairs(scene) do
		if v.load then
			v.load()
		end
	end
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
	scene[current].update(x, y)
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
	if scene[current].draw then
		scene[current].draw()
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
	if scene[current].onMousePress then
		scene[current].onMousePress(button, x, y)
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
	if scene[current].onMouseRelease then
		scene[current].onMouseRelease(button, x, y)
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
	if scene[current].onKeyPress then
		scene[current].onMousePress(key)
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
	if scene[current].onKeyRelease then
		scene[current].onMouseRelease(key)
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
	if scene[current].onFocusChange then
		scene[current].onFocusChange(f)
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
	-- Nothing to do
end
