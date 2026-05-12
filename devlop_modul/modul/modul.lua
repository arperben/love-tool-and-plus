
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

return modul