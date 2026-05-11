---------
-- objet
-- v0.4.3
---------

local modulobjet = {}
local window_height, window_width = 0, 0
local center = false
local GlobalScroll = false
local mouvObjet_x = 0
local mouvObjet_y = 0

function modulobjet.update_all_objet()
    window_height,window_width = love.window.getMode()
end

function modulobjet.SetGlobalScroll()
    GlobalScroll = true
end

function modulobjet:GiveMouvObjet()
    return mouvObjet_x, mouvObjet_y
end

function modulobjet.SetWindowsCenter()
    center = true
end

function modulobjet:mouv(mouv_x,mouv_y)

    self.x = self.x + mouv_x
    self.y = self.y + mouv_y

end

function modulobjet:create(t) 
    window_height,window_width = love.window.getMode() -- sa permet de l'avoir sans que l'utilisateur ne s'embête
    -- initie la classe objet(sa peut être tout est n'import quoi)

    t = t or {} -- ma list

    -- init de tout les les variable qui ne doit pas être modifier
    t.saut_test = false   -- le joueur est-il en train de sauter
    t.onGround = false   -- le joueur ne touche pas le sol
    t.vy = 0

    -- init de tout les variable modifiable
    t.gui = t.gui or false
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
    if not(t.img == nil) then
        t.img = love.graphics.newImage( t.img )
    end

    t.ficX = t.x -- pour l'affichage
    t.ficY = t.y

    if  t.rayon then -- c'est pour les calcul de collision vu que je ne gère que des quadrilède
        t.width = t.rayon*2
        t.height = t.rayon*2
    end

    if (not(t.width) or not(t.height)) and t.img then -- idem juste avec les image
        t.width = t.img:getWidth()
        t.height = t.img:getHeight()
    end

    -- gui carractéristique
    if type(t.x) == 'string' then
        t.strx = t.x
        if not(t.gui) then error"ceci est spécifique au gui" end
        if t.x == "rigth" then t.x = window_height - t.width + t.decalx
        elseif t.x == "left" then  t.x = 0 
        else error"il y a une erreur de saisie" end
    end
    if type(t.y) == 'string' then
        t.stry = t.y
        if not(t.gui) then error"ceci est spécifique au gui" end
        if t.y == "down" then t.y = window_width - t.height + t.decaly
        elseif t.y == "up" then t.y = 0
        else error"il y a une erreur de saisie" end
    end
    if t.gui then t.scroll = false end

    setmetatable( t, self )
    self.__index = self
    return t
end

function modulobjet:setAffichagePosition() --permet de centrer mon objet
    
    if self.gui then
        if self.strx == "rigth" then self.x = window_height - self.width + self.decalx
        elseif self.strx == "left" then self.x = 0 end
        if self.stry == "down" then self.y = window_width - self.height + self.decaly
        elseif self.stry == "up" then self.y = 0 end
        self.ficX = self.x
        self.ficY = self.y
    else
        if GlobalScroll and self.scroll then 
            self.ficX = self.x
            self.ficY = self.y
        else
            self.ficX = self.x
            self.ficY = self.y
        end
    end
end

-- affichage --------------------------------
function modulobjet:afficheCircle()
    self:setAffichagePosition()

    love.graphics.setColor( love.math.colorFromBytes( self.r, self.g, self.b ) )

    if self.rayon == nil then error"il manque la variable rayon pour exécuter se programme" end -- test les erreur

    love.graphics.circle("fill", self.ficX+10, self.ficY+10, self.rayon, 100)
end

function modulobjet:afficheRectangle()
    self:setAffichagePosition()

    love.graphics.setColor( love.math.colorFromBytes( self.r, self.g, self.b ) )

    if self.height == nil then error"il manque la variable height pour exécuter se programme" end -- test les erreur
    if self.width == nil then error"il manque la variable width pour exécuter se programme" end

    love.graphics.rectangle("fill", self.ficX, self.ficY, self.width, self.height)
end

function modulobjet:afficheImg()
    self:setAffichagePosition()
    
    love.graphics.draw( self.img, self.ficX, self.ficY )
end
---------------------------------------------

function modulobjet:collision_obj( cible )
    -- cible est l'objet dont on veut faire une test de collision
    -- val permet de tester l'objet sur des cas en avance
    return self.x  < cible.x + cible.width
       and self.x + self.width > cible.x
       and self.y < cible.y + cible.height
       and self.y + self.height > cible.y
end

function modulobjet:mouseIsPass()
    if not(self.scroll) or not(center) then
        return self.x < love.mouse.getX()
            and self.x + self.width > love.mouse.getX() + 1
            and self.y < love.mouse.getY()
            and self.y + self.height > love.mouse.getY() + 1
    else
        return self.x + window_height/2 - mouvObjet_x < love.mouse.getX()
            and self.x + self.width + window_height/2 - mouvObjet_x > love.mouse.getX() + 1
            and self.y + window_width/2 - mouvObjet_y < love.mouse.getY()
            and self.y + self.height + window_width/2 - mouvObjet_y > love.mouse.getY() + 1
    end
end

function modulobjet:GiveColor()
    return self.r, self.g, self.b,'|'
end

function modulobjet:test_collision( lo )

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
                    if GlobalScroll then mouvObjet_x = mouvObjet_x - dx1 end
                else
                    self.x = self.x + dx2
                    if GlobalScroll then mouvObjet_x = mouvObjet_x + dx2 end
                end

            -- Collision verticale
            else
                if dy1 < dy2 then
                    -- vient d’en haut → sol
                    self.y = self.y - dy1
                    if GlobalScroll then mouvObjet_y = mouvObjet_y - dy1 end
                    self.vy = 0
                    self.onGround = true
                else
                    -- vient d’en bas → plafond
                    self.y = self.y + dy2
                    if GlobalScroll then mouvObjet_y = mouvObjet_y + dy2 end
                    self.vy = 0
                end
            end
        end
    end
end