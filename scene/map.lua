--------------------------------------------
-- map @ scene
-- @ SF Software
--------------------------------------------
local utils = require "lib.utils"

local map = {}

-- Map ID
local currentMap = "000-debug"
local currentPos = {5, 5}
local focusPos = {0, 0}
-- Character ID (todo: class data?)
local characterList = {
	[0] = {
		position = currentPos,
		-- down, left, right, up
		faceto = 1,
		status = 2
	}
}

local info = {}
local tileset = {}
local layer = {}
local character = {
	source = {}
}

local clock = 0

function map:enter()
	-- load map
	local f = io.open(string.format("resource/map/%s.tmx", currentMap))
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
		local source = s:match([[source="%.%./tiles/(.-%.tsx)"]])
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
		tileset[#tileset + 1] = {
			source = love.graphics.newImage(string.format("resource/tiles/%s", source)),
			quad = {},
			first = tonumber(first),
			alpha = tonumber(alpha or 1)
		}
		for i = 1, tilecount do
			local sx = (i - 1) % columns * info.tileWidth
			local sy = math.floor((i - 1) / columns) * info.tileHeight
			tileset[#tileset].quad[i] = love.graphics.newQuad(sx, sy, info.tileWidth, info.tileHeight,
				tileset[#tileset].source:getDimensions())
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
	
	-- load characters
	local index = dofile("resource/characters/index.des")
	assert(index, "Character index not found.")
	for i = 1, #index do
		local t = dofile(string.format("resource/characters/%s", index[i]))
		assert(t, string.format("Character description <%s> not found.", index[i]))
		table.insert(character.source, {
			width = t.width,
			height = t.height,
			columns = t.columns,
			source = love.graphics.newImage(string.format("resource/characters/%s", t.source))
		})
		for k, v in pairs(t) do
			if type(k) == "number" then
				character[k] = {
					source = #character.source
				}
				for i = 1, 4 do
					character[k][i] = {}
					for c = 1, t.columns do
						local sx = (v.col + c - 2) * t.width
						local sy = (v.line + i - 2) * t.height
						character[k][i][c] = love.graphics.newQuad(sx, sy, t.width, t.height,
							character.source[#character.source].source:getDimensions())
					end
					if t.columns == 3 then
						character[k][i][4] = character[k][i][2]
					end
				end
			end
		end
	end
	
	-- init
	local width, height = love.graphics.getDimensions()
	width = math.floor(width / info.tileWidth + 0.5)
	height = math.floor(height / info.tileHeight + 0.5)
	if info.width <= width then
		focusPos[1] = math.floor(info.width / 2)
	else
		local half = math.floor(width / 2)	
		focusPos[1] = utils.setRange(currentPos[1], 1 + half, info.width - half)
	end
	if info.height <= height then
		focusPos[2] = math.floor(info.height / 2)
	else
		local half = math.floor(height / 2)
		focusPos[2] = utils.setRange(currentPos[1], 1 + half, info.height - half)
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
	local width, height = love.graphics.getDimensions()
	width = math.floor(width / info.tileWidth + 0.5)
	height = math.floor(height / info.tileHeight + 0.5)
	local halfWidth, halfHeight = math.floor(width / 2), math.floor(height / 2)
	local lineLeft, lineRight = focusPos[2] - halfHeight, focusPos[2] - halfHeight + height
	local colLeft, colRight = focusPos[1] - halfWidth, focusPos[1] - halfWidth + width
	for i = 1, #layer do
		for line = lineLeft, lineRight do
			for col = colLeft, colRight do
				if layer[i][line] and layer[i][line][col] then
					local cur = layer[i][line][col]
					love.graphics.draw(tileset[cur.tile].source, tileset[cur.tile].quad[cur.id], 
						(col - colLeft) * info.tileWidth, (line - lineLeft) * info.tileHeight)
				end
			end
		end
		if i == 2 then
			for k, v in pairs(characterList) do
				love.graphics.draw(character.source[character[k].source].source, 
					character[k][v.faceto][v.status], 
					(v.position[1] - colLeft) * info.tileWidth, 
					(v.position[2] - lineLeft + 1) * info.tileHeight - character.source[character[k].source].height)
			end
		end
	end
end

function map:mousepressed(x, y, button, istouch)
	
end

function map:keypressed(key)
	
end

return map 