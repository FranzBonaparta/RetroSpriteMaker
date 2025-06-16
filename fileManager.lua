local FileManager={}
function FileManager.saveSprite(name, grid, palette)
    local path = "sprites/" .. name .. ".lua"
    local fileData = "return {\n"
    
    -- Sauvegarde de la grille
    fileData = fileData .. "  grid = {\n"
    for y = 1, #grid do
        fileData = fileData .. "    { "
        for x = 1, #grid[y] do
            fileData = fileData .. tostring(grid[y][x]) .. ", "
        end
        fileData = fileData .. "},\n"
    end
    fileData = fileData .. "  },\n"

    -- Sauvegarde de la palette
    fileData = fileData .. "  palette = {\n"
    for _, color in ipairs(palette) do
        fileData = fileData .. string.format("    { %d, %d, %d },\n", color[1], color[2], color[3])
    end
    fileData = fileData .. "  }\n"
    fileData = fileData .. "}\n"

    love.filesystem.createDirectory("sprites") -- Crée le dossier si nécessaire
    love.filesystem.write(path, fileData)
    print("Sprite sauvé dans : " .. path)
end
local function sameColor(c1, c2)
    return c1[1] == c2[1] and c1[2] == c2[2] and c1[3] == c2[3]
end
function FileManager.loadSprite(name)
    local chunk = love.filesystem.load("sprites/" .. name .. ".lua")
    local data = chunk()
    return data.grid, data.palette
end
function FileManager.saveDraw(ui,tiles)
    local index = 1
    local indexArray={}
    local saveString="{"
    for _, line in ipairs(ui.palette.colorTiles) do
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
local function isWhite(color)
    return color[1] == 255 and color[2] == 255 and color[3] == 255
end
--to export your image at PNG format
function FileManager.exportPng(ui,tiles)
    local tilesAmount=ui.scaler.tilesAmount
    local canvas = love.graphics.newCanvas(
    tilesAmount * ui.scale,
    tilesAmount * ui.scale,
    { format = "rgba8" })
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0, 0, 0, 0)-- alpha 0 = transparent
    love.graphics.setBlendMode("alpha", "premultiplied") -- important
    --correction of the PNG framing
    for rowIndex, row in ipairs(tiles) do
        for colIndex, tile in ipairs(row) do
            if not isWhite(tile.color) then
                local r, g, b = tile.color[1] / 255, tile.color[2] / 255, tile.color[3] / 255
                local x = (colIndex - 1) * ui.scale
                local y = (rowIndex - 1) * ui.scale
                love.graphics.setColor(r, g, b)
                love.graphics.rectangle("fill", x, y, ui.scale, ui.scale)
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
function FileManager.fileTree(folder,fileTree)
   	local filesTable = love.filesystem.getDirectoryItems(folder)
	for i,v in ipairs(filesTable) do
		local file = folder.."/"..v
		local info = love.filesystem.getInfo(file)
		if info then
			if info.type == "file" then
				fileTree = fileTree.."\n"..file
			elseif info.type == "directory" then
				fileTree = fileTree.."\n"..file.." (DIR)"
				fileTree = FileManager.fileTree(file, fileTree)
			end
		end
	end
	return folder.." contain "..#filesTable.." elements\n"..fileTree 
end

return FileManager