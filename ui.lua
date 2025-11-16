-- This file is part of RetroSpriteMaker.
-- RetroSpriteMaker is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See <https://www.gnu.org/licenses/>.
local Object = require("libs.classic")
local Button = require("button")
local UI = Object:extend()
local Palette = require("palette")
local Scaler = require("scaler")
local FileManager = require("fileManager")
local Draws = require("libs.Draws")
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
    self:initButtons({ self.load, self.save })
    self.input = InputName(50, 50, 400, 200)
    self.tiles = nil
    self.canDraw = true
    self.coolDown = 0
    self.modalBox = InputName(50, 50, 500, 200, 0)
    self.modalBox.isModal = true
end

function UI:initButtons(buttons)
    for _, button in pairs(buttons) do
        button:setImmediate()
        button:setBackgroundColor(125, 125, 125)
        button:setAngle(5)
    end
    self.load:setOnClick(function()
        self.fileVizualizer:reset()
        self.fileVizualizer.hidden = false
    end)
    self.save:setOnClick(function()
        print("saving...")
        self.canDraw = false
        self.input:show()
        --FileManager.saveSprite(name, grid, self.palette)
    end)
end

function UI:saveFile()
    self.save.onClick()
end

function UI:showLoader()
    self.canDraw = false
    --self.load.onClick()
end

function UI:draw()
    love.graphics.setColor(1, 1, 1)
    self.palette:draw()
    self.scaler:draw()
    self.save:draw()
    self.load:draw()
    love.graphics.setColor(1, 1, 1)

    if self.input:isVisible() then
        self.input:draw()
    end

    self:drawInfo()
    if self.modalBox.visible then
        self.modalBox:draw()
    end
end

function UI:mousepressed(mx, my, button, grid)
    if self.modalBox.visible then
        self.modalBox:mousepressed(mx, my, button)
    else
        self.input:mousepressed(mx, my, button)
        --if fileVizualizer is visible then procede
        if self.fileVizualizer:isVisible() then
            local name = self.fileVizualizer:mousepressed(mx, my, button)
            if name then
                --print("name=" .. name)
                --loading datas
                local newPalette, newGrid = {}, {}
                newGrid, newPalette = FileManager.loadSprite(name)
                self.palette:setColors(newPalette)
                self.scaler:setTilesAmount(#newGrid[1])
                grid:adjustAmount()
                grid:loadTiles()
                --setting newColors
                for y, line in ipairs(newGrid) do
                    for x, colorIndex in ipairs(line) do
                        if colorIndex ~= 0 then
                            local r, g, b = self.palette:getColorsByIndex(colorIndex)
                            grid.tiles[y][x].color = { r, g, b }
                        end
                    end
                end
                grid:updateCanvas()
                --setting newPalette

                self.fileVizualizer.hidden = true
                return
            end
            --if fileVizualizer is hidden then activate buttons
        elseif not self.fileVizualizer:isVisible() and not self.input:isVisible() then
            self.palette:mousepressed(mx, my, button)
            if self.save:isHovered(mx, my) and button == 1 then
                self.tiles = grid.tiles
                self.save.onClick()
            end
            if self.load:isHovered(mx, my) then
                self:showLoader()
                self.load:mousepressed(mx, my, button)
            end
        end
    end
end

function UI:update(dt)
    self.palette:update(dt)
    if self.fileVizualizer:isVisible() then
        self.fileVizualizer:update()
        self.coolDown = 1
        return
    end
    self.input:update(dt)
    if self.input:consumeValidation() then
        print("Sauvegarde déclenchée :", self.input.name)

        FileManager.saveSprite(self.input.name, self.tiles, self.palette)
        self.input.name = ""
        self.coolDown = 1
        return
    end
    if not self.fileVizualizer:isVisible() and not self.input:isVisible() then
        self.coolDown = math.max(0, self.coolDown - dt)
        if self.coolDown <= 0 then
            self.canDraw = true
        end
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
            local path = "sprites/export.png"
            local source = love.filesystem.getRealDirectory(path)
            self.modalBox:setText("sprite recorded at: \n" .. source .. "\n/" .. path)
            self.modalBox:show()
        end
    end
end

function UI:drawInfo()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(":Paint", 630, 450)
    love.graphics.print(":Erase", 710, 450)
    Draws.leftClick(600 - 5, 440, 2)
    Draws.rightClick(680 - 5, 440, 2)
    love.graphics.setColor(0, 0, 0)

    love.graphics.printf("[C] Copy on clipboard", 600, 480, 500)
    love.graphics.print("Grid Size", 700, 380)
    love.graphics.print("[E] Export to png", 600, 500)
end

return UI
