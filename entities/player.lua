COLOR_PALLETTE = require('constants.colors')
Entity = require 'components.entity'
attachDashToEntity = require('components.dash')

Player = Entity.new('player', 320, 320, 14, 14, 25, 25, 30, 3)
attachDashToEntity(Player, 20, 1.75, 0.6)

Player.collider = world:newBSGRectangleCollider(Player.x, Player.y, Player.width, Player.height, 3)
Player.collider:setFixedRotation(true)

Player.crouched = false
Player.crouchSpeed = 0.55

Player.noiseParticles = {}
Player.particleTimer = 0
Player.particleGenerationTime = 0.25

Player.visible = true

local function generateAndTrackParticles(dt)
    for i, noiseParticle in ipairs(Player.noiseParticles) do
        Particle.track(noiseParticle, dt)
    end

    Player.particleTimer = Player.particleTimer + dt
    local generationTime = Player.particleGenerationTime
    if Player.particleTimer >= generationTime then
        local noiseRadius = (math.abs(Player.vx) + math.abs(Player.vy)) * 0.18

        if noiseRadius > Player.width * 2 then
            table.insert(Player.noiseParticles, Particle.new(Player.x, Player.y, noiseRadius, 3, 0.02, 7))    
        end

        Player.particleTimer = 0
    end
end

-- function Player.draw()
--     COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE)
--     love.graphics.rectangle('fill', Player.x - Player.width / 2, Player.y - Player.height / 2, Player.width, Player.height)
--     COLOR_PALLETTE.setColor(COLOR_PALLETTE.BLACK)
--     love.graphics.rectangle('fill', Player.x - Player.width / 2 + 2, Player.y - Player.height / 2 + 2, 4, 4)

--     for i, noiseParticle in ipairs(Player.noiseParticles) do
--         if noiseParticle.expired then
--             table.remove(Player.noiseParticles, i)
--         else
--             Particle.animate(noiseParticle)
--         end
--     end

--     Player.animateDash()
-- end

function Player.move(dt)
    Player.direction = movement.getKeyboardDirectionVector()
    local normalizedVector = physics.normalizeVector(Player.direction)

    Player.vx = Player.vx + (Player.speed + Player.momentum) * (Player.crouched and Player.crouchSpeed or 1) * normalizedVector.x
    Player.vy = Player.vy + (Player.speed + Player.momentum) * (Player.crouched and Player.crouchSpeed or 1) * normalizedVector.y

    Player.vx = Player.vx * 0.92 --+ Player.momentum * Player.direction.x
    Player.vy = Player.vy * 0.92 --+ Player.momentum * Player.direction.y

    Player.collider:setLinearVelocity(Player.vx, Player.vy)

    Player.trackDash(dt)
    generateAndTrackParticles(dt)
end

-- return Player