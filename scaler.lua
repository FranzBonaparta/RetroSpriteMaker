local Tile=require("tile")

local Scaler=Tile:extend()
local amounts={8,16,32}
function Scaler:new(x,y,scale)
    self.super:new(x,y,scale)
    self.tilesAmount=16
    self.super:setColor({125,125,125})
end
function Scaler:changeTilesAmount()
    for i, amount in ipairs(amounts) do
        if self.tilesAmount==amount then
            if i<#amounts then
                self.tilesAmount=amounts[i+1]
                break
            else
                self.tilesAmount=amounts[1]
                break
            end
        end
    end
end
function Scaler:draw()
    self.super:draw()
    local text=string.format("%dx%d",self.tilesAmount,self.tilesAmount)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(text,self.x,self.y,self.size-5)
    love.graphics.setColor(1,1,1)
end

function Scaler:mousepressed(mx,my,button)
    if button==1 then
        if self.super:mouseIsHover(mx,my) then
            self:changeTilesAmount()
        end
    end
end

return Scaler