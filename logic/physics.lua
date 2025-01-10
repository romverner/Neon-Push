physics = {}

function physics.get2DVector()
    return { x = 0, y = 0 }
end

function physics.normalizeVector(vectorToNormalize)
    local length = math.sqrt( vectorToNormalize.x^2 + vectorToNormalize.y^2 )
    
    if length > 0 then
        vectorToNormalize.x = vectorToNormalize.x / length
        vectorToNormalize.y = vectorToNormalize.y / length
    end

    return vectorToNormalize
end

function physics.distanceBetweenCoords(coords1, coords2)
    return math.sqrt( (coords2.x - coords1.x)^2 + (coords2.y - coords1.y)^2 )
end

return physics