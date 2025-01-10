require 'classes.screen_effect'
require 'classes.test_particle'

local SnowEffect = ScreenEffect:new(COLOR_PALLETTE.WHITE, COLOR_PALLETTE.BLUE)
SnowEffect.particles = {}

function SnowEffect:run()
    if #SnowEffect.particles < 1000 then
        for i=1,5000-#SnowEffect.particles,1 do
            local particle = TestParticle:new(math.random(10,virtualWidth+200), -math.random(1,1000), 2, -math.pi/3.5, 0.1, 20)
            table.insert(SnowEffect.particles, particle)
        end
    end

    for i, particle in ipairs(self.particles) do
        if particle.x < 0 or particle.x > virtualWidth or particle.y > virtualHeight then
            table.remove(self.particles, i)
        end

        local mapVector = currentMap:getVectorAtCoords(particle)
        local randomVector = {x=-0.01 * math.random(), y=math.random()}

        -- if mapVector then
        --     randomVector.x = randomVector.x * mapVector.x
        --     randomVector.y = randomVector.y * mapVector.y
        -- end
        particle:moveSelf(randomVector)
    end
end

function SnowEffect:draw()
    for i, particle in ipairs(self.particles) do
        particle:draw(COLOR_PALLETTE.WHITE, 0.4)
    end
end

return SnowEffect