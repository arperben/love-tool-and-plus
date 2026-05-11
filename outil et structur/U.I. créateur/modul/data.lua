---------
-- data
-- v0.0.0
---------

local TSerial = require("modul/TSerial")
local luaP = require("modul/lua+")

local dt = {}

function dt.save(name, data)

    -- on vérifie que name et data son du bon type
    luaP.check(data, "table", "data doit être de type table")
    luaP.check(name, "string", "nameFichier doit être de type string")

    local temp = TSerial.pack(data) -- la fonction permet de transformer data en class data

    temp = love.data.compress("string", "zlib", temp, 9) -- on compress
    temp = love.data.encode("string", "base64", temp)

    local sucess, message = love.filesystem.write(name, temp)

    if not sucess then
        error("fichier non crée/modifier : ".. message)
    end
end

function dt.load(name)

    luaP.check(name, "string", "nameFichier doit être de type string")

    if love.filesystem.getInfo(name) then -- on vérifie si le fichier existe

        data = love.data.decode("string", "base64", love.filesystem.read(name)) -- on decode puis decompresse
        data = love.data.decompress("string", "zlib", data)

        data = TSerial.unpack(data) -- on unpack les donnée pour pouvoir les utilisers

    else
        return false
    end

    return data
end

function dt.save_txt(name, data)

    -- on vérifie que name est du bon type

    if type(name) ~= "string" then
        error("nameFichier doit être de type string")
    end
    if type(data) == "table" then
        data = modul.show(data)
    elseif type(data) ~= "string" then
        error("data doit être de type string ou table")
    end

    local sucess, message = love.filesystem.write(name, data)

    if not sucess then
        error("fichier non crée/modifier : ".. message)
    end
end

function dt.load_txt(name)

    if type(name) ~= "string" then
        error("nameFichier doit être de type string")
    end

    if love.filesystem.getInfo(name) then -- on vérifie si le fichier existe
        data = love.filesystem.read(name) -- on récup les donnée

    else
        return ""
    end

    return data
end

return dt