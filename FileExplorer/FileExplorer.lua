-- This file is part of RetroSpriteMaker.
-- RetroSpriteMaker is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- See <https://www.gnu.org/licenses/>.
local FileExplorer = {}

function FileExplorer.didExist(path)
    local info = love.filesystem.getInfo(path)
    return info and info.type == "directory"
end

function FileExplorer.getFiles(folder)
    local files = {}
    local children = love.filesystem.getDirectoryItems(folder)
    for _, child in ipairs(children) do
        local file = child
        local info = love.filesystem.getInfo(folder .. "/" .. file)
        if info then
            if info.type == "file" then
                table.insert(files, file)
            end
        end
    end
    return files
end
function FileExplorer.getFolders(folder)
        local folders = {}
    local children = love.filesystem.getDirectoryItems(folder)
    for _, child in ipairs(children) do
        local directory = child
        local info = love.filesystem.getInfo(folder .. "/" .. directory)
        if info then
            if info.type == "directory" then
                table.insert(folders, directory)
            end
        end
    end
    return folders
end
function FileExplorer.readContent(fileSearched)
    local files = love.filesystem.getDirectoryItems("sprites")
    local content, size = "", 0
    for k, file in ipairs(files) do
        if file == fileSearched then
            content, size = love.filesystem.read("sprites/" .. file)
            return content
        end
    end
    return ""
end

return FileExplorer

