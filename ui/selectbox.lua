
return function(ui, items, x, y, row, col, width, height, cursor)
	ui:registerDraw(function()
		ui.theme.selectbox.draw(items, row, col, width, height, cursor.index)
	end, x, y, width, height)
	
end 