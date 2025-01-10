Tile = {}

function Tile.getDefaultTileObj(x, y, size)
    return {
        x = x,
        y = y,
        xNoise = x / (20 * size),
        yNoise = y / (20 * size),
        size = size,
        center = { x = x + size / 2, y = y + size / 2},
        vector = { x = math.random(), y = math.random() },
        lastAngle = 0,
        effectActive = false
    }
end

function Tile:new(x, y, size)
    obj = Tile.getDefaultTileObj(x, y, size)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tile:update(time, angleOverride, sizeOverride)
    local fractionalTime = time * 0.05
    local noise = love.math.noise(self.xNoise + fractionalTime, self.yNoise + fractionalTime)

    if angleOverride then
        self.lastAngle = angleOverride
        self.lastSize = sizeOverride
        self.effectActive = true
        angleOverride = angleOverride
        self.vector = trigonometry.getPolarCoordinates(angleOverride, sizeOverride * 0.75)
    else
        self.effectActive = false
        local angle = math.pi * 4 * noise
        self.vector = trigonometry.getPolarCoordinates(angle, 1)
    end
end

function Tile:draw(color, opacity)
    if color then
        COLOR_PALLETTE.setColor(color, opacity)
    elseif self.effectActive then
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.RED, 0.6)
    else
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.BLUE, 0.55)
    end

    if self.effectActive then
        local qCircle = math.pi / 4
        local fractionCircle = math.pi / 10
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.BLUE, 0.55)
        love.graphics.line(
            self.center.x,
            self.center.y,
            self.center.x + 0.02 * self.vector.x * self.lastSize / 20,
            self.center.y + 0.02 * self.vector.y * self.lastSize / 20
        )

        COLOR_PALLETTE.setColor(COLOR_PALLETTE.PURPLE, 0.6)
        love.graphics.arc(
            'line',
            'open',
            self.center.x,
            self.center.y,
            self.lastSize * 0.08,
            self.lastAngle + fractionCircle,
            self.lastAngle - fractionCircle
        )
        -- COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 0.4)
        -- love.graphics.arc('line', 'open', self.center.x, self.center.y, self.size, self.lastAngle - 0.1, self.lastAngle + 0.1)
    elseif not effectLayer then
        love.graphics.line(
            self.center.x,
            self.center.y,
            -- self.center.x + self.vector.x * 8,
            -- self.center.y + self.vector.y * 8 
            self.center.x + math.min(self.vector.x * 8, 3),
            self.center.y + math.min(self.vector.y * 8, 3)
        )
    end
end

return Tile