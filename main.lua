-- RetroSpriteMaker
-- Made by Jojopov
-- Licence : GNU GPL v3 - 2025
-- https://www.gnu.org/licenses/gpl-3.0.html
local Palette = require("palette")
local Tile = require("tile")
local Scaler=require("scaler")
local scale=32
local tilesAmount=16
local palette = Palette(600, scale)
local tiles = {}
local selectedColor = palette.colorSelected -- default
SelectedTile = nil
local brush = Tile(600, 400, scale)
brush:setColor({ selectedColor[1], selectedColor[2], selectedColor[3] })
local height=love.graphics.getHeight()-40
local scaler=Scaler(700,400,32)
-- Function called only once at the beginning
local function loadTiles()
    local offsetX, offsetY = 32, 32

    tiles={}
        for y = 1, tilesAmount do
        tiles[y] = {}
        for x = 1, tilesAmount do
            local tile = Tile(offsetX +(x-1) * scale, offsetY+(y-1) * scale, scale)
            tiles[y][x] = tile
        end
    end
end
function love.load()
    loadTiles()

    -- Initialization of resources (images, sounds, variables)
    love.graphics.setBackgroundColor(1, 1, 1) -- dark grey background
end

-- Function called at each frame, it updates the logic of the game
function love.update(dt)
    -- dt = delta time = time since last frame
    -- Used for fluid movements
    local mx, my = love.mouse.getX(), love.mouse.getY()
    if love.mouse.isDown(1) then
        for _, line in ipairs(tiles) do
            for _, tile in ipairs(line) do
                if tile:mouseIsHover(mx, my) then
                    tile:setColor(brush.color)
                end
            end
        end
    end
    if love.mouse.isDown(2) then
        for _, line in ipairs(tiles) do
            for _, tile in ipairs(line) do
                if tile:mouseIsHover(mx, my) then
                    tile:setColor({ 255, 255, 255 })
                end
            end
        end
    end
    palette:update(dt)
    if tilesAmount~=scaler.tilesAmount then
            tilesAmount=scaler.tilesAmount
            scale = (tilesAmount == 32) and 16 or 32

        loadTiles()
    end
end

-- Function called after each update to draw on screen
function love.draw()
    -- Everything that needs to be displayed passes here
    love.graphics.setColor(1, 1, 1) -- white

    for _, line in ipairs(tiles) do
        for _, tile in ipairs(line) do
            tile:draw()
        end
    end
    palette:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Selected Color", 600, 380)
    love.graphics.printf("Right click to erase\nLeft click to paint", 600, 450, 500)
    love.graphics.printf("Press C to copy on clipboard",600,480,500)
    love.graphics.print("Grid Size",700,380)
    scaler:draw()
    brush:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Press E to export to png", 600,500)
    love.graphics.printf("Made by Jojopov\nGNU GPL3 - 2025",600,height,200)
end
local function sameColor(c1, c2)
    return c1[1] == c2[1] and c1[2] == c2[2] and c1[3] == c2[3]
end
--to export the grid for your application
local function saveDraw()
    local index = 1
    local indexArray={}
    local saveString="{"
    for _, line in ipairs(palette.colorTiles) do
        for _, tile in ipairs(line) do
            table.insert(indexArray,{index=index,color=tile.color})
                        index = index + 1

        end
    end
               

    for _, line in ipairs(tiles) do
        saveString = saveString .. "{"
        for _, tile in ipairs(line)do
             local tileColorIndex=0
            for _, ind in ipairs(indexArray)do
                if sameColor(tile.color, ind.color) then
                    tileColorIndex=ind.index
                    break
                end
            end
            saveString = saveString .. tostring(tileColorIndex) .. ","
        end
        saveString=saveString:sub(1, -2).."},"
    end
    saveString = saveString:sub(1, -2) -- We remove the last comma
    saveString = saveString .. "}"
    print(saveString)
    love.system.setClipboardText(saveString) -- Copy to clipboard
    print("Map copiée !")
end
--to export your image at PNG format
local function exportPng()
    local canvas = love.graphics.newCanvas(
    tilesAmount * scale,
    tilesAmount * scale,
    { format = "rgba8" })
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)-- alpha 0 = transparent
    love.graphics.setBlendMode("alpha", "premultiplied") -- important

    for _, line in ipairs(tiles) do
        for _, tile in ipairs(line) do
            tile:setBorderColor(0,0,0)
            if tile.color[1]~=255 and tile.color[2]~=255 and tile.color[3]~=255 then
            tile:draw()
            end
        end
    end

    love.graphics.setCanvas()
    local imageData = canvas:newImageData()
    imageData:encode("png", "export.png")
    local path = love.filesystem.getSaveDirectory( )
    print("Sprite exporté vers "..path.."/export.png")
    
    for _, line in ipairs(tiles) do
        for _, tile in ipairs(line) do
            tile:setBorderColor(255,0,0)
        end
    end
    love.graphics.clear()
end
-- Function called at each touch
function love.keypressed(key)
    -- Example: exit the game with Escape
    if key == "escape" then
        love.event.quit()
    end
    if key == "c" then
        --copy to clipboard
        saveDraw()
    end
    if key=="e" then
        exportPng()
    end
end

function love.mousepressed(mx, my, button)
    palette:mousepressed(mx, my, button)
    if palette.colorSelected then
        selectedColor = palette.colorSelected
        brush:setColor(selectedColor)
        for _, line in ipairs(tiles) do
            for _, tile in ipairs(line) do
                if button == 1 and tile:mouseIsHover(mx, my) then
                    tile:setColor(brush.color)
                end
            end
        end
    end
    scaler:mousepressed(mx,my,button)
end
