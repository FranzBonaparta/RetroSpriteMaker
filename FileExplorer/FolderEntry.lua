local Object=require("libs.classic")
local FolderEntry=Object:extend()
local Draws=require("libs.Draws")

function FolderEntry:new(path,name,x,y)
    self.path=path
    self.name=name
    self.fullPath=self.path.."/"..self.name
    self.x=x or 0
    self.y=y or 0
    self.width=64
    self.height=64

end

function FolderEntry:draw()
    Draws.folder(self.x, self.y, 2)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.name, self.x+10, self.y + 60)
end
function FolderEntry:setCoord(x,y)
    self.x=x
    self.y=y
end
function FolderEntry:isHovered(mx, my)
    return mx >= self.x and mx <= self.x + self.width and
           my >= self.y and my <= self.y + self.height
end

function FolderEntry:onClick(explorer)
    --local content=explorer.readContent(self.name)
    print("Dossier cliqué :",self.fullPath)
end

return FolderEntry