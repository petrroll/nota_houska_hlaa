local sensorInfo = {
    name = "Get AA Threat Grid",
    desc = "Gets a grid representing safe / dangerous positions for flying on map.",
    author = "Petrroll",
    date = "2018-05-31",
    license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- acutal, no caching

function getInfo()
    return {
        period = EVAL_PERIOD_DEFAULT
    }
end

mapSizeX = Game.mapSizeX
mapSizeZ = Game.mapSizeZ

SpringGetGroundHeight = Spring.GetGroundHeight

RANGE = 1100
HEIGHT_RANGE = 300


local function isLocationSafe(location, enemyPos)
    for id, enemyPos in pairs(enemyPos) do
        local heightDiff = math.abs(enemyPos.y - location.y)
        if (enemyPos:Distance(location) < RANGE and heightDiff < HEIGHT_RANGE) then
            return false
        end
    end
    return true
end

-- @description gets a grid representing safe / dangerous positions for flying on map.
return function(enemyPos, flyingHeight, gridGranularity)
    local grid = {}
    local goodLocs = {}

    xi = 1
    for x=0, mapSizeX, gridGranularity do
        grid[xi] = {}
        
        yi = 1
        for y=0, mapSizeZ, gridGranularity do

            local location = Vec3(x, SpringGetGroundHeight(x,y), y) 
            if isLocationSafe(location + Vec3(0, flyingHeight, 0), enemyPos) then
                grid[xi][yi] = { true, location }
                goodLocs[#goodLocs + 1] = location
            else
                grid[xi][yi] = { false, location }
            end

            yi = yi + 1
        end
        
        xi = xi + 1
    end
    
    return {grid=grid, trueList=goodLocs, granularity=gridGranularity}
end
