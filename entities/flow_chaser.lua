require 'classes.entity'
require 'components.vision'

local FlowChaser = {}

function FlowChaser:new(x, y)
    obj = Entity.getDefualtEntityObject('FlowChaser', 20, x or 300, y or 300, 16, 16, 5, 5, 1)
    local chsr = Entity:new(obj)
    chsr.collider = world:newCircleCollider(chsr.x, chsr.y, chsr.width/2)
    -- chsr.collider:setFixedRotation(true)
    setmetatable(chsr, self)
    self.__index = self
    return chsr
end

function FlowChaser:setDirection()
    local angleToPlayer = trigonometry.atanByCoordinates(self, Player)
    local newVector = trigonometry.getPolarCoordinates(angleToPlayer, 1)

    self.direction.x = newVector.x
    self.direction.y = newVector.y
end

function FlowChaser:move(dt)
    self:setDirection()

    local mapVector = currentMap:getVectorAtCoords(self)
    local normalizedVector = physics.normalizeVector(self.direction)
    local distancetoPlayer = physics.distanceBetweenCoords(self, Player)
    distancetoPlayer = distancetoPlayer / 64
    local multiplier = 1 / distancetoPlayer

    self.vx = self.vx + self.speed * normalizedVector.x * multiplier
    self.vy = self.vy + self.speed * normalizedVector.y * multiplier

    self.vx = self.vx * 0.95 + self.speed * mapVector.vector.x * 0.99
    self.vy = self.vy * 0.95 + self.speed * mapVector.vector.y * 0.99

    self.collider:setLinearVelocity(self.vx, self.vy)
end

function FlowChaser:draw()
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.RED, 1)
    love.graphics.circle('fill', self.x, self.y, self.width/2)
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.ORANGE, 0.75)
    love.graphics.circle('line', self.x, self.y, self.width/2)
end

function FlowChaser:matchPositionToCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

return FlowChaser