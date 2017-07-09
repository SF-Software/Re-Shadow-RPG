--------------------------------------------
-- Utils @ Re: Shadow RPG
-- @ SF Software
--------------------------------------------
module(..., package.seeall)

--------------------------------------------
-- drawList @ utils
--------------------------------------------
-- list: contains drawable objects
-- percent: percentage
-- board: percentage
--------------------------------------------
function drawList(list, percent, board)
	assert(type(list) == "table" and inRange(percent, 0, 1))
	if board then
		assert(inRange(board, 0, 1))
	end
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight() * percent
	board = board and (width * board) or (width / (#list + 1))
	local gap = (width - board * 2) / (#list - 1)
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


