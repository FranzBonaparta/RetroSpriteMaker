-- This file is part of RetroSpriteMaker.
-- RetroSpriteMaker is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See <https://www.gnu.org/licenses/>.
local Object = require("libs.classic")

local Button = Object:extend()
local defaultFont = love.graphics.newFont(14)

function Button:new(x, y, width, height, text, f, angle)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text or " "
    self.onClick = f or nil
    self.pressed = false
    self.pressedTime = 0
    self.image = nil
    self.canReleased = true
    self.backgroundColor={0,0,0}
    self.angle=angle or 0
    self.toRemove=false
    self.locked=false
end
function Button:setToRemove()
    self.toRemove=true
end
function Button:setOnClick(f)
    self.onClick=f
end
function Button:setLocked(state)
    self.locked = state
end

function Button:isLocked()
    return self.locked
end
function Button:adjustButtonSizeToText()
    local offset = 35

    local fontHeight = defaultFont:getHeight()
    local fontWidth = defaultFont:getWidth(self.text)
    self.width = fontWidth + offset + offset
    self.height = fontHeight + offset
end
function Button:setBackgroundColor(r, g, b, a)
    r, g, b = love.math.colorFromBytes(r, g, b)
    self.backgroundColor = { r, g, b, a }
end
function Button:setAngle(angle)
    self.angle=angle
end
function Button:draw()
    love.graphics.setFont(defaultFont)

    local offset = self.pressed and 0 or 0
    -- Drawing the background
    love.graphics.setColor(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], 0.8)
    love.graphics.rectangle("fill", self.x + offset, self.y + offset,
        self.width, self.height, self.angle, self.angle)

    if self.image then
        -- Scale calcul
        local scaleX = self.width / self.image:getWidth()
        local scaleY = self.height / self.image:getHeight()
        local imgW = self.image:getWidth() * scaleX
        local imgH = self.image:getHeight() * scaleY
        -- Center
        local imgX = self.x + offset + (self.width - imgW) / 2
        local imgY = self.y + offset + (self.height - imgH) / 2

        -- Draw the centered image
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.image, imgX, imgY, 0, scaleX, scaleY)
    end
    --center text above
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(
        self.text,
        self.x,
        self.y + self.height / 3,
        self.width,
        "center"
    )
    love.graphics.setColor(1, 1, 1)
 
end

function Button:setImmediate()
    self.canReleased = false
end

function Button:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
        my >= self.y and my <= self.y + self.height
end

--draw effect when clicked
function Button:mousepressed(mx, my, button)
    if button == 1 and self:isHovered(mx, my) then
        if self.canReleased == true then
            self.pressed = true
            self.pressedTime = 0.1
        else
            self.onClick()
            --print("click on "..mx..","..my)
        end
        --FxManager.play("click")
    end
end

--run onclick when released
function Button:mousereleased(mx, my, button)
    if button == 1 and self:isHovered(mx, my)
        and self.pressed == true and self.canReleased == true then
        self.onClick()
        --print("click", mx, my)
        return true -- tell parent box to stop propagation
    end
    self.pressed = false
end

function Button:update(dt)
    if self.pressed then
        self.pressedTime = self.pressedTime - dt
        if self.pressedTime <= 0 then
            self.pressed = false
        end
    end
end

return Button
