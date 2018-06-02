local sensorInfo = {
	name = "GetPath",
	desc = "Return map of locations specifying a path in a given grid graph.",
	author = "Petrroll",
	date = "2018-05-31",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = -1 -- actual, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT
	}
end

--
-- queue implementation based on MIT code: https://github.com/catwell/cw-lua/blob/master/deque/deque.lua
--

--- Deque implementation by Pierre 'catwell' Chapuis
--- MIT licensed (see LICENSE.txt)

local push_right = function(self, x)
  assert(x ~= nil)
  self.tail = self.tail + 1
  self[self.tail] = x
end

local push_left = function(self, x)
  assert(x ~= nil)
  self[self.head] = x
  self.head = self.head - 1
end

local peek_right = function(self)
  return self[self.tail]
end

local peek_left = function(self)
  return self[self.head+1]
end

local pop_right = function(self)
  if self:is_empty() then return nil end
  local r = self[self.tail]
  self[self.tail] = nil
  self.tail = self.tail - 1
  return r
end

local pop_left = function(self)
  if self:is_empty() then return nil end
  local r = self[self.head+1]
  self.head = self.head + 1
  local r = self[self.head]
  self[self.head] = nil
  return r
end

local length = function(self)
  return self.tail - self.head
end

local is_empty = function(self)
  return self:length() == 0
end


local iter_right = function(self)
  local i = self.tail+1
  return function()
    if i > self.head+1 then
      i = i-1
      return self[i]
    end
  end
end

local iter_left = function(self)
  local i = self.head
  return function()
    if i < self.tail then
      i = i+1
      return self[i]
    end
  end
end

local methods = {
  push_right = push_right,
  push_left = push_left,
  peek_right = peek_right,
  peek_left = peek_left,
  pop_right = pop_right,
  pop_left = pop_left,
  iter_right = iter_right,
  iter_left = iter_left,
  length = length,
  is_empty = is_empty,
}

local newQueue = function()
  local r = {head = 0, tail = 0}
  return setmetatable(r, {__index = methods})
end

---
--- End of Queue implementation
---

-- @description returns map of locations specifying a path in a given grid graph
return function(startPos, destPos, boolGridObj)
    local graphGrid = boolGridObj.grid   

    local startXi = math.floor(startPos.x / boolGridObj.granularity) + 1
    local startYi = math.floor(startPos.z / boolGridObj.granularity) + 1

    local destXi = math.floor(destPos.x / boolGridObj.granularity) + 1
    local destYi = math.floor(destPos.z / boolGridObj.granularity) + 1

    local gridSizeX = #graphGrid
    local gridSizeY = #(graphGrid[1])

    -- neccessary because due to drifting towers-bug the destination can actually sometimes be off the map
    if destXi > gridSizeX then destXi = gridSizeX end 
    if destYi > gridSizeY then destYi = gridSizeY end 
    if startXi > gridSizeX then startXi = gridSizeX end 
    if startYi > gridSizeY then startYi = gridSizeY end 

    if destXi < 1 then destXi = 1 end 
    if destYi < 1 then destYi = 1 end 
    if startXi < 1 then startXi = 1 end 
    if startYi < 1 then startYi = 1 end 

    local start = {x=startXi, y=startYi}
    local dest = {x=destXi, y=destYi}


    -- The whole current distance and hight keeping in navGraph is an ugly hack to add
    -- ..some non-one distances support to BFS. I.e to add support for prefering certain
    -- ..(lower hight) neighbor edges to others. A dijstra / a* with a proper distance 
    -- ..that captures the preference of not going higher should be used instead. 
    -- ..In case of refactoring: remember this heap: https://github.com/geoffleyland/lua-heaps

    local function neighborExistsSafeNotExploredOrBetter(nb, currLoc, navGraph, graphGrid, gridSizeX, gridSizeY)
        if not (nb.x >= 1 and nb.x <= gridSizeX) then return false end         -- neighbor not on map in x -> false  
        if not (nb.y >= 1 and nb.y <= gridSizeY) then return false end    -- neighbor not on map in y -> false  
        
        if not (graphGrid[nb.x][nb.y].safe) then return false end -- nb not safe -> false
        if navGraph[nb.x][nb.y] == nil then return true end       -- nb not visited -> true
        
        if navGraph[nb.x][nb.y].dis <= navGraph[currLoc.x][currLoc.y].dis then return false end -- if nb isn't from this front -> false  
        return graphGrid[currLoc.x][currLoc.y].loc.y < navGraph[nb.x][nb.y].predHig -- nb's prede is of same distance as curr and curr is better 
    end
    
    local nbs = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {-1, -1}, {1, 1}, {-1, 1}, {1, -1}}
    local bfsQ = newQueue()

    local navGraph = {}
    navGraph[dest.x] = {}
    navGraph[dest.x][dest.y] = {pred = dest, predHig=graphGrid[dest.x][dest.y].loc.y, dis = 0}

    -- create predecessor based navGraph trough modified BFS
    bfsQ:push_right(dest)
    while not bfsQ:is_empty() do
        local currLoc = bfsQ:pop_right()
        for i=1, #nbs do
            local nb = {x = (currLoc.x + nbs[i][1]), y = (currLoc.y + nbs[i][2])}
            if navGraph[nb.x] == nil then navGraph[nb.x] = {} end   

            -- if the neighbor is safe & hasn't been explored yet -> add to navGraph & queue
            if neighborExistsSafeNotExploredOrBetter(nb, currLoc, navGraph, graphGrid, gridSizeX, gridSizeY) then
                if navGraph[nb.x][nb.y] == nil then bfsQ:push_left(nb) end -- need to check -> can be just updating pred with a lower hight 
                navGraph[nb.x][nb.y] = {pred= currLoc, predHig=graphGrid[currLoc.x][currLoc.y].loc.y, dis = navGraph[currLoc.x][currLoc.y].dis + 1}
            end

        end
    end


    -- find path in the navgraph trough going from start via .pred references
    if navGraph[start.x] == nil or navGraph[start.x][start.y] == nil then
        return {suc=false, dta=nil}
    end

    local currLoc = start
    local path = {graphGrid[currLoc.x][currLoc.y].loc}
    while currLoc.x ~= dest.x or currLoc.y ~= dest.y do
        currLoc = navGraph[currLoc.x][currLoc.y].pred
        path[#path+1] = graphGrid[currLoc.x][currLoc.y].loc
    end

    return {suc=true, dta=path}
end