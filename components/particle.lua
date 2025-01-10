local Particle = {}

function Particle.new(x, y, radius, startRadius, frameTime, lifespan)
    return {
        x=x,
        y=y,
        maxRadius=radius,
        currentRadius=startRadius,
        radiusTenth=radius * 1/20,
        generatedAt=love.timer.getTime(),
        frameTime=frameTime,
        currentFrameTime=0,
        lastFrame=false,
        scoreAdded=0,
        touchingOuter=false,
        touchingInner=false,

        lifespan=lifespan,
        expired=false
    }
end

function Particle.track(existingParticle, dt)
    if existingParticle.lastFrame then
        existingParticle.expired = true
        return
    end

    existingParticle.currentFrameTime = existingParticle.currentFrameTime + dt

    if existingParticle.currentFrameTime >= existingParticle.frameTime then

        local double, triple = existingParticle.currentRadius/2, existingParticle.currentRadius/4

        for i,enemy in ipairs(enemies) do
            local distanceToEnemy = physics.distanceBetweenCoords(enemy, existingParticle)

            if distanceToEnemy < double then
                Score = Score + 2
                existingParticle.touchingInner = true
                existingParticle.scoreAdded = 2
            elseif distanceToEnemy < existingParticle.currentRadius then
                Score = Score + 1
                existingParticle.scoreAdded = 1
                existingParticle.touchingOuter = true
            end
        end

        existingParticle.currentFrameTime = 0
        existingParticle.currentRadius = math.min(existingParticle.currentRadius + existingParticle.radiusTenth, existingParticle.maxRadius)

        if existingParticle.currentRadius == existingParticle.maxRadius then
            existingParticle.lastFrame = true
        end

        if love.timer.getTime() - existingParticle.generatedAt > existingParticle.lifespan then
            existingParticle.expired = true
        end
    end
end

function Particle.animate(existingParticle)
    local radiusToDraw = existingParticle.currentRadius
    
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 0.3)
    love.graphics.circle('line', existingParticle.x, existingParticle.y, radiusToDraw)
    if existingParticle.touchingOuter then
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 1)
        love.graphics.print(existingParticle.scoreAdded, existingParticle.x + radiusToDraw, existingParticle.y)
    end
    
    COLOR_PALLETTE.setColor(COLOR_PALLETTE.TEAL, 0.5)
    love.graphics.circle('line', existingParticle.x, existingParticle.y, radiusToDraw/2)
    if existingParticle.touchingInner then
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, 1)
        love.graphics.print(existingParticle.scoreAdded, existingParticle.x + radiusToDraw / 2, existingParticle.y)
    end
end

return Particle