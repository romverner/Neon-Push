trigonometry = {}

function trigonometry.getPolarCoordinates(angle, radius)
    return {
        x = radius * math.cos(angle),
        y = radius * math.sin(angle)
    }
end

function trigonometry.getRelativeCenterForCoords(centerCoords, coords)
    return {
        x = centerCoords.x - coords.x,
        y = centerCoords.y - coords.y
    }
end

function trigonometry.atanByCoordinates(centerCoords, compareCoords)
    local opposite = compareCoords.y - centerCoords.y
    local adjacent = compareCoords.x - centerCoords.x
    local angle = math.atan(opposite / adjacent)

    if compareCoords.x < centerCoords.x then
        angle = angle + math.pi
    end

    return angle
end

function trigonometry.isClockwise(toCheckCoord, centerCoord)
    return -toCheckCoord.x*centerCoord.y + toCheckCoord.y*centerCoord.x > 0
end

function trigonometry.withinRadius(toCheckCoord, radiusSquared)
    return toCheckCoord.x*toCheckCoord.x + toCheckCoord.y*toCheckCoord.y <= radiusSquared
end

function trigonometry.isInsideSector(toCheck, center, startAngle, endAngle, radius)
    -- Get sector polar coords using trig fn's
    local sectorStart = trigonometry.getPolarCoordinates(startAngle, radius)
    local sectorEnd = trigonometry.getPolarCoordinates(endAngle, radius)
    
    -- Need to new relative center to use polar coordinates with
    local relativeCenter = trigonometry.getRelativeCenterForCoords(center, toCheck)

    return not trigonometry.isClockwise(sectorStart, relativeCenter)
        and trigonometry.isClockwise(sectorEnd, relativeCenter) and
        trigonometry.withinRadius(relativeCenter, radius^2)
end

return trigonometry