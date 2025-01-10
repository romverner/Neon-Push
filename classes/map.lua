Tile = require('classes.tile')

Map = {}

function Map.getDefaultMapObject()
    return {
        xSize = 84,
        ySize = 84,
        tileSize = 8,
        halfSize = 4,
        time = 0,

        -- effect tracking
        effectDistanceFromStart = 1,
        applyEffect = false,
        effectStartCoord = { x = 0, y = 0 },
        effectSize = 1,
        effectVectors = {},
        effectFrameRate = 0.03,
        effectCurrentTime = 0,
        
        tiles = {}
    }
end

function Map:new()
    obj = obj or Map.getDefaultMapObject()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Map:generate()
    for x=1, self.xSize, 1 do
        local column = {}
        local vectorCol = {}
        
        for y=1, self.ySize, 1 do
            local tile = Tile:new((x-2)*self.tileSize, (y-2)*self.tileSize, 16)
            table.insert(column, tile)

            local vector = {angle=nil}
            table.insert(vectorCol, vector)
        end

        table.insert(self.tiles, column)
        table.insert(self.effectVectors, vectorCol)
    end
end

function Map:calculateEffectVectors(reset)
    local centerTile = self.tiles[self.effectStartCoord.x][self.effectStartCoord.y]

    for x=1, self.xSize, 1 do
        for y, tile in ipairs(self.tiles[x]) do
            -- generateAngle for each tile each time, simplifies downstream logic
            -- and is ultimately more performant
            local distance = physics.distanceBetweenCoords(centerTile.center, tile.center)
            local angle = nil
            local size = 1
            local effectiveRadius = self.effectSize * math.ceil(math.sqrt(2 * self.tileSize^2))
            local minDistance = self.effectDistanceFromStart * self.tileSize - effectiveRadius
            local maxDistance = self.effectDistanceFromStart * self.tileSize + effectiveRadius

            if not reset then
                if distance <= maxDistance and distance >= minDistance then
                    angle = trigonometry.atanByCoordinates(centerTile.center, tile.center)
                    distance = math.abs(distance - self.effectSize)
                    size = math.max(maxDistance - distance, 1)
                end
            end

            self.effectVectors[x][y] = {angle=angle, size=size}
        end
    end
end

function Map:addEffect(tileX, tileY, waveSize)
    self.effectStartCoord.x = tileX
    self.effectStartCoord.y = tileY
    self.effectSize = waveSize
    self.applyEffect = true
    self:calculateEffectVectors()
end

function Map:update(dt)
    self.time = self.time + dt
    
    for x=1, self.xSize, 1 do
        for y,tile in ipairs(self.tiles[x]) do
            if self.applyEffect then
                local effects = self.effectVectors[x][y]
                tile:update(self.time, effects.angle, effects.size)
            else
                tile:update(self.time)
            end
        end
    end

    if self.applyEffect then
        self.effectCurrentTime = self.effectCurrentTime + dt

        if self.effectCurrentTime > self.effectFrameRate then
            self.effectCurrentTime = 0

            self.effectDistanceFromStart = self.effectDistanceFromStart + 1
        
            if self.effectDistanceFromStart > self.xSize then
                self.applyEffect = false
                self.effectDistanceFromStart = 1
                self:calculateEffectVectors(true)
            else
                self:calculateEffectVectors()
            end
        end
    end
end

function Map:getPositionCoord(coords)
    local x, y = math.ceil(coords.x / self.tileSize), math.ceil(coords.y / self.tileSize)
    
    if x > self.xSize then
        x = self.xSize
    end

    if x < 1 then
        x = 1
    end

    if y > self.ySize then
        y = self.ySize
    end

    if y < 1 then
        y = 1
    end

    return x, y
end

function Map:getVectorAtCoords(coords)
    local x, y = self:getPositionCoord(coords)

    if self.tiles[x] then
        if self.tiles[x][y] then
            return self.tiles[x][y]
        end
    end
end

function Map:draw(color, opacity)
    if color then
        COLOR_PALLETTE.setColor(color, opacity or 1)
    end

    for x=1, self.xSize, 1 do
        for y=1, self.ySize, 1 do
            local tile = self.tiles[x][y]
            tile:draw()
        end
    end
end

return Map