require 'classes.particle'

TestParticle = {}

function TestParticle:new(x, y, radius, startRadius, frameTime, lifespan)
    obj = Particle.getDefaultParticleObject(x, y, radius, startRadius, frameTime, lifespan)
    local particle = Particle:new(obj)
    setmetatable(particle, self)
    self.__index = self
    return particle
end

function TestParticle:draw(color, opacity)
    if color then
        COLOR_PALLETTE.setColor(color, opacity or 1)
    else
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.YELLOW, 0.25)
    end

    love.graphics.circle('fill', self.x, self.y, self.maxRadius)
end

function TestParticle:moveSelf(vector)
    if vector then
        self.vx = self.vx * 0.25 + self.speed * vector.x 
        self.vy = self.vy * 0.25 + self.speed * vector.y 
    end

    self.vx = self.vx * 0.5 - self.vx * 0.1
    self.vy = self.vy * 0.5 - self.vy * 0.1

    -- self.collider:setLinearVelocity(self.vx, self.vy)

    self.x = self.x + self.vx
    self.y = self.y + self.vy
    

    -- if self.x < 0 or self.x > virtualWidth then
    --     self.x = math.random(0, virtualWidth)
    -- end

    -- if self.y < 0 or self.y > virtualHeight then
    --     self.y = math.random(0, virtualHeight)
    -- end
end

return TestParticle