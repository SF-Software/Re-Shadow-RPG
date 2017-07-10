local assets_manager = require('lib.assets_manager')

local ui = {}
local theme_image
local function __NULL__() end

function ui.init(theme)
	theme_image = assets_manager.images.theme[theme]
end
function ui.draw()
	love.graphics.draw(theme_image)
end

local all_callbacks = {'draw', 'errhand', 'update'}
for k in pairs(love.handlers) do
	all_callbacks[#all_callbacks + 1] = k
end

function ui.registerEvents(callbacks)
	local registry = {}
	callbacks = callbacks or all_callbacks
	for _, f in ipairs(callbacks) do
		registry[f] = love[f] or __NULL__
		if ui[f] then
			love[f] = function(...)
				registry[f](...)
				return ui[f](...)
			end
		end
	end
end
return ui 