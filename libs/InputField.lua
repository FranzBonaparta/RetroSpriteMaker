local Object = require("libs.classic")

local InputField = Object:extend()

-- Constructor
function InputField:new(type)
    self.type = type or "alphabetic"      -- Type of allowed input ("alphabetic", "numeric", etc.)
    self.text = ""                        -- The actual input text
    self.focused = false                  -- Whether the field is currently focused
    self.cursorPos = #self.text + 1       -- Position of the cursor (1-based index)
    self.font = love.graphics.newFont(14) -- Default font
    self.width = 200                      -- Maximum width of the field (in pixels)
    self.height = self.font:getHeight()   -- Height of the field, based on font
    self.x = 10                           -- X position on screen
    self.y = 10                           -- Y position on screen
    self.cursorBlinkTime = 0              -- Timer used for blinking effect
    self.cursorVisible = true             -- Whether the cursor is currently visible
    self.placeholder = "Write here"
    self.cursorState = "arrow"
end

-- Draw the text and cursor
function InputField:draw()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0,0,0, 0.3)
    love.graphics.rectangle("fill", self.x - 3, self.y - 3, self.width + 3, self.height + 3)
    --print textinput
    if #self.text > 0 then
        love.graphics.setColor(0,0,0, 1)
        love.graphics.printf(self.text, self.x, self.y, self.width, "left")
    else
        --placeholder
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.printf(self.placeholder, self.x, self.y, self.width, "left")
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- Draw cursor if field is focused and blinking is "on"
    if self.focused and self.cursorVisible then
        local textBeforeCursor = self.text:sub(1, self.cursorPos - 1)
        local cursorX = self.x + self.font:getWidth(textBeforeCursor)

        love.graphics.setLineWidth(1)
        love.graphics.line(cursorX, self.y, cursorX, self.y + self.height)
    end
end

function InputField:setPlaceholder(text)
    self.placeholder = text
end

-- Handle typed characters
function InputField:textinput(t)
    local filtered = self:filterInput(t) -- Filter input based on type

    -- Prepare new version of text with the new character inserted
    local before = self.text:sub(1, self.cursorPos - 1)
    local after = self.text:sub(self.cursorPos)
    local potentialText = before .. filtered .. after

    -- Only allow insertion if it doesn't exceed the field's visual width
    if self.font:getWidth(potentialText) < self.width and self.focused then
        self.text = potentialText
        self.cursorPos = self.cursorPos + #filtered
    end
end

-- Filter input based on the specified input type
function InputField:filterInput(t)
    if self.type == "float" then
        if t == "." and self.text:find("%.") then
            return ""                          -- Only allow one dot for decimal numbers
        end
        return string.match(t, "[%d%.]") or "" -- Allow digits and one dot
    elseif self.type == "numeric" then
        return string.match(t, "[%d]") or ""   -- Allow digits and one dot
    elseif self.type == "alphabetic" then
        return string.match(t, "[%D]") or ""   -- Allow non-digit characters only
    else
        return t                               -- Default: allow all characters
    end
end

-- Handle special keys (backspace, arrows, return)
function InputField:keypressed(key)
    local keyActions = {
        backspace = function()
            if self.cursorPos > 1 then
                -- Remove character before cursor
                self.text = self.text:sub(1, self.cursorPos - 2) .. self.text:sub(self.cursorPos)
                self.cursorPos = self.cursorPos - 1
            end
        end,
        ["return"] = function()
            self.focused = false -- Defocus on Enter
        end,
        left = function()
            self.cursorPos = math.max(1, self.cursorPos - 1) -- Move cursor left
        end,
        right = function()
            self.cursorPos = math.min(#self.text + 1, self.cursorPos + 1) -- Move cursor right
        end,
        ["kpenter"] = function()
            self.focused = false -- Also defocus on keypad Enter
        end,
    }

    local action = keyActions[key]
    if action then action() end
end
function InputField:setCoord(x,y)
    self.x=x
    self.y=y
end
-- Handle mouse click: activate input field if clicked inside
function InputField:mousepressed(mx, my, button)
    if button == 1 and not self.focused then
        self.focused = mx >= self.x and mx <= self.x + self.width and
            my >= self.y and my <= self.y + self.height
        --desactivate if click outside
    elseif button == 1 and self.focused then
        self.focused = (mx < self.x or mx > self.x + self.width) and (my < self.y or my > self.y + self.height)
    end
end

-- Update cursor blinking timer
function InputField:update(dt)
    if self.focused then
        self.cursorBlinkTime = self.cursorBlinkTime + dt
        if self.cursorBlinkTime > 0.5 then
            self.cursorBlinkTime = 0
            self.cursorVisible = not self.cursorVisible -- Toggle cursor visibility
        end
    end
    --change mouse cursor when hover the field
    local mouseX, mouseY = love.mouse.getPosition()
    local newCursor = (mouseX > self.x and mouseX < self.x + self.width and mouseY > self.y) and "ibeam" or "arrow"
    if self.cursorState ~= newCursor then
        love.mouse.setCursor(love.mouse.getSystemCursor(newCursor))
        self.cursorState = newCursor
    end
end

return InputField
