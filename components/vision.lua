function attachVisionToEntity(entity, visionRadius, startAngle, endAngle)
    entity.attention = nil
    entity.visionRadius = visionRadius or 300
    entity.visionStartAngle = startAngle or math.pi / 4
    entity.visionEndAngle = endAngle or math.pi / 4
    entity.segmentAngle = math.pi / 8

    function entity:aimVisionAtAttention()
        if self.attention then
            local angleTo = trigonometry.atanByCoordinates(self, self.attention)
            self.visionStartAngle = angleTo + self.sectorHalf
            self.visionEndAngle = angleTo - self.sectorHalf
        end
    end

    function entity:canSeeCoord(coord)
        return trigonometry.isInsideSector(
            coord,
            self,
            self.visionStartAngle,
            self.visionEndAngle,
            self.visionRadius
        )
    end

    function entity:look(lookAt)
        local canSeePlayer = self.canSeeCoord(lookAt or Player)

        if canSeePlayer then
            self.attention = Player
        end
    end

    function entity:drawVision()
        love.graphics.arc('line', self.x, self.y, self.visionRadius, self.visionStartAngle, self.visionEndAngle)
    end

    return entity
end