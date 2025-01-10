require 'classes.noise_particle'

function attachNoiseGenerationToEntity(entity)
    entity.noiseParticles = {}
    entity.noiseParticleTimer = 0
    entity.noiseGenerationTime = 0.5
    entity.noiseSizeFactor = 0.1
    entity.noiseRadiusMinimum = entity.width / 4
    entity.noiseRadiusMaximum = 100
    entity.noiseFrameTime = 0.02
    entity.noiseLifespan = 4

    function entity:generateNoiseParticle()
        local newParticle = NoiseParticle:new(self.x, self.y, self.noiseRadiusMaximum, radius, self.noiseFrameTime, self.noiseLifespan)

        table.insert(self.noiseParticles, newParticle)
    end

    function entity:changeNoiseGenerationTime(newTime)
        self.noiseGenerationTime = newTime
    end

    function entity:trackNoiseParticles(dt)
        self.noiseRadiusMaximum = 3 * (math.abs(self.vx) + math.abs(self.vy)) * self.noiseSizeFactor
        for i, particle in ipairs(self.noiseParticles) do
            particle:trackFrames(dt)
        end

        self.noiseParticleTimer = self.noiseParticleTimer + dt
        
        if self.noiseParticleTimer >= self.noiseGenerationTime then
            local radius = (math.abs(self.vx) + math.abs(self.vy)) * self.noiseSizeFactor

            if radius > self.noiseRadiusMinimum then
                self:generateNoiseParticle()
            end

            self.noiseParticleTimer = 0
        end
    end

    function entity:drawNoise()
        for i, particle in ipairs(self.noiseParticles) do
            particle:draw()

            if particle.lastFrame then
                table.remove(self.noiseParticles, i)
            end
        end
    end

    return entity
end