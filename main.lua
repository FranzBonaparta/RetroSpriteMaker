-- RetroSpriteMaker
-- Made by Jojopov
-- Licence : GNU GPL v3 - 2025
-- https://www.gnu.org/licenses/gpl-3.0.html
local Tile = require("tile")
local UI = require("ui")
local ui = UI()
local tilesAmount = 16
local tiles = {}
local selectedColor = ui.palette.colorSelected -- default
SelectedTile = nil
local brush = Tile(600, 400, ui.scale)
brush:setColor({ selectedColor[1], selectedColor[2], selectedColor[3] })
local height = love.graphics.getHeight() - 40
-- Function called only once at the beginning
local function loadTiles()
    local offsetX, offsetY = 32, 32

    tiles = {}
    for y = 1, tilesAmount do
        tiles[y] = {}
        for x = 1, tilesAmount do
            local tile = Tile(offsetX + (x - 1) * ui.scale, offsetY + (y - 1) * ui.scale, ui.scale)
            tiles[y][x] = tile
        end
    end
end
function love.load()
    love.filesystem.setIdentity("RetroSpriteMaker")

    love.filesystem.setIdentity(love.filesystem.getIdentity(), true)

    loadTiles()

    -- Initialization of resources (images, sounds, variables)
    love.graphics.setBackgroundColor(1, 1, 1) -- dark grey background
end

-- Function called at each frame, it updates the logic of the game
function love.update(dt)
    -- dt = delta time = time since last frame
    -- Used for fluid movements
    ui:update(dt)
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
    if tilesAmount ~= ui.scaler.tilesAmount then
        tilesAmount = ui.scaler.tilesAmount
        ui.scale = (tilesAmount == 32) and 16 or 32

        loadTiles()
    end
end

-- Function called after each update to draw on screen
function love.draw()
    -- Everything that needs to be displayed passes here
    love.graphics.setColor(1, 1, 1) -- white
    ui:draw()
    for _, line in ipairs(tiles) do
        for _, tile in ipairs(line) do
            tile:draw()
        end
    end
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Selected Color", 600, 380)
    love.graphics.printf("Right click to erase\nLeft click to paint", 600, 450, 500)
    love.graphics.printf("Press C to copy on clipboard", 600, 480, 500)
    love.graphics.print("Grid Size", 700, 380)
    brush:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Press E to export to png", 600, 500)
    love.graphics.printf("Made by Jojopov\nGNU GPL3 - 2025", 600, height, 200)
    if ui.fileVizualizer:isVisible() then
        ui.fileVizualizer:draw()
    end
end

-- Function called at each touch
function love.keypressed(key)
    -- Example: exit the game with Escape
    if key == "escape" then
        love.event.quit()
    end
    ui:keypressed(key, tiles)
end

function love.mousepressed(mx, my, button)
    ui:mousepressed(mx, my, button, tiles)
    if not ui.fileVizualizer:isVisible() then
        if ui.palette.colorSelected then
            selectedColor = ui.palette.colorSelected
            brush:setColor(selectedColor)
            for _, line in ipairs(tiles) do
                for _, tile in ipairs(line) do
                    if button == 1 and tile:mouseIsHover(mx, my) then
                        tile:setColor(brush.color)
                    end
                end
            end
            ui.scaler:mousepressed(mx, my, button)
        end
    end
end
