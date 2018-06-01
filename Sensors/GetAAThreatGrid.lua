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

MIN_PURE_DIST = 1100

MIN_PURE_HIGHT = 1500
HIGHT_DIST_RATIO = 10
MIN_DISTANCE = 512

MIN_COMBINATION = 800 * 600

MAX_HEIGHT = 760

local function isLocationSafe(location, enemyPos)
    for id, enemyPos in pairs(enemyPos) do
        
        local heightDiff = math.abs(enemyPos.y - location.y)
        local rangeDiff = enemyPos:Distance(location)

        local locNotTooHigh = (location.y < MAX_HEIGHT)

        local enemyFarEnough = (rangeDiff > MIN_PURE_DIST)
        local enemyHighEnough = (heightDiff > MIN_PURE_HIGHT and heightDiff/rangeDiff > HIGHT_DIST_RATIO and rangeDiff > MIN_DISTANCE)
        local enemyCombinationEnough = (rangeDiff * heightDiff > MIN_COMBINATION)

        if not ( (enemyFarEnough or enemyHighEnough or enemyCombinationEnough) and (locNotTooHigh) ) then
            return false
        end
    end
    return true
end

-- @description gets a grid representing safe / dangerous positions for flying on map.
return function(enemyPos, flyingHeight, gridGranularity)
    local grid = {}
    local goodLocs = {}

    xi = 1 -- x:index to grid
    for x=0, mapSizeX, gridGranularity do
        grid[xi] = {}
        
        yi = 1 -- y:index to grid
        for y=0, mapSizeZ, gridGranularity do

            local location = Vec3(x, SpringGetGroundHeight(x,y), y) 
            if isLocationSafe(location + Vec3(0, flyingHeight, 0), enemyPos) then
                grid[xi][yi] = { safe=true, loc=location }
                goodLocs[#goodLocs + 1] = location
            else
                grid[xi][yi] = { safe=false, loc=location }
            end

            yi = yi + 1
        end
        
        xi = xi + 1
    end
    
    return {grid=grid, trueList=goodLocs, granularity=gridGranularity}
end
