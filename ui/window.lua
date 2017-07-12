
return function(ui, x, y, width, height)
	ui:registerDraw(function()
		ui.theme.window:draw(width, height)
	end, x, y, width, height)	
end 