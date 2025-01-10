COLOR_PALLETTE = require('constants.colors')

local Entity = require('components.entity')
local attachSightToEntity = require('components.sight')
local GenericEntity = {}

function GenericEntity.newPusher(name, x, y, width, height, health, speed, maxSpeed, momentum, directX, directY)
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
    NewPusher.direction.y = directY

    NewPusher.lock.x = false
    NewPusher.lock.y = false

    NewPusher.collider = world:newBSGRectangleCollider(
        NewPusher.x, 
        NewPusher.y, 
        NewPusher.width, 
        NewPusher.height, 
        3
    )

    NewPusher.collider:setFixedRotation(true)

    return NewPusher
end

function GenericEntity.attachSightToEntity(entity, visionRadius, startAngle, endAngle, attention, piDivider)
    attachSightToEntity(entity, visionRadius, startAngle, endAngle, attention, piDivider)

    entity.setDirection = function ()
        local currentX = math.floor(entity.x)
        local currentY = math.floor(entity.y)

        if entity.attention then
            local attentionX = math.floor(entity.attention.x)
            local attentionY = math.floor(entity.attention.y)

            if not entity.lock.x then
                if attentionX > currentX then
                    entity.direction.x = 1
                elseif attentionX < currentX then
                    entity.direction.x = -1
                end
            end
            
            if not entity.lock.y then
                if attentionY > currentY then
                    entity.direction.y = 1
                elseif attentionY < currentY then
                    entity.direction.y = -1
                end
            end
            
        end
    end

    entity.move = function(dt)
        entity.see()
        entity.setDirection()

        local normalizedVector = physics.normalizeVector(entity.direction)

        entity.vx = entity.vx + (entity.speed + entity.momentum) * normalizedVector.x * math.abs(normalizedVector.x)
        entity.vy = entity.vy + (entity.speed + entity.momentum) * normalizedVector.y * math.abs(normalizedVector.y)

        if not entity.lock.x then
            entity.vx = entity.vx * 0.98
        end

        if not entity.lock.y then
            entity.vy = entity.vy * 0.98
        end

        -- if not entity.attention then
        --     entity.vx = entity.vx * 0.5
        --     entity.vy = entity.vy * 0.5
        -- end

        entity.collider:setLinearVelocity(entity.vx, entity.vy)
    end

    entity.draw = function (debug)
        -- COLOR_PALLETTE.setColor(COLOR_PALLETTE.PURPLE)
        love.graphics.setColor(COLOR_PALLETTE.PURPLE.r, COLOR_PALLETTE.PURPLE.g, COLOR_PALLETTE.PURPLE.b, 1)
        love.graphics.rectangle('fill', entity.x-entity.halfWidth, entity.y-entity.halfHeight, entity.width, entity.height)

        if debug then
           entity.drawVisionCone()
        end
    end
end

return GenericEntity