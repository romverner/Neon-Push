Powerup = {}

function Powerup.getDefaultPowerupObj()
    return {
        duration = 5,
        appliedDuration = nil,
        lifespan = 20,
        generatedAt = love.timer.getTime(),
        expired = false,
        vxMultiplier = 1,
        vyMultiplier = 1,
        uses = {
            noise = false,
            dash = false,
            vision = false
        },
        noise = {
            generationTimeMultiplier = 1,
            maxRadiusMultiplier = 1,
        },
        dash = {
            durationMultiplier = 1,
            speedMultiplier = 1
        }
    }
end

function Powerup:new(obj)
    obj = obj or Powerup.getDefaultPowerupObj()
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Powerup:apply(entity, dt)
    if self.appliedDuration >= self.duration then
        self.expired = true
        return
    end

    entity.vx = entity.vx * self.vxMultiplier
    entity.vy = entity.vy * self.vyMultiplier 

    self.appliedDuration = self.appliedDuration + dt
end