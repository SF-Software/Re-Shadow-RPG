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

local clock = 0

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
		local source = s:match([[source="%.%./resource/tiles/(.-%.tsx)"]])
		local first = s:match([[firstgid="(%d+)"]])
		local alpha = s:match([[opacity="([%d%.]+)"]])
		assert(source and first, "Invaild tileset tag.")
		local f = io.open(string.format("resource/tiles/%s", source))
		source = f:read("*a")
		f:close()
		local s = source:match("<tileset([^\n]-)>")
		local tilecount = s:match([[tilecount="(%d+)"]])
		local columns = s:match([[columns="(%d+)"]])
		local source = source:match([[<image.-source="(.-)".->]])
		assert(tilecount and columns, "Invaild tileset file.")
		tilecount = tonumber(tilecount)
		columns = tonumber(columns)
		local tileData = love.image.newImageData(string.format("resource/tiles/%s", source))
		tileset[#tileset + 1] = {
			source = {},
			first = tonumber(first),
			alpha = tonumber(alpha or 1)
		}
		for i = 1, tilecount do
			local temp = love.image.newImageData(info.tileWidth, info.tileHeight)
			local sx = (i - 1) % columns * info.tileWidth
			local sy = math.floor((i - 1) / columns) * info.tileHeight
			temp:paste(tileData, 0, 0, sx, sy, info.tileWidth, info.tileHeight)
			tileset[#tileset].source[i] = love.graphics.newImage(temp)
		end
	end
	-- step 2: load layers
	local layerPt = "<layer[^\n]->.-<data.->(.-)</data>.-</layer>"
	while res:find(layerPt) do
		local layerData = res:match(layerPt)
		res = res:gsub(layerPt, "", 1)
		assert(layerData, "Layer data not found.")
		local status, csv = pcall(loadstring(string.format("return {%s}", layerData)))
		assert(status, "Failed to load layer data.")
		table.insert(layer, {})
		for line = 1, info.height do
			layer[#layer][line] = {}
			for col = 1, info.width do
				local id = csv[(line - 1) * info.width + col]
				if id == 0 then
					layer[#layer][line][col] = nil
				else
					local tile = #tileset
					for i = 1, #tileset do
						if tileset[i].first > id then
							tile = i - 1
							break
						end
					end
					layer[#layer][line][col] = {
						tile = tile,
						id = id - tileset[tile].first + 1
					}
				end
			end
		end
	end
	clock = 0
end

function map:update()
	if clock < 30 then
		clock = clock + 1
	end
end

function map:draw()
	love.graphics.setColor(255, 255, 255, 255 / 30 * clock)
	for i = 1, #layer do
		for line = 1, #layer[i] do
			for col = 1, #layer[i][line] do
				local cur = layer[i][line][col]
				if cur then
					love.graphics.draw(tileset[cur.tile].source[cur.id], 
						(col - 1) * info.tileWidth, (line - 1) * info.tileHeight)
				end
			end
		end
	end
end

function map:mousepressed(x, y, button, istouch)
	
end

function map:keypressed(key)
	
end

return map 