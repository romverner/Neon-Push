Entity = require 'components.entity'

PusherAmbush = Entity.new('PusherAmbush', 450, 100, 999, 15, 35, 1)

PusherAmbush.collider = world:newBSGRectangleCollider(PusherAmbush.x, PusherAmbush.y, PusherAmbush.width, PusherAmbush.height, 3)
PusherAmbush.collider:setFixedRotation(true)

PusherAmbush.facing = { x=-1, y = 0 }
PusherAmbush.visionDistance = 75
PusherAmbush.detectionTime = 0.5
PusherAmbush.detectionLevel = 0
PusherAmbush.patrolPoints = {{x=75,y=75,name='patrol'},{x=350,y=75,name='patrol'}}

PusherAmbush.attention = nil
PusherAmbush.inspectTime = 6
PusherAmbush.angleToAttention = 0
PusherAmbush.visionArcStartAngle = math.pi + math.pi/2.25
PusherAmbush.visionArcEndAngle = math.pi - math.pi/2.25

PusherAmbush.lastAction = love.timer.getTime()

local function aimVisionAtAttention()
    if PusherAmbush.attention then
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(PusherAmbush, PusherAmbush.attention)
        PusherAmbush.visionArcStartAngle = angleTo + sectorAngleHalf
        PusherAmbush.visionArcEndAngle = angleTo - sectorAngleHalf
    end
end

function PusherAmbush.draw()
    love.graphics.circle('line', PusherAmbush.x, PusherAmbush.y, 14)
    aimVisionAtAttention()
    love.graphics.arc('line', PusherAmbush.x, PusherAmbush.y, PusherAmbush.visionDistance, PusherAmbush.visionArcStartAngle, PusherAmbush.visionArcEndAngle)
end

function PusherAmbush.listen()
    if PusherAmbush.attention then
        if PusherAmbush.attention.name ~= Player.name then
            for _, particle in ipairs(Player.noiseParticles) do
                if physics.distanceBetweenCoords(PusherAmbush, particle) <= particle.currentRadius then
                    PusherAmbush.attention = particle
                    PusherAmbush.lastAction = love.timer.getTime()
                    break
                end
            end 
        end 
    else
        for _, particle in ipairs(Player.noiseParticles) do
            if physics.distanceBetweenCoords(PusherAmbush, particle) <= particle.currentRadius then
                PusherAmbush.attention = particle
                PusherAmbush.lastAction = love.timer.getTime()
                break
            end
        end 
    end
end

function PusherAmbush.see(dt)
    -- local visionPoint = { x = PusherAmbush.facing.x * PusherAmbush.visionDistance, y = PusherAmbush.facing.y * PusherAmbush.visionDistance }
    -- local distanceToVisionPoint = physics.distanceBetweenCoords(PusherAmbush, visionPoint)
    -- distanceToVisionPoint = math.min(distanceToVisionPoint, PusherAmbush.visionDistance)
    local playerDetected = trigonometry.isInsideSector(Player, PusherAmbush, PusherAmbush.visionArcStartAngle, PusherAmbush.visionArcEndAngle, PusherAmbush.visionDistance)
    
    if playerDetected and PusherAmbush.detectionLevel > PusherAmbush.detectionTime then
        PusherAmbush.attention = Player
    elseif playerDetected and PusherAmbush.detectionLevel > PusherAmbush.detectionTime / 2 then
        PusherAmbush.detectionLevel = PusherAmbush.detectionLevel + dt
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(PusherAmbush, Player)
        PusherAmbush.visionArcStartAngle = angleTo + sectorAngleHalf
        PusherAmbush.visionArcEndAngle = angleTo - sectorAngleHalf
    elseif playerDetected then
        PusherAmbush.detectionLevel = PusherAmbush.detectionLevel + dt
    else
        PusherAmbush.detectionLevel = math.max(PusherAmbush.detectionLevel - dt, 0)

    end
end

local function scan()

end

local function patrol()
    local nearestPoint = nil
    PusherAmbush.direction.x = 0
    PusherAmbush.direction.y = 0

    if love.timer.getTime() - PusherAmbush.lastAction >= PusherAmbush.inspectTime then
        for i,point in ipairs(PusherAmbush.patrolPoints) do
            local distanceTo = physics.distanceBetweenCoords(point, PusherAmbush)
            
            if distanceTo > 32 then
                if not nearestPoint then
                    nearestPoint = point
                    nearestPoint.distanceTo = distanceTo
                elseif distanceTo < nearestPoint.distanceTo then
                    nearestPoint = point
                    nearestPoint.distanceTo = distanceTo
                end    
            end
        end

        PusherAmbush.facing.x = nearestPoint.x - PusherAmbush.x > 0 and 1 or -1
        PusherAmbush.attention = nearestPoint
        PusherAmbush.lastAction = love.timer.getTime()
    else
        scan()
    end
end

function PusherAmbush.setDirection()
    local dummyX = math.floor(PusherAmbush.x)
    local dummyY = math.floor(PusherAmbush.y)

    if PusherAmbush.attention then
        local attentionX = math.floor(PusherAmbush.attention.x)
        local attentionY = math.floor(PusherAmbush.attention.y)
        local distanceToAttention = physics.distanceBetweenCoords(PusherAmbush.attention, PusherAmbush)

        if distanceToAttention < 16 and PusherAmbush.attention.name ~= 'player' then
            PusherAmbush.attention = nil
        end

        if attentionX > dummyX then
            PusherAmbush.direction.x = 1
        elseif attentionX < dummyX then
            PusherAmbush.direction.x = -1
        else
            PusherAmbush.direction.x = 0
        end

        if attentionY > dummyY then
            PusherAmbush.direction.y = 1
        elseif attentionY < dummyY then
            PusherAmbush.direction.y = -1
        else
            PusherAmbush.direction.y = 0
        end
    else
        -- patrol()
    end
end

function PusherAmbush.move(dt)
    -- PusherAmbush.listen()
    PusherAmbush.see(dt)
    PusherAmbush.setDirection()
    
    local normalizedVector = physics.normalizeVector(PusherAmbush.direction)

    PusherAmbush.vx = PusherAmbush.vx + (PusherAmbush.speed + PusherAmbush.momentum) * normalizedVector.x * math.abs(normalizedVector.x)
    PusherAmbush.vy = PusherAmbush.vy + (PusherAmbush.speed + PusherAmbush.momentum) * normalizedVector.y * math.abs(normalizedVector.y)

    PusherAmbush.vx = PusherAmbush.vx * 0.92
    PusherAmbush.vy = PusherAmbush.vy * 0.92

    if not PusherAmbush.attention then
        PusherAmbush.vx = PusherAmbush.vx * 0.15
        PusherAmbush.vy = PusherAmbush.vy * 0.15
    else
        PusherAmbush.vx = PusherAmbush.vx * 1.04
        PusherAmbush.vy = PusherAmbush.vy * 1.04
    end

    PusherAmbush.collider:setLinearVelocity(PusherAmbush.vx, PusherAmbush.vy)
end

return PusherAmbush