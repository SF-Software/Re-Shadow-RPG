function __NULL__() end

function love.conf(t)
	t.window.title = "Re:Shadow RPG"
	t.window.width = 800
	t.window.height = 600
	t.console = true
	
	t.modules.joystick = false
	t.modules.physics = false
end 