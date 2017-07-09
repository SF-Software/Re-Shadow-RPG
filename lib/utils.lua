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
	assert(type(list) == "table" and type(percent) == "number" and percent >= 0 and percent <= 1)
	if board then
		assert(type(board) == "number" and board >= 0 and board <= 1)
	end
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight() * percent
	board = board and (width * board) or (width / (#list + 1))
	local gap = (width - board * 2) / (#list - 1)
	for i = 1, #list do
		love.graphics.draw(list[i], board - list[i]:getWidth() / 2, height - list[i]:getHeight() / 2)
		board = board + gap
	end
end