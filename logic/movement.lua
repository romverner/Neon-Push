movement = {}

local function updateCenter(entity)
    entity.center.x = entity.x + entity.halfWidth
    entity.center.y = entity.y + entity.halfHeight
end

function movement.getWorldCoordinate(entity)
    local worldX = math.floor((entity.x + entity.halfWidth) / 16)
    local worldY = math.floor((entity.y + entity.halfHeight) / 16)
    return { x = worldX, y = worldY }
end

function movement.getKeyboardDirectionVector()
    local vector = physics.get2DVector()

    if love.keyboard.isDown('d') then
        vector.x = 1
    elseif love.keyboard.isDown('a') then
        vector.x = -1
    end

    if love.keyboard.isDown('w') then
        vector.y = -1
    elseif love.keyboard.isDown('s') then
        vector.y = 1
    end

    return vector
end

function movement.updateVelocities(dt, entity, friction, accelModifier)
    -- Normalize vector for diagonal movements.
    normalizedVector = physics.normalizeVector(entity.direction)
    -- Calculate new acceleration
    entity.ax, entity.ay = physics.getAcceleration(dt, normalizedVector, entity.speed, entity.momentum)

    -- Apply modifier if not nil
    if accelModifier then
        entity.ax = entity.ax * accelModifier
        entity.ay = entity.ay * accelModifier
    end

    -- Get new velocity
    entity.vx = entity.vx + entity.ax
    entity.vy = entity.vy + entity.ay

    if entity.vx < 0 then
        entity.vx = math.max(entity.vx, -entity.maxSpeed)
    else
        entity.vx = math.min(entity.vx, entity.maxSpeed)     
    end
    
    if entity.vy < 0 then
        entity.vy = math.max(entity.vy, -entity.maxSpeed)
    else
        entity.vy = math.min(entity.vy, entity.maxSpeed)
    end

    -- Apply friction
    entity.vx = entity.vx * friction
    entity.vy = entity.vy * friction

    return entity
end

function movement.updateVelocities(entity)
    entity.x = entity.x + entity.vx
    entity.y = entity.y + entity.vy

    if entity.x < 0 then
        entity.x = 0
    end

    if entity.y < 0 then
        entity.y = 0
    end

    if entity.x > Map.gameWorld[3] then
        entity.x = Map.gameWorld[3]
    end

    if entity.y > Map.gameWorld[4] then
        entity.y = Map.gameWorld[4]
    end

    updateCenter(entity)
    
    return entity
end

return movement