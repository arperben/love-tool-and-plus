---------
-- objet
-- v1.3.1
---------

local objet = {
    window_height = 0,
    window_width = 0,
    center = false,
    Globalx = 0,
    Globaly = 0,
    GlobalDecalx = 0,
    GlobalDecaly = 0
}
local luaP = require("modul/lua+")

function objet.update_all_objet()
    objet.window_height,objet.window_width = love.window.getMode()
end

function objet.globalmouv(mouv_x,mouv_y,TestDecal)
    
    if TestDecal == nil then -- le test calsic ne fonctionne pas avec des booléen
        TestDecal = true 
    end
    mouv_x = mouv_x or 0
    mouv_y = mouv_y or 0
    
    -- série de test des fonction de l'objet et de leur variable pour éviter les erreur de type
    luaP.checkType(mouv_x, "number", "la variable mouv_x n'est pas un nombre")
    luaP.checkType(mouv_y, "number", "la variable mouv_y n'est pas un nombre")

    luaP.checkType(TestDecal, "boolean", "la variable TestForValFic n'est pas un booléen")

    luaP.checkType(objet.Globalx, "number", "la variable Globalx n'est pas un nombre")
    luaP.checkType(objet.Globaly, "number", "la variable Globaly n'est pas un nombre")

    luaP.checkType(objet.GlobalDecalx, "number", "la variable GlobalDecalx n'est pas un nombre")
    luaP.checkType(objet.GlobalDecaly, "number", "la variable GlobalDecaly n'est pas un nombre")

    if TestDecal then
        objet.Globalx = objet.Globalx + mouv_x
        objet.Globaly = objet.Globaly + mouv_y
    else
        objet.GlobalDecalx = objet.GlobalDecalx + mouv_x
        objet.GlobalDecaly = objet.GlobalDecaly + mouv_y
    end
end
function objet:mouv(mouv_x,mouv_y,TestDecal)
    
    if TestDecal == nil then -- le test calssic ne fonctionne pas avec des booléen
        TestDecal = true
    end
    mouv_x = mouv_x or 0
    mouv_y = mouv_y or 0
    
    -- série de test des fonction de l'objet et de leur variable pour éviter les erreur de type
    luaP.checkType(mouv_x, "number", "la variable mouv_x n'est pas un nombre")
    luaP.checkType(mouv_y, "number", "la variable mouv_y n'est pas un nombre")

    luaP.checkType(TestDecal, "boolean", "la variable TestForValFic n'est pas un booléen")

    luaP.checkType(self.x, "number", "la variable x n'est pas un nombre")
    luaP.checkType(self.y, "number", "la variable y n'est pas un nombre")

    luaP.checkType(self.decalx, "number", "la variable decalx n'est pas un nombre")
    luaP.checkType(self.decaly, "number", "la variable decaly n'est pas un nombre")

    if TestDecal then
        self.x = self.x + mouv_x
        self.y = self.y + mouv_y
    else
        self.decalx = self.decalx + mouv_x
        self.decaly = self.decaly + mouv_y
    end
end

function objet:create(t) 

    t = t or {} -- ma list

    luaP.checkType(t, 'table', "la variable t n'est pas une table")

    -- init de tout les les variable qui ne doit pas être modifier
    t.saut_test = false   -- le joueur est-il en train de sauter
    t.onGround = false   -- le joueur ne touche pas le sol
    t.vy = 0
    t.time = love.timer.getTime()
    t.ficX = 0
    t.ficY = 0
    t.decalx = 0
    t.decaly = 0

    -- init de tout les variable modifiable
    if t.TestGlobalMouv == nil then
        t.TestGlobalMouv = true
    end
    t.r = t.r or 255
    t.g = t.g or 255
    t.b = t.b or 255
    if t.scroll == nil then t.scroll = GlobalScroll end
    t.gravity = t.gravity or 0.5
    t.jumpPower = t.jumpPower or 10
    t.x = t.x or 0
    t.y = t.y or 0
    t.decalx = t.decalx or 0
    t.decaly = t.decaly or 0

    if not(t.img == nil) then -- à refaire car trop de faille
        t.img = love.graphics.newImage( t.img )
    end

    if  not(t.rayon == nil) then -- c'est pour les calcul de collision vu que je ne gère que des quadrilède
        t.width = t.rayon*2
        t.height = t.rayon*2
    end

    if (not(t.width) or not(t.height)) and t.img then -- idem juste avec les image
        t.width = t.img:getWidth()
        t.height = t.img:getHeight()
    end

    t.rayon = t.rayon or 0
    t.width = t.width or 0
    t.height = t.height or 0
    t.img = t.img or 'not'

    setmetatable( t, self )
    self.__index = self
    return t
end

function objet:setAffichagePosition()

    local decalx = objet.GlobalDecalx
    local decaly = objet.GlobalDecaly
    local mouvx = objet.Globalx
    local mouvy = objet.Globaly

    if not(self.TestGlobalMouv) then
        decalx = 0
        decaly = 0
        mouvx = 0
        mouvy = 0
    end

    luaP.checkType(self.x, 'number', "la variable x n'est pas un nombre")
    luaP.checkType(self.y, 'number', "la variable y n'est pas un nombre")
    luaP.checkType(self.ficX, 'number', "la variable ficX n'est pas un nombre")
    luaP.checkType(self.ficY, 'number', "la variable ficY n'est pas un nombre")
    luaP.checkType(self.decalx, 'number', "la variable decalx n'est pas un nombre")
    luaP.checkType(self.decaly, 'number', "la variable decaly n'est pas un nombre")
    luaP.checkType(objet.window_height, 'number', "la variable window_height n'est pas un nombre")
    luaP.checkType(objet.window_width, 'number', "la variable window_width n'est pas un nombre")

    if objet.center then --permet de centrer mon objet
        self.ficX = self.x + objet.window_height/2 + self.decalx + decalx + mouvy
        self.ficY = self.y + objet.window_width/2 + self.decaly + decaly + mouvy
    else
        self.ficX = self.x + self.decalx + decalx + mouvx
        self.ficY = self.y + self.decaly + decaly + mouvy
    end
end

-- affichage --------------------------------

function objet:draw( typ, mode )
    typ = typ or 'rectangle' 
    mod = mod or 'fill'

    ----------------- test les erreur -----------------------
    if self.height == nil then error"il manque la variable heigth pour exécuter se programme" end -- heigth
    if not(type(self.height) == 'number') then error"la variable height n'est pas du type 'number'" end

    if self.width == nil then error"il manque la variable width pour exécuter se programme" end -- width
    if not(type(self.width) == 'number') then error"la variable width n'est pas du type 'number'" end

    if self.rayon == nil then error"il manque la variable rayon pour exécuter se programme" end -- rayon
    if not(type(self.rayon) == 'number') then error"la variable rayon n'est pas du type 'number'" end

    if self.x == nil then error"il manque la variable x pour exécuter se programme" end -- x
    if not(type(self.x) == 'number') then error"la variable x n'est pas du type 'number'" end

    if self.y == nil then error"il manque la variable y pour exécuter se programme" end -- y
    if not(type(self.y) == 'number') then error"la variable y n'est pas du type 'number'" end

    if self.img == nil then error"il manque la variable img pour exécuter se programme" end -- img
    --if not(type(self.img) == 'number') then error"la variable img n'est pas du type 'number'" end

    if self.r == nil or self.g == nil or self.b == nil then error"l'une des varaibles couleur (r, g, b) est de type 'nil'" end -- r, g, b
    if not(type(self.r) == 'number' or type(self.g) == 'number' or type(self.b) == 'number') then error"la variable y n'est pas du type 'number'" end
    ---------------------------------------------------------
    
    self:setAffichagePosition()

    love.graphics.setColor( love.math.colorFromBytes( self.r, self.g, self.b ) )

    if typ == 'rectangle' then
        love.graphics.rectangle(mod, self.ficX, self.ficY, self.width, self.height)

    elseif typ == 'circle' then
        love.graphics.circle(mod, self.ficX+self.rayon, self.ficY+self.rayon, self.rayon, 100)

    elseif typ == 'image' then -- crée un carrée blanc dans n'import quel cas
        love.graphics.draw( self.img, self.ficX, self.ficY )
    end
end
---------------------------------------------

function objet:collision_obj( cible )
    -- cible est l'objet dont on veut faire une test de collision
    
    luaP.checkType(cible, 'table', "la variable cible n'est pas une table")
    
    luaP.checkType(cible.x, 'number', "la variable x de cible n'est pas un nombre")
    luaP.checkType(cible.y, 'number', "la variable y de cible n'est pas un nombre")

    luaP.checkType(cible.width, 'number', "la variable width de cible n'est pas un nombre")
    luaP.checkType(cible.height, 'number', "la variable height de cible n'est pas un nombre")

    luaP.checkType(self.x, 'number', "la variable x n'est pas un nombre")
    luaP.checkType(self.y, 'number', "la variable y n'est pas un nombre")

    luaP.checkType(self.width, 'number', "la variable width n'est pas un nombre")
    luaP.checkType(self.height, 'number', "la variable height n'est pas un nombre")

    return self.x  < cible.x + cible.width
       and self.x + self.width > cible.x
       and self.y < cible.y + cible.height
       and self.y + self.height > cible.y
end

function objet:mouseIsPass()

    local decalx = objet.GlobalDecalx
    local decaly = objet.GlobalDecaly
    local mouvx = objet.Globalx
    local mouvy = objet.Globaly

    if not(self.TestGlobalMouv) then
        decalx = 0
        decaly = 0
        mouvx = 0
        mouvy = 0
    end

    if not(objet.center) then
        print(self.x + self.decalx + decalx + mouvx)
        return self.x + self.decalx + decalx + mouvx < love.mouse.getX()
            and self.x + self.width + self.decalx + decalx + mouvx > love.mouse.getX() + 1 -- pour quelle soyent un peut plus grande
            and self.y + self.decaly + decaly + mouvy < love.mouse.getY()
            and self.y + self.height + self.decaly + decaly + mouvy > love.mouse.getY() + 1 
    else
        return self.x + objet.window_height/2 + self.decalx + decalx + mouvx < love.mouse.getX()
            and self.x + self.width + objet.window_height/2 + self.decalx + decalx + mouvx > love.mouse.getX() + 1
            and self.y + objet.window_width/2 + self.decaly + decaly + mouvy < love.mouse.getY()
            and self.y + self.height + objet.window_width/2 + self.decaly + decaly + mouvy> love.mouse.getY() + 1
    end
end

function objet:test_collision( lo )

    self.onGround = false

    for i, mur in pairs(lo) do
        if self:collision_obj( mur ) then

            local dx1 = ((self.x) + self.width) - mur.x
            local dx2 = (mur.x + mur.width) - self.x
            local overlapX = math.min(dx1, dx2)

            local dy1 = ((self.y) + self.height) - mur.y -- j'enlever au coordoné pour recentré sur le joueur
            local dy2 = (mur.y + mur.height) - self.y
            local overlapY = math.min(dy1, dy2)

            -- Collision horizontale
            if overlapX < overlapY then
                if dx1 < dx2 then
                    self.x = self.x - dx1
                else
                    self.x = self.x + dx2
                end

            -- Collision verticale
            else
                if dy1 < dy2 then
                    -- vient d’en haut → sol
                    self.y = self.y - dy1
                    self.vy = 0
                    self.onGround = true
                else
                    -- vient d’en bas → plafond
                    self.y = self.y + dy2
                    self.vy = 0
                end
            end
        end
    end
end

function objet:apply_gravity()
    self.vy = self.vy + self.gravity
    self.y = self.y + self.vy
end

-- Déclencher un saut
function objet:saut()
    if self.onGround then
        self.vy = -self.jumpPower   -- impulsion vers le haut
        self.onGround = false
    end
end

-- Mettre à jour chaque frame
function objet:updateGravityCollision(lo)
    self:apply_gravity()
    self:test_collision(lo)
end

function objet:wait(time)
    if love.timer.getTime() - self.time >= time then
        self.time = love.timer.getTime()
        return true
    else
        return false
    end
end

return objet