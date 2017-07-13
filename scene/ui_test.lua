local ui = require 'ui'
local ui_test = {}
function ui_test:enter()
	
end
local index = 0
local count = 0
function ui_test:update()
	
	ui:selectbox({"items", "test2", "test3", "test4", "test5", "test6", "test7"}, 5, 5, 190, 90, 80, 7, 1, {index = index})
	ui:selectbox({"items", "test2", "test3", "test4", "test5", "test6", "test7"}, 200, 5, 190, 90, 80, 7, 1, {index = 2})
	ui:window(0, 0, 200, 100)
	ui:window(0, 100, 200, 500)
	ui:window(200, 0, 600, 600)
	if count > 10 then
		index =(index + 1) % 7
		count = 1
	end
	count = count + 1
end
return ui_test; 