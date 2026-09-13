local action = {}
local i = 1

function action.delete()
    -- permet de supprimer un objet
    table.insert(action_utilisateur, listObjet[selectes])
    table.remove(listObjet, selectes)
    action_utilisateur[#action_utilisateur].position = selectes
    selectes = nil
end

function action.createRectangle()
    -- permet de crée un rectangle depuis la fenêtre

    if modul.luaP.isOneCliked(1) then -- des qu'un click est détecter on commence le rectangle
        x,y = love.mouse.getX(),love.mouse.getY()
        click = true

    elseif love.mouse.isDown(1) and click then -- si on maintient la souris cliqué 
        local height = love.mouse.getY() - y
        local width = love.mouse.getX() - x

        if listObjet[#listObjet + i] == nil then
            creerObjet(height, width, x, y, 'rectangle')
        else
            listObjet[#listObjet].width = width
            listObjet[#listObjet].height = height
        end

    elseif not(love.mouse.isDown(1)) and click then 
        click = false
        i = 1
        cache = {}
        mode = 'selection'
    end
end

function action.createCarre()
    -- permet de crée un carré depuis la fenêtre

    if modul.luaP.isOneCliked(1) then -- des qu'un click est détecter on commence le rectangle
        x,y = love.mouse.getX(),love.mouse.getY()
        click = true

    elseif love.mouse.isDown(1) and click then -- si on maintient la souris cliqué 
        local height = love.mouse.getY() - y
        local width = love.mouse.getX() - x

        if height < width then
            height = width
        else
            width = height
        end

        if listObjet[#listObjet + i] == nil then
            creerObjet(height, width, x, y, 'rectangle')
        else
            listObjet[#listObjet].width = width
            listObjet[#listObjet].height = height
        end

    elseif not(love.mouse.isDown(1)) and click then 
        click = false
        i = 1
        cache = {}
        mode = 'selection'
    end
end

function creerObjet(height, width, x, y, categorie)
    if not(height == 0 or width == 0) then -- je vérifie que se n'est pas just un click
        table.insert(listObjet,modul.objet:create{
            height = height,
            width = width,
            x = x,
            y = y,
            categorie = categorie,
        })
        i = 0
        table.insert(action_utilisateur, #listObjet)
    end
end

function action.ctr_z()
    if type(action_utilisateur[#action_utilisateur]) == 'number' then
            table.insert(cache, listObjet[#listObjet])
            table.remove(listObjet,#listObjet)

    elseif type(action_utilisateur[#action_utilisateur]) == 'table' then
        table.insert(listObjet, action_utilisateur[#action_utilisateur].position, action_utilisateur[#action_utilisateur])
        table.insert(cache, action_utilisateur[#action_utilisateur].position)
        table.remove(action_utilisateur, #action_utilisateur)
    end
end

return action