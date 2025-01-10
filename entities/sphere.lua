COLOR_PALLETTE = require('constants.colors')

local Entity = require('components.entity')
local SpherePusher = {}

function SpherePusher.newPusher(name, x, y, width, height, health, speed, maxSpeed, momentum, directX, directY)
    local NewPusher = Entity.new(
        name,
        x,
        y,
        width,
        height,
        health,
        speed,
        maxSpeed,
        momentum
    )

    NewPusher.lock = {}

    NewPusher.direction.x = directX
    NewPusher.direction.y = 0

    NewPusher.lock.x = false
    NewPusher.lock.y = false

    NewPusher.collider = world:newRectangleCollider(
        NewPusher.x, 
        NewPusher.y, 
        NewPusher.width,
        NewPusher.height
    )

    NewPusher.collider:setFixedRotation(true)

    NewPusher.move = function(dt)
        local normalizedVector = physics.normalizeVector(NewPusher.direction)

        NewPusher.vx = NewPusher.vx + (NewPusher.speed + NewPusher.momentum) * normalizedVector.x * math.abs(normalizedVector.x)
        NewPusher.vy = NewPusher.vy + (NewPusher.speed + NewPusher.momentum) * normalizedVector.y * math.abs(normalizedVector.y)

        if not NewPusher.lock.x then
            NewPusher.vx = NewPusher.vx * 0.9
        end

        if not NewPusher.lock.y then
            NewPusher.vy = NewPusher.vy * 0.9
        end

        NewPusher.collider:setLinearVelocity(NewPusher.vx, NewPusher.vy)
    end

    NewPusher.draw = function (debug)
        love.graphics.setColor(COLOR_PALLETTE.ORANGE.r, COLOR_PALLETTE.ORANGE.g, COLOR_PALLETTE.ORANGE.b, 1)
        love.graphics.rectangle('fill', NewPusher.x - NewPusher.halfWidth, NewPusher.y - NewPusher.halfHeight, NewPusher.width, NewPusher.height)
    end

    return NewPusher
end

return SpherePusher