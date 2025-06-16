local Object=require("libs.classic")
local Button=require("button")
local UI=Object:extend()
local Palette = require("palette")
local Scaler=require("scaler")
local FileManager=require("fileManager")
local text=nil

function UI:new()
    self.scale=32
    self.scaler=Scaler(700,400,32)
    self.palette=Palette(600, self.scale)
    self.save=Button(600,520,32,32,"save")
    self.load=Button(650,520,32,32,"load")
end
function UI:saveFile(name,grid)
    self.save:setOnClick(function()FileManager.saveSprite(name,grid, self.palette)end)
end
function UI:loadFile(name)
    self.load:setOnClick(function()FileManager.loadSprite(name)end)
end
function UI:draw()
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
function UI:mousepressed(mx,my,button)
    self.palette:mousepressed(mx, my, button)
    self.save:mousepressed(mx,my,button)
    self.load:mousepressed(mx,my,button)
end
function UI:update(dt)
    self.palette:update(dt)
end
function UI:keypressed(key,tiles)
        if key == "c" then
        --copy to clipboard
        FileManager.saveDraw(self,tiles)
    end
    if key=="e" then
        FileManager.exportPng(self,tiles)
    end
    if key=="f" then
        local folder=love.filesystem.getSaveDirectory( )
        text=FileManager.fileTree(folder,"")
    end
end
return UI