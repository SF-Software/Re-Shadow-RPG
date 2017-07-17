local tick = require 'base.tick'
local input = require 'base.input'
local function cursor_dec(index, m, key)
	if input.key_repeat(key, 8) and(index > 0 or(input.key_trigger(key) and index == 0)) then
		return(index - 1 + m) % m
	else
		return index
	end
	
end
local function cursor_inc(index, m, key)
	if input.key_repeat(key, 8) and(index < m - 1 or(input.key_trigger(key) and index == m - 1)) then
		return(index + 1 + m) % m
	else
		return index
	end
end
return function(ui, x, y, width, height, arg)
	local items, item_width, item_height, row, col, cursor = arg.items, arg.item_width, arg.item_height, arg.rows, arg.columns, arg.cursor	
	
	local index_r = math.floor(cursor.index / col)
	local index_c = cursor.index % col
	
	
	index_r = cursor_dec(index_r, row, 'up')
	
	
	index_r = cursor_inc(index_r, row, 'down')
	
	
	index_c = cursor_dec(index_c, col, 'left')
	
	index_c = cursor_inc(index_c, col, 'right')
	
	cursor.index = index_r * col + index_c
	
	ui:registerDraw(function()
		ui.theme.selection:draw(items, row, col, item_width, item_height, width, height, cursor)
		
	end, x, y, width, height)
	return cursor.index
end 