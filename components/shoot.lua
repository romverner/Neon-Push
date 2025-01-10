require 'classes.bullet'

function attachShootToEntity(entity)
    entity.shotTimer = 0
    entity.fireRate = 0.15
    entity.shotSpeed = 5
    entity.bulletSize = 10
    entity.target = nil
    entity.bullets = {}

    function entity:shoot(dt)
        self.shotTimer = self.shotTimer + dt

        for i, bullet in ipairs(self.bullets) do
            bullet:travel()
        end

        if self.shotTimer >= self.fireRate and love.mouse.isDown(1) then
            local nearestTarget = nil
            local shortestDistance = nil

            for i, enemy in ipairs(enemies) do
                local distanceToEnemy = physics.distanceBetweenCoords(enemy, self.center)
                if not shortestDistance then
                    shortestDistance = distanceToEnemy
                    nearestTarget = enemy
                end

                if distanceToEnemy < shortestDistance then
                    shortestDistance = distanceToEnemy
                    nearestTarget = enemy
                end
            end

            local angleToTarget = trigonometry.atanByCoordinates(self, nearestTarget)
            local polarCoord = trigonometry.getPolarCoordinates(angleToTarget, self.width)

            local bullet = Bullet:new(self.x + polarCoord.x, self.y + polarCoord.y, self.bulletSize, nearestTarget)
            bullet:shootAt(nearestTarget, angleToTarget)
            table.insert(self.bullets, bullet)

            self.shotTimer = 0
        end
    end

    function entity:drawBullets()
        for i, bullet in ipairs(self.bullets) do
            bullet:draw()
        end
    end

    function entity:matchBulletPositionsToColliders()
        for i, bullet in ipairs(self.bullets) do
            bullet:matchPositionToCollider()
        end
    end
end