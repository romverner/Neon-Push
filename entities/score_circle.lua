require 'classes.particle'
require 'classes.float_text'

local ScoreCircle = {}

function ScoreCircle:new(x, y, maxRadius, startRadius, lifespan)
    local circleParticle = Particle.getDefaultParticleObject(x, y, maxRadius, startRadius, 1, lifespan)
    circleParticle.minRadius = startRadius
    circleParticle.points = 1
    circleParticle.pointsAdded = 1
    circleParticle.multiplier = 1
    circleParticle.contactTime = 0
    circleParticle.timer = 0
    circleParticle.startTimer = false
    circleParticle.waitTime = 0.2
    circleParticle.print = false
    circleParticle.printTimer = 0
    circleParticle.printWaitTime = 1.5
    circleParticle.floatTexts = {}
    circleParticle.delete = false
    setmetatable(circleParticle, self)
    self.__index = self
    return circleParticle
end

function ScoreCircle:draw(color, opacity)
    if color then
        COLOR_PALLETTE.setColor(color, opacity or 1)
    else
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.YELLOW, 0.25)
    end

    love.graphics.circle('fill', self.x, self.y, self.currentRadius)

    for i, text in ipairs(self.floatTexts) do
        text:draw()
    end

    COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 0.25)
    love.graphics.circle('line', self.x, self.y, self.currentRadius)
end

function ScoreCircle:isTouchingPlayer()
    if self.currentRadius >= physics.distanceBetweenCoords(self, Player) then
        return true
    end
    
    return false
end

function ScoreCircle:addScore()
    self.multiplier = self.multiplier + self.contactTime * 10  / (self.currentRadius * 2)
    self.pointsAdded = math.floor(self.points * self.multiplier)
    Score = Score + self.pointsAdded
end

function ScoreCircle:createScoreText()
    local printText = FloatText:new('+'..self.pointsAdded, self.x+self.currentRadius, self.y, 0.75)
    table.insert(self.floatTexts, printText)
end

function ScoreCircle:pop(x, y)
    currentMap:addEffect(x, y, 5)
    self.delete = true
end

function ScoreCircle:move(dt, vector)
    local touchingPlayer = self:isTouchingPlayer()

    if touchingPlayer then
        self.contactTime = self.contactTime + dt * 0.2
        self.currentRadius = self.currentRadius + dt * 30
    else
        self.contactTime = math.max(self.contactTime - dt * 1.8, 0)
        self.currentRadius = math.max(self.currentRadius - dt * 8, self.minRadius)
    end


    if self.currentRadius > self.maxRadius then
        self.currentRadius = self.maxRadius
        local x, y = currentMap:getPositionCoord(self)
        self:pop(x, y)
    end

    if self.timer >= self.waitTime then
        self.startTimer = false
        self.timer = 0

        if touchingPlayer then
            self.startTimer = true
            self:addScore()
            self:createScoreText()
        end
    elseif self.startTimer then
        self.timer = self.timer + dt 
    elseif touchingPlayer then
        self.startTimer = true
        self:addScore()
        self:createScoreText()
    end

    if vector then
        self.vx = self.vx * 0.25 + self.speed * vector.x 
        self.vy = self.vy * 0.25 + self.speed * vector.y 
    end

    self.vx = self.vx * 0.5 - self.vx * 0.1
    self.vy = self.vy * 0.5 - self.vy * 0.1

    self.x = self.x + self.vx
    self.y = self.y + self.vy

    for i, text in ipairs(self.floatTexts) do
        text:track(dt)
    end
end

return ScoreCircle