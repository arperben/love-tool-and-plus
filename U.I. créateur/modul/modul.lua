
local modul =
{
    math = require("modul/maths_plus"),
    objet = require("modul/objet"),
    dt = require("modul/data"),
    luaP = require("modul/lua+")
}

function modul.update()
    modul.objet.update_all_objet()
end

function modul.show(list)
    message = "["
    for i,item in pairs(list) do
        if type(item) == "table" then
            item = modul.show(item)
        end
        message = message .. "'".. item .. "',"
    end
    message = message .. "]"
    return message
end

return modul