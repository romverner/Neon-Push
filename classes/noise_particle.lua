require 'classes.particle'

NoiseParticle = {}

function NoiseParticle:new(x, y, radius, startRadius, frameTime, lifespan)
    obj = Particle.getDefaultParticleObject(x, y, radius, startRadius, frameTime, lifespan)
    local particle = Particle:new(obj)
    setmetatable(particle, self)
    self.__index = self
    return particle
end

function NoiseParticle:trackFrames(dt)
    if self.onLastFrame then
        self.expired = true
        return
    end

    self.currentFrameTime = self.currentFrameTime + dt

    if self.currentFrameTime >= self.frameTime then
        self.currentFrameTime = 0
        self.currentRadius = math.min(self.currentRadius + self.radiusTwentieth, self.maxRadius)

        if self.currentRadius == self.maxRadius then
            self.lastFrame = true
        end

        if love.timer.getTime() - self.generatedAt > self.lifespan then
            self.expired = true
        end
    end
end

function NoiseParticle:draw()
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 0.3)
    love.graphics.circle('line', self.x, self.y, self.currentRadius)
    -- love.graphics.print(self.vx, 300, 50)

    COLOR_PALLETTE.setColor(COLOR_PALLETTE.TEAL, 0.5)
    love.graphics.circle('line', self.x, self.y, self.currentRadius/2)
end

return NoiseParticle