return function(ui, x, y, width, height)
	ui:registerDraw(function()
		love.graphics.setScissor(x, y, width, height)
		local lf = love.graphics.newQuad(0, 0, 32, 32, ui.theme_image:getDimensions())
		love.graphics.draw(ui.theme_image, lf, 0, 0)
		love.graphics.setScissor()
	end)	
end 