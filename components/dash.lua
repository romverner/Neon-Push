function attachDashToEntity(entity, boost, cooldown, rollTime)
    entity.momentum = 0
    entity.rollBoost = boost or 600
    entity.rollCooldown = cooldown or 0.6
    entity.rollBoostTime = rollTime or 0.3
    entity.rolledLast = nil
    entity.rollParticles = {}
    entity.rollParticleSpawnTimer = 0
    entity.rollParticleSpawnRate = 0.02

    function entity:newDashParticle(x, y, width, height, frameTime, lifespan)
        return {
            x=x,
            y=y,
            width=width,
            height=height,
            generatedAt=love.timer.getTime(),
            frameTime=frameTime,
            currentFrameTime=0,
            lastFrame=false,
    
            lifespan=lifespan,
            expired=false
        }
    end

    function entity:animateDash()
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 0.5)

        local totalParticles = #self.rollParticles
        for i, particle in ipairs(self.rollParticles) do
            love.graphics.rectangle('line', particle.x, particle.y, particle.width-(totalParticles-i), particle.height-(totalParticles-i))
        end
    end

    function entity:trackDash(dt)
        local now = love.timer.getTime()

        for i, particle in ipairs(self.rollParticles) do
            if love.timer.getTime() - particle.generatedAt > particle.lifespan then
                table.remove(self.rollParticles, i)
            end
        end

        if self.rolledLast then
            if now - self.rolledLast >= self.rollBoostTime then
                self.momentum = 0
            elseif now - self.rolledLast < self.rollBoostTime and self.rollParticleSpawnTimer >= self.rollParticleSpawnRate then
                local newParticle = self:newDashParticle(
                    self.x - self.halfWidth,
                    self.y - self.halfHeight,
                    self.width, 
                    self.height, 
                    0.1,
                    self.rollBoostTime
                )
    
                table.insert(self.rollParticles, newParticle)
                self.rollParticleSpawnTimer = 0
            end
        end

        self.rollParticleSpawnTimer = self.rollParticleSpawnTimer + dt
    end

    function entity:roll() 
        local now = love.timer.getTime()

        if not self.rolledLast then
            self.momentum = self.rollBoost
            self.rolledLast = now

        elseif now - self.rolledLast >= self.rollCooldown then

            self.momentum = self.rollBoost
            self.rolledLast = now

        end
    end
end