-- main.lua

-- fonction local
local action = require("action")

--fonction globale
mode = 'selection'
modul = require("modul/modul")
selectes = nil
action_utilisateur = {}
listObjet = {}
cache = {}
click = false

-- permet d'avoir accées aux fichier de sauvegarde
-- %appdata%\LOVE\

local annuler = modul.objet.create{

}

function love.load()
    love.window.setMode(800, 600, {resizable=true})
    love.window.maximize()
end

function love.update()
    if mode == 'rectangle' then
        action.createRectangle()

    elseif mode == 'carre' then
        action.createCarre()

    elseif selectes ~= nil then

        if love.keyboard.isDown('delete') then -- supprimer l'objet
            action.delete()

        elseif mode == 'selection' and love.mouse.isDown(1) and listObjet[selectes]:mouseIsPass() then -- faire bouger l'objet avec la souris
            listObjet[selectes].x = love.mouse.getX() - listObjet[selectes].width/2
            listObjet[selectes].y = love.mouse.getY() - listObjet[selectes].height/2
        end
    end
end

function love.keypressed(keys)
    
    if (keys == 'z' and love.keyboard.isDown({'rctrl','lctrl'})) and #listObjet > 0 then -- annuler

        if type(action_utilisateur[#action_utilisateur]) == 'number' then
            table.insert(cache, listObjet[#listObjet])
            table.remove(listObjet,#listObjet)

        elseif type(action_utilisateur[#action_utilisateur]) == 'table' then
            table.insert(listObjet, action_utilisateur[#action_utilisateur].position, action_utilisateur[#action_utilisateur])
            table.insert(cache, action_utilisateur[#action_utilisateur].position)
            table.remove(action_utilisateur, #action_utilisateur)
        end
    end

    if keys == 's' and love.keyboard.isDown({'rctrl','lctrl'}) then
        modul.dt.save_txt('data',listObjet)
    end

    if keys == 'y' and love.keyboard.isDown({'rctrl','lctrl'}) and #cache > 0 then

        if type(cache[#cache]) == 'table' then
            table.insert(listObjet, cache[#cache])
            table.remove(cache, #cache)

        elseif type(cache[#cache]) == 'number' then
            table.insert(action_utilisateur, listObjet[cache[#cache]])
            action_utilisateur[#action_utilisateur].position = cache[#cache]
            table.remove(listObjet, cache[#cache])
            table.remove(cache, #cache)
        end
    end

    if keys == 'r' then
        mode = 'rectangle'
    end

    if keys == 'c' then
        mode = 'carre'
    end
end

function love.draw()
    for i,objet in ipairs(listObjet) do
        if objet:mouseIsPass() and love.mouse.isDown(1) and mode == 'selection' then
            selectes = i
        end
        objet:draw(objet.categorie)
    end
end