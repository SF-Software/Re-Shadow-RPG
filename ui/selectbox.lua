
return function(ui, items, x, y, width, height, item_width, row, col, cursor)
	ui:registerDraw(function()
		ui.theme.selectbox:draw(items, row, col, item_width, width, height, cursor.index)
	end, x, y, width, height)
	
end 