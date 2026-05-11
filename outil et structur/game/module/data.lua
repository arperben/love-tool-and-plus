---------
-- objet
-- v0.0.0
---------

local TSerial = require("module/TSerial")

local dt = {}

function dt.save(name, data)

    -- on vérifie que name et data son du bon type
    if type(data) ~= "table" then
        error("data doit être de type table")
    end

    if type(name) ~= "string" then
        error("nameFichier doit être de type string")
    end

    local temp = TSerial.pack(data) -- la fonction permet de transformer data en class data

    temp = love.data.compress("string", "zlib", temp, 9) -- on compress
    temp = love.data.encode("string", "base64", temp)

    local sucess, message = love.filesystem.write(name, temp)

    if not sucess then
        error("fichier non crée : ".. message)
    end
end

function dt.load(name)

    if type(name) ~= "string" then
        error("nameFichier doit être de type string")
    end

    if love.filesystem.getInfo(name) then -- on vérifie si le fichier existe

        data = love.data.decode("string", "base64", love.filesystem.read(name)) -- on decode puis decompresse
        data = love.data.decompress("string", "zlib", data)
        print(data)

        data = TSerial.unpack(data) -- on unpack les donnée pour pouvoir les utilisers
        print(data)

    else
        return false
    end

    return data
end

return dt