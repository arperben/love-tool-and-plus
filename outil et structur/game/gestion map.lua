local modul = require("module/modul")

local World= {}

function World.CreerListeWorldGen( scale )
    -- __.CreerListeWorldGen( scale )
    -- cree une liste de départ du monde
    -- scale règle la préssision de la récupération de valeur
    
    World.scale = scale -- on définit le scale pour plus tard
    World.element = {} -- création de la tabel
    local window_width, window_height = love.window.getMode() -- on récupère la taille de l'écran

    local maxX = math.floor(window_width / World.taille)
    local maxY = math.floor(window_height / World.taille)

    for y = 1, maxY do
        World.element[y] = {}

        for x = 1, maxX do
            World.element[y][x] = World.SetObjetWorld(x, y, scale)

        end
    end

    World.Grandx = maxX
    World.Grandy = maxY
end

function World.SetObjetWorld( X, Y, scale )
    -- __.SetObjetWorld( X, Y, scale )
    -- renvoir un un élément de class objet selon des coordonnée et le scale
    -- X,Y

    local n = love.math.noise(X * scale, Y * scale)
            
    -- modifier la valeur telle que 0.03 selon le scale me permet d'auptenir un nois un peut près identique
    local n1 = love.math.noise(X * 0.000000003, Y * 0.000000003) 
    
    n = (n+n1) /2 -- je mélange mais deux noise

    if n <= 0.5 then -- herbe
        n = modul.objet:create{ x = (X-1)*10, y = (Y-1)*10, height = World.taille, width = World.taille, b = 0, r = 0, g = 255}

    --elseif n<=0.5 then
        --  n = modul.objet:create{ x = (X-1)*10, y = (Y-1)*10, height = World.taille, width = World.taille, b = 63.75, r = 63.75, g = 255}

    elseif n <= 0.55 then -- sable
        n = modul.objet:create{ x = (X-1)*10, y = (Y-1)*10, height = World.taille, width = World.taille, b = 0, r = 255, g = 255}

    elseif n <= 0.7 then -- eau peut profonde
        n = modul.objet:create{ x = (X-1)*10, y = (Y-1)*10, height = World.taille, width = World.taille, g = 63.75, r = 63.75, b = 255}

    else -- eau profonde
        n = modul.objet:create{ x = (X-1)*10, y = (Y-1)*10, height = World.taille, width = World.taille, g = 0, r = 0, b = 255}
    end

    return n
end

function World.WorldMouvObjet()
    World.Grandx = World.Grandx + 1
    for y = 1,#World.element do
        table.remove(World.element[y], 1)
        table.insert(World.element[y], World.SetObjetWorld(World.Grandx, y, World.scale))
    end
end

return World
