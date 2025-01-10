GenericEntity = require 'entities.generic'
SpherePusher = require 'entities.sphere'

local Spawner = {}
Spawner.random = {}
Spawner.maxEnemies = 30
Spawner.lastSpawnedAt = nil
Spawner.spawnTime = 1.5

function Spawner.random.leftCoord()
    local x = - 10
    local y = math.random(7, virtualHeight - 7)
    return { x = x, y = y }
end

function Spawner.random.rightCoord()
    local x = virtualWidth + 10
    local y = math.random(7, virtualHeight - 7)
    return { x = x, y = y }
end

function Spawner.random.newPusher()
    local coordinates = {}
    local leftSpawn = false

    if math.random(1,100) > 50 then
        coordinates = Spawner.random.leftCoord()
        leftSpawn = true
    else
        coordinates = Spawner.random.rightCoord()
    end

    local newPusher = GenericEntity.newPusher(
        'Pusher',
        coordinates.x,
        coordinates.y,
        18,
        18,
        50,
        20,
        50,
        1,
        leftSpawn and 1 or -1,
        0
    )

    -- newPusher.lock.y = true
    newPusher.direction.x = leftSpawn and 1 or -1

    GenericEntity.attachSightToEntity(
        newPusher,
        200,
        leftSpawn and math.pi / 2.2 or math.pi / 2.2 + math.pi,
        leftSpawn and - math.pi / 2.2 or -math.pi / 2.2 + math.pi,
        nil,
        2.2
    )

    table.insert(enemies, newPusher)
end

function Spawner.random.newSphere()
    local coordinates = {}
    local leftSpawn = false

    if math.random(1,100) > 50 then
        coordinates = Spawner.random.leftCoord()
        leftSpawn = true
    else
        coordinates = Spawner.random.rightCoord()
    end

    local newPusher = SpherePusher.newPusher(
        'Pusher',
        coordinates.x,
        coordinates.y,
        18,
        30,
        50,
        2,
        20,
        1,
        leftSpawn and 1 or -1,
        0
    )

    newPusher.direction.x = leftSpawn and 1 or -1
    newPusher.lock.x = true
    newPusher.lock.y = true

    table.insert(enemies, newPusher)
end

function Spawner.run(dt, maxEnemies)
    Spawner.maxEnemies = maxEnemies or Spawner.maxEnemies

    for i, v in ipairs(enemies) do
        Entity.matchPositionToCollider(v)

        if v.x > 690 or v.x < -50 or v.y < -50 or v.y > 690 then
            v.collider:destroy()
            table.remove(enemies, i)
        else
            v.move(dt)
        end
    end

    local scoreFactor = math.floor(Score/1000)

    if scoreFactor == 0 then
        scoreFactor = 1
    end

    local now = love.timer.getTime()
    if Spawner.lastSpawnedAt and (now - Spawner.lastSpawnedAt) * scoreFactor >= Spawner.spawnTime then
        local entity = nil

        if math.random(1,10) < 2 then
            entity = Spawner.random.newPusher()
        else
            entity = Spawner.random.newSphere()
        end
        -- local entity = Spawner.random.newPusher()
        table.insert(enemies, entity)
        Spawner.lastSpawnedAt = love.timer.getTime()
    end

    if not Spawner.lastSpawnedAt then
        Spawner.lastSpawnedAt = love.timer.getTime()
    end
end

function Spawner.draw()
    for i,enemy in ipairs(enemies) do
        enemy.draw()
    end
end

return Spawner