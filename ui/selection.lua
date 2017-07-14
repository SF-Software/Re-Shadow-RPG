local tick = require 'base.tick'

return function(ui, x, y, width, height, arg)
	local items, item_width, item_height, row, col, cursor = arg.items, arg.item_width, arg.item_height, arg.rows, arg.columns, arg.cursor	
	if tick.frame % 10 == 0 then
		local index_r = math.floor(cursor.index / col)
		local index_c = cursor.index % col
		if love.keyboard.isDown('up') then
			index_r = math.max(index_r - 1, 0)
		end
		if love.keyboard.isDown('down') then
			index_r = math.min(index_r + 1, row - 1)
		end
		if love.keyboard.isDown('left') then
			index_c = math.max(index_c - 1, 0)
		end
		if love.keyboard.isDown('right') then
			index_c = math.min(index_c + 1, col - 1)
		end
		cursor.index = index_r * col + index_c
	end
	ui:registerDraw(function()
		ui.theme.selection:draw(items, row, col, item_width, item_height, width, height, cursor)
	end, x, y, width, height)
	
end 