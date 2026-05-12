
local modul =
{
    math = require("module/maths_plus"),
    objet = require("module/objet"),
    dt = require("module/data")
}

function modul.update()
    modul.objet.update_all_objet()
end

function modul.show(list)
    message = "["
    for i,item in pairs(list) do
        message = message .. "'".. item .. "',"
    end
    message = message .. "]"
    return message
end

return modul