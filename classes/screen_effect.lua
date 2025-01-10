ScreenEffect = {}

function ScreenEffect.getDefaultScreenEffectObject(bgColor, vectorColor)
    return {
        backgroundColor = bgColor,
        vectorColor = vectorColor,
        active = true
    }
end

function ScreenEffect:new(bgColor, vectorColor)
    local obj = ScreenEffect.getDefaultScreenEffectObject(bgColor, vectorColor)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return ScreenEffect