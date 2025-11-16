local Object = require("libs.classic")
local Tile = require("tile")
local Palette = Object:extend()

local colors = { { { 240, 237, 255 }, { 163, 151, 216 }, { 50, 39, 99 }, { 20, 2, 40 } },
    { { 249, 230, 194 }, { 249, 134, 92 },  { 211, 12, 29 },  { 130, 0, 58 } },
    { { 255, 235, 186 }, { 249, 170, 72 },  { 158, 53, 30 },  { 91, 11, 40 } },
    { { 255, 249, 191 }, { 206, 194, 57 },  { 142, 142, 27 }, { 46, 84, 0 } },
    { { 233, 255, 147 }, { 170, 198, 57 },  { 56, 153, 0 },   { 0, 73, 19 } },
    { { 208, 249, 132 }, { 110, 224, 69 },  { 29, 198, 43 },  { 5, 114, 56 } },
    { { 229, 255, 209 }, { 158, 255, 158 }, { 50, 219, 129 }, { 7, 122, 122 } },
    { { 186, 255, 211 }, { 112, 255, 228 }, { 35, 181, 239 }, { 5, 36, 119 } },
    { { 230, 201, 255 }, { 182, 99, 249 },  { 98, 47, 237 },  { 33, 12, 91 } },
    { { 249, 199, 235 }, { 191, 138, 234 }, { 86, 66, 175 },  { 39, 25, 99 } } }

function Palette:new(x, y)
    self.x = x
    self.y = y
    self.size = 32

    self.colorTiles = {}
    self.colorSelected = {20,2,40}
    self.cursorState="arrow"
    self:setColors(colors)
end
function Palette:setColors(newColors)
    self.colorTiles={}
    for j, line in ipairs(newColors) do
        self.colorTiles[j] = {}
        for i, color in ipairs(line) do
            local tile = Tile(self.x + self.size * (i - 1), self.y + self.size * (j - 1), self.size)
            tile:setColor(color)
            self.colorTiles[j][i] = tile
        end
    end
end
function Palette:getColorsByIndex(index)
    local colorIndex=1
    for _, line in ipairs(self.colorTiles) do

        for _, color in ipairs(line) do
            if index==colorIndex then
                return color.color[1],color.color[2],color.color[3]
            end
            colorIndex=colorIndex+1
        end
    end
end
function Palette:draw()
    -- Calculation of the total size of the pallet
    local paletteWidth = #colors[1] * self.size
    local paletteHeight = #colors * self.size


    --love.graphics.rectangle("line", self.x, self.y, paletteWidth, paletteHeight)

    for _, line in ipairs(self.colorTiles) do
        for _, tile in ipairs(line) do
            tile:draw()
        end
    end
end
function Palette:update(dt)
    local mx, my = love.mouse.getPosition()
    local hover=false
    for _, line in ipairs(self.colorTiles) do
        for _, tile in ipairs(line) do
            if tile:mouseIsHover(mx, my)  then hover=true end
        end
    end
    local newCursor = hover and "hand" or "arrow"
    if self.cursorState ~= newCursor then
        love.mouse.setCursor(love.mouse.getSystemCursor(newCursor))
        self.cursorState = newCursor
    end
end

function Palette:mousepressed(mx, my, button)
    if button ==1 then
         for _, line in ipairs(self.colorTiles) do
            for _, tile in ipairs(line) do
                if tile:mouseIsHover(mx, my)  then
                    self.colorSelected = tile.color
                    --print("tile cliked on ["..tile.x..","..tile.y.."]")
                    --print("colorSelected: "..self.colorSelected[1],self.colorSelected[2],self.colorSelected[3])
                    break
                end
            end
        end
    end
       
end

return Palette
