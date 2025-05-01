-- main.lua - entry point of your Love2D project
local Palette = require("palette")
local Tile = require("tile")

local palette = Palette(600, 32)
local tiles = {}
local selectedColor = palette.colorSelected -- default
SelectedTile = nil
local brush = Tile(600, 400, 32)
brush:setColor({ selectedColor[1], selectedColor[2], selectedColor[3] })
local height=love.graphics.getHeight()-40
-- Function called only once at the beginning
function love.load()
    for y = 1, 16 do
        tiles[y] = {}
        for x = 1, 16 do
            local tile = Tile(x * 32, y * 32, 32)
            tiles[y][x] = tile
        end
    end

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

    brush:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Made by Jojopov\nLicence GNU GPL3 -2025",600,height,200)
end
local function sameColor(c1, c2)
    return c1[1] == c2[1] and c1[2] == c2[2] and c1[3] == c2[3]
end

local function saveDraw()
    print(brush.color[1], brush.color[2], brush.color[3])

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
end

function love.mousepressed(mx, my, button)
    palette:mousepressed(mx, my, button)
    if palette.colorSelected then
        selectedColor = palette.colorSelected
        brush:setColor(selectedColor)
        for _, line in ipairs(tiles) do
            for _, tile in ipairs(line) do
                if button == 1 and tile:mouseIsHover(mx, my) then
                    print("tile cliked on :" .. mx, my)
                    tile:setColor(brush.color)
                end
            end
        end
    end
end
