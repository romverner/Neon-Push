love.keyboard.keysPressed = {}
love.keyboard.keysReleased = {}

push = require 'libraries.push.push'
physics = require 'logic.physics'
movement = require 'logic.movement'
trigonometry = require 'logic.trigonometry'

virtualWidth = 640
virtualHeight = 640

windowWidth = 720
windowHeight = 720

function love.load()
    -- makes upscaling look pixel-y instead of blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    wf = require 'libraries.windfield'
    world = wf.newWorld(0, 0)

    COLOR_PALLETTE = require('constants.colors')
    Player = require('entities.player_v2')
    FlowChaser = require('entities.flow_chaser')
    PushChaser = require('entities.push_chaser')
    Map = require('classes.map')
    currentMap = Map:new()
    currentMap:generate()
    ScoreCircle = require('entities.score_circle')
    SnowEffect = require('screen_effects.snow')

    Score = 0
    -- Spawner = require('logic.spawner')

    enemies = {}
    parts = {}
    -- table.insert(enemies, newChaser)

    for i=1,40,1 do
        local newChaser = FlowChaser:new(math.random(0, virtualWidth), math.random(0, virtualHeight))
        table.insert(enemies, newChaser)
    end

    for i=1,1,1 do
        local newChaser = PushChaser:new(math.random(0, virtualWidth), math.random(0, virtualHeight))
        table.insert(enemies, newChaser)
    end

    for i=1,5,1 do
        local part = ScoreCircle:new(math.random(0, virtualWidth),math.random(0, virtualHeight),math.random(34,185),math.random(8, 20),10,0.1,1)
        table.insert(parts, part)
    end

    push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
        fullscreen = false,
        resizable = true
    })

    fps = 0
end

function love.update(dt)
    fps = 1 / dt

    Player:move(dt)

    for i,v in ipairs(enemies) do
        v:move(dt, currentMap)
    end

    -- SnowEffect:run()

    -- newChaser:move(dt, currentMap)
    world:update(dt)
    currentMap:update(dt)
    -- Spawner.run(dt, 30)

    for i,v in ipairs(parts) do
        if v.delete then
            table.remove(parts, i)
        else
            local mapVector = currentMap:getVectorAtCoords(v)

            if mapVector and not mapVector.effectActive then
                v:move(dt, mapVector.vector)
            else
                v:move(dt)
            end
        end
    end

    -- if mapVector then
    --     part:moveSelf(mapVector.vector)
    -- else
    --     part:moveSelf()
    -- end
    -- end
    
    Player:matchPositionToCollider()

    for i,v in ipairs(enemies) do
        v:matchPositionToCollider()
    end

    Player:matchBulletPositionsToColliders()

    -- newChaser:matchPositionToCollider()
    -- Player:trackNoiseParticles(dt)

    -- for i,v in ipairs(parts) do
    --     v.x = v.collider:getX()
    --     v.y = v.collider:getY()
    -- end
    -- cam:setPosition(Player.x, Player.y)

    -- for i=1,1000,1 do
    --     local part = Particle:new()
    --     table.insert(parts, part)
    -- end

    Score = Score + dt
end

function love.draw()
    push:apply('start')
    drawToCamera()
    -- love.graphics.setColor(1,1,1,1)
    -- love.graphics.print(math.abs(Player.vx) + math.abs(Player.vy), 0, 15)
    push:apply('end')
end

function love.keypressed(key)
    if key == "lshift" then
        Player:roll()
    end

    if key == '=' then
        
    end
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

function drawToCamera()

    COLOR_PALLETTE.setColor(COLOR_PALLETTE.BLACK, 1)
    love.graphics.rectangle('fill', -5, -5, virtualWidth + 5, virtualHeight + 5)

    -- currentMap:draw(COLOR_PALLETTE.WHITE, 0.25)
    currentMap:draw()
    -- part:draw()
    for i,v in ipairs(parts) do
        v:draw()
    end

    -- newChaser:draw()
    Player:draw()


    for i,v in ipairs(enemies) do
        v:draw()
    end



    -- for i,v in ipairs(enemies) do
    --     v.draw()
    -- end

    -- Spawner.draw()

    -- love.graphics.setColor(1,1,1,0.5)
    -- love.graphics.rectangle('line', 0, 0, virtualWidth, virtualHeight)

    local cornerDistance = physics.distanceBetweenCoords({x=0,y=0}, {x=320, y=320})
    local distanceToCenter = physics.distanceBetweenCoords(Player, {x=320, y=320})

    local opacityToUse = distanceToCenter/cornerDistance
    opacityToUse = math.max(opacityToUse - 0.5, 0)

    SnowEffect:draw()

    if distanceToCenter > cornerDistance then
        opacityToUse = 1
    end

    COLOR_PALLETTE.setColor(COLOR_PALLETTE.RED, opacityToUse)
    love.graphics.rectangle('fill', 0, 0, virtualWidth, virtualHeight)

    love.graphics.setColor(1,1,1)
    love.graphics.print(math.floor(Score), 2,2)
    love.graphics.print(fps, 300, 0)
    -- world:draw()
end