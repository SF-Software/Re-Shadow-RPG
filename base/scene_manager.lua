--------------------------------------------
-- Scene Manager @ Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local M = setmetatable({}, {__index = function(self, func)
	return function(...)
		(self.current() [func] or __NULL__)(...)
	end
end})

--------------------------------------------
-- scene @ Scene Manager
--------------------------------------------
local scene = {}

--------------------------------------------
-- push @ Scene Manager
--------------------------------------------
-- state: table
--------------------------------------------
function M:push(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene + 1] = state
	state.enter()
end

--------------------------------------------
-- pop @ Scene Manager
--------------------------------------------
function M:pop()
	assert(#scene > 1, "Not able to pop.")
	scene[#scene] = nil
end

--------------------------------------------
-- switch @ Scene Manager
--------------------------------------------
-- state: table
--------------------------------------------
function M:switch(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene] = state
	state.enter()
end

--------------------------------------------
-- current @ Scene Manager
--------------------------------------------
-- ret: table
--------------------------------------------
function M:current()
	return scene[#scene]
end

return M 