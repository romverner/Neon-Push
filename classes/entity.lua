require 'components.vision'
require 'components.noise'
require 'components.dash'
require 'components.shoot'

Entity = {}

function Entity.getDefualtEntityObject(name, health, x, y, width, height, speed, maxSpeed, momentum)
    local xLocal, yLocal = x or 0, y or 0
    local widthLocal, heightLocal = width or 16, height or 16

    return {
        startCoords = {x=xLocal, y=yLocal},
        direction = {x=0, y=0},
        x = xLocal,
        y = yLocal,
        vx = 0,
        vy = 0,
        ax = 0,
        ay = 0,
        center = { x = xLocal + width/2, y = yLocal + height/2 },
        lock = {x=false, y=false},
        speed = speed or 10,
        maxSpeed = maxSpeed or 20,
        momentum = momentum or 0,
        health = health or 10,
        name = name or 'Default',
        width = widthLocal,
        halfWidth = widthLocal/2,
        height = heightLocal,
        halfHeight = heightLocal/2,
        attention = nil
    }
end

function Entity:new(obj)
    obj = obj or Entity.getDefualtEntityObject()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Entity:newCollider(fixed)
    self.collider = world:newBSGRectangleCollider(self.x, self.y, self.width, self.height, 3)
    self.collider:setFixedRotation(fixed or false)
end

function Entity:matchPositionToCollider()
    self.x = self.collider:getX()
    self.y = self.collider:getY()
    self.center.x = self.x
    self.center.y = self.y
end

function Entity:attachVision(radius, startAngle, endAngle)
    attachVisionToEntity(self, radius, startAngle, endAngle)
end

function Entity:attachNoise()
    attachNoiseGenerationToEntity(self)
end

function Entity:attachRoll(boost, cooldown, rollTime)
    attachDashToEntity(self, boost, cooldown, rollTime)
end

function Entity:attachShoot()
    attachShootToEntity(self)
end

return Entity