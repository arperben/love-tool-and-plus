-- main_test

local modul=require("modul/modul")

modul.objet.center = true

lo = {sol = modul.objet:create{
   x = -500,
   y = -50,
   height = 50,
   width = 1000
}}

temoin = modul.objet:create{
   x = -100,
   y = -100,
   height = 100,
   width = 100
}

perso = modul.objet:create{
   x = 0,
   y = -100,
   rayon = 5
}

perso2 = modul.objet:create{
   x = -300,
   y = -300,
   rayon = 10,
   r = 0,
   g = 0,
   b = 255
}

image1 = modul.objet:create{
   x = 0,
   y = 0,
   --img = love.graphics.newImage("new_project.png")
}

modul.dt.save_txt("save.txt", {perso2, perso})

function love.keypressed(key, scancode, isrepeat)
   if key == 'escape' then
      love.window.close()
   elseif key == 'up' then
      perso:saut()
   --elseif key == 'down' then
      --perso:mouv(0,1)
   elseif key == 'right' then
      perso:mouv(1,0)
   elseif key == 'left' then
      perso:mouv(-1,0)

   elseif key == 'z' then
      perso2:mouv(0,-10,false)
   elseif key == 's' then
      perso2:mouv(0,10,false)
   elseif key == 'd' then
      perso2:mouv(10,0,false)
   elseif key == 'q' then
      perso2:mouv(-10,0,false)
   end
end

function love.load()
   love.window.setMode(800, 600, {resizable=true})
   love.window.maximize()
   --t = modul.dt.load("save.txt")
   --print(modul.show(t))
end

function love.update()
   modul.update()
   temoin.x = perso2.x
   temoin.y = perso2.y
   if temoin:mouseIsPass() then
      temoin.r = 255
   else
      temoin.r = 0
   end
   if perso2:collision_obj(temoin) then
      perso2.b = 0
   else
      perso2.b = 255
   end
   perso:updateGravityCollision(lo)
end

function love.draw()
   lo.sol:draw('rectangle', 'line')
   perso:draw('circle')
   perso2:draw('circle')
   temoin:draw()
end

function love.quit()
   print('bye')
end
