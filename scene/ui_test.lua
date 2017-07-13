local ui = require 'ui'
local ui_test = {}
function ui_test:enter()
	
end
function ui_test:update()
	ui:window(0, 0, 200, 100)
	ui:window(0, 100, 200, 500)
	ui:window(200, 0, 600, 600)
end
return ui_test 