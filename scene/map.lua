--------------------------------------------
-- map @ scene
-- @ SF Software
--------------------------------------------
local utils = require "lib.utils"

local map = {}

-- Map ID
local currentMap = "000-debug"
local focusPos = {
	x = 0,
	y = 0
}
-- Character ID (todo: class data?)
local characterList = {
	[0] = {
		position = {
			x = 5,
			y = 5
		},
		-- down, left, right, up
		faceto = 1,
		status = 2
	}
}

local speed = 2 -- blocks per second
local frequency = 6 -- frames per second
local step = speed / 60
local scrollGap = 5

local movement = {
	down = {1, 0, step},
	left = {2, - step, 0},
	right = {3, step, 0},
	up = {4, 0, - step}
}

local info = {}
local tileset = {}
local layer = {}
local character = {
	source = {}
}

local clock = 0
local lastFrame = 0

function map:enter()
	-- load map
	local res = love.filesystem.read(string.format("resource/map/%s.tmx", currentMap))
	
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
		
		source = love.filesystem.read(string.format("resource/tiles/%s", source))
		
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
			local sx =(i - 1) % columns * info.tileWidth
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
			layer[#layer] [line] = {}
			for col = 1, info.width do
				local id = csv[(line - 1) * info.width + col]
				if id == 0 then
					layer[#layer] [line] [col] = nil
				else
					local tile = #tileset
					for i = 1, #tileset do
						if tileset[i].first > id then
							tile = i - 1
							break
						end
					end
					layer[#layer] [line] [col] = {
						tile = tile,
						id = id - tileset[tile].first + 1
					}
				end
			end
		end
	end
	
	-- load characters
	local index = love.filesystem.load("resource/characters/index.des")()
	assert(index, "Character index not found.")
	for i = 1, #index do
		local t = love.filesystem.load(string.format("resource/characters/%s", index[i]))()
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
					character[k] [i] = {}
					for c = 1, t.columns do
						local sx =(v.col + c - 2) * t.width
						local sy =(v.line + i - 2) * t.height
						character[k] [i] [c] = love.graphics.newQuad(sx, sy, t.width, t.height,
						character.source[#character.source].source:getDimensions())
					end
					if t.columns == 3 then
						character[k] [i] [4] = character[k] [i] [2]
					end
				end
			end
		end
	end
	
	-- init
	-- 坐标编号: 从(0,0)到(29,19)
	-- 总共有30x20个方块,地图中心是(14.5, 9.5)
	-- 屏幕可以容纳25x18.75个方块.
	local width, height = love.graphics.getDimensions()
	width = width / info.tileWidth
	height = height / info.tileHeight
	if info.width <= width then
		focusPos.x =(info.width - 1) / 2
	else
		local half = width / 2
		focusPos.x = utils.setRange(characterList[0].position.x, half, info.width - half - 1)
	end
	if info.height <= height then
		focusPos.y =(info.height - 1) / 2
	else
		local half = height / 2
		focusPos.y = utils.setRange(characterList[0].position.y, half, info.height - half - 1)
	end
	print(focusPos.x, focusPos.y)
	clock = 0
end
-- 需求:
-- 1) 实现人物的行走(done)
-- 2) 确定当前的focusPos
--    规则: 朝某个方向移动后, 若进入到了距离窗口边界5格内, 且该方向地图边界尚未被绘制, 则focusPos向该方向同步移动.
--          除此以外的任何时点, focusPos不移动.
function map:update()
	if clock < 30 then
		clock = clock + 1
	end
	local moving = false
	for k, v in pairs(movement) do
		if love.keyboard.isDown(k) then
			characterList[0].faceto = v[1]
			
			local width, height = love.graphics.getDimensions()
			width = width / info.tileWidth
			height = height / info.tileHeight
			local halfWidth, halfHeight = width / 2, height / 2
			local lineLeft, lineRight = focusPos.y - halfHeight, focusPos.y - halfHeight + height
			local colLeft, colRight = focusPos.x - halfWidth, focusPos.x - halfWidth + width
			
			characterList[0].position.x = utils.setRange(characterList[0].position.x + v[2], 0, info.width - 1)
			characterList[0].position.y = utils.setRange(characterList[0].position.y + v[3], 0, info.height - 1)
			
			if(characterList[0].position.x - colLeft) < scrollGap and(colLeft - step) >= 0 then
				focusPos.x = focusPos.x - step
			elseif(colRight - characterList[0].position.x) < scrollGap and(colRight + step) <= info.width then
				focusPos.x = focusPos.x + step
			elseif(characterList[0].position.y - lineLeft) < scrollGap and(lineLeft - step) >= 0 then
				focusPos.y = focusPos.y - step
			elseif(lineRight - characterList[0].position.y) < scrollGap and(lineRight + step) <= info.height then
				focusPos.y = focusPos.y + step
			end
			
			if os.clock() - lastFrame > 1 / frequency then	
				characterList[0].status = characterList[0].status + 1
				if characterList[0].status > #character[0] [1] then
					characterList[0].status = 1
				end
				lastFrame = os.clock()
			end
			
			moving = true
			break
		end
	end
	if not moving then
		characterList[0].status = 2
	end
end
-- 需求:
-- 1) 以给定的focusPos为地图中心坐标, 将其对准窗口中心进行地图绘制.
-- 2) 使得focusPos可以为小数.
function map:draw()
	love.graphics.setColor(255, 255, 255, 255 / 30 * clock)
	local width, height = love.graphics.getDimensions()
	width = width / info.tileWidth
	height = height / info.tileHeight
	local halfWidth, halfHeight = width / 2, height / 2
	local lineLeft, lineRight = focusPos.y - halfHeight, focusPos.y - halfHeight + height
	local colLeft, colRight = focusPos.x - halfWidth, focusPos.x - halfWidth + width
	for i = 1, #layer do
		for line = lineLeft, lineRight do
			for col = colLeft, colRight do
				if layer[i] [math.floor(line) + 1] and layer[i] [math.floor(line) + 1] [math.floor(col) + 1] then
					local cur = layer[i] [math.floor(line) + 1] [math.floor(col) + 1]
					love.graphics.draw(tileset[cur.tile].source, tileset[cur.tile].quad[cur.id],
					(col - colLeft) * info.tileWidth,(line - lineLeft) * info.tileHeight)
				end
			end
		end
		if i == 2 then
			for k, v in pairs(characterList) do
				love.graphics.draw(character.source[character[k].source].source,
				character[k] [v.faceto] [v.status],
				(v.position.x - colLeft) * info.tileWidth,
				(v.position.y - lineLeft + 1) * info.tileHeight - character.source[character[k].source].height)
			end
		end
	end
end

function map:mousepressed(x, y, button, istouch)
	
end

function map:keypressed(key)
	
end

return map 