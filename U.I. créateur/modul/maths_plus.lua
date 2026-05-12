-------------
-- maths_plus
-- v0.2.1
-------------

local modulmathsplus={}

function modulmathsplus.round( num, dec )
    -- test erreur
    if num == nil then error"il vous manque la variable num" end

    local mult = 10^(dec or 0)
    return math.floor(num * mult + 0.5) / mult
end

function modulmathsplus.hypotenuse( longeur1, longeur2 )
    -- test erreur
    if longeur1 == nil or longeur2 == nil then error"il vous manque une longueur" end
    
    return math.sqrt(longeur1^2 + longeur2^2)
end

return modulmathsplus