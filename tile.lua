-- This file is part of RetroSpriteMaker.
-- RetroSpriteMaker is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See <https://www.gnu.org/licenses/>.
local Object = require("libs.classic")

local Tile = Object:extend()

function Tile:new(x, y, size)
    self.x = x
    self.y = y
    self.size = size
    self.color = { 255, 255, 255 }
    self.borderColor = { 255, 0, 0 }
end

function Tile:draw()
    
    local r, g, b = self.color[1] / 255, self.color[2] / 255, self.color[3] / 255

    love.graphics.setColor(r, g, b)
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
    if self.borderColor[1] == 255 then
        r, g, b = self.borderColor[1] / 255, self.borderColor[2] / 255, self.borderColor[3] / 255

        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end

    love.graphics.setColor(1, 1, 1)
end

function Tile:setColor(colorArray)
    self.color = { colorArray[1], colorArray[2], colorArray[3] }
end

function Tile:setBorderColor(r, g, b)
    self.borderColor = { r, g, b }
end

function Tile:mouseIsHover(mx, my)
    local isHover = false
    if mx >= self.x and mx <= self.x + self.size and
        my >= self.y and my <= self.y + self.size then
        isHover = true
    end
    return isHover
end

return Tile
