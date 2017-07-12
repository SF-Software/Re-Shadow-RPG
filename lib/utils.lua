--------------------------------------------
-- Utils @ Re: Shadow RPG
-- @ SF Software
--------------------------------------------
local utils = {}

--------------------------------------------
-- drawList @ utils
--------------------------------------------
-- list: contains drawable objects
-- percent: percentage
-- board: percentage
-- ret: table, objects' position
--------------------------------------------
function utils.drawList(list, percent, board)
	assert(type(list) == "table" and utils.inRange(percent, 0, 1))
	if board then
		assert(utils.inRange(board, 0, 1))
	end
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight() * percent
	board = board and(width * board) or(width /(#list + 1))
	local gap =(width - board * 2) /(#list - 1)
	local ret = {}
	for i = 1, #list do
		ret[i] = {
			x = {board - list[i]:getWidth() / 2, board + list[i]:getWidth() / 2},
			y = {height - list[i]:getHeight() / 2, height + list[i]:getHeight() / 2}
		}
		love.graphics.draw(list[i], ret[i].x[1], ret[i].y[1])
		board = board + gap
	end
	return ret
end


--------------------------------------------
-- inRange @ main
--------------------------------------------
-- var: number
-- left: number
-- right: number
-- ret: boolean
--------------------------------------------
function utils.inRange(var, left, right)
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
function utils.select(t, x, y, func)
	for i = 1, #t do
		if utils.inRange(x, t[i].x[1], t[i].x[2]) and utils.inRange(y, t[i].y[1], t[i].y[2]) then
			return i
		end
	end
end
function limit(v, min, max)
	return math.min(math.max(v, max), min)
end
return utils 