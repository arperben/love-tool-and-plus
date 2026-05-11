local modul=require("module/modul") -- mon modul avec doc
local map=require("gestion map")

local mouv_x = 0
local mouv_y = 0
local taille = 10
map.taille = taille

local selection = modul.objet:create{
    height = taille,
    width = taille,
    scroll = false
}

function love.load()
    love.window.setMode(800, 600, {resizable=true})
    modul.objet.SetGlobalScroll()
    love.window.maximize()
    map.CreerListeWorldGen( 0.05 )
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "d" then
        map.WorldMouvObjet()
        mouv_x = -taille
    end
end

function love.update()
    modul.update()
    selection.x = modul.math.round((love.mouse.getX() - selection.width/2) / taille) * taille
    selection.y = modul.math.round((love.mouse.getY() - selection.height/2) / taille) * taille
    if love.keyboard.isDown( 'right' ) then
  --      map.WorldMouvObjet()
        mouv_x = -taille
    end
    if love.keyboard.isDown( 'q' ) then
        mouv_x = taille
    end
    if love.keyboard.isDown( 'z' ) then
        mouv_y = taille
    end
    if love.keyboard.isDown( 's' ) then
        mouv_y = -taille
    end
end

function love.draw()
    for y = 1,#map.element do
        for x = 1,#map.element[y] do
            map.element[y][x]:mouv(mouv_x, mouv_y)
            if map.element[y][x].x>=-taille and map.element[y][x].x<=love.graphics.getWidth() and map.element[y][x].y>=-taille and map.element[y][x].y<=love.graphics.getHeight() then
                map.element[y][x]:afficheRectangle()
            end
        end
    end
    selection:afficheRectangle()
    mouv_x, mouv_y = 0, 0
end
