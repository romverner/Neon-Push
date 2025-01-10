require 'classes.entity'

local playerSettings = Entity.getDefualtEntityObject(
    'Player',
    5,
    25,
    25,
    14,
    14,
    15,
    50,
    1
)

local Player = Entity:new(playerSettings)
Player:newCollider(true)
Player:attachNoise()
Player:attachRoll(20, 1.75, 0.6)
Player:attachShoot()

function Player:draw()
    self:drawNoise()
    self:animateDash()
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE)
    love.graphics.rectangle('fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
    self:drawBullets()
end

function Player:move(dt)
    self.direction = movement.getKeyboardDirectionVector()
    local nVector = physics.normalizeVector(self.direction)

    self.vx = self.vx + (self.speed + self.momentum) * (self.crouched and self.crouchSpeed or 1) * nVector.x
    self.vy = self.vy + (self.speed + self.momentum) * (self.crouched and self.crouchSpeed or 1) * nVector.y

    self.vx = self.vx * 0.92 --+ self.momentum * self.direction.x
    self.vy = self.vy * 0.92 --+ self.momentum * self.direction.y

    self.collider:setLinearVelocity(self.vx, self.vy)
    self:trackDash(dt)

    self:shoot(dt)
end

return Player