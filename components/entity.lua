local attachSightToEntity = require('components.sight')

local Entity = {}

function Entity.new(name, x, y, width, height, health, speed, maxSpeed, momentum)
    local startX = x
    local startY = y
    local width = width
    local height = height
    return {
        direction = { x = 0, y = 0 },
        x = startX,
        y = startY,
        ax = 0,
        ay = 0,
        vx = 0,
        vy = 0,
        startCoords = { x = startX, y = startY },
        center = { x = startX + width / 2, y = startY + height / 2},
        width = width,
        halfWidth = width / 2,
        height = height,
        halfHeight = height / 2,
        speed = speed,
        maxSpeed = maxSpeed,
        momentum = momentum,
        health = health,
        name = name
    }
end

function Entity.matchPositionToCollider(entity)
    entity.x = entity.collider:getX()
    entity.y = entity.collider:getY()
end

function Entity.attachSightToEntity(entity, visionRadius, startAngle, endAngle, attention, piDivider)
    attachSightToEntity(entity, visionRadius, startAngle, endAngle, attention, piDivider)
end

return Entity