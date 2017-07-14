local tick = {framerate = 60, rate = 0.03, timescale = 1, sleep = 0.001, dt = 0, accum = 0, tick = 1, frame = 1}

local timer = love.timer
local graphics = love.graphics

love.run = function()
	if not timer then
		error('love.timer is required for tick')
	end
	
	if love.math then
		love.math.setRandomSeed(os.time())
	end
	
	if love.load then
		love.load(arg)
	end
	timer.step()
	local lastframe = 0
	
	love.update(0)
	
	while true do
		timer.step()
		tick.dt = timer.getDelta() * tick.timescale
		tick.accum = tick.accum + tick.dt
		while tick.accum >= tick.rate do
			tick.accum = tick.accum - tick.rate
			
			if love.event then
				love.event.pump()
				for name, a, b, c, d, e, f in love.event.poll() do
					if name == 'quit' then
						if not love.quit or not love.quit() then
							return a
						end
					end
					
					love.handlers[name](a, b, c, d, e, f)
				end
			end
			
			tick.tick = tick.tick + 1
			if love.update then
				love.update(tick.rate)
			end
		end
		
		while tick.framerate and timer.getTime() - lastframe < 1 / tick.framerate do
			timer.sleep(0.0005)
		end
		
		lastframe = timer.getTime()
		if graphics and graphics.isActive() then
			graphics.clear(graphics.getBackgroundColor())
			graphics.origin()
			tick.frame = tick.frame + 1
			if love.draw then
				love.draw()
			end
			graphics.present()
		end
		
		timer.sleep(tick.sleep)
	end
end

return tick
