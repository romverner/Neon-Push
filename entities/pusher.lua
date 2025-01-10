Entity = require 'components.entity'
attention = require 'components.sight'
local Pusher = Entity.new('pusher', 20, 20, 999, 15, 35, 1)
attention(Pusher)
Pusher.collider = world:newBSGRectangleCollider(Pusher.x, Pusher.y, Pusher.width, Pusher.height, 3)
Pusher.collider:setFixedRotation(true)

Pusher.facing = { x=1, y = 0 }
Pusher.visionDistance = 75
Pusher.detectionTime = 0.5
Pusher.detectionLevel = 0
Pusher.patrolPoints = {{x=75,y=75,name='patrol'},{x=350,y=75,name='patrol'}}

Pusher.attention = nil
Pusher.inspectTime = 6
Pusher.angleToAttention = 0
Pusher.visionArcStartAngle = 0 + math.pi/2.25
Pusher.visionArcEndAngle = 0 - math.pi/2.25

Pusher.lastAction = love.timer.getTime()

local function aimVisionAtAttention()
    if Pusher.attention then
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(Pusher, Pusher.attention)
        Pusher.visionArcStartAngle = angleTo + sectorAngleHalf
        Pusher.visionArcEndAngle = angleTo - sectorAngleHalf
    end
end

function Pusher.draw()
    love.graphics.circle('line', Pusher.x, Pusher.y, 14)
    aimVisionAtAttention()
    love.graphics.arc('line', Pusher.x, Pusher.y, Pusher.visionDistance, Pusher.visionArcStartAngle, Pusher.visionArcEndAngle)
end

function Pusher.listen()
    if Pusher.attention then
        if Pusher.attention.name ~= Player.name then
            for _, particle in ipairs(Player.noiseParticles) do
                if physics.distanceBetweenCoords(Pusher, particle) <= particle.currentRadius then
                    Pusher.attention = particle
                    Pusher.lastAction = love.timer.getTime()
                    break
                end
            end 
        end 
    else
        for _, particle in ipairs(Player.noiseParticles) do
            if physics.distanceBetweenCoords(Pusher, particle) <= particle.currentRadius then
                Pusher.attention = particle
                Pusher.lastAction = love.timer.getTime()
                break
            end
        end 
    end
end

function Pusher.see(dt)
    -- local visionPoint = { x = Pusher.facing.x * Pusher.visionDistance, y = Pusher.facing.y * Pusher.visionDistance }
    -- local distanceToVisionPoint = physics.distanceBetweenCoords(Pusher, visionPoint)
    -- distanceToVisionPoint = math.min(distanceToVisionPoint, Pusher.visionDistance)
    local playerDetected = trigonometry.isInsideSector(Player, Pusher, Pusher.visionArcStartAngle, Pusher.visionArcEndAngle, Pusher.visionDistance)
    
    if playerDetected and Pusher.detectionLevel > Pusher.detectionTime then
        Pusher.attention = Player
    elseif playerDetected and Pusher.detectionLevel > Pusher.detectionTime / 2 then
        Pusher.detectionLevel = Pusher.detectionLevel + dt
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(Pusher, Player)
        Pusher.visionArcStartAngle = angleTo + sectorAngleHalf
        Pusher.visionArcEndAngle = angleTo - sectorAngleHalf
    elseif playerDetected then
        Pusher.detectionLevel = Pusher.detectionLevel + dt
    else
        Pusher.detectionLevel = math.max(Pusher.detectionLevel - dt, 0)

    end
end


function Pusher.setDirection()
    local dummyX = math.floor(Pusher.x)
    local dummyY = math.floor(Pusher.y)

    if Pusher.attention then
        -- local attentionX = math.floor(Pusher.attention.x)
        local attentionY = math.floor(Pusher.attention.y)
        local distanceToAttention = physics.distanceBetweenCoords(Pusher.attention, Pusher)

        if distanceToAttention < 16 and Pusher.attention.name ~= 'player' then
            Pusher.attention = nil
        end
        
        Pusher.direction.x = 1
        -- if attentionX > dummyX then
        --     Pusher.direction.x = 1
        -- elseif attentionX < dummyX then
        --     Pusher.direction.x = -1
        -- else
        --     Pusher.direction.x = 0
        -- end

        if attentionY > dummyY then
            Pusher.direction.y = 1
        elseif attentionY < dummyY then
            Pusher.direction.y = -1
        -- else
        --     Pusher.direction.y = 0
        end
    end
end

function Pusher.move(dt)
    Pusher.see(dt)
    Pusher.setDirection()
    
    local normalizedVector = physics.normalizeVector(Pusher.direction)

    Pusher.vx = Pusher.vx + (Pusher.speed + Pusher.momentum) * normalizedVector.x * math.abs(normalizedVector.x)
    Pusher.vy = Pusher.vy + (Pusher.speed + Pusher.momentum) * normalizedVector.y * math.abs(normalizedVector.y)

    Pusher.vx = Pusher.vx * 0.92
    Pusher.vy = Pusher.vy * 0.92

    if not Pusher.attention then
        Pusher.vx = Pusher.vx * 0.15
        Pusher.vy = Pusher.vy * 0.15
    else
        Pusher.vx = Pusher.vx * 1.04
        Pusher.vy = Pusher.vy * 1.04
    end

    Pusher.collider:setLinearVelocity(Pusher.vx, Pusher.vy)
end

return Pusher