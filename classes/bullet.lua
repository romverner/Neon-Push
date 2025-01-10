Bullet = {}

function Bullet.getDefaultObj(x, y, size, target)
    return {
        x = x or 0,
        y = y or 0,
        vx = 0,
        vy = 0,
        speed = 800,
        size = size or 2,
        target = target,
        angle = nil
    }
end

function Bullet:new(x, y, size, target)
    local obj = Bullet.getDefaultObj(x, y, size, target)
    obj.collider = world:newRectangleCollider(x, y, size, size)
    obj.collider:setFixedRotation(true)

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Bullet:shootAt(entity, angle)
    self.target = entity
    self.angle = angle
end

function Bullet:travel()
    if self.target then
        self.angle = trigonometry.atanByCoordinates(self, self.target)
        local distanceToTarget = physics.distanceBetweenCoords(self, self.target)
        local nVector = trigonometry.getPolarCoordinates(self.angle, 1)
        
        self.vx = self.vx + self.speed * nVector.x
        self.vy = self.vy + self.speed * nVector.y

    else
        local mapVector = currentMap:getVectorAtCoords(self)
        self.vx = self.vx + self.speed * mapVector.vector.x * 0.021
        self.vy = self.vy + self.speed * mapVector.vector.y * 0.021
    end

    self.collider:setLinearVelocity(self.vx, self.vy)
    self.target = nil
end

function Bullet:draw()
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.TEAL, 1)
    love.graphics.rectangle('line', self.x, self.y, self.size, self.size)
end

function Bullet:destroy()
    self.collider:destroy()
end

function Bullet:matchPositionToCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

return Bullet