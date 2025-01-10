Particle = {}

function Particle.getDefaultParticleObject(x, y, radius, startRadius, frameTime, lifespan)
    local maxRadius = radius or 16
    return {
        x = x or 0,
        y = y or 0,
        vx = 1,
        vy = 1,
        speed = 1,
        maxRadius = maxRadius or 16,
        currentRadius = startRadius or 4,
        radiusTwentieth = maxRadius / 20 or 16 / 20,
        generatedAt = love.timer.getTime(),
        frameTime = frameTime or 0.25,
        currentFrameTime = 0,
        onLastFrame = false,
        lifespan = lifespan or 5,
        expired = false
    }
end

function Particle:new(obj)
    obj = obj or Particle.getDefaultParticleObject()
    obj.generatedAt = love.timer.getTime()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return Particle