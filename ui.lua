local Object = require("libs.classic")
local Button = require("button")
local UI = Object:extend()
local Palette = require("palette")
local Scaler = require("scaler")
local FileManager = require("fileManager")
local text = nil
local FileVizualizer = require("FileExplorer.FileVizualizer")
local InputName = require("inputName")
function UI:new()
    self.scale = 32
    self.scaler = Scaler(700, 400, 32)
    self.palette = Palette(600, self.scale)
    self.save = Button(600, 520, 40, 40, "save")
    self.load = Button(650, 520, 40, 40, "load")
    self.fileVizualizer = FileVizualizer("RetroSpriteMaker", "sprites")
    self.fileVizualizer:init()
    self.fileVizualizer.hidden = true
    self.load:setImmediate()
    self.load:setBackgroundColor(125, 125, 125)
    self.load:setAngle(5)
    self.save:setAngle(5)
    self.save:setBackgroundColor(125, 125, 125)
    self.input = InputName(50, 50, 400, 200)
    self.save:setImmediate()
    self.grid = nil
end

function UI:saveFile(name, grid)
    self.save:setOnClick(function()
        self.input:show()
        --FileManager.saveSprite(name, grid, self.palette)
    end)
end

function UI:showLoader()
    self.load:setOnClick(function()
        self.fileVizualizer:reset()
        self.fileVizualizer.hidden = false
    end)
end

function UI:draw()
    if self.input:isVisible() then
        self.input:draw()
    else
        love.graphics.setColor(1, 1, 1)
        self.palette:draw()
        self.scaler:draw()
        self.save:draw()
        self.load:draw()
        love.graphics.setColor(1, 1, 1)
        if text then
            print(text)
        end
    end
end

function UI:mousepressed(mx, my, button, grid)
    self.input:mousepressed(mx, my, button)

    --if fileVizualizer is visible then procede
    if self.fileVizualizer:isVisible() then
        local name = self.fileVizualizer:mousepressed(mx, my, button)
        if name then
            print("name=" .. name)
            --loading datas
            local newPalette, newGrid = {}, {}
            newGrid, newPalette = FileManager.loadSprite(name)
            self.scaler:setTilesAmount(#newGrid[1])
            --setting newColors
            for y, line in ipairs(newGrid) do
                for x, tile in ipairs(line) do
                    grid[y][x].color = tile
                end
            end
            --setting newPalette
            self.palette:setColors(newPalette)
            self.fileVizualizer.hidden = true
            return
        end
        --if fileVizualizer is hidden then activate buttons
    elseif not self.fileVizualizer:isVisible() and not self.input:isVisible() then
        self.palette:mousepressed(mx, my, button)
        if self.save:isHovered(mx, my) then
            self.grid = grid
            self:saveFile("export", self.grid)
        end
        self.save:mousepressed(mx, my, button)
        if self.load:isHovered(mx, my) then
            self:showLoader()
            self.load:mousepressed(mx, my, button)
        end
    end
end

function UI:update(dt, grid)
    self.palette:update(dt)
    if self.fileVizualizer:isVisible() then
        self.fileVizualizer:update()
    end
    self.input:update(dt)
    if self.input.validated then
        FileManager.saveSprite(self.input.name, grid, self.palette)
        self.input.name = ""
        self.input.validated = false
    end
end

function UI:keypressed(key, tiles)
    if self.input:isVisible() then
        self.input:keypressed(key)
    else
        if key == "c" then
            --copy to clipboard
            FileManager.saveDraw(self, tiles)
        end
        if key == "e" then
            FileManager.exportPng(self, tiles)
        end
        if key == "f" then
            local folder = love.filesystem.getSaveDirectory()
            text = FileManager.fileTree(folder, "")
        end
    end
end

return UI
