--------------------------------------------
-- Scene Manager @ Re: Shadow RPG
-- @ SF Software
--------------------------------------------
module(..., package.seeall)

--------------------------------------------
-- scene @ Scene Manager
--------------------------------------------
local scene = {}

--------------------------------------------
-- push @ Scene Manager
--------------------------------------------
-- state: table
--------------------------------------------
function push(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene + 1] = state
	state.enter()
end

--------------------------------------------
-- pop @ Scene Manager
--------------------------------------------
function pop()
	assert(#scene > 1, "Not able to pop.")
	scene[#scene] = nil
end

--------------------------------------------
-- switch @ Scene Manager
--------------------------------------------
-- state: table
--------------------------------------------
function switch(state)
	assert(type(state) == "table", "Not a table.")
	scene[#scene] = state
	state.enter()
end

--------------------------------------------
-- current @ Scene Manager
--------------------------------------------
-- ret: table
--------------------------------------------
function current()
	return scene[#scene]
end