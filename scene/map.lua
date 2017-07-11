--------------------------------------------
-- map @ scene
-- @ SF Software
--------------------------------------------
local map = {}

-- Map ID
local currentMap = "000-debug"
-- Character ID (todo: class data?)
local characterList = {0}

local info = {}
local tileset = {}
local layer = {}

function map:enter()
	-- load map
	local f = io.open(string.format("map/%s.tmx", currentMap))
	local res = f:read("*a")
	f:close()
	-- step 0: load info
	local mapTags = res:match("<map([^\n]+)>")
	assert(mapTags, "Invaild map data.")
	info = {
		width = mapTags:match([[width="(%d+)"]]),
		height = mapTags:match([[height="(%d+)"]]),
		tileWidth = mapTags:match([[tilewidth="(%d+)"]]),
		tileHeight = mapTags:match([[tileheight="(%d+)"]])
	}
	assert(info.width and info.height and info.tileWidth and info.tileHeight, "Invaild map tags.")
	for k, v in pairs(info) do
		info[k] = tonumber(v)
	end
	-- step 1: load tilesets
	local tilesetPt = [[<tileset(.-)/>]]
	while res:find(tilesetPt) do
		local s = res:match(tilesetPt)
		res = res:gsub(tilesetPt, "", 1)
		local source = s:match([[source="%.%./resource/tiles/(..-)%.tsx"]])
		local first = s:match([[firstgid="(%d+)"]])
		local alpha = s:match([[opacity="([%d%.]+)"]])
		assert(source and first, "Invaild tileset tag.")
		tileset[#tileset + 1] = {
			source = love.graphics.newImage(string.format("resource/tiles/%s.png", source)),
			first = tonumber(first),
			alpha = tonumber(alpha or 1)
		}
	end
	-- step 2: load layers
	local layerPt = [[<layer[^\n]->.-<data.->(.-)</data>.-</layer>]]
	while res:find(layerPt) do
		local layerData = res:match(layerPt)
		res = res:gsub(layerPt, "", 1)
		assert(layerData, "Layer data not found.")
		local status, csv = pcall(loadstring(string.format("return {%s}", layerData)))
		assert(status, "Failed to load layer data.")
		table.insert(layer, {})
		for line = 1, info.height do
			layer[#layer][line] = {}
			for col = 1, info.weigh do
				local id = csv[(line - 1) * info.height + col]
				local tile = 1
				for i = 1, #tileset do
					if first > id then
						tileID = i - 1
						id = id - first + 1
						break
					end
				end
				layer[#layer][line][col] = {
					tile = tile,
					id = id
				}
			end
		end
	end
end

function map:update()
	
end

function map:draw()
	
end

function map:mousepressed(x, y, button, istouch)
	
end

function map:keypressed(key)
	
end

return map 