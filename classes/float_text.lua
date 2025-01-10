FloatText = {}

function FloatText.getDefaultFloatTextObejct(text, x, y, lifespan)
    return {
        text = text,
        x = x,
        y = y,
        aliveTime = 0,
        lifespan = lifespan
    }
end

function FloatText:new(text, x, y, lifespan)
    obj = FloatText.getDefaultFloatTextObejct(text, x, y, lifespan)
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function FloatText:draw(color, opacity)
    if color then
        COLOR_PALLETTE.setColor(color, opacity or 1)
    else
        local opacity = math.max(1 - (self.aliveTime / self.lifespan), 0)
        COLOR_PALLETTE.setColor(COLOR_PALLETTE.WHITE, opacity)
    end

    if self.aliveTime < self.lifespan then
        love.graphics.print(self.text, self.x, self.y)
    end
end

function FloatText:track(dt)
    if self.aliveTime < self.lifespan then
        self.aliveTime = self.aliveTime + dt 
    end
end

return FloatText