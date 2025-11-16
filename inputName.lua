-- This file is part of RetroSpriteMaker.
-- RetroSpriteMaker is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See <https://www.gnu.org/licenses/>.
local Object = require("libs.classic")
local InputName = Object:extend()
local InputField = require("libs.InputField")
local Button = require("button")

function InputName:new(x, y, width, height)
    self.inputField = InputField()
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.name = ""
    self.visible = false
    self.inputField:setCoord(self.x + 64, self.y + 64)
    self.cancel = Button(self.x + 50, self.y + self.height - 100, 100, 50, "cancel")
    self.validate = Button(self.width + self.x - 200, self.y + self.height - 100, 100, 50, "validate")
    self.validated = false
    self:initButtons()
    self.isModal = false
end

function InputName:initButtons()
    self.cancel:setBackgroundColor(255, 0, 0)
    self.cancel:setAngle(20)
    self.cancel:setOnClick(function() self.visible = false end)
    self.cancel:setImmediate()
    self.validate:setBackgroundColor(0, 255, 0)
    self.validate:setAngle(20)
    self.validate:setImmediate()
    self.validate:setOnClick(function()
        if self.inputField.text then
            self.name = self.inputField.text
            self.visible = false
            self.validated = true
        end
    end)
end

function InputName:setText(text)
    self.text = text
end

function InputName:consumeValidation()
    if self.validated then
        self.validated = false
        return true
    end
    return false
end

function InputName:draw()
    if self:isVisible() then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0, 0, 0)

        if not self.isModal then
            self.inputField:draw()
            self.cancel:draw()
            love.graphics.print("Entrez le nom du sprite :", self.x + 64, self.y + 32)
        else
            love.graphics.print(self.text, self.x + 64, self.y + 32)
            love.graphics.setColor(1, 1, 1)
        end
        self.validate:draw()

        love.graphics.setColor(1, 1, 1)
    end
end

function InputName:mousepressed(mx, my, button)
    if self:isVisible() then
        self.inputField:mousepressed(mx, my, button)
        self.validate:mousepressed(mx, my, button)
        self.cancel:mousepressed(mx, my, button)
    end
end

function InputName:keypressed(key)
    if self:isVisible() then
        self.inputField:keypressed(key)
    end
end

function InputName:textinput(t)
    if self:isVisible() and self.inputField.focused then
        self.inputField:textinput(t)
        self.name = self.inputField.text
        --print(self.name)
    end
end

function InputName:update(dt)
    if self:isVisible() then
        self.inputField:update(dt)
    end
end

function InputName:show()
    self.visible = true
end

function InputName:hide()
    self.visible = false
end

function InputName:isVisible()
    return self.visible
end

return InputName
