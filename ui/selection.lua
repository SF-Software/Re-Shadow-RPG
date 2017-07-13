
return function(ui, x, y, width, height, arg)
	local items, item_width, item_height, row, col, cursor = arg.items, arg.item_width, arg.item_height, arg.rows, arg.columns, arg.cursor
	ui:registerDraw(function()
		ui.theme.selection:draw(items, row, col, item_width, item_height, width, height, cursor)
	end, x, y, width, height)
	
end 