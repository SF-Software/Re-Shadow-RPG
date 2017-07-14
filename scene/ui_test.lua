local ui = require 'ui'
local ui_test = {}
function ui_test:enter()
	
end
local cursor = {index = 0}
local count = 0
local t = {}
for i = 1, 35 do
	t[i] = "wtf" .. i
end
function ui_test:update()
	
	ui:selection(t,	50, 50, 186, 100, 60, 7, 5, cursor)
	--ui:selectbox({"items", "test2", "test3", "test4", "test5", "test6", "test7"}, 200, 5, 190, 90, 80, 7, 1, {index = 2})
	ui:window(50, 50, 190, 100)
	--	ui:window(0, 100, 200, 500)
	--	ui:window(200, 0, 600, 600)
	if count > 10 then
		--	index =(index + 1) % 35
		count = 1
	end
	count = count + 1
end
return ui_test; 