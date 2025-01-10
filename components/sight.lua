function attachSightToEntity(entity, visionRadius, visionStartAngle, visionEndAngle, attention, piDivider)
    entity.attention = attention
    entity.visionRadius = visionRadius
    entity.visionStartAngle = visionStartAngle
    entity.visionEndAngle = visionEndAngle
    entity.piDivider = piDivider or 4
    entity.sectorHalf = math.pi / entity.piDivider

    entity.aimVisionAtAttention = function()
        if entity.attention then
            local angleTo = trigonometry.atanByCoordinates(entity, entity.attention)
            entity.visionStartAngle = angleTo + entity.sectorHalf
            entity.visionEndAngle = angleTo - entity.sectorHalf
        end
    end

    entity.isCoordInVision = function(coordToCheck)
        return trigonometry.isInsideSector(
            coordToCheck,
            entity,
            entity.visionStartAngle,
            entity.visionEndAngle,
            entity.visionRadius
        )
    end

    entity.see = function ()
        local playerDetected = trigonometry.isInsideSector(Player, entity, entity.visionStartAngle, entity.visionEndAngle, entity.visionRadius)

        if playerDetected then
            entity.attention = Player
        end
    end

    entity.drawVisionCone = function ()
        love.graphics.arc('line', entity.x, entity.y, entity.visionRadius, entity.visionStartAngle, entity.visionEndAngle)
    end

    return entity
end