local Object=require("libs.classic")
local Tile=require("tile")
local Grid=Object:extend()

function Grid:new(ui)
    self.tiles={}
    self.ui=ui
    self.tilesAmount=self.ui.scaler.tilesAmount
end
function Grid:loadTiles()
    local offsetX, offsetY = 32, 32

    self.tiles = {}
    for y = 1, self.tilesAmount do
        self.tiles[y] = {}
        for x = 1, self.tilesAmount do
            local tile = Tile(offsetX + (x - 1) * self.ui.scale, offsetY + (y - 1) * self.ui.scale, self.ui.scale)
            self.tiles[y][x] = tile
        end
    end
end
function Grid:getTiles()
    return self.tiles
end

function Grid:getTilesAmount()
    return self.tilesAmount
end
function Grid:draw()
    love.graphics.setColor(1, 1, 1) -- white
    for _, line in ipairs(self.tiles) do
        for _, tile in ipairs(line) do
            tile:draw()
        end
    end
end
function Grid:update(brush)
    local mx, my = love.mouse.getX(), love.mouse.getY()
    --check if we can draw
    if self.ui.canDraw then
        if love.mouse.isDown(1) then
            for _, line in ipairs(self.tiles) do
                for _, tile in ipairs(line) do
                    if tile:mouseIsHover(mx, my) then
                        tile:setColor(brush.color)
                    end
                end
            end
        end
        if love.mouse.isDown(2)then
            for _, line in ipairs(self.tiles) do
                for _, tile in ipairs(line) do
                    if tile:mouseIsHover(mx, my) then
                        tile:setColor({ 255, 255, 255 })
                    end
                end
            end
        end
            self:adjustAmount()
    end
end
function Grid:adjustAmount()
    if self.tilesAmount ~= self.ui.scaler.tilesAmount then
            self.tilesAmount = self.ui.scaler.tilesAmount
            self.ui.scale = (self.tilesAmount == 32) and 16 or 32
            self:loadTiles()
        end
end
function Grid:mousepressed(mx,my,button,brush)
    if  self.ui.canDraw then
        if self.ui.palette.colorSelected then
            local selectedColor = self.ui.palette.colorSelected
            brush:setColor(selectedColor)
            for _, line in ipairs(self.tiles) do
                for _, tile in ipairs(line) do
                    if button == 1 and tile:mouseIsHover(mx, my) then
                        tile:setColor(brush.color)
                    end
                end
            end
            self.ui.scaler:mousepressed(mx, my, button)
        end
    end
end
return Grid