require 'classes.entity'
require 'components.vision'

local PushChaser = {}

function PushChaser:new(x, y)
    obj = Entity.getDefualtEntityObject('PushChaser', 20, x or 300, y or 300, 24, 24, 5, 10, 1)
    local chsr = Entity:new(obj)
    chsr.collider = world:newRectangleCollider(chsr.x, chsr.y, chsr.width, chsr.height)
    chsr.collider:setFixedRotation(true)
    -- chsr.collider:setFixedRotation(true)
    setmetatable(chsr, self)
    self.__index = self
    return chsr
end

function PushChaser:setDirection()
    local angleToPlayer = trigonometry.atanByCoordinates(self, Player)
    local newVector = trigonometry.getPolarCoordinates(angleToPlayer, 1)

    self.direction.x = newVector.x
    self.direction.y = newVector.y
end

function PushChaser:move(dt)
    self:setDirection()

    local mapVector = currentMap:getVectorAtCoords(self)
    local normalizedVector = physics.normalizeVector(self.direction)

    self.vx = self.vx * 0.97 + self.speed * normalizedVector.x + self.momentum
    self.vy = self.vy * 0.97 + self.speed * normalizedVector.y + self.momentum

    if mapVector then
        self.vx = self.vx + self.speed * mapVector.vector.x * 0.5
        self.vy = self.vy + self.speed * mapVector.vector.y * 0.5    
    end

    self.collider:setLinearVelocity(self.vx, self.vy)
end

function PushChaser:draw()
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.PURPLE, 1)
    love.graphics.rectangle('fill', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.RED, 0.75)
    love.graphics.rectangle('line', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end

function PushChaser:matchPositionToCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

return PushChaser