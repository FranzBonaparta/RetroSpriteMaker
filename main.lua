-- RetroSpriteMaker
-- Made by Jojopov
-- Licence : GNU GPL v3 - 2025
-- https://www.gnu.org/licenses/gpl-3.0.html
local Tile = require("tile")
local UI = require("ui")
local ui = UI()
local Grid=require("Grid")
local grid=Grid(ui)
local selectedColor = ui.palette.colorSelected -- default
local brush = Tile(600, 400, ui.scale)
brush:setColor({ selectedColor[1], selectedColor[2], selectedColor[3] })

-- Function called only once at the beginning
function love.load()
        -- Initialization of resources (images, sounds, variables)
    love.filesystem.setIdentity("RetroSpriteMaker")
    love.filesystem.setIdentity(love.filesystem.getIdentity(), true)
    grid:loadTiles()
    love.graphics.setBackgroundColor(1, 1, 1) -- dark grey background
end

-- Function called at each frame, it updates the logic of the game
function love.update(dt)
    -- dt = delta time = time since last frame 
    ui:update(dt)
    grid:update(brush)
end

-- Function called after each update to draw on screen
function love.draw()
    -- Everything that needs to be displayed passes here
    love.graphics.setColor(1, 1, 1) -- white
    grid:draw()
     love.graphics.setColor(0, 0, 0)
    love.graphics.print("Color", 600, 380)

    --love.graphics.printf("Right click: erase\nLeft click: paint", 600, 450, 500)
    brush:draw()  
    ui:draw()

    love.graphics.setColor(0, 0, 0)
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
    ui:keypressed(key, grid.tiles)
end

function love.mousepressed(mx, my, button)
    if ui.fileVizualizer:isVisible() or ui.modalBox:isVisible() then
        ui:mousepressed(mx, my, button, grid)
        return
    end
    ui:mousepressed(mx, my, button, grid)
    --check if we can draw
    grid:mousepressed(mx,my,button,brush)
end

function love.textinput(text)
    ui.input:textinput(text)
end
