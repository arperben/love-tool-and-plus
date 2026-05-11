local luaP = {}

function luaP.isOneCliked(button)

    if love.mouse.isDown(button) and canClick then -- canclick  sert à éviter que le click soit pris en compte plusieurs fois
        canClick = false
        return true
    end

    if not(love.mouse.isDown(button)) then
        canClick = true
    end
    return false
end

function luaP.checkType(var,verif,message)
    if type(var) ~= verif then
        error(message)
    end
end

return luaP