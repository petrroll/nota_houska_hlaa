function getUnitsVecPocition(uid)
    local pointX, pointY, pointZ = Spring.GetUnitPosition(uid)
    local loc = Vec3(pointX, pointY, pointZ)
    
    return loc
end