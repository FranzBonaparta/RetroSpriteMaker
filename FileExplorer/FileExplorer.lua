local FileExplorer = {}

function FileExplorer.explore(path)
    local files = love.filesystem.getDirectoryItems(path)
    local fileTree = ""
    for k, file in ipairs(files) do
        fileTree = fileTree .. "\n" .. (k .. ". " .. file) --outputs something like "1. main.lua"
    end
    return fileTree
end

function FileExplorer.didExist(path)
    local info = love.filesystem.getInfo(path)
    return info and info.type == "directory"
end

function FileExplorer.getFile(fileSearched)

end

function FileExplorer.recursiveEnumerate(folder, fileTree)
    local filesTable = love.filesystem.getDirectoryItems(folder)
    for i, v in ipairs(filesTable) do
        local file = folder .. "/" .. v
        local info = love.filesystem.getInfo(file)
        if info then
            if info.type == "file" then
                fileTree = fileTree .. "\n" .. file
            elseif info.type == "directory" then
                fileTree = fileTree .. "\n" .. file .. " (DIR)"
                fileTree = FileExplorer.recursiveEnumerate(file, fileTree)
            end
        end
    end
    return fileTree
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

function FileExplorer.switchContent(files, index)
    local content = FileExplorer.readContent(files[index])
    print(content)
    return content
end

return FileExplorer
--[[function FileExplorer.fileTreeReal(path)
    local fileTree = path .. ":\n"
    local p = io.popen('ls -l "' .. path .. '"')
    if not p then return "Erreur d'exploration" end
    for line in p:lines() do
        fileTree = fileTree .. line .. "\n"
    end
    p:close()
    return fileTree
end]]
